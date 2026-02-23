# OpenClaw Infrastructure Reference

## Server

| Property | Value |
|----------|-------|
| **IP** | `24.144.82.75` |
| **SSH** | `root@24.144.82.75` |
| **OS** | Ubuntu, Linux 6.8.0-71 |
| **Specs** | 2 vCPU, 4GB RAM, 120GB disk (Intel) |
| **Region** | DigitalOcean SFO3 |
| **Hostname** | `openclaw-ubuntu-s-2vcpu-4gb-120gb-intel-sfo3-01` |

## File System Layout

```
/opt/
  openclaw-cli.sh              # CLI tool (main interface)
  openclaw.env                 # Environment variables (API keys, tokens)

/home/openclaw/.openclaw/
  openclaw.json                # Main configuration file (JSON5)
  agents/
    main/                      # Default agent (ClawBot) workspace
      SOUL.md                  # Personality definition
      IDENTITY.md              # Identity card
      MEMORY.md                # Persistent long-term memory
    kim/                       # Kim agent workspace
      SOUL.md
      IDENTITY.md
      MEMORY.md
      YYYY-MM-DD.md            # Daily memory files
    dobby/                     # Dobby agent workspace
      SOUL.md
      IDENTITY.md
      MEMORY.md
  skills/                      # Installed skills directory
```

## Configuration (openclaw.json)

Full config structure:

```json
{
  "gateway": {
    "auth": {
      "token": "<gateway-auth-token>"
    },
    "remote": {
      "token": null
    },
    "trustedProxies": ["127.0.0.1", "::1"]
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "openrouter/<author>/<slug>",
        "fallback": null
      }
    }
  },
  "channels": {
    "discord": {
      "accounts": {
        "<account-name>": {
          "token": "<discord-bot-token>"
        }
      },
      "guilds": {
        "<guild-id>": {
          "requireMention": false,
          "channels": {
            "<channel-name>": { "allow": true }
          }
        }
      },
      "groupPolicy": "open"
    }
  },
  "routing": {
    "bindings": [
      {
        "channel": "discord",
        "account": "<account-name>",
        "agent": "<agent-id>"
      }
    ]
  }
}
```

## Environment File (/opt/openclaw.env)

Contains:
- `OPENROUTER_API_KEY` - OpenRouter API key for model access
- Discord bot tokens (also duplicated in openclaw.json accounts)

## Service Management

```bash
systemctl status openclaw       # Check status
systemctl restart openclaw      # Restart service
systemctl stop openclaw         # Stop service
systemctl start openclaw        # Start service
journalctl -u openclaw -f       # Live log tail
journalctl -u openclaw --since "1h ago"  # Recent logs
```

## Caddy Reverse Proxy

- **Public URL:** `https://24.144.82.75`
- **Internal:** `127.0.0.1:18789` (localhost-only dashboard)
- **TLS:** Let's Encrypt with short-lived certs (6-day, auto-renew)
- **Note:** Caddy connects via IPv6 `::1` — must be in `trustedProxies`

## Dashboard Access

- **URL:** `https://24.144.82.75/?token=<gateway-auth-token>`
- **Token:** Set in `gateway.auth.token` in openclaw.json
- **Device pairing:** Required for first browser connection (see ManageDevices workflow)

## CLI Tool (/opt/openclaw-cli.sh)

```bash
# Configuration
/opt/openclaw-cli.sh config set <key.path> <value>
/opt/openclaw-cli.sh config get <key.path>

# Devices
/opt/openclaw-cli.sh devices list
/opt/openclaw-cli.sh devices approve <request-id>

# Skills
/opt/openclaw-cli.sh skills list
/opt/openclaw-cli.sh skills install <name>
/opt/openclaw-cli.sh skills remove <name>
/opt/openclaw-cli.sh skills search <query>
```

## Backup Convention

Config backups use timestamp format:
```
/home/openclaw/.openclaw/openclaw.json.backup.YYYYMMDD-HHMMSS
```

Always backup before config changes.
