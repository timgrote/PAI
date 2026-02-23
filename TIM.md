# Tim's PAI Restore Guide

> **For Claude/Pi:** Tim will point you at this file after a fresh Claude Code install.
> Read it top to bottom and execute each phase. Ask Tim for input only where noted.

## Phase 1: Prerequisites

Confirm before proceeding:
- Claude Code is installed and running
- This repo is cloned at `~/repos/PAI`
- Tim has his `.env` contents ready (from password manager)

## Phase 2: Install Upstream PAI

Follow the upstream PAI install process. The latest release instructions are in this repo at `Releases/` or `INSTALL.md`. Tim's fork tracks `danielmiessler/PAI`.

After the base PAI install completes, continue to Phase 3 to apply Tim's personal config on top.

## Phase 3: Restore Environment Variables

1. Copy the template: `cp ~/repos/PAI/.env.example ~/.claude/.env`
2. **Ask Tim** to paste his real API keys into `~/.claude/.env` (stored in his password manager)
3. Verify the file has real values (not empty placeholders) for at least:
   - `ANTHROPIC_API_KEY`
   - `ELEVENLABS_API_KEY`
   - `OPENAI_API_KEY`
   - `RESCUE_TIME_API_KEY`

The `.env.example` in this repo has comments showing where to generate each key if any need to be regenerated.

## Phase 4: Restore settings.json

```bash
cp ~/repos/PAI/settings.json ~/.claude/settings.json
```

This file contains Tim's full configuration:
- **Identity:** DA name is "Pi", Tim's timezone is America/Denver
- **Hooks:** SecurityValidator, LoadContext, SessionSummary, sentiment capture, etc.
- **Permissions:** Broad allow list for Bash, Read, Write, Edit, web fetches, MCP tools
- **Plugins:** Feature-dev, code-review, commit-commands, playwright, greptile, context7, learning-output-style, and more
- **Status line:** Custom command at `~/.claude/statusline-command.sh`

After copying, restart Claude Code to activate hooks.

## Phase 5: Install Personal Skills

These skills are Tim's custom additions — not part of upstream PAI. Each is stored as a pack in `Packs/` in this repo.

For each pack below, copy the skill source into the installed skills directory:

```bash
# BookChat — Book conversation companion for reading sessions
cp -r ~/repos/PAI/Packs/pai-bookchat-skill/src/skills/BookChat ~/.claude/skills/BookChat

# DailyNote — Create/open daily journal notes from Obsidian template
cp -r ~/repos/PAI/Packs/pai-dailynote-skill/src/skills/DailyNote ~/.claude/skills/DailyNote

# OpenClaw — Manage OpenClaw AI assistant on DigitalOcean
cp -r ~/repos/PAI/Packs/pai-openclaw-skill/src/skills/OpenClaw ~/.claude/skills/OpenClaw

# Podium — Personal task management via Podium/Conductor API (Tailscale)
cp -r ~/repos/PAI/Packs/pai-podium-skill/src/skills/Podium ~/.claude/skills/Podium

# Review — Nightly + weekly journal reviews with RescueTime integration
cp -r ~/repos/PAI/Packs/pai-review-skill/src/skills/Review ~/.claude/skills/Review
```

Also copy the RescueTime tool that the Review skill depends on:
```bash
cp ~/repos/PAI/Packs/pai-review-skill/src/skills/PAI/Tools/RescueTime.ts ~/.claude/skills/PAI/Tools/RescueTime.ts
```

## Phase 6: Verify Installation

Run these checks and report results to Tim:

1. **Hooks firing:** Start a new session — you should see the PAI startup banner and context loading
2. **Skills loaded:** Check that `skill-index.json` includes BookChat, DailyNote, OpenClaw, Podium, Review
3. **Podium API:** `curl -s http://100.105.238.37:3000/api/projects/proj-9450dc11/tasks | head -c 200` — should return JSON (requires Tailscale)
4. **RescueTime API:** `bun ~/.claude/skills/PAI/Tools/RescueTime.ts summary --days 1` — should show productivity data
5. **Voice:** `curl -s -X POST http://localhost:8888/notify -H "Content-Type: application/json" -d '{"message": "Pi is back online"}'` — should speak if voice server is running

## Phase 7: Post-Install Notes

Things that are NOT restored by this process and may need manual setup:

| Item | Notes |
|------|-------|
| **`~/.claude/CLAUDE.md`** | Tim's global Claude instructions. Lives in Dropbox at `/mnt/d/Dropbox/Personal/` as vault CLAUDE.md, but the global one at `~/.claude/CLAUDE.md` may need manual recreation |
| **MCP servers** | Configured in project-level `.claude/settings.local.json` files, not in global settings. May need reconfiguring per-project (Obsidian, n8n, etc.) |
| **Obsidian CLI alias** | `alias obsidian='/mnt/c/Users/tim/AppData/Local/Programs/Obsidian/Obsidian.com'` in `~/.bashrc` |
| **Memory files** | `~/.claude/MEMORY/` and `~/.claude/projects/` are session-specific and not backed up |
| **Git remotes** | This repo should have: `origin` = `timgrote/PAI`, `upstream` = `danielmiessler/PAI` |

## Reference: What Lives Where

| What | Location | Backed up in this repo? |
|------|----------|------------------------|
| API keys | `~/.claude/.env` | Template only (`.env.example`) |
| Config (hooks, permissions, plugins) | `~/.claude/settings.json` | YES — `settings.json` |
| Upstream PAI skills | `~/.claude/skills/PAI/` | Via upstream install |
| Personal skills | `~/.claude/skills/{Name}/` | YES — `Packs/pai-{name}-skill/` |
| RescueTime tool | `~/.claude/skills/PAI/Tools/RescueTime.ts` | YES — in review skill pack |
| Hook scripts | `~/.claude/hooks/` | Via upstream install |
| Session memory | `~/.claude/MEMORY/` | Not backed up |
| Project memory | `~/.claude/projects/` | Not backed up |
