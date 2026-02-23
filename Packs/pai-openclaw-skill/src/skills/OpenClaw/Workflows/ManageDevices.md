# ManageDevices Workflow

Manage browser device pairing and Discord user pairing for OpenClaw access.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the ManageDevices workflow in the OpenClaw skill to manage device pairing"}' \
  > /dev/null 2>&1 &
```

Running the **ManageDevices** workflow in the **OpenClaw** skill to manage device pairing...

## Context

OpenClaw requires device pairing for browser dashboard connections. When a new browser connects, it generates a unique device fingerprint and enters a "pairing required" state until approved via CLI.

**Dashboard URL:** `https://24.144.82.75/?token=<gateway-auth-token>`

## Operations

### List Pending Pairing Requests
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-list
```

### Approve Device
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-approve <request-id>
```

After approval, the browser auto-connects within seconds. The device fingerprint is remembered for future connections — no re-approval needed.

### Revoke Device
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh devices-revoke <request-id>
```

## Pairing Flow

1. User opens dashboard in browser
2. Browser assigned unique device fingerprint
3. Dashboard shows "pairing required" / "Health Offline"
4. Admin runs `devices-list` → finds pending request
5. Admin runs `devices-approve <id>` → browser auto-connects
6. Fingerprint remembered — subsequent visits work without re-pairing

## Discord User Pairing

When a Discord user PMs a bot (or messages in a guild with pairing policy), they get an access error with a **pairing code**:

```
OpenClaw: access not configured.
Your Discord user id: <user-id>
Pairing code: <CODE>
Ask the bot owner to approve with: openclaw pairing approve discord <code>
```

### Approve Discord User
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh raw "/opt/openclaw-cli.sh pairing approve discord <CODE>"
```

This pairs the Discord user ID permanently — they won't need to re-pair.

### Known Users
- Tim: `113738429250011142` (approved)

## Notes

- Browser device pairing: each page load generates a new device ID — multiple pending requests are normal
- Browser pairing requests have expiration timers
- Browser pairing is per-fingerprint, not per-session
- Discord user pairing is per-user-ID, permanent after approval
- Both types are required by design when pairing policies are active
