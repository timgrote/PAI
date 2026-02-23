# EditConfig Workflow

Safely edit openclaw.json with automatic backup, validation, and rollback on failure.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the EditConfig workflow in the OpenClaw skill to edit configuration"}' \
  > /dev/null 2>&1 &
```

Running the **EditConfig** workflow in the **OpenClaw** skill to edit configuration...

## Reference

Load `Infrastructure.md` for full config structure and path details.

## Process

### 1. Backup Current Config
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-backup
```

### 2. Read Current Config
```bash
# Full config
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get

# Specific section
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get <section.path>
```

### 3. Apply Changes

**For simple key-value changes:**
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set <key.path> <value>
```

**For complex changes (arrays, nested objects):**
Read full config, modify locally, write back:
```bash
# Read config
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get > /tmp/openclaw-config.json

# Edit locally, then write back
cat /tmp/openclaw-config.json | ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-write /home/openclaw/.openclaw/openclaw.json
```

### 4. Validate Config
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "jq empty /home/openclaw/.openclaw/openclaw.json && echo 'VALID' || echo 'INVALID'"
```

If **INVALID**: Restore from backup immediately:
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "BACKUP=\$(ls -t /home/openclaw/.openclaw/openclaw.json.backup.* | head -1) && cp \"\$BACKUP\" /home/openclaw/.openclaw/openclaw.json && echo 'Restored from backup'"
```

### 5. Restart Service
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
```

### 6. Verify Health
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status
```

If service fails to start, check logs and consider rollback:
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs-errors --tail 10
```

## Common Config Paths

| Path | Purpose | Example Value |
|------|---------|--------------|
| `agents.defaults.model.primary` | Default AI model | `"openrouter/xai/grok-3"` |
| `agents.defaults.model.fallback` | Fallback model | `null` |
| `channels.discord.guilds.<id>.requireMention` | Mention requirement | `false` |
| `channels.discord.groupPolicy` | Guild access policy | `"open"` |
| `channels.discord.accounts.<name>.token` | Bot token | `"<token>"` |
| `gateway.trustedProxies` | Trusted proxy IPs | `["127.0.0.1", "::1"]` |

## Safety Rules

1. **Always backup before editing**
2. **Always validate JSON after editing**
3. **Always restart and verify after changes**
4. **Auto-rollback if validation fails**
