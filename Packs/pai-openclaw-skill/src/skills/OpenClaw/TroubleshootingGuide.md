# OpenClaw Troubleshooting Guide

Decision trees for common issues, seeded from real debugging sessions.

---

## Quick Diagnostic

```bash
# Run full diagnostic
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh doctor

# Check service status
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep

# Recent errors
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors
```

---

## Issue: Service Crash Loop

### Symptoms
- Service repeatedly starts and stops
- `systemctl status openclaw` shows "activating (auto-restart)"

### Decision Tree

```
Service crashing?
├── Check logs: logs-errors --tail 50
│   ├── "Fatal Gateway error: 4014" → Discord Intent Issue (see below)
│   ├── "ECONNREFUSED" → Network/port issue
│   ├── JSON parse error → Config corruption (see below)
│   └── "unauthorized" → Token mismatch (see below)
```

---

## Issue: Discord Error 4014 (Disallowed Intents)

### Symptoms
```
Fatal Gateway error: 4014
[agent] Discord Message Content Intent is disabled
```

### Root Cause
Discord bot missing **Message Content Intent** in Developer Portal. One bot crashing takes down the entire service.

### Fix
1. Identify which bot: check logs for agent name in brackets
2. Go to Discord Developer Portal -> Applications -> select the bot's app
3. Bot -> Privileged Gateway Intents -> enable **Message Content Intent**
4. Save and restart: `~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart`

### Prevention
Always enable Message Content Intent when creating new Discord bots.

---

## Issue: Chinese Language Fallback (Kimi K2)

### Symptoms
Agent responds in Chinese instead of English:
```
"作为一个人工智能语言模型，我还没有学会回答这个问题..."
```

### Root Cause
Kimi K2 (Moonshot AI, Chinese company) falls back to Chinese when hitting content filters or unable to handle a request.

### Fix
Add to the agent's SOUL.md:
```
Always respond in English. No exceptions.
```

```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-read /home/openclaw/.openclaw/agents/<id>/SOUL.md
# Add English-only instruction, then write back
```

---

## Issue: Proxy Trust / Token Mismatch

### Symptoms
```
"gateway connect failed: Error: unauthorized: gateway token mismatch"
"disconnected (1008): pairing required"
Dashboard shows "Health Offline"
```

### Root Cause
Caddy reverse proxy connects via IPv6 `::1` but `trustedProxies` only had `127.0.0.1`.

### Fix
```bash
# Ensure both IPv4 and IPv6 loopback are trusted
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get gateway.trustedProxies
# Should show: ["127.0.0.1", "::1"]
# If missing ::1, add it via direct config edit
```

---

## Issue: Bot Skipping Messages

### Symptoms
```
Log: "discord: skipping guild message, reason: no-mention"
```
Bot is online but ignores messages unless @mentioned.

### Fix
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.guilds.774002504895430657.requireMention false
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
```

---

## Issue: groupPolicy Blocking

### Symptoms
Bot account has `groupPolicy: "allowlist"` but no guilds explicitly listed. Bot won't respond anywhere.

### Fix
Either remove the per-account `groupPolicy` (inherits top-level `"open"`) or explicitly add the guild:
```bash
# Check current policy
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get channels.discord
```

---

## Issue: Device Pairing Required

### Symptoms
Browser dashboard shows "pairing required" / "Health Offline" after connecting.

### Context
This is by design for new browser connections. Each page load generates a new device fingerprint.

### Fix
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-list
# Find the pending request
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-approve <request-id>
```
Browser auto-connects within seconds after approval. Fingerprint is remembered for future connections.

---

## Issue: Config Parse Error

### Symptoms
Service won't start after config edit. Logs show JSON parse error.

### Fix
```bash
# Validate JSON
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "jq empty /home/openclaw/.openclaw/openclaw.json"

# If invalid, restore from backup
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "ls -t /home/openclaw/.openclaw/openclaw.json.backup.* | head -1"
# Copy latest backup over config, then restart
```

### Prevention
Always use the EditConfig workflow which auto-backups before changes.

---

## Issue: SSH Connection Failed

### Symptoms
`ssh: connect to host 24.144.82.75 port 22: Connection timed out`

### Checks
1. Is the droplet running? Check DigitalOcean dashboard
2. Is SSH service up? (can only check if you have console access)
3. Firewall blocking? DigitalOcean firewall rules
4. SSH key issue? Check `~/.ssh/` for correct key

---

## Issue: OpenRouter API Errors

### Symptoms
Agents not responding, logs show API errors or rate limits.

### Checks
```bash
# Verify API key is set
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "grep OPENROUTER_API_KEY /opt/openclaw.env"

# Check if model slug is valid
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get agents.defaults.model.primary
```

### Common Model Slugs
- `openrouter/xai/grok-3`
- `openrouter/moonshotai/kimi-k2`
- `openrouter/anthropic/claude-sonnet-4`
- `openrouter/openai/gpt-4o`
