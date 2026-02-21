# Workflow: Vault Search

## Basic Search

```bash
obsidian search query="search terms" vault=Personal
```

## Search with Context

Shows matching lines with surrounding context:

```bash
obsidian search:context query="MCP protocol" vault=Personal
```

## Scoped Search

Limit to a specific folder:

```bash
obsidian search query="meditation" path="Journals" vault=Personal
obsidian search query="Gateway" path="Projects" vault=TIE
```

## Search with Limits

```bash
obsidian search query="term" limit=5 vault=Personal
```

## JSON Output for Parsing

```bash
obsidian search query="term" format=json vault=Personal
```

## Case Sensitive Search

```bash
obsidian search query="API" case vault=Personal
```

## Open Search in Obsidian GUI

```bash
obsidian search:open query="search terms" vault=Personal
```

## Common Patterns

### Find Related Notes

```bash
obsidian search:context query="topic" vault=Personal
obsidian backlinks file="Topic Note" vault=Personal
obsidian links file="Topic Note" vault=Personal
```

### Find Unlinked References

```bash
# Search for a term, then check if those files link to the canonical note
obsidian search query="concept name" vault=Personal
obsidian backlinks file="Concept Note" vault=Personal
# Compare results — files that mention but don't link are candidates for linking
```
