## Why

The current `openviking-memory-no-mcp` plugin is described as a hook-only plugin whose MCP access must be installed and configured by the user. That wording causes agents to look for user or project `.mcp.json` configuration instead of reusing the OpenViking MCP that is already available through the host's existing MCPHub setup.

## What Changes

- **BREAKING** Rename `openviking-memory-no-mcp` to `openviking-mcphub` across plugin metadata, marketplace entries, installation docs, and validation scripts.
- Preserve the hook-only packaging model with no bundled `.mcp.json`, but change the plugin guidance to assume OpenViking MCP tools come from the current runtime's existing MCPHub wiring.
- Update the plugin manifest, skill text, README, and tests so agents are told to use the current session's OpenViking MCP when it is available and to fall back to hook-driven recall/capture when it is not.
- Remove guidance that tells users or agents to install or maintain OpenViking MCP configuration in Codex user or project config for this plugin variant.

## Capabilities

### New Capabilities
- `openviking-mcphub-plugin`: Defines the hook-only OpenViking plugin variant that reuses session-provided MCPHub access without shipping its own `.mcp.json`.

### Modified Capabilities
- `project-scoped-plugin-installation`: Plugin documentation and validation requirements need to cover plugins that depend on a session-provided shared MCP instead of local MCP wiring.

## Impact

- Affected plugin root, manifest, skill, README, and test coverage for the OpenViking no-bundled-MCP variant
- Marketplace metadata and install/validation scripts that enumerate plugin names and expected files
- User-facing installation and troubleshooting guidance for OpenViking plugin variants
