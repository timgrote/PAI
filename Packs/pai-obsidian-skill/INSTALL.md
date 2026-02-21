# PAI Obsidian Skill v1.0.0 - Installation Guide

**This guide is designed for AI agents installing this pack into a user's infrastructure.**

---

## AI Agent Instructions

**This is a wizard-style installation.** Use Claude Code's native tools to guide the user through installation:

1. **AskUserQuestion** - For user decisions and confirmations
2. **Bash/Read/Write** - For actual installation
3. **VERIFY.md** - For final validation

### Welcome Message

Before starting, greet the user:
```
"I'm installing PAI Obsidian Skill v1.0.0 - Vault operations via the official Obsidian CLI. This skill lets me read, write, search, and manage your Obsidian notes directly from the terminal.

Let me analyze your system and guide you through installation."
```

---

## Phase 1: System Analysis

**Execute this analysis BEFORE any file operations.**

### 1.1 Run These Commands

```bash
PAI_CHECK="${PAI_DIR:-$HOME/.claude}"
echo "PAI_DIR: $PAI_CHECK"

# Check if pai-core-install is installed (REQUIRED)
if [ -f "$PAI_CHECK/skills/CORE/SKILL.md" ]; then
  echo "OK pai-core-install is installed"
else
  echo "ERROR pai-core-install NOT installed - REQUIRED!"
fi

# Check for existing Obsidian skill
if [ -d "$PAI_CHECK/skills/Obsidian" ]; then
  echo "WARNING Existing Obsidian skill found at: $PAI_CHECK/skills/Obsidian"
else
  echo "OK No existing Obsidian skill (clean install)"
fi

# Check for Obsidian CLI
if command -v obsidian &>/dev/null; then
  echo "OK Obsidian CLI accessible via alias/PATH"
  obsidian version 2>/dev/null
elif [ -f "/mnt/c/Users/$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/AppData/Local/Programs/Obsidian/Obsidian.com" ]; then
  echo "OK Obsidian CLI found at Windows path (needs alias)"
else
  echo "ERROR Obsidian CLI not found"
fi

# Check if Obsidian is running
if obsidian version &>/dev/null; then
  echo "OK Obsidian is running and responding to CLI"
else
  echo "WARNING Obsidian may not be running (CLI requires running app)"
fi
```

### 1.2 Present Findings

Tell the user what you found:
```
"Here's what I found on your system:
- pai-core-install: [installed / NOT INSTALLED - REQUIRED]
- Existing Obsidian skill: [Yes / No]
- Obsidian CLI: [accessible / needs alias / NOT FOUND]
- Obsidian running: [Yes / No - REQUIRED for CLI]"
```

**STOP if pai-core-install is not installed.** Tell the user to install it first.

**If Obsidian CLI not found:** Guide the user through CLI setup:
1. Obsidian 1.12+ required (check for updates)
2. Catalyst license ($25 one-time, Early Access)
3. Enable CLI in Settings → Command line interface
4. Download `Obsidian.com` from Discord #insider-desktop-release
5. Place in Obsidian install folder

---

## Phase 2: Installation

### 2.1 Create Directory Structure

```bash
PAI_DIR="${PAI_DIR:-$HOME/.claude}"
mkdir -p "$PAI_DIR/skills/Obsidian/Workflows"
```

### 2.2 Copy Skill Files

```bash
PACK_DIR="$(pwd)"
PAI_DIR="${PAI_DIR:-$HOME/.claude}"

cp -r "$PACK_DIR/src/skills/Obsidian/"* "$PAI_DIR/skills/Obsidian/"
```

### 2.3 Set Up WSL Alias (if needed)

If the CLI is accessible via Windows path but not aliased:

```bash
# Detect Windows username
WIN_USER=$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r')
OBSIDIAN_PATH="/mnt/c/Users/$WIN_USER/AppData/Local/Programs/Obsidian/Obsidian.com"

if [ -f "$OBSIDIAN_PATH" ] && ! command -v obsidian &>/dev/null; then
  echo "alias obsidian=\"$OBSIDIAN_PATH\"" >> ~/.bashrc
  echo "Alias added to ~/.bashrc"
fi
```

---

## Phase 3: Verification

**Execute all checks from VERIFY.md.**

---

## Success Message

```
"PAI Obsidian Skill v1.0.0 installed successfully!

What's available:
- Read, create, and edit notes from terminal
- Search vault with full-text and contextual search
- Manage daily notes (read, append, prepend)
- List and toggle tasks across the vault
- Query tags, properties, and vault structure

Usage examples:
- 'Read my Big Ideas note' → obsidian read file="Big Ideas"
- 'Search vault for MCP' → obsidian search query="MCP"
- 'Add to today's journal' → obsidian daily:append content="..."
- 'List my incomplete tasks' → obsidian tasks todo"
```
