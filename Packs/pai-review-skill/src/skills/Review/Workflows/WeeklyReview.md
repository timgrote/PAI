# WeeklyReview Workflow

Interactive weekly review that zooms out on habits, work, themes, and connections. Walks through the week conversationally, then fills in the weekly note.

## Vault Awareness

**Journals:** `/mnt/d/Dropbox/Personal/Journals/{YYYY}/{YYYY-MM-DD}.md`
**Weekly Notes:** `/mnt/d/Dropbox/Personal/Review/Weekly/{YYYY}-W{WW}.md`
**Weekly Template:** `/mnt/d/Dropbox/Personal/Templates/Weekly Template.md`
**Big Ideas:** `/mnt/d/Dropbox/Personal/Big Ideas.md`
**Telos:** `/mnt/d/Dropbox/Personal/Telos.md`
**AI Reminders:** `/mnt/d/Dropbox/Personal/byClaude/AI_Reminders.md`
**Weekly Review Questions:** `/mnt/d/Dropbox/Personal/byClaude/Weekly_Review_Questions.md`
**Books:** `/mnt/d/Dropbox/Personal/Books/`
**People files:** Vault root (`/mnt/d/Dropbox/Personal/{Name}.md`)
**Session logs:** `/home/tim/.claude/projects/` (grouped by project directory)

## Week Calculation

The review covers the current ISO week (Monday through Sunday). Calculate dates:
- Use `date +%G-W%V` for the current ISO week number
- Monday = start of ISO week, Sunday = end
- Journal files: `{YYYY}-{MM}-{DD}.md` for each day Mon-Sun
- Weekly note file: `{YYYY}-W{WW}.md` in the same year folder

## Flow

The review is a **conversation**, not a report dump. Present findings progressively, let Tim react, discuss, and reflect at each phase before moving on.

### Phase 1: Load Context (silent)

**Do silently — no output to Tim until Phase 2:**

1. Read all 7 journal entries for the week (Mon-Sun). Note which days exist.
2. Read the weekly note if it exists already
3. Read `Weekly_Review_Questions.md` for queued discussion topics
4. Read `AI_Reminders.md` for due/overdue items
5. Read `Telos.md` for active goals and challenges
6. Read `Big Ideas.md` for recent additions
7. Scan git commits across all known project repos (see Git Commit Scanning below)
8. Scan Claude Code sessions for the week (see Session Scanning below)
9. Pull RescueTime weekly summary:
   ```bash
   bun ~/.claude/skills/PAI/Tools/RescueTime.ts summary --days 7
   ```

**Spawn a haiku agent for git commits and another for session scanning** to keep load time fast.

### Phase 1.5: Today Check-In

Before zooming out to the week, check if today's journal is empty or sparse. If the evening sections (Create, Contemplate, Contact, Learning, Blessings, Improvements, Evening Reflection) are mostly blank:

- Ask Tim: "Before we do the weekly — anything about today worth capturing?"
- Listen for what happened, who he talked to, what he worked on
- Fill in today's journal sections from what he shares (in Tim's voice)
- Then transition naturally into the weekly view

If today's journal is already filled in, skip this and go straight to Phase 2.

### Phase 2: Habit Trends

Open with a casual greeting referencing something from the week.

Show a 7-day habit table:
- **Fields:** Smoke, Sit, Read, Exercise, Piano, Stretch, Trash/News Free
- Pull from journal frontmatter for each day
- Mark streaks, gaps, best/worst days
- Calculate weekly totals (e.g., "Sat 5/7 days, Read 6/7")

Tone: friend noticing patterns over a week, not a fitness app. Point out what's working. If something dropped off, mention it once without nagging.

**Ask Tim:** "How do you feel about the habits this week? Anything you want to adjust?"

### Phase 2b: Screen Time Trends

Show the weekly RescueTime data loaded in Phase 1:
- **7-day productivity pulse trend** (e.g., "Mon 72, Tue 65, Wed 58, Thu 71, Fri 70, Sat 62, Sun 18")
- **Average pulse** and how it compares (good week vs meh week)
- **Total productive vs distracting hours** for the whole week
- **Top categories** by total time across the week
- **Patterns** — which days were most focused? Any correlation with habits (meditation days more productive? exercise days more focused?)

Keep it brief and observational. One paragraph, maybe two. Let Tim react before moving on.

If RescueTime data isn't available, skip silently.

### Phase 3: Week's Work

Present the week's work in two sections:

**Git Commits** — grouped by repo, summarized by theme:
```
**Raindrop:**
- 12 commits: New drip grid calculator, bugfix on zone sizing

**PAI:**
- 8 commits: Weekly review skill, hook refinements

**ChantDB:**
- 3 commits: Dark mode polish
```

**Claude Sessions** — grouped by project, one line per distinct topic. Same approach as NightlyReview session scanning but covering the full week. Deduplicate across days.

**Ask Tim:** "Anything big I missed? How did the balance feel between projects?"

### Phase 4: Journal Themes

Pull from journal content across the week:

- **Contemplate entries** — list all contemplation topics. Look for recurring themes.
- **Emotional arc** — scan gratitude, blessings, reflections. Note shifts across the week without psychoanalyzing.
- **Learning entries** — what did Tim learn or note?
- **People mentioned** — who showed up in journals this week? Check if they have vault files.

Present as a light narrative: "Early in the week you were thinking about X, by Thursday that shifted to Y. Z kept coming up."

**Ask Tim:** "Any threads here you want to pull on? Anything that surprised you looking back?"

### Phase 5: Connections & Ideas

- **Big Ideas touched** — any additions or edits to Big Ideas.md this week?
- **Book notes** — any reading sessions captured? Themes from BookChat?
- **Cross-connections** — things Tim wrote about in journals that connect to Big Ideas, Telos goals, or book notes but aren't linked yet. Suggest links.
- **Unfinished threads** — topics from Claude sessions or journals that started but didn't resolve. Worth continuing?

**Ask Tim:** "Want to capture any of these connections? Anything to add to Big Ideas?"

### Phase 6: Telos & Reminders

- **Telos pulse** — check active goals/challenges against the week's activity. Did anything move? Any goals going stale?
- **AI Reminders** — surface anything due or overdue. Ask about each one: still relevant? Done? Push it?
- **Weekly Review Questions** — go through queued topics from `Weekly_Review_Questions.md`

**Ask Tim:** "Anything to update in Telos? Any reminders to clear out?"

### Phase 7: Next Week Seeding

**Check the calendar:**
1. Use `get_upcoming_events` MCP tool for next 7 days
2. Share what's coming — meetings, deadlines, appointments

**Ask about focus:**
"Looking at next week — what are the 2-3 things you want to make sure happen?"

Listen for intentions. These seed the next weekly note.

### Phase 8: Write the Weekly Note

Create or update the weekly note at `Review/Weekly/{YYYY}-W{WW}.md`.

If the file doesn't exist, read the Weekly Template and create it with Templater tags processed.

Fill in sections from the conversation:
- **Best Parts of the Week** — from Tim's responses
- **Improvements to the Week** — from Tim's responses
- **Learning/Review/Reflection** — themes and insights from the review
- **Roles sections** — any relationship/people reflections Tim shared
- **Summary** — brief narrative of the week (locations, events, vibe)

Write in Tim's voice. Don't editorialize.

### Phase 8.5: Create Next Week's File

Create next week's weekly note at `Review/Weekly/{YYYY}-W{next_WW}.md`.

1. Read the Weekly Template (`Templates/Weekly Template.md`)
2. Create the file with template content (process Templater tags for next week's dates)
3. Add Tim's stated intentions from Phase 7 to the **Must Happen** section as unchecked tasks
4. Add any calendar events from Phase 7 as context

This way Monday morning the file is already there with priorities seeded. Tim can open it and start adding to it through the week.

### Phase 9: Wrap Up

Offer 2-3 observations — not lectures:
- Week-over-week trends (comparing to last week if data exists)
- Patterns worth noting
- Something Tim might not have noticed

Update `Weekly_Review_Questions.md`:
- Move discussed topics to archive
- Add any new topics that came up during the review

End warm. Keep it brief.

---

## Git Commit Scanning

Tim is authenticated as `timgrote` via GitHub CLI (`gh`). Use the GitHub API to pull commits:

1. For each known repo, get commits for the week:
   ```bash
   for repo in timgrote/podium timgrote/Raindrop timgrote/chantdb; do
     echo "### $repo"
     gh api "/repos/$repo/commits?since={monday}T00:00:00Z&until={next_monday}T00:00:00Z&per_page=50" \
       --jq '.[] | "  " + .commit.author.date[0:10] + " | " + (.commit.message | split("\n")[0])' 2>&1
   done
   ```

2. To discover other repos Tim pushed to during the week:
   ```bash
   gh api "/users/timgrote/events" --paginate \
     --jq '[.[] | select(.type == "PushEvent" and (.created_at >= "{monday}T00:00:00Z"))] | [.[].repo.name] | unique | .[]'
   ```

3. Group by repo, summarize by theme (not individual commit messages).

**Spawn a haiku agent** for this to keep the main conversation fast.

---

## Session Scanning

Same approach as NightlyReview but covering Monday through Sunday:

1. Find all JSONL files modified during the week across project directories:
   ```
   find /home/tim/.claude/projects/ -maxdepth 2 -name "*.jsonl" -newermt "{monday}" ! -newermt "{next_monday}"
   ```

2. Extract first user message from each session. Parse JSON for `message.content`.

3. Group by project directory, deduplicate, skip noise:
   - Background task notifications
   - `SENTIMENT:` / `CONTEXT:` prefix messages
   - `<task-notification>` / `<local-command-caveat>` messages

4. Summarize each project's week in 2-5 lines covering main topics and arc of work.

**Spawn a haiku agent** for this to keep the main conversation fast.

---

## Rules

1. **Conversational, not a report** — present findings, then discuss. Don't dump everything at once.
2. **Tim's voice** — when writing weekly note sections, write how Tim talks
3. **No nagging** — note patterns, don't lecture about them
4. **Progressive disclosure** — each phase builds on the last. Let Tim steer what gets more attention.
5. **Connections over completeness** — finding one meaningful link between a journal entry and a Big Idea is worth more than listing every commit
6. **Keep git/session summaries thematic** — "worked on X feature" not "14 commits touching files A, B, C"
7. **Respect the template** — the weekly note template has specific sections. Fill what's relevant, leave the rest for Tim
8. **Capture, don't editorialize** — the weekly note is Tim's reflection, not your analysis
9. **Update Weekly_Review_Questions.md** — archive discussed topics, add new ones that emerged
