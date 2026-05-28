---
name: openviking-memory-no-mcp-usage
description: Use this plugin when the task benefits from OpenViking-backed long-term memory across Codex sessions, with MCP left for the user to install and configure.
---

# OpenViking Memory No MCP

Use this plugin when the task benefits from long-term memory across Codex sessions.

- Rely on the hook-driven recall/capture flow.
- Use MCP tools only when explicit search, storage, deletion, or resource control is needed.
- This plugin does not bundle `.mcp.json`; if you want MCP tools or a non-default endpoint, install and configure OpenViking MCP yourself in your user or project Codex config.
- If MCP startup fails after manual configuration, verify your runtime trusted the plugin hooks and that your effective MCP config still points at the intended OpenViking endpoint.
