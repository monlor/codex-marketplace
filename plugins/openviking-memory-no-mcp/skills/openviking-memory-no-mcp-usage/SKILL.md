---
name: openviking-memory-no-mcp-usage
description: Use this plugin when the task benefits from OpenViking-backed long-term memory, but MCP should remain user-managed.
---

# OpenViking Memory No MCP

Use this plugin when the task benefits from OpenViking-backed long-term memory, but MCP should remain user-managed.

- Rely on the hook-driven recall/capture flow.
- Do not assume OpenViking MCP tools are available.
- If the user wants MCP or a non-default endpoint, point them to their project or user `.mcp.json` instead of this plugin.
