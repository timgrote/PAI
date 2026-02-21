# Workflow: Daily Note Operations

## Open Today's Daily Note

```bash
obsidian daily vault=Personal
```

## Read Daily Note Contents

```bash
obsidian daily:read vault=Personal
```

## Append to Daily Note

Useful for adding to journal sections (contemplation, gratitude, etc.):

```bash
obsidian daily:append content="- Thought about [[Big Ideas#Open Protocols]]" vault=Personal
```

## Prepend to Daily Note

```bash
obsidian daily:prepend content="## Morning Priority\n- Focus on X" vault=Personal
```

## Get Daily Note Path

```bash
obsidian daily:path vault=Personal
```

## Common Patterns

### Add to Contemplation Section

```bash
# Read current daily note to find right section
obsidian daily:read vault=Personal

# Append contemplation entry
obsidian daily:append content="\n### Contemplation\n- Thought about X [[Big Ideas#Topic]]" vault=Personal
```

### Check Today's Tasks

```bash
obsidian tasks daily vault=Personal
```
