---
name: openviking-memory-usage
description: Use this plugin when the task benefits from OpenViking-backed long-term memory across Codex sessions, including bundled MCP access.
---

# OpenViking Memory

Use this plugin when the task benefits from long-term memory across Codex sessions.

- Prefer the hook-driven recall/capture flow by default.
- Use the MCP tools only when explicit search, storage, or deletion control is needed.
- If MCP startup fails, verify your runtime trusted the plugin hooks and that your effective MCP config still points at the intended OpenViking endpoint.
