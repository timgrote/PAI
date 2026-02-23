---
name: Podium
description: Personal task management via Podium/Conductor API. USE WHEN user says "add task", "my tasks", "personal task", "what's on my list", "task due", "complete task", "check off", OR references personal project tasks. Manages tasks on Tim's personal project in Podium.
---

# Podium

Personal task management through the Podium/Conductor API running on the production server. Tim's personal project acts as his task manager — tasks live alongside his business projects but in a dedicated personal project.

## Configuration

- **API Base:** `http://100.105.238.37:3000/api` (Tailscale — `tie-conductor`)
- **Personal Project ID:** `proj-9450dc11` (project name: "Tim")
- **Auth:** None required via Tailscale network
- **Task statuses:** `todo`, `in_progress`, `done`

## Workflow Routing

| Workflow | Trigger | File |
|----------|---------|------|
| **GetTasks** | "my tasks", "what's on my list", "personal tasks", "what's due" | `Workflows/GetTasks.md` |
| **AddTask** | "add task", "new task", "remind me to", "create a task" | `Workflows/AddTask.md` |
| **CompleteTask** | "complete task", "done with", "finished", "check off" | `Workflows/CompleteTask.md` |

## Examples

**Example 1: Quick add**
```
User: "Add a task to revisit my investment strategy, due next month"
-> Creates task on personal project with title and due date
-> Confirms creation
```

**Example 2: Check tasks**
```
User: "What's on my personal task list?"
-> Fetches all open tasks from personal project
-> Shows grouped by status with due dates
```

**Example 3: Complete**
```
User: "Check off the dentist task"
-> Finds matching task by title search
-> Marks as done
-> Confirms
```

## API Reference

All endpoints use the base URL above. No auth headers needed.

**List tasks:**
```
GET /projects/{project_id}/tasks
```

**Create task:**
```
POST /projects/{project_id}/tasks
Body: { "title": "...", "description": "...", "status": "todo", "due_date": "YYYY-MM-DD" }
```

**Update task:**
```
PATCH /tasks/{task_id}
Body: { "status": "done" } or { "title": "...", "due_date": "..." }
```

**Delete task:**
```
DELETE /tasks/{task_id}
```
