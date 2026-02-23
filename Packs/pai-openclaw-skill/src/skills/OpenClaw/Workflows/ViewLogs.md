# ViewLogs Workflow

View and analyze OpenClaw service logs.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the ViewLogs workflow in the OpenClaw skill to view logs"}' \
  > /dev/null 2>&1 &
```

Running the **ViewLogs** workflow in the **OpenClaw** skill to view logs...

## Operations

### Recent Logs (default 50 lines)
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs
```

### Custom Line Count
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs --tail 100
```

### Errors Only
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors --tail 50
```

### Time-Based Query
```bash
# Last hour
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh journal 1h

# Last 30 minutes
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh journal 30min

# Today
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh journal today
```

### Live Tail (via raw SSH)
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "journalctl -u openclaw -f --no-pager" &
# Note: will need to be killed manually
```

### Filter by Agent Name
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "journalctl -u openclaw --no-pager --tail 50 | grep -i '<agent-name>'"
```

### Filter by Keyword
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "journalctl -u openclaw --no-pager --tail 100 | grep -i '<keyword>'"
```

## Common Log Patterns

| Pattern | Meaning |
|---------|---------|
| `Fatal Gateway error: 4014` | Discord intent not enabled |
| `discord: skipping guild message` | requireMention filtering |
| `unauthorized: gateway token mismatch` | Proxy trust issue |
| `disconnected (1008)` | WebSocket disconnect, pairing needed |
| Agent name in brackets `[kim]` | Message from specific agent |

## Analysis

After fetching logs, analyze for:
1. Error patterns (recurring errors)
2. Crash timestamps (when did it break)
3. Agent-specific issues (which agent)
4. External causes (API errors, rate limits)

Route to **Troubleshoot** workflow if issues need fixing.
