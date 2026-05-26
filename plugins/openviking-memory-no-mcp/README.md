# openviking-memory-no-mcp

`openviking-memory-no-mcp` is the hook-only OpenViking Codex memory plugin.

It includes:

- Codex hooks for automatic memory recall and capture
- the same OpenViking lifecycle scripts as the full plugin
- no bundled `.mcp.json`

Use this version when you want Codex memory hooks, but prefer to add MCP yourself in user or project config.

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default the hook scripts target `http://127.0.0.1:1933`.

## Important Install Step

After `codex plugin add`, render the cached plugin copy so Codex hooks use absolute paths:

```bash
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory-no-mcp
```

## Manual MCP

If you also want MCP, add it yourself in the relevant Codex config. This plugin intentionally does not ship `.mcp.json`.

## Validation

```bash
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory-no-mcp
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-memory-no-mcp/`.
