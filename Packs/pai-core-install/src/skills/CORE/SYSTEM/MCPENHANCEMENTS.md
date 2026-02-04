# MCP Enhancements Reference

Recent MCP specification updates (2025-11-25) that improve PAI capabilities.

---

## Tool Icons (Technique #10)

MCP servers can now expose icons for better UI presentation:

```json
{
  "name": "search_vault",
  "description": "Search notes in Obsidian vault",
  "icon": "search",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": { "type": "string" }
    }
  }
}
```

**Standard Icon Names:**
- `search` - Search/find operations
- `file` - File operations
- `folder` - Directory operations
- `edit` - Edit/modify operations
- `calendar` - Calendar/scheduling
- `email` - Email operations
- `database` - Data storage
- `api` - External API calls
- `security` - Security operations
- `settings` - Configuration

**Implementation:**
Add `icon` field to tool definitions in your MCP servers.

---

## Durable Tasks (Technique #11)

**Experimental support for long-running operations that survive connection drops.**

### Concept

Traditional MCP tool calls block until completion. Durable tasks allow:
- Starting a task that runs independently
- Polling for status/results
- Retrieving results after reconnection

### Pattern

```typescript
// MCP Server implementation
interface TaskResult {
  taskId: string;
  status: 'pending' | 'running' | 'completed' | 'failed';
  progress?: number;
  result?: any;
  error?: string;
}

// Start task
async function startTask(params: TaskParams): Promise<{ taskId: string }> {
  const taskId = generateUUID();
  // Store task state, start background work
  return { taskId };
}

// Poll for result
async function getTaskResult(taskId: string): Promise<TaskResult> {
  // Return current status and results if available
}
```

### Use Cases

- Long-running research (>60s)
- Batch document processing
- Multi-step analysis workflows
- Operations that users might want to leave running

---

## Tool Calling in Sampling (Technique #12)

MCP sampling requests can now include tools:

```typescript
const result = await client.sampling.sample({
  prompt: "Find and analyze the security vulnerabilities",
  tools: [
    { name: "search_code", ... },
    { name: "read_file", ... }
  ],
  toolChoice: "auto"
});
```

**Benefits:**
- MCP servers can give models tool access during generation
- Enables more sophisticated agentic patterns within MCP
- Reduces round-trips for multi-step operations

---

## OAuth for MCP (Technique #2)

MCP servers that don't support Dynamic Client Registration can use pre-configured OAuth:

```bash
# Add MCP server with OAuth credentials
claude mcp add slack-server npx @anthropic/mcp-slack \
  --client-id "your-client-id" \
  --client-secret "your-client-secret"
```

**Applies To:**
- n8n MCP servers
- Corporate OAuth-protected services
- Self-hosted integrations

---

## Subagent MCP Fix (Technique #6)

**Fixed in Claude Code v2.1.30**

Subagents spawned via Task tool now correctly access MCP tools.

**Before:** MCP tools like Greptile, n8n, Obsidian might fail in delegated tasks.

**After:** MCP tools sync to shared application state, available to all subagents.

**Impact on PAI:**
- Agent delegation with MCP tools works reliably
- Research workflows using MCP scrapers function correctly
- Multi-agent workflows with shared tool access

---

## n8n MCP Integration

PAI's n8n MCP servers provide:

**Calendar (`mcp__n8n-calendar__`):**
- `get_upcoming_events` - 7-day calendar view

**Email (`mcp__n8n-email__`):**
- `get_recent_emails` - Recent inbox messages
- `search_emails` - Gmail search syntax
- `send_email` - Compose and send

**Adding Icons (Future Enhancement):**
```json
// In n8n workflow MCP tool definition
{
  "name": "get_upcoming_events",
  "description": "Get calendar events",
  "icon": "calendar"
}
```

---

## Last Updated

2026-02-04 - Based on MCP Spec 2025-11-25 and Claude Code v2.1.30
