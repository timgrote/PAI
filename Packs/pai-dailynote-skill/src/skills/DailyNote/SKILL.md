---
name: DailyNote
description: Create or open daily journal notes from template. USE WHEN user says "create a note", "open today's journal", "daily note", "tomorrow's note", "yesterday's journal", OR references a specific date's journal.
---

# DailyNote

Micro skill for creating or opening daily journal notes. Given a date, either opens the existing journal or creates one from the Daily Template with Templater syntax resolved.

## Paths

- **Journals:** `/mnt/d/Dropbox/Personal/Journals/{YYYY}/{YYYY-MM-DD}.md`
- **Template:** `/mnt/d/Dropbox/Personal/Templates/Daily Template.md`

## Usage

Accepts natural date references:
- "today", "tomorrow", "yesterday"
- Day names: "Friday", "next Monday"
- Explicit dates: "Feb 20", "2026-02-20"

## Logic

1. **Resolve the date** to `YYYY-MM-DD` format
2. **Check if file exists:** `Journals/{YYYY}/{YYYY-MM-DD}.md`
3. **If exists:** Read it (and optionally open in Obsidian if requested)
4. **If not:** Create from template:
   a. Read `/mnt/d/Dropbox/Personal/Templates/Daily Template.md`
   b. Replace Templater tags:
      - `<% tp.date.now("YYYY-MM-DD", -1, tp.file.title) %>` → previous day's date
      - `<% tp.date.now("YYYY-MM-DD", 1, tp.file.title) %>` → next day's date
      - `<% tp.date.now("dddd, MMMM DD, YYYY", 0, tp.file.title) %>` → full date string (e.g., "Thursday, February 19, 2026")
      - `<% tp.file.cursor(1) %>` → remove (Templater cursor, not needed)
   c. Write to `Journals/{YYYY}/{YYYY-MM-DD}.md`
   d. Ensure the year folder exists (`Journals/{YYYY}/`)

## Pre-fill Support

When called with intentions (e.g., from the Review skill), add them as `- [ ]` items under the Intention/Attention section, replacing the empty `- [ ]` line from the template.

**Do NOT pre-fill the Affirmation section.** Tim retypes it from memory as a deliberate practice.

## Examples

**Example 1: Create tomorrow's note**
```
User: "Create a note for tomorrow"
→ Resolves tomorrow's date
→ Creates from template with dates filled in
→ Reports: "Created journal for Thursday, February 19, 2026"
```

**Example 2: Open existing note**
```
User: "Open yesterday's journal"
→ Resolves yesterday's date
→ File exists → reads and returns it
```

**Example 3: Called by Review skill with intentions**
```
Review skill: Create note for tomorrow with intentions ["Get Podium live", "Review HL21 with Allie", "Sit"]
→ Creates from template
→ Fills in intention checkboxes
```
