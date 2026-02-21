---
name: PAI Obsidian Skill
pack-id: danielmiessler-pai-obsidian-skill-v1.0.0
version: 1.0.0
author: danielmiessler
description: Obsidian vault operations via the official Obsidian CLI (v1.12+). Read, write, search, and manage notes from the terminal.
type: skill
purpose-type: [vault-management, note-taking, knowledge-base]
platform: claude-code
dependencies: [pai-core-install, obsidian-cli]
keywords: [obsidian, vault, notes, daily-notes, search, tags, tasks, knowledge-management]
---

# PAI Obsidian Skill Pack

Direct Obsidian vault manipulation via the official Obsidian CLI (v1.12+). Read, create, search, append, manage tasks, tags, properties, and more — all from the terminal.

## What's Included

```
src/skills/Obsidian/
  SKILL.md              # Main skill definition and routing
  Workflows/
    DailyNote.md        # Daily note operations
    Search.md           # Vault search operations
    Notes.md            # Create, read, append, prepend notes
    Tasks.md            # Task management
    VaultInfo.md        # Vault structure and metadata
```

## Key Features

- **Daily Notes**: Open, read, append to daily notes
- **Search**: Full-text search with context across the vault
- **Notes**: Create, read, append, prepend content to any note
- **Tasks**: List, toggle, complete tasks across the vault
- **Tags & Properties**: Query and set frontmatter properties and tags
- **Multi-Vault**: Target specific vaults with `vault=Name`

## Requirements

- Obsidian 1.12+ with CLI enabled (Early Access / Catalyst license)
- Obsidian must be running (CLI communicates via IPC)
- `Obsidian.com` redirector in the Obsidian install folder

### WSL Setup

The CLI binary lives on the Windows side. Add an alias in `~/.bashrc`:

```bash
alias obsidian="/mnt/c/Users/<username>/AppData/Local/Programs/Obsidian/Obsidian.com"
```

## Quick Start

```bash
# List vaults
obsidian vaults verbose

# Open today's daily note
obsidian daily vault=Personal

# Search the vault
obsidian search query="MCP protocol" vault=Personal

# Read a note
obsidian read file="Big Ideas"

# Append to a note
obsidian append file="Big Ideas" content="New idea here"

# List incomplete tasks
obsidian tasks todo vault=Personal
```
