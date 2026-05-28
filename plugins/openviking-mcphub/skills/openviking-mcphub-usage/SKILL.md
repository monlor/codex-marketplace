---
name: openviking-mcphub-usage
description: Use this plugin when the task benefits from OpenViking-backed long-term memory across Codex sessions and the current runtime may already expose OpenViking MCP through MCPHub.
---

# OpenViking MCPHub

Use this plugin when the task benefits from long-term memory across Codex sessions.

- Rely on the hook-driven recall/capture flow.
- Use MCP tools only when explicit search, storage, deletion, or resource control is needed.
- This plugin does not bundle `.mcp.json`; when direct MCP tools are needed, prefer the current session's OpenViking MCP if MCPHub already exposes it.
- Do not tell the user to search for or maintain Codex `.mcp.json` for this plugin variant unless they explicitly ask to manage MCP wiring themselves.
- If the current runtime session does not expose OpenViking MCP, fall back to hook-driven recall/capture and continue without direct MCP tools.
