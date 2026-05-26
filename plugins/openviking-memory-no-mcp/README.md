# openviking-memory-no-mcp

`openviking-memory-no-mcp` is the hook-only OpenViking Codex memory plugin.

It includes:

- Codex hooks for automatic memory recall and capture
- the same OpenViking lifecycle scripts as the full plugin
- no bundled `.mcp.json`

Use this version when you want Codex memory hooks, but prefer to add MCP yourself in user or project config.

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default the hook scripts target `http://127.0.0.1:1933`.

## Hook Runtime

Modern Codex injects `PLUGIN_ROOT` and `PLUGIN_DATA` for plugin hooks. This plugin uses that contract directly, so there is no post-install cache rewrite step.

Enable `plugin_hooks = true` and trust the hooks when Codex asks.

## Manual MCP

If you also want MCP, add it yourself in the relevant Codex config. This plugin intentionally does not ship `.mcp.json`.

## Validation

```bash
codex plugin add openviking-memory-no-mcp@monlor-marketplace
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-memory-no-mcp/<version>/` and verify `hooks/hooks.json` still contains `${PLUGIN_ROOT}` commands.
