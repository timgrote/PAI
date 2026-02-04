# Security Templates Reference (Technique #9)

Based on official Claude Code `settings-strict.json` and `settings-lax.json` templates from Anthropic.

---

## Permission Precedence (Technique #7)

**Content-level `ask` takes precedence over tool-level `allow`.**

This enables layered security: allow broad tool access while requiring confirmation for dangerous patterns.

```json
{
  "permissions": {
    "allow": ["Bash"],
    "ask": [
      "Bash(rm -rf *)",
      "Bash(rm -r *)",
      "Bash(sudo rm *)",
      "Bash(git push --force*)",
      "Bash(git push -f *)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(chmod 777 *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)",
      "Bash(wget * | bash)",
      "Bash(> /dev/*)",
      "Bash(dd if=*)"
    ]
  }
}
```

---

## Strict Template

For high-security environments or enterprise deployments:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "allowManagedPermissionRulesOnly": true,
  "allowManagedHooksOnly": true,
  "permissions": {
    "disableBypassPermissionsMode": "disable",
    "allow": [],
    "ask": ["Bash"],
    "deny": ["WebSearch", "WebFetch"]
  },
  "sandbox": {
    "autoAllowBashIfSandboxed": false,
    "network": {
      "allowAllUnixSockets": false,
      "allowLocalBinding": false
    }
  }
}
```

**Key Features:**
- No automatic permissions - everything requires approval
- Managed-only rules prevent user modifications
- Web access disabled (air-gapped mode)
- Sandbox restrictions on network

---

## Balanced Template (Recommended for PAI)

Applied to Personal and TIE vaults:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [],
    "deny": [],
    "ask": [
      "Bash(rm -rf *)",
      "Bash(rm -r *)",
      "Bash(sudo rm *)",
      "Bash(git push --force*)",
      "Bash(git push -f *)",
      "Bash(git reset --hard*)",
      "Bash(git clean -f*)",
      "Bash(chmod 777 *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)",
      "Bash(curl * | sh)",
      "Bash(wget * | bash)",
      "Bash(> /dev/*)",
      "Bash(dd if=*)"
    ]
  }
}
```

**Why This Works:**
- Allows normal workflow without constant confirmations
- Catches destructive operations before execution
- Works with existing `settings.local.json` allowed commands
- Defense in depth with SecurityValidator hook

---

## Lax Template

For development/testing environments:

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": ["Bash", "Edit", "Write", "Read"],
    "deny": [],
    "ask": []
  }
}
```

**Warning:** Only use in sandboxed environments or when you fully trust the workflow.

---

## Integration with PAI Security

### Defense in Depth

PAI uses multiple security layers:

1. **Permission Templates** (this file) - Base permission rules
2. **SecurityValidator Hook** - Real-time command validation
3. **`.pai-protected.json`** - API key and secret detection patterns
4. **TruffleHog** - Pre-commit secret scanning

### Hook + Permission Synergy

The SecurityValidator hook handles:
- Complex pattern matching beyond glob syntax
- Contextual security decisions
- Audit logging to MEMORY/SECURITY/

Permission templates handle:
- First-line defense for obvious dangerous commands
- Simpler patterns that don't need hook logic
- User-visible confirmation prompts

---

## Applying Templates

**Personal Vault:**
```bash
# Already applied - /mnt/d/Dropbox/Personal/.claude/settings.json
```

**TIE Vault:**
```bash
# Already applied - /mnt/d/Dropbox/TIE/.claude/settings.json
```

**New Projects:**
1. Copy the balanced template to `.claude/settings.json`
2. Add project-specific allows to `settings.local.json`
3. The `ask` patterns from settings.json will still require confirmation

---

## Last Updated

2026-02-04 - Added based on Claude Code v2.1.27 permission precedence feature
