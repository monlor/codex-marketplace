# openviking-memory

`openviking-memory` is the full OpenViking Codex memory plugin.

It includes:

- Codex hooks for automatic memory recall and capture
- OpenViking MCP wiring through `.mcp.json`
- zero-dependency Node hook scripts copied from the upstream example

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default it targets `http://127.0.0.1:1933`.

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

Bundled MCP uses the default endpoint `http://127.0.0.1:1933/mcp`.
If you need a different MCP URL, override your user or project MCP config manually.

## Validation

```bash
codex plugin add openviking-memory@monlor-marketplace
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-memory/<version>/` and verify `hooks/hooks.json` still contains `${PLUGIN_ROOT}` commands.
