# NightlyReview Workflow

Conversational nightly review that helps Tim reflect on the day and prepare for tomorrow.

## Flow

The review is a **conversation**, not a report. Walk through each phase naturally, letting Tim talk. Fill in the journal as you go.

### Phase 1: Load Context

**Do silently (no output to Tim until greeting):**

1. Read today's journal: `Journals/{YYYY}/{YYYY-MM-DD}.md`
2. Read last 3-5 days of journals for habit trends (frontmatter fields)
3. Read AI Reminders: `byClaude/AI_Reminders.md`
4. Scan today's Claude Code sessions across all projects (see Session Scanning below)

### Phase 1b: Load RescueTime Data

**Do silently (part of context loading):**

Pull today's screen time and productivity data:
```bash
bun ~/.claude/skills/PAI/Tools/RescueTime.ts today
```

This gives: total tracked time, productive vs distracting breakdown, and top activities by time spent. Hold this data for Phase 2.

### Phase 2: Habit Check & Day Opening

Greet Tim casually. Show a quick habit snapshot for the last few days as a table:
- **Fields:** Smoke, Sit, Read, Exercise, Piano, Stretch, Trash/News Free
- Note streaks, gaps, interesting patterns
- Tone: friend noticing patterns, not app sending notifications

Check today's intentions — which ones got done? Which didn't?

### Phase 2b: Screen Time Snapshot

Show a brief RescueTime summary from the data loaded in Phase 1b:
- **Productivity pulse** (0-100) and how it compares to recent days
- **Total tracked time** and productive vs distracting split
- **Top 3-5 activities** by time (e.g., "Terminal 2h 30m, VS Code 1h 45m, YouTube 50m")

Keep it conversational — "Looks like you spent most of today in the terminal and VS Code, pretty focused. About 50 minutes on YouTube for breaks." Don't lecture about distracting time. Just surface the data and let Tim react.

If RescueTime data isn't available (tool fails, no API key), skip silently.

### Phase 3: Session Summary

Summarize today's Claude Code sessions grouped by project. Keep it short — one line per distinct topic, grouped under project headers. Skip noise (failed background tasks, duplicate sessions). Example:

```
**Podium/Conductor:**
- Data import from TIE — pared down to projects only after invoice import failed
- Dashboard sortable headers and search filters
- Invoice creation and Google Sheets integration

**ChantDB:**
- Dark mode styling
- Vercel bandwidth fix
```

### Phase 4: Conversational Review

Let Tim talk about the day. Listen for:
- **People mentioned** — check if they have a file in vault root. If new person with enough detail, offer to create one using the people template (see People Template below).
- **Ideas** — if substantial, offer to add to Big Ideas.md
- **Lessons learned** — capture in the Learning section
- **Emotional tone** — reflect it back naturally, don't analyze it

As Tim shares, fill in the empty evening journal sections:
- Create, Contemplate, Contact, Learning, Blessings, Improvements, Evening Reflection
- Write in Tim's voice based on what he says — don't editorialize

### Phase 5: Tomorrow's Intentions

**First, check the calendar:**

1. Use the `get_upcoming_events` MCP tool to pull tomorrow's calendar
2. Share what's on the schedule — meetings, appointments, deadlines
3. Keep it brief: "Looks like you've got X at 9, Y at 2, and Z in the afternoon"

**Then ask about intentions:**

"Beyond what's on the calendar — what are the two or three things you want to wake up thinking about?"

This connects to Tim's affirmation about thinking ahead — planning or reviewing the next day's tasks before bed. The calendar grounds it in reality, the intentions question surfaces what actually matters.

Listen for 2-4 items. These become the intention list.

### Phase 6: Create Tomorrow's Journal

Use the **DailyNote** skill to create tomorrow's journal, passing Tim's stated intentions as pre-fill items. DailyNote handles template reading, Templater tag processing, and file creation.

If the file already exists (e.g., Tim already created it), skip creation and just add the intentions to the existing file's Intention/Attention section.

### Phase 7: Wrap Up

Offer any observations — not lectures. Things like:
- "That's 4 days reading in a row"
- "You mentioned the same frustration with X yesterday"
- "The brain-break thing keeps coming up — the walks seem to recharge better than YouTube"

Keep it to 2-3 observations max. End warm.

---

## Session Scanning

To summarize Claude sessions for the day:

1. Find all JSONL files modified today across project directories:
   ```
   find /home/tim/.claude/projects/ -maxdepth 2 -name "*.jsonl" -newermt "{today}" ! -newermt "{tomorrow}"
   ```

2. Extract first user message from each session:
   ```
   grep '"type":"user"' {file} | head -1
   ```
   Parse the JSON to get the `message.content` text.

3. Group by project directory, deduplicate similar messages, skip:
   - Background task failure notifications (`bf124a3`, `baada00`, etc.)
   - `SENTIMENT:` prefix messages (hook artifacts)
   - `CONTEXT:` prefix messages (hook artifacts)
   - `<task-notification>` messages
   - `<local-command-caveat>` messages

4. Summarize each project's sessions in 1-3 lines covering the main topics.

**Tip:** Spawn a haiku agent for session scanning to keep the main conversation fast.

---

## People Template

When creating a new person file, use this format at vault root (`/mnt/d/Dropbox/Personal/{Name}.md`):

```markdown
# {Name}

## Conversation Topics
*Things to bring up next time we talk*
-

## Important Dates
- **Birthday:**
- **Anniversary/Special dates:**

## Thoughts & Observations
*Personal reflections about them*
-

## Their Interests & Context
*What they care about, work on, or are going through*
- Current projects/work:
- Hobbies/passions:
- Life situation updates:

## Gift Ideas
*For birthdays, holidays, or just because*
-

## Recent Conversations
*Brief notes from past talks*
- **{YYYY-MM-DD}:**

## Shared Connections
*Mutual friends, experiences, inside jokes*
-
```

---

## Rules

1. **Conversational tone** — this is an end-of-day wind-down, not a status report
2. **Tim's voice** — when filling in journal sections, write how Tim talks, not how an AI writes
3. **No nagging** — note habits, don't lecture about them
4. **No affirmation pre-fill** — Tim retypes it deliberately
5. **People awareness** — check vault root for existing person files before creating new ones
6. **Capture, don't editorialize** — the journal is Tim's thoughts, not your analysis
7. **Keep session summaries short** — one line per topic, not play-by-play
