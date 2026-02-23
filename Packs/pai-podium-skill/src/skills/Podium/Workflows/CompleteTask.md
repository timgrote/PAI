# CompleteTask Workflow

Mark a task as done on Tim's personal project in Podium.

## Execution Steps

1. **Identify the task** from the user's request. The user will reference it by name or partial name.

2. **Fetch all open tasks** to find a match:
   ```bash
   curl -s "http://100.105.238.37:3000/api/projects/proj-9450dc11/tasks"
   ```

3. **Match the task** by searching titles (case-insensitive, partial match). If multiple matches, use AskUserQuestion to let the user pick.

4. **Mark as done:**
   ```bash
   curl -s -X PATCH "http://100.105.238.37:3000/api/tasks/{task_id}" \
     -H "Content-Type: application/json" \
     -d '{"status": "done"}'
   ```
   The API automatically sets `completed_at` when status changes to `done`.

5. **Confirm completion:**
   ```
   Done: "Task title"
   ```

6. **If no matching task found**, say so and show the list of open tasks so the user can clarify.

## Guard Rails

- Always confirm which task you're completing before marking it done
- If the match is ambiguous (multiple tasks contain the search term), ask the user to pick
- Show the full task title in confirmation so the user knows the right one was completed
