---
name: OpenClaw
description: Manage OpenClaw personal AI assistant on DigitalOcean. USE WHEN openclaw, claw, agents, discord bots, check status, manage agents, switch model, troubleshoot openclaw, device pairing, openclaw skills, openclaw logs, or openclaw config.
---

## Customization

**Before executing, check for user customizations at:**
`~/.claude/skills/CORE/USER/SKILLCUSTOMIZATIONS/OpenClaw/`

If this directory exists, load and apply any PREFERENCES.md, configurations, or resources found there. These override default behavior. If the directory does not exist, proceed with skill defaults.

# OpenClaw

Manage and troubleshoot Tim's OpenClaw personal AI assistant running on a DigitalOcean droplet. Three agents (ClawBot, Kim, Dobby), three Discord bots, browser dashboard, skill system.

## SSH Tool

All operations go through the SSH wrapper:

**Tool:** `~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh`

```bash
# Quick examples
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh doctor
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh agents-list
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get agents
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs --tail 20
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-list
```

## Voice Notification

**You MUST send this notification BEFORE doing anything else when this skill is invoked.**

1. **Send voice notification**:
   ```bash
   curl -s -X POST http://localhost:8888/notify \
     -H "Content-Type: application/json" \
     -d '{"message": "Running the WORKFLOWNAME workflow in the OpenClaw skill to ACTION"}' \
     > /dev/null 2>&1 &
   ```

2. **Output text notification**:
   ```
   Running the **WorkflowName** workflow in the **OpenClaw** skill to ACTION...
   ```

## Workflow Routing

| Workflow | Trigger | File |
|----------|---------|------|
| **CheckStatus** | "check openclaw", "is openclaw running", "openclaw status", "health check" | `Workflows/CheckStatus.md` |
| **ManageAgents** | "add agent", "delete agent", "update soul", "agent config", "edit identity" | `Workflows/ManageAgents.md` |
| **SwitchModel** | "switch model", "change model", "use grok", "use kimi", "model config" | `Workflows/SwitchModel.md` |
| **ManageDiscord** | "discord bot", "add bot", "binding", "requireMention", "discord config" | `Workflows/ManageDiscord.md` |
| **ManageSkills** | "openclaw skills", "install skill", "clawhub", "list skills" | `Workflows/ManageSkills.md` |
| **EditConfig** | "edit openclaw config", "config set", "update config", "openclaw settings" | `Workflows/EditConfig.md` |
| **Troubleshoot** | "openclaw broken", "bot not responding", "fix openclaw", "crash", "debug openclaw" | `Workflows/Troubleshoot.md` |
| **ViewLogs** | "openclaw logs", "show errors", "tail logs", "journal" | `Workflows/ViewLogs.md` |
| **ManageDevices** | "device pairing", "approve device", "list devices", "pair browser" | `Workflows/ManageDevices.md` |
| **UpdateOpenClaw** | "update openclaw", "upgrade openclaw", "check openclaw version" | `Workflows/UpdateOpenClaw.md` |

## Reference Files

Load these on-demand when detailed context is needed:

| File | When to Load |
|------|-------------|
| `Infrastructure.md` | Server details, paths, config format, service management |
| `AgentReference.md` | Agent system, identities, souls, memory, workspaces |
| `DiscordReference.md` | Discord multi-bot setup, bindings, intents, OAuth2 |
| `TroubleshootingGuide.md` | Known issues, error messages, decision trees |

## Examples

**Example 1: Check health**
```
User: "Is openclaw running?"
-> Invokes CheckStatus workflow
-> Runs status-deep via SSH tool
-> Reports service state, agent status, recent errors
```

**Example 2: Switch AI model**
```
User: "Switch openclaw to grok-3"
-> Invokes SwitchModel workflow
-> Backs up config, sets new model, restarts, verifies
```

**Example 3: Fix crash**
```
User: "Openclaw keeps crashing"
-> Invokes Troubleshoot workflow
-> Loads TroubleshootingGuide.md for known issues
-> Checks logs, identifies root cause, applies fix
```

**Example 4: Approve browser**
```
User: "Approve my browser for openclaw"
-> Invokes ManageDevices workflow
-> Lists pending requests, approves device
```
