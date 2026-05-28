# openviking-mcphub-plugin Specification

## Purpose
TBD - created by archiving change rename-openviking-mcphub. Update Purpose after archive.
## Requirements
### Requirement: Marketplace SHALL publish an OpenViking MCPHub plugin variant
The repository SHALL publish a plugin named `openviking-mcphub` that provides the hook-based OpenViking memory workflow without shipping its own `.mcp.json` or manifest-declared `mcpServers`.

#### Scenario: Plugin package exposes hooks without bundled MCP wiring
- **WHEN** a consumer inspects the `openviking-mcphub` plugin package
- **THEN** the package contains a valid `.codex-plugin/plugin.json` and hook definitions
- **THEN** the package does not contain a bundled `.mcp.json`
- **THEN** the plugin manifest does not declare plugin-managed MCP servers

### Requirement: OpenViking MCPHub guidance SHALL prefer session-provided MCP access
The `openviking-mcphub` plugin SHALL instruct agents to use OpenViking MCP tools from the current runtime session when they are already exposed by MCPHub, instead of directing users to install or maintain plugin-local Codex MCP configuration.

#### Scenario: Skill text describes MCPHub-first usage
- **WHEN** an agent reads the `openviking-mcphub` skill guidance
- **THEN** the guidance tells the agent to prefer the current session's OpenViking MCP when direct MCP tools are needed
- **THEN** the guidance does not tell the agent to search for or maintain `.mcp.json` in user or project Codex config

#### Scenario: README documents hook-only fallback
- **WHEN** a user reads the `openviking-mcphub` README
- **THEN** the README explains that direct MCP access depends on the current runtime already exposing OpenViking through MCPHub
- **THEN** the README explains that hook-driven recall and capture still work without bundled MCP wiring

