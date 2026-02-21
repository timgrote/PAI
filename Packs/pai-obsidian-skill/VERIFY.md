---
name: pai-obsidian-skill-verify
version: 1.0.0
---

# Verification Guide

Verify your Obsidian skill installation is working correctly.

## Quick Verification

### 1. Check Files Exist

```bash
ls ~/.claude/skills/Obsidian/
# Should show: SKILL.md Workflows/
```

### 2. Check CLI Accessibility

```bash
obsidian version
# Should return Obsidian version number
```

### 3. Check Vault Connection

```bash
obsidian vaults verbose
# Should list known vaults with paths
```

### 4. Test Read Operation

```bash
obsidian vault
# Should return vault name, path, file count
```

## Comprehensive Verification

### Test Each Capability

```bash
echo "=== PAI Obsidian Skill v1.0.0 Verification ==="

# Check skill file
echo "Checking skill file..."
[ -f "${PAI_DIR:-$HOME/.claude}/skills/Obsidian/SKILL.md" ] && echo "OK SKILL.md" || echo "ERROR SKILL.md missing"

# Check workflows
echo ""
echo "Checking workflows..."
for wf in DailyNote Search Notes Tasks VaultInfo; do
  [ -f "${PAI_DIR:-$HOME/.claude}/skills/Obsidian/Workflows/${wf}.md" ] && echo "OK ${wf}.md" || echo "ERROR ${wf}.md missing"
done

# Check CLI
echo ""
echo "Checking Obsidian CLI..."
if obsidian version &>/dev/null; then
  echo "OK CLI responding: $(obsidian version 2>/dev/null)"
else
  echo "ERROR CLI not responding (is Obsidian running?)"
fi

# Check vault access
echo ""
echo "Checking vault access..."
obsidian vaults verbose 2>/dev/null && echo "OK Vaults accessible" || echo "ERROR Cannot access vaults"

# Test search
echo ""
echo "Testing search..."
obsidian search query="test" limit=1 2>/dev/null && echo "OK Search working" || echo "ERROR Search failed"

# Test daily note
echo ""
echo "Testing daily note..."
obsidian daily:path 2>/dev/null && echo "OK Daily note path resolved" || echo "WARNING Daily note not configured"

echo ""
echo "=== Verification Complete ==="
```

## Feature Verification Checklist

| Feature | Test Command | Expected Result |
|---------|--------------|-----------------|
| CLI access | `obsidian version` | Version number |
| Vault list | `obsidian vaults verbose` | Vault names + paths |
| Vault info | `obsidian vault` | Name, path, file count |
| Search | `obsidian search query="test" limit=1` | Search results |
| Daily note | `obsidian daily:path` | File path |
| File list | `obsidian files total` | File count |
| Tags | `obsidian tags total` | Tag count |
| Tasks | `obsidian tasks total` | Task count |

## Troubleshooting

### "command not found: obsidian"

Add alias to `~/.bashrc`:
```bash
alias obsidian="/mnt/c/Users/<username>/AppData/Local/Programs/Obsidian/Obsidian.com"
source ~/.bashrc
```

### CLI returns nothing / exit code 1

Obsidian must be running. The CLI communicates via IPC with the app.

### "vault not found"

Check vault name matches exactly:
```bash
obsidian vaults verbose
```

Use `vault=<exact-name>` parameter.

## Success Criteria

Installation is verified when:

1. `SKILL.md` and all workflow files exist
2. `obsidian version` returns a version
3. `obsidian vaults verbose` lists vaults
4. `obsidian search query="test"` returns results
