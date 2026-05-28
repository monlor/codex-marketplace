# openviking-memory-no-mcp

`openviking-memory-no-mcp` is the OpenViking Codex memory plugin without bundled MCP wiring.

It includes:

- Codex hooks for automatic memory recall and capture
- the same OpenViking lifecycle scripts as the full plugin
- zero-dependency Node hook scripts copied from the upstream example
- no bundled `.mcp.json`

Use this version when you want the same OpenViking memory hooks as the full plugin, but prefer to install and configure MCP yourself in your user or project Codex config.

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default the hook scripts target `http://127.0.0.1:1933`.

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
If you want direct MCP access for search, resource, or memory management, add and maintain OpenViking MCP config yourself in the relevant Codex user or project config.
If you need a different MCP URL, override your user or project MCP config manually.

## Validation

```bash
codex plugin add openviking-memory-no-mcp@monlor-marketplace
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-memory-no-mcp/<version>/` and verify `hooks/hooks.json` still contains `${PLUGIN_ROOT}` commands.
