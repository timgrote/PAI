# ManageDiscord Workflow

Configure Discord bots, channels, bindings, and guild settings for OpenClaw.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the ManageDiscord workflow in the OpenClaw skill to manage Discord bots"}' \
  > /dev/null 2>&1 &
```

Running the **ManageDiscord** workflow in the **OpenClaw** skill to manage Discord bots...

## Reference

Load `DiscordReference.md` for current bot inventory, config structure, and OAuth2 setup instructions.

## Operations

### View Current Discord Config
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get channels.discord
```

### View Bindings
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get routing.bindings
```

### Add New Discord Bot

1. **Create Discord Application** (user must do in Discord Developer Portal):
   - New Application -> name it
   - Bot section -> Reset Token -> copy token
   - Enable **Message Content Intent** (critical — prevents 4014 crash)
   - Generate invite URL: scopes `bot` + `applications.commands`

2. **Add bot token to config:**
   ```bash
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.accounts.<name>.token "<token>"
   ```

3. **Add routing binding** (may require direct config edit for array operations):
   ```bash
   # Read current config
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-get routing
   # Edit to add new binding entry, then write back via EditConfig workflow
   ```

4. **Restart:**
   ```bash
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
   ```

### Set requireMention

```bash
# Disable (bot responds to all messages)
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.guilds.774002504895430657.requireMention false

# Enable (bot only responds when @mentioned)
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.guilds.774002504895430657.requireMention true

~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
```

### Set groupPolicy

```bash
# Open (respond in any guild)
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.groupPolicy '"open"'

# Allowlist (only explicitly listed guilds)
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.groupPolicy '"allowlist"'
```

### Update Bot Token

If token is regenerated in Discord Developer Portal:
1. Update in config:
   ```bash
   ~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.accounts.<name>.token "<new-token>"
   ```
2. For main bot, also update `/opt/openclaw.env`
3. Restart service

### Remove Discord Bot

1. Remove account from config
2. Remove binding from routing
3. Restart service

## Troubleshooting

- **4014 crash:** Bot missing Message Content Intent — enable in Developer Portal
- **no-mention skip:** Set `requireMention: false` for the guild
- **groupPolicy block:** Check per-account and top-level groupPolicy settings
