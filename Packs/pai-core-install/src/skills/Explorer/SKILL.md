---
name: Explorer
description: Open folders in Windows Explorer from WSL. USE WHEN user says "/e", "open folder", "open in explorer", OR "show in explorer". Accepts optional path argument.
invocation: e
---

# Explorer

Opens folders in the system file browser (Windows Explorer on WSL, native file manager on Linux).

## Usage

- `/e` - Open current working directory
- `/e [path]` - Open specified path

## Instructions

### Step 1: Detect Environment

Check if running in WSL by looking for "microsoft" or "WSL" in `/proc/version`:

```bash
grep -qi microsoft /proc/version 2>/dev/null
```

- Exit code 0 = WSL environment
- Exit code 1 = Native Linux

### Step 2: Open Folder

#### WSL (Windows)

Convert path and use Windows Explorer:

```bash
cmd.exe /c start "" "[windows-path]"
```

**Path Conversion:**
- `/mnt/d/Dropbox/TIE` → `D:\Dropbox\TIE`
- `/mnt/c/Users/tim` → `C:\Users\tim`

#### Native Linux

Use `xdg-open` (works with GNOME, KDE, XFCE, etc.):

```bash
xdg-open "[path]"
```

No path conversion needed for native Linux.

### Behavior

1. If no path argument provided, use the current working directory
2. If path argument provided, use that path
3. Detect environment (WSL vs native Linux)
4. For WSL: Convert any WSL-style path (`/mnt/x/...`) to Windows format (`X:\...`)
5. Execute appropriate command based on environment

## Examples

**Example 1: Open current directory (WSL)**
```
User: "/e"
→ Detects WSL environment
→ Gets current working directory
→ Converts to Windows path
→ Runs: cmd.exe /c start "" "D:\Dropbox\TIE"
→ Explorer window opens
```

**Example 2: Open specific path (WSL)**
```
User: "/e /mnt/d/Dropbox/TIE/Project Management"
→ Detects WSL environment
→ Converts path to: D:\Dropbox\TIE\Project Management
→ Runs: cmd.exe /c start "" "D:\Dropbox\TIE\Project Management"
→ Explorer window opens
```

**Example 3: Open folder (Native Linux)**
```
User: "/e /home/tim/Documents"
→ Detects native Linux environment
→ Runs: xdg-open "/home/tim/Documents"
→ System file manager opens (Nautilus, Dolphin, Thunar, etc.)
```

**Example 4: Open folder by context**
```
User: "open the Templates folder in explorer"
→ Determines path: /mnt/d/Dropbox/TIE/Templates
→ Detects environment
→ Opens in appropriate file browser
```
