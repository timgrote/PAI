# Workflow: Vault Info & Health

## Vault Overview

```bash
obsidian vault vault=Personal
# Returns: name, path, file count, folder count, size
```

## List All Vaults

```bash
obsidian vaults verbose
# Returns: vault names with paths
```

## File Statistics

```bash
obsidian files total vault=Personal           # Total file count
obsidian folders total vault=Personal         # Total folder count
obsidian files folder="Journals" vault=Personal  # Files in folder
```

## Vault Health

### Find Orphan Notes (no incoming links)

```bash
obsidian orphans vault=Personal
obsidian orphans total vault=Personal
```

### Find Dead Ends (no outgoing links)

```bash
obsidian deadends vault=Personal
```

### Find Broken Links

```bash
obsidian unresolved vault=Personal
obsidian unresolved counts vault=Personal
```

## Tags Overview

```bash
obsidian tags counts sort=count vault=Personal
```

## Properties Overview

```bash
obsidian properties total vault=Personal
obsidian properties counts sort=count vault=Personal
```

## Plugin Status

```bash
obsidian plugins:enabled vault=Personal
obsidian plugins:enabled filter=community vault=Personal
```

## Version

```bash
obsidian version
```
