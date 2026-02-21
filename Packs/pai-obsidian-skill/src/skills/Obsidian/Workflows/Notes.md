# Workflow: Note Management

## Read a Note

```bash
# By name (wikilink-style resolution)
obsidian read file="Big Ideas" vault=Personal

# By exact path
obsidian read path="Books/Neuromancer.md" vault=Personal
```

## Create a Note

```bash
# Simple creation
obsidian create name="New Idea" content="# New Idea\n\nInitial thoughts here." vault=Personal

# From template
obsidian create name="2026-02-21" template="Daily" vault=Personal

# Create and open
obsidian create name="New Note" content="Content" open vault=Personal
```

## Append to a Note

```bash
obsidian append file="Big Ideas" content="\n---\n\n# New Idea Title\n*First captured: 2026-02-21*\n\nIdea content here." vault=Personal
```

## Prepend to a Note

```bash
obsidian prepend file="Note" content="## Added Section\n\nNew content at top." vault=Personal
```

## Open a Note in Obsidian

```bash
obsidian open file="Big Ideas" vault=Personal
obsidian open file="Big Ideas" newtab vault=Personal
```

## Move / Rename

```bash
# Move to different folder
obsidian move file="Note" to="Archive/Note.md" vault=Personal

# Rename
obsidian rename file="Old Name" name="New Name" vault=Personal
```

## Delete

```bash
obsidian delete file="Note" vault=Personal              # To trash
obsidian delete file="Note" permanent vault=Personal    # Permanent
```

## File Info

```bash
obsidian file file="Big Ideas" vault=Personal
```

## Get Outline / Headings

```bash
obsidian outline file="Big Ideas" vault=Personal
obsidian outline file="Big Ideas" format=json vault=Personal
```
