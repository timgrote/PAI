# SwitchModel Workflow

Change the AI model used by OpenClaw agents via OpenRouter.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the SwitchModel workflow in the OpenClaw skill to switch AI model"}' \
  > /dev/null 2>&1 &
```

Running the **SwitchModel** workflow in the **OpenClaw** skill to switch AI model...

## Model Format

OpenRouter model slugs: `openrouter/<author>/<slug>`

### Known Models

| Model | Slug | Notes |
|-------|------|-------|
| Grok 3 | `openrouter/xai/grok-3` | Current default |
| Kimi K2 | `openrouter/moonshotai/kimi-k2` | Chinese fallback risk — add English-only to SOUL.md |
| Claude Sonnet | `openrouter/anthropic/claude-sonnet-4` | Anthropic |
| GPT-4o | `openrouter/openai/gpt-4o` | OpenAI |

## Process

### 1. Backup Config
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-backup
```

### 2. Check Current Model
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get agents.defaults.model
```

### 3. Set New Model
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set agents.defaults.model.primary "openrouter/<author>/<slug>"
```

### 4. Verify API Key
Ensure OpenRouter API key is set:
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "grep OPENROUTER_API_KEY /opt/openclaw.env | head -1"
```

If switching to a provider that needs a different key, update `/opt/openclaw.env`.

### 5. Restart and Verify
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
```

Check logs for model loading confirmation:
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs --tail 10
```

### 6. Post-Switch Checks

**If switching to Kimi K2 or other non-English models:**
Ensure all agent SOUL.md files include:
```
Always respond in English. No exceptions.
```

**If model doesn't work:**
Check logs for API errors, verify the model slug is valid on OpenRouter, and ensure API key has access to the model.

## Rollback

If the new model causes issues:
```bash
# Restore config from backup
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "ls -t /home/openclaw/.openclaw/openclaw.json.backup.* | head -1"
# Copy backup back and restart
```
