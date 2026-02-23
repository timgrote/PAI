# UpdateOpenClaw Workflow

Safely upgrade OpenClaw from upstream git repo while preserving all user data.

## Voice Notification

```bash
curl -s -X POST http://localhost:8888/notify \
  -H "Content-Type: application/json" \
  -d '{"message": "Running the UpdateOpenClaw workflow in the OpenClaw skill to upgrade OpenClaw"}' \
  > /dev/null 2>&1 &
```

Running the **UpdateOpenClaw** workflow in the **OpenClaw** skill to upgrade OpenClaw...

## Architecture

- **Repo:** `/opt/openclaw/` — git clone of `github.com/openclaw/openclaw.git`
- **User data:** `/home/openclaw/.openclaw/` — config, agents, workspaces (outside repo, safe from updates)
- **Service:** `openclaw.service` — runs `node /opt/openclaw/dist/index.js gateway`
- **Owner:** `openclaw` user (all git/build commands must run as this user)

## Process

### 1. Check for Updates
```bash
sudo -u openclaw git -C /opt/openclaw fetch origin
sudo -u openclaw git -C /opt/openclaw log --oneline -1 HEAD
sudo -u openclaw git -C /opt/openclaw log --oneline -1 origin/main
sudo -u openclaw git -C /opt/openclaw rev-list HEAD..origin/main --count
```

If 0 commits behind, stop — already up to date.

### 2. Check for Local Modifications
```bash
sudo -u openclaw git -C /opt/openclaw status --short
```

If dirty: stash or commit local changes before proceeding.

### 3. Backup Config
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh config-backup
```

### 4. Stop Service
```bash
systemctl stop openclaw
```

### 5. Pull Updates
```bash
sudo -u openclaw git -C /opt/openclaw pull origin main
```

### 6. Install Dependencies
```bash
cd /opt/openclaw && sudo -u openclaw pnpm install --frozen-lockfile
```

If `--frozen-lockfile` fails (lockfile changed), use `pnpm install` instead.

### 7. Build
```bash
cd /opt/openclaw && sudo -u openclaw pnpm build
```

### 8. Start Service
```bash
systemctl start openclaw
```

### 9. Verify Health
```bash
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh status-deep
~/.claude/skills/OpenClaw/Tools/OpenClawSSH.sh logs --tail 10
```

## Rollback

If the upgrade fails:
```bash
systemctl stop openclaw
sudo -u openclaw git -C /opt/openclaw reset --hard <previous-commit>
cd /opt/openclaw && sudo -u openclaw pnpm install --frozen-lockfile
cd /opt/openclaw && sudo -u openclaw pnpm build
systemctl start openclaw
```

## Notes

- User data in `~/.openclaw/` is never touched by git operations
- Always run git/pnpm as `openclaw` user (repo ownership)
- The `dist/` directory is rebuilt from source on each upgrade
- Check CHANGELOG.md for breaking changes before major version jumps
