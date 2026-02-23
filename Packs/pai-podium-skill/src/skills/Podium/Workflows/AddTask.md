# AddTask Workflow

Create a new task on Tim's personal project in Podium.

## Execution Steps

1. **Extract task details** from the user's request:
   - `title` — the task title (required)
   - `description` — additional details (optional)
   - `due_date` — due date in YYYY-MM-DD format (optional)
   - `status` — defaults to `todo`

2. **Parse natural language dates** if the user says things like:
   - "tomorrow" → tomorrow's date
   - "next week" → next Monday
   - "next month" → first of next month
   - "in two weeks" → 14 days from now
   - "friday" → this coming Friday
   - "end of march" → 2026-03-31
   Use `date` command to compute: `date -d "next friday" +%Y-%m-%d`

3. **Create the task** via API:
   ```bash
   curl -s -X POST "http://100.105.238.37:3000/api/projects/proj-9450dc11/tasks" \
     -H "Content-Type: application/json" \
     -d '{"title": "TITLE", "description": "DESC", "status": "todo", "due_date": "YYYY-MM-DD"}'
   ```

4. **Confirm creation:**
   ```
   Added to personal tasks: "Task title"
   Due: {date or "No due date"}
   ```

5. **If the user's request is ambiguous**, use AskUserQuestion to clarify the due date or title.

## Guard Rails

- NEVER create a task without the user explicitly asking to add one
- Always confirm what was created
- If the API returns an error (e.g., server unreachable), say so clearly
- Default project is always Tim's personal project (`proj-9450dc11`) unless user specifies otherwise
