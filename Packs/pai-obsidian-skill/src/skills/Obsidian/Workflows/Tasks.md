# Workflow: Task Management

## List Tasks

```bash
# All incomplete tasks
obsidian tasks todo vault=Personal

# All completed tasks
obsidian tasks done vault=Personal

# Tasks in a specific file
obsidian tasks todo file="Weekly Action Plan" vault=Personal

# Tasks grouped by file with line numbers
obsidian tasks todo verbose vault=Personal

# Tasks from daily note
obsidian tasks daily vault=Personal

# Task count
obsidian tasks todo total vault=Personal
```

## Toggle a Task

```bash
# Toggle by file and line number
obsidian task file="Project" line=15 toggle vault=Personal

# Mark done
obsidian task file="Project" line=15 done vault=Personal

# Mark as todo (uncomplete)
obsidian task file="Project" line=15 todo vault=Personal
```

## Custom Status Characters

```bash
# Set custom status (e.g., "/" for in-progress)
obsidian task file="Project" line=15 status="/" vault=Personal
```

## JSON Output

```bash
obsidian tasks todo format=json vault=Personal
```

## Common Patterns

### Morning Task Review

```bash
obsidian tasks daily vault=Personal
obsidian tasks todo file="Weekly Action Plan" vault=Personal
```

### End of Day Cleanup

```bash
# See what's still open
obsidian tasks todo verbose vault=Personal

# Complete finished tasks
obsidian task file="Project" line=10 done vault=Personal
obsidian task file="Project" line=15 done vault=Personal
```
