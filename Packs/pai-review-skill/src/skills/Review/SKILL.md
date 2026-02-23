---
name: Review
description: Nightly journal review and next-day preparation, plus weekly reviews. USE WHEN user says "nightly review", "daily review", "end of day", "review the day", "/review", "let's go over today", "weekly review", "review the week", "week in review", OR "/weekly".
---

# Review

Review companion for nightly and weekly reflections. Nightly reviews capture the day and prepare tomorrow. Weekly reviews zoom out on habits, work, themes, and connections.

## Vault Awareness

**Journals:** `/mnt/d/Dropbox/Personal/Journals/{YYYY}/{YYYY-MM-DD}.md`
**Journal Template:** `/mnt/d/Dropbox/Personal/Templates/Daily Template.md`
**People files:** Vault root (`/mnt/d/Dropbox/Personal/{Name}.md`) — use same template as Mark.md, RJ.md, Josh.md
**Big Ideas:** `/mnt/d/Dropbox/Personal/Big Ideas.md`
**AI Reminders:** `/mnt/d/Dropbox/Personal/byClaude/AI_Reminders.md`
**byClaude folder:** `/mnt/d/Dropbox/Personal/byClaude/`
**Session logs:** `/home/tim/.claude/projects/` (grouped by project directory)

## Workflow Routing

| Workflow | Trigger | File |
|----------|---------|------|
| **NightlyReview** | "nightly review", "daily review", "end of day", "/review" | `Workflows/NightlyReview.md` |
| **WeeklyReview** | "weekly review", "review the week", "week in review", "/weekly" | `Workflows/WeeklyReview.md` |

## Examples

**Example 1: Standard nightly review**
```
User: "/review"
-> Reads today's journal, checks habits, scans Claude sessions
-> Conversationally walks through the day
-> Asks about tomorrow's intentions
-> Creates next day's journal with intentions filled in
```

**Example 2: Quick review with context**
```
User: "Let's go over today"
-> Same flow, adapts to whatever Tim shares
-> Fills in empty journal sections from conversation
-> Notes any new people, ideas, or connections
```

**Example 3: Weekly review**
```
User: "/weekly"
-> Reads 7 days of journals, git commits, Claude sessions
-> Shows habit trends, work summary, journal themes
-> Surfaces Big Ideas connections, Telos progress, AI reminders
-> Walks through the week conversationally
-> Seeds next week's focus areas
-> Fills in weekly note template
```
