# ManageAgents Workflow

Create, configure, and delete OpenClaw agents. Manage identity, soul, and memory files.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the ManageAgents workflow in the OpenClaw skill to manage agents"}' \
  > /dev/null 2>&1 &
```

Running the **ManageAgents** workflow in the **OpenClaw** skill to manage agents...

## Reference

Load `AgentReference.md` for current agent inventory, workspace paths, and file formats.

## Operations

### List Agents
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh agents-list
```

### Read Agent Files
```bash
# Read soul, identity, or memory
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-read /home/openclaw/.openclaw/agents/<id>/SOUL.md
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-read /home/openclaw/.openclaw/agents/<id>/IDENTITY.md
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-read /home/openclaw/.openclaw/agents/<id>/MEMORY.md
```

### Update Agent Soul/Identity/Memory

1. Read current file content
2. Modify as needed
3. Write back via SSH:
```bash
echo "<new content>" | ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-write /home/openclaw/.openclaw/agents/<id>/SOUL.md
```
4. Restart service: `~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart`

### Create New Agent

1. **Create workspace:**
   ```bash
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh agents-add <agent-id>
   ```

2. **Create SOUL.md** with personality definition:
   ```bash
   echo "You are <name>. <personality description>.

   Always respond in English. No exceptions." | \
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh file-write /home/openclaw/.openclaw/agents/<id>/SOUL.md
   ```

3. **Create IDENTITY.md** with agent identity card.

4. **Create MEMORY.md** with initial persistent facts.

5. **If using Discord:** Set up bot account and binding (see ManageDiscord workflow).

6. **Restart:** `~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart`

### Delete Agent

1. Remove routing binding from config (via EditConfig workflow)
2. Remove Discord account from config (if applicable)
3. Delete workspace:
   ```bash
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh agents-delete <agent-id>
   ```
4. Restart service

## Important Notes

- **English-only rule:** Always include "Always respond in English. No exceptions." in SOUL.md for non-English models (especially Kimi K2)
- **Restart required:** Changes to agent files take effect after service restart
- **Memory persistence:** MEMORY.md is loaded at session start; daily YYYY-MM-DD.md files are auto-created
- **Context window:** 131k tokens per agent, auto-trims when full
