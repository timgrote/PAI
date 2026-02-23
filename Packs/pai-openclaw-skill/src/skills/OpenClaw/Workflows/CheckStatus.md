# CheckStatus Workflow

Health check for the OpenClaw service, agents, Discord bots, and infrastructure.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the CheckStatus workflow in the OpenClaw skill to check system health"}' \
  > /dev/null 2>&1 &
```

Running the **CheckStatus** workflow in the **OpenClaw** skill to check system health...

## Process

### 1. Quick Check
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status
```

If running, proceed to deep check. If stopped, jump to Step 4.

### 2. Deep Health Check
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep
```

Reports:
- Service state (active/inactive)
- Caddy proxy status
- Dashboard reachability
- Config summary (model, accounts, bindings, proxies)
- Recent errors (last 5 minutes)

### 3. Full Diagnostic (if issues found)
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh doctor
```

Reports:
- System resources (uptime, disk, memory)
- All service statuses
- Network connectivity (internal + public)
- Config validation
- Agent workspace integrity

### 4. If Service is Down

Check recent logs for crash reason:
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors --tail 20
```

Then route to **Troubleshoot** workflow if needed.

## Output

Report to user:
- Service status (running/stopped)
- Agent count and model
- Discord bot connectivity
- Any active issues or recent errors
- Resource utilization if relevant

## Success Criteria

- **Healthy:** Service running, no recent errors, dashboard reachable
- **Degraded:** Service running but errors present
- **Down:** Service stopped, needs troubleshooting
