#!/usr/bin/env bun
/**
 * SessionSummary.hook.ts - Mark Work Complete and Clear State (SessionEnd)
 *
 * PURPOSE:
 * Finalizes a Claude Code session by marking the current work directory as
 * COMPLETED and clearing the session state. This ensures clean session boundaries
 * and accurate work tracking.
 *
 * TRIGGER: SessionEnd
 *
 * INPUT:
 * - stdin: Hook input JSON (session_id, transcript_path)
 * - Files: MEMORY/STATE/current-work-{session_id}.json (session-keyed)
 *
 * OUTPUT:
 * - stdout: None
 * - stderr: Status messages
 * - exit(0): Always (non-blocking)
 *
 * SIDE EFFECTS:
 * - Updates: MEMORY/WORK/<dir>/META.yaml (status: COMPLETED, completed_at timestamp)
 * - Creates: MEMORY/STATE/resume-{session_id}.json (session resume info)
 * - Creates: MEMORY/STATE/last-resume.json (legacy, most recent session)
 * - Deletes: MEMORY/STATE/current-work-{session_id}.json (clears session state)
 *
 * CONCURRENCY:
 * - Session-keyed files support multiple concurrent Claude instances in different folders
 * - Each session has isolated state files keyed by session_id
 * - Legacy files maintained for backwards compatibility
 *
 * INTER-HOOK RELATIONSHIPS:
 * - DEPENDS ON: AutoWorkCreation (expects WORK/ structure and current-work.json)
 * - COORDINATES WITH: WorkCompletionLearning (both run at SessionEnd)
 * - MUST RUN BEFORE: None (final cleanup)
 * - MUST RUN AFTER: WorkCompletionLearning (learning capture uses state before clear)
 *
 * STATE TRANSITIONS:
 * - META.yaml status: "ACTIVE" → "COMPLETED"
 * - META.yaml completed_at: null → ISO timestamp
 * - current-work.json: exists → deleted
 *
 * DESIGN NOTES:
 * - Does NOT write to SESSIONS/ directory (WORK/ is the primary tracking system)
 * - Deleting current-work.json signals a clean slate for next session
 *
 * ERROR HANDLING:
 * - No current work: Logs message, exits gracefully
 * - Missing META.yaml: Skips update, continues to state clear
 * - File operation failures: Logged to stderr
 *
 * PERFORMANCE:
 * - Non-blocking: Yes
 * - Typical execution: <50ms
 */

import { writeFileSync, existsSync, readFileSync, unlinkSync } from 'fs';
import { join } from 'path';
import { getISOTimestamp } from './lib/time';

const MEMORY_DIR = join(process.env.HOME!, '.claude', 'MEMORY');
const STATE_DIR = join(MEMORY_DIR, 'STATE');
const WORK_DIR = join(MEMORY_DIR, 'WORK');

// Session-keyed state files to support multiple concurrent Claude instances
function getCurrentWorkFile(sessionId: string): string {
  return join(STATE_DIR, `current-work-${sessionId}.json`);
}

function getResumeFile(sessionId: string): string {
  return join(STATE_DIR, `resume-${sessionId}.json`);
}

// Legacy paths for backwards compatibility
const LEGACY_CURRENT_WORK_FILE = join(STATE_DIR, 'current-work.json');
const LEGACY_RESUME_FILE = join(STATE_DIR, 'last-resume.json');

interface CurrentWork {
  session_id: string;
  work_dir: string;
  created_at: string;
  item_count: number;
}

interface HookInput {
  session_id?: string;
  transcript_path?: string;
}

interface ResumeInfo {
  session_id: string;
  resume_command: string;
  work_dir: string | null;
  ended_at: string;
}

/**
 * Save resume command for session continuity (Technique #4: Resume Hints)
 * Stores session ID and resume command for later reference
 * Uses session-keyed files to support multiple concurrent instances
 */
function saveResumeInfo(sessionId: string, workDir: string | null): void {
  try {
    const resumeInfo: ResumeInfo = {
      session_id: sessionId,
      resume_command: `claude --resume ${sessionId}`,
      work_dir: workDir,
      ended_at: getISOTimestamp()
    };

    // Write session-specific resume file
    const resumeFile = getResumeFile(sessionId);
    writeFileSync(resumeFile, JSON.stringify(resumeInfo, null, 2), 'utf-8');

    // Also update legacy file for backwards compatibility (most recent session)
    writeFileSync(LEGACY_RESUME_FILE, JSON.stringify(resumeInfo, null, 2), 'utf-8');

    console.error(`[SessionSummary] Resume command saved: claude --resume ${sessionId}`);
  } catch (error) {
    console.error(`[SessionSummary] Error saving resume info: ${error}`);
  }
}

/**
 * Mark work directory as completed and clear session state
 * Uses session-keyed files to support multiple concurrent instances
 */
function clearSessionWork(sessionId: string): void {
  try {
    const currentWorkFile = getCurrentWorkFile(sessionId);

    // Try session-specific file first, fall back to legacy
    let workFile = currentWorkFile;
    if (!existsSync(currentWorkFile)) {
      if (existsSync(LEGACY_CURRENT_WORK_FILE)) {
        // Check if legacy file belongs to this session
        const legacyContent = readFileSync(LEGACY_CURRENT_WORK_FILE, 'utf-8');
        const legacyWork = JSON.parse(legacyContent) as CurrentWork;
        if (legacyWork.session_id === sessionId) {
          workFile = LEGACY_CURRENT_WORK_FILE;
        } else {
          console.error('[SessionSummary] No current work to complete for this session');
          return;
        }
      } else {
        console.error('[SessionSummary] No current work to complete');
        return;
      }
    }

    // Read current work state
    const content = readFileSync(workFile, 'utf-8');
    const currentWork: CurrentWork = JSON.parse(content);

    // Mark work directory as COMPLETED
    if (currentWork.work_dir) {
      const metaPath = join(WORK_DIR, currentWork.work_dir, 'META.yaml');
      if (existsSync(metaPath)) {
        let metaContent = readFileSync(metaPath, 'utf-8');
        metaContent = metaContent.replace(/^status: "ACTIVE"$/m, 'status: "COMPLETED"');
        metaContent = metaContent.replace(/^completed_at: null$/m, `completed_at: "${getISOTimestamp()}"`);
        writeFileSync(metaPath, metaContent, 'utf-8');
        console.error(`[SessionSummary] Marked work directory as COMPLETED: ${currentWork.work_dir}`);
      }
    }

    // Delete session state file
    unlinkSync(workFile);
    console.error('[SessionSummary] Cleared session work state');
  } catch (error) {
    console.error(`[SessionSummary] Error clearing session work: ${error}`);
  }
}

async function main() {
  try {
    // Read input from stdin
    const inputText = await Bun.stdin.text();
    if (!inputText || inputText.trim() === '') {
      process.exit(0);
    }

    // Parse hook input for session info
    let hookInput: HookInput = {};
    try {
      hookInput = JSON.parse(inputText);
    } catch {
      // If parsing fails, continue with empty input
    }

    const sessionId = hookInput.session_id || 'unknown';

    // Get current work info before clearing (using session-keyed file)
    let workDir: string | null = null;
    const currentWorkFile = getCurrentWorkFile(sessionId);

    // Try session-specific file first, then legacy
    const fileToRead = existsSync(currentWorkFile) ? currentWorkFile : LEGACY_CURRENT_WORK_FILE;
    if (existsSync(fileToRead)) {
      try {
        const content = readFileSync(fileToRead, 'utf-8');
        const currentWork: CurrentWork = JSON.parse(content);
        // Only use if it matches this session
        if (currentWork.session_id === sessionId) {
          workDir = currentWork.work_dir;
        }
      } catch {
        // Ignore parse errors
      }
    }

    // Save resume info for session continuity (Technique #4)
    if (sessionId !== 'unknown') {
      saveResumeInfo(sessionId, workDir);
    }

    // Mark work as complete and clear state (session-keyed)
    // NOTE: Does NOT write to SESSIONS/ - WORK/ is the primary system
    clearSessionWork(sessionId);

    console.error('[SessionSummary] Session ended, work marked complete');
    process.exit(0);
  } catch (error) {
    // Silent failure - don't disrupt workflow
    console.error(`[SessionSummary] SessionEnd hook error: ${error}`);
    process.exit(0);
  }
}

main();
