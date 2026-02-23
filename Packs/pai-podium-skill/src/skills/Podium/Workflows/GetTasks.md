# GetTasks Workflow

Retrieve and display open tasks from Tim's personal project on Podium.

## Execution Steps

1. **Fetch tasks** from the personal project:
   ```bash
   curl -s "http://100.105.238.37:3000/api/projects/proj-9450dc11/tasks"
   ```

2. **Parse the JSON response** — returns an array of task objects. Extract for each:
   - `id` — task ID
   - `title` — the task title
   - `description` — optional details
   - `status` — `todo`, `in_progress`, or `done`
   - `due_date` — when it's due (YYYY-MM-DD or null)
   - `created_at` — when it was created
   - `subtasks` — nested subtasks if any

3. **Filter and sort:**
   - By default, show only open tasks (`todo` and `in_progress`)
   - Sort: overdue first, then by due date (soonest first), then undated
   - If user asks for "all tasks" or "completed", include `done` status too

4. **Format the output:**

   ```
   **Personal Tasks** ({count} open)

   **Overdue:**
   - [ ] Task name — due {date} ({days} overdue)

   **Due Soon (this week):**
   - [ ] Task name — due {date}

   **Upcoming:**
   - [ ] Task name — due {date}

   **No Due Date:**
   - [ ] Task name

   **In Progress:**
   - [~] Task name — due {date}
   ```

5. **If no open tasks**, say:
   ```
   No open tasks on your personal project. Clean slate!
   ```

## Notes

- Tasks with subtasks: show parent with count (e.g., "Setup new laptop (3 subtasks)")
- Due date awareness: flag overdue tasks prominently
- Keep output scannable — one line per task unless description is specifically requested
