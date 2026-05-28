# openviking-mcphub

`openviking-mcphub` is the OpenViking Codex memory plugin that reuses OpenViking MCP from the current runtime's MCPHub setup instead of bundling plugin-local MCP wiring.

It includes:

- Codex hooks for automatic memory recall and capture
- the same OpenViking lifecycle scripts as the full plugin
- zero-dependency Node hook scripts copied from the upstream example
- no bundled `.mcp.json`

Use this version when you want the same OpenViking memory hooks as the full plugin, but expect direct MCP access to come from the current runtime session's existing MCPHub wiring.

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default the hook scripts target `http://127.0.0.1:1933`.

For direct MCP tools, this plugin also expects the current runtime to already expose OpenViking through MCPHub. If the session does not provide those tools, the hook-driven recall and capture flow still works without bundled MCP wiring.

## Hook Runtime

Modern Codex injects `PLUGIN_ROOT` and `PLUGIN_DATA` for plugin hooks. This plugin uses that contract directly, so there is no post-install cache rewrite step.

Enable `plugin_hooks = true` and trust the hooks when Codex asks.

## Configuration

Connection and identity are resolved from:

- `OPENVIKING_URL` or `OPENVIKING_BASE_URL`
- `OPENVIKING_API_KEY` or `OPENVIKING_BEARER_TOKEN`
- `OPENVIKING_ACCOUNT`
- `OPENVIKING_USER`
- `OPENVIKING_AGENT_ID`
- `OPENVIKING_CLI_CONFIG_FILE` or `~/.openviking/ovcli.conf`

The hook scripts use the same OpenViking configuration chain as the full plugin.

This plugin does not ship `.mcp.json`.
If you need direct MCP access for search, resource, or memory management, use the current runtime session's OpenViking MCP when MCPHub exposes it.
If the session does not expose OpenViking MCP, keep using the hook-driven recall and capture flow or switch to the full `openviking-memory` plugin if bundled MCP wiring is required.

## Validation

```bash
codex plugin add openviking-mcphub@monlor-marketplace
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-mcphub/<version>/` and verify `hooks/hooks.json` still contains `${PLUGIN_ROOT}` commands.
