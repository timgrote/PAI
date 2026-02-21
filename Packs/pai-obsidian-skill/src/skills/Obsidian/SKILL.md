---
name: Obsidian
description: Obsidian vault operations via official CLI (v1.12+). Read, write, search, manage notes and tasks from terminal. USE WHEN user says "open note", "search vault", "daily note", "create note", "read note", "list tasks", "add to note", "vault search", "obsidian", OR any vault manipulation request.
version: 1.0.0
---

## Customization

**Before executing, check for user customizations at:**
`~/.claude/skills/CORE/USER/SKILLCUSTOMIZATIONS/Obsidian/`

If this directory exists, load and apply any PREFERENCES.md, configurations, or resources found there. These override default behavior. If the directory does not exist, proceed with skill defaults.

# Obsidian Skill v1.0.0 — Vault Operations via CLI

Direct Obsidian vault manipulation through the official Obsidian CLI (v1.12+). The CLI communicates via IPC with the running Obsidian app.

---

## Execution Rules

- **One CLI call per operation.** The CLI is fast — don't add extra calls to "verify" or "check" unless the user asks.
- **Use the `obsidian` alias**, not the full Windows path. The alias is set up in `~/.bashrc`.
- **Don't read back notes after opening them** unless the user asks what's in them.

---

## Prerequisites

- **Obsidian 1.12+** with CLI enabled in Settings
- **Obsidian must be running** — the CLI talks to the live app via IPC
- **CLI accessible** — either in PATH or via alias (see WSL setup below)

### WSL Setup

The Obsidian CLI binary (`Obsidian.com`) lives on the Windows side. Call it from WSL:

```bash
# Direct path
"/mnt/c/Users/<username>/AppData/Local/Programs/Obsidian/Obsidian.com" help

# Or via alias in ~/.bashrc
alias obsidian="/mnt/c/Users/<username>/AppData/Local/Programs/Obsidian/Obsidian.com"
```

### CLI Binary Detection

```bash
# Try alias first, then common paths
OBSIDIAN_CLI="${OBSIDIAN_CLI:-obsidian}"
if ! command -v "$OBSIDIAN_CLI" &>/dev/null; then
  # WSL fallback
  OBSIDIAN_CLI="/mnt/c/Users/$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r')/AppData/Local/Programs/Obsidian/Obsidian.com"
fi
```

---

## Vault Targeting

Most commands accept `vault=<name>` to target a specific vault. Without it, commands target the active vault.

```bash
obsidian daily vault=Personal
obsidian search query="MCP" vault=TIE
obsidian vaults verbose  # List all known vaults
```

---

## Command Reference

### Daily Notes

```bash
obsidian daily                              # Open today's daily note
obsidian daily:read                         # Read daily note contents
obsidian daily:path                         # Get daily note file path
obsidian daily:append content="Text here"   # Append to daily note
obsidian daily:prepend content="Text here"  # Prepend to daily note
```

### Notes — Read & Write

```bash
obsidian read file="Note Name"              # Read by name (wikilink style)
obsidian read path="folder/note.md"         # Read by exact path
obsidian create name="New Note" content="Initial content"
obsidian create name="Note" template="Daily" # Create from template
obsidian append file="Note" content="Added text"
obsidian prepend file="Note" content="Top text"
obsidian open file="Note"                   # Open in Obsidian GUI
obsidian open file="Note" newtab            # Open in new tab
obsidian delete file="Note"                 # Move to trash
```

### Search

```bash
obsidian search query="search terms"                    # Basic search
obsidian search:context query="search terms"            # With surrounding lines
obsidian search query="term" path="Journals" limit=10   # Scoped search
obsidian search query="term" case                       # Case sensitive
obsidian search query="term" format=json                # JSON output
```

### Tasks

```bash
obsidian tasks                              # All tasks
obsidian tasks todo                         # Incomplete only
obsidian tasks done                         # Completed only
obsidian tasks todo file="Project"          # Tasks in specific file
obsidian tasks todo verbose                 # Grouped by file with line numbers
obsidian tasks daily                        # Tasks from daily note
obsidian task file="Note" line=5 toggle     # Toggle a task
obsidian task file="Note" line=5 done       # Mark complete
```

### Tags

```bash
obsidian tags                               # List all tags
obsidian tags counts                        # With occurrence counts
obsidian tags file="Note"                   # Tags in specific file
obsidian tag name="project" verbose         # Tag info with file list
```

### Properties (Frontmatter)

```bash
obsidian properties file="Note"                         # All properties
obsidian property:read name="status" file="Note"        # Read property
obsidian property:set name="status" value="done" file="Note"  # Set property
obsidian property:remove name="draft" file="Note"       # Remove property
```

### Files & Structure

```bash
obsidian files                              # List all files
obsidian files folder="Journals" ext=md     # Filter by folder/extension
obsidian folders                            # List folders
obsidian file file="Note"                   # File info (size, dates)
obsidian links file="Note"                  # Outgoing links
obsidian backlinks file="Note"              # Incoming links
obsidian orphans                            # Files with no incoming links
obsidian deadends                           # Files with no outgoing links
obsidian unresolved                         # Broken links
```

### Bookmarks

```bash
obsidian bookmarks                          # List bookmarks
obsidian bookmark file="path/to/note.md"    # Bookmark a file
obsidian bookmark search="query"            # Bookmark a search
```

### Templates

```bash
obsidian templates                          # List available templates
obsidian template:read name="Daily"         # Read template content
obsidian template:insert name="Daily"       # Insert into active file
```

### Plugins

```bash
obsidian plugins                            # List installed plugins
obsidian plugins:enabled                    # List enabled plugins
obsidian plugin:enable id="plugin-id"       # Enable a plugin
obsidian plugin:disable id="plugin-id"      # Disable a plugin
```

### Vault Info

```bash
obsidian vault                              # Vault name, path, stats
obsidian vaults verbose                     # All vaults with paths
obsidian version                            # Obsidian version
```

---

## Output Formats

Many commands support `format=` parameter:

| Format | Use |
|--------|-----|
| `tsv` | Tab-separated (default for lists) |
| `json` | Structured data for parsing |
| `csv` | Comma-separated |
| `yaml` | For properties |
| `text` | Plain text (default for search) |

---

## Workflows

Detailed workflow guides are in the `Workflows/` directory:

- **DailyNote.md** — Daily note operations and journal integration
- **Search.md** — Search patterns and vault exploration
- **Notes.md** — Note creation, editing, and management
- **Tasks.md** — Task management across the vault
- **VaultInfo.md** — Vault structure, health checks, and metadata

---

## Tips

- **File resolution**: `file=` resolves by name like wikilinks. `path=` is exact.
- **Spaces**: Quote values with spaces: `file="Big Ideas"`
- **Newlines**: Use `\n` for newline in content values.
- **Active file**: Most commands default to the active file when file/path is omitted.
