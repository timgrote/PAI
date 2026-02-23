# OpenClaw Agent Reference

## Agent System Overview

Each agent has:
- **Workspace directory** at `/home/openclaw/.openclaw/agents/<agent-id>/`
- **SOUL.md** - Personality definition (tone, style, behavioral rules)
- **IDENTITY.md** - Name, role, display info
- **MEMORY.md** - Persistent long-term memory (loaded at session start)
- **YYYY-MM-DD.md** - Daily memory files (auto-created when agent remembers things)

## Current Agents

### ClawBot (Default/Main)

| Property | Value |
|----------|-------|
| **Agent ID** | `main` (default agent) |
| **Display Name** | ClawBot |
| **Model** | `openrouter/xai/grok-3` |
| **Discord Bot** | @ClawBot |
| **Bot ID** | `1469506033901768726` |
| **Workspace** | `/home/openclaw/.openclaw/agents/main/` |

### Kim

| Property | Value |
|----------|-------|
| **Agent ID** | `kim` |
| **Display Name** | Kim |
| **Model** | `openrouter/moonshotai/kimi-k2` |
| **Personality** | Terse, Tank Girl vibe |
| **Discord Bot** | @Kim |
| **Bot ID** | `1469682992258744534` |
| **Workspace** | `/home/openclaw/.openclaw/agents/kim/` |

### Dobby

| Property | Value |
|----------|-------|
| **Agent ID** | `dobby` |
| **Display Name** | Dobby |
| **Model** | `openrouter/moonshotai/kimi-k2` |
| **Personality** | Harry Potter house-elf |
| **Discord Bot** | @Dobby |
| **Bot ID** | `1469711311943368790` |
| **Workspace** | `/home/openclaw/.openclaw/agents/dobby/` |
| **Status** | May be disabled in config (had 4014 crash issues) |

## Model Configuration

Models are set via OpenRouter format: `openrouter/<author>/<slug>`

**Known working models:**
- `openrouter/xai/grok-3` - xAI Grok 3
- `openrouter/moonshotai/kimi-k2` - Moonshot Kimi K2 (Chinese fallback risk)

**Set default model:**
```bash
/opt/openclaw-cli.sh config set agents.defaults.model.primary "openrouter/<author>/<slug>"
```

**Per-agent model override:** Set in agent config section (if supported by version).

## Memory System

### MEMORY.md (Long-term)
- Loaded at start of every private session
- Contains: preferences, credentials, decisions, persistent facts
- Manually editable via file-write

### Daily Memory (YYYY-MM-DD.md)
- Auto-created when agent uses "remember that..." in conversation
- One file per day per agent
- Context window: 131k tokens (auto-trims when full, saves important details)

## Agent Workspace Operations

### Read agent soul
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-read /home/openclaw/.openclaw/agents/<id>/SOUL.md
```

### Update agent soul
Write new content to SOUL.md (use file-write or raw SSH):
```bash
echo "New soul content..." | ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-write /home/openclaw/.openclaw/agents/<id>/SOUL.md
```

### Create new agent
1. Create workspace: `agents-add <id>`
2. Create SOUL.md, IDENTITY.md, MEMORY.md in workspace
3. Add Discord account + token in config (if using Discord)
4. Add binding in routing config
5. Restart service

### Important: English-Only Rule
Non-English models (especially Kimi K2) need this in SOUL.md:
```
Always respond in English. No exceptions.
```
Without this, Kimi K2 may fall back to Chinese responses.
