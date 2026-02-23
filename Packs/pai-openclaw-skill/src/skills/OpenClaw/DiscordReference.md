# OpenClaw Discord Reference

## Multi-Bot Architecture

OpenClaw supports multiple Discord bot accounts, each bound to a different agent. Each bot needs its own Discord application, token, and gateway intents.

## Current Bots

| Bot | Account Name | Bot ID | Agent | Status |
|-----|-------------|--------|-------|--------|
| @ClawBot | (default) | `1469506033901768726` | main | Active |
| @Kim | `kim` | `1469682992258744534` | kim | Active |
| @Dobby | `dobby` | `1469711311943368790` | dobby | Check config |

**Guild ID:** `774002504895430657`
**Channel ID:** `888179202342404187`

## Config Structure

### Bot Accounts
```json
"channels": {
  "discord": {
    "accounts": {
      "kim": { "token": "<bot-token>" },
      "dobby": { "token": "<bot-token>" }
    }
  }
}
```

The default/main bot token is in `/opt/openclaw.env`.

### Guild Settings
```json
"channels": {
  "discord": {
    "guilds": {
      "774002504895430657": {
        "requireMention": false,
        "channels": {
          "channel-name": { "allow": true }
        }
      }
    },
    "groupPolicy": "open"
  }
}
```

### Routing Bindings
```json
"routing": {
  "bindings": [
    { "channel": "discord", "account": "kim", "agent": "kim" },
    { "channel": "discord", "account": "dobby", "agent": "dobby" }
  ]
}
```

Each binding maps: Discord account -> Agent. The default agent handles unbound accounts.

## Discord Bot Token Format

Token structure: `<base64-bot-id>.<timestamp>.<hmac>`
- First segment (before first `.`) is base64-encoded bot ID
- Token is the **secret** — treat like a password

## Setting Up a New Discord Bot

### 1. Create Application
- Go to https://discord.com/developers/applications
- New Application -> name it
- Bot section -> Reset Token -> copy token

### 2. Enable Privileged Intents (CRITICAL)
In Discord Developer Portal -> Bot -> Privileged Gateway Intents:
- **Message Content Intent** - REQUIRED (without it: error 4014 crash loop)
- Server Members Intent - recommended
- Presence Intent - optional

### 3. Generate Invite URL
OAuth2 -> URL Generator:
- **Scopes:** `bot`, `applications.commands`
- **Bot Permissions:** Send Messages, Read Message History, Read Messages/View Channels
- **Integration Type:** Guild Install: ENABLED, User Install: DISABLED

### 4. Add to OpenClaw Config
```bash
# Add account token
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.accounts.<name>.token "<token>"

# Add binding
# (May need direct config edit for array operations)

# Restart
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh restart
```

## Key Settings

### requireMention
- `true` (default) - Bot only responds when @mentioned
- `false` - Bot responds to all messages in allowed channels

```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-set channels.discord.guilds.774002504895430657.requireMention false
```

### groupPolicy
- `"open"` - Bot responds in any guild it's in
- `"pairing"` - Requires device-style pairing per guild
- `"allowlist"` - Only responds in explicitly listed guilds

## Common Discord Issues

### Bot not responding (no-mention skip)
```
Log: "discord: skipping guild message, reason: no-mention"
Fix: Set requireMention to false for the guild
```

### Error 4014 crash loop
```
Log: "Fatal Gateway error: 4014" / "Disallowed intent(s)"
Fix: Enable Message Content Intent in Discord Developer Portal
```

### Bot token invalidation
If a token is regenerated in Discord Developer Portal, the old one stops working immediately. Update in both:
1. `/opt/openclaw.env` (for main bot)
2. `openclaw.json` accounts section (for additional bots)
Then restart.
