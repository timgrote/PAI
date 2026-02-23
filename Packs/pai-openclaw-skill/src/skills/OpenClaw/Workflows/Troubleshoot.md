# Troubleshoot Workflow

Diagnose and fix OpenClaw issues using log analysis and the troubleshooting decision tree.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the Troubleshoot workflow in the OpenClaw skill to diagnose issues"}' \
  > /dev/null 2>&1 &
```

Running the **Troubleshoot** workflow in the **OpenClaw** skill to diagnose issues...

## Reference

**Load `TroubleshootingGuide.md` immediately** — it contains decision trees for all known issues.

## Process

### 1. Gather Symptoms

Ask user what they're experiencing:
- Service down / crash loop?
- Bot not responding?
- Specific error message?
- When did it start?

### 2. Run Diagnostics
```bash
# Full diagnostic
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh doctor

# Recent errors
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors --tail 30

# Service status
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep
```

### 3. Identify Root Cause

Match symptoms to `TroubleshootingGuide.md` decision trees:

| Symptom | Likely Cause | Guide Section |
|---------|-------------|---------------|
| Crash loop | Discord 4014 or config error | "Service Crash Loop" |
| Chinese responses | Kimi K2 fallback | "Chinese Language Fallback" |
| "pairing required" | New device needs approval | "Device Pairing Required" |
| "no-mention" skip | requireMention = true | "Bot Skipping Messages" |
| Token mismatch | trustedProxies missing ::1 | "Proxy Trust / Token Mismatch" |
| JSON parse error | Config corruption | "Config Parse Error" |
| API errors | OpenRouter key issue | "OpenRouter API Errors" |
| SSH timeout | Server/network issue | "SSH Connection Failed" |

### 4. Apply Fix

Follow the specific fix steps from TroubleshootingGuide.md for the identified issue.

### 5. Verify Fix
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs --tail 10
```

### 6. Report

Tell user:
- What was wrong (root cause)
- What was done to fix it
- Current status after fix
- Any preventive measures
