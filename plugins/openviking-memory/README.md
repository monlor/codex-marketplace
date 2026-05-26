# openviking-memory

`openviking-memory` is the full OpenViking Codex memory plugin.

It includes:

- Codex hooks for automatic memory recall and capture
- OpenViking MCP wiring through `.mcp.json`
- zero-dependency Node hook scripts copied from the upstream example

## Host Dependency

This plugin expects an OpenViking server to be reachable. By default it targets `http://127.0.0.1:1933`.

## Important Install Step

After `codex plugin add`, render the cached plugin copy so Codex hooks use absolute paths:

```bash
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory
```

## Configuration

Connection and identity are resolved from:

- `OPENVIKING_URL` or `OPENVIKING_BASE_URL`
- `OPENVIKING_API_KEY` or `OPENVIKING_BEARER_TOKEN`
- `OPENVIKING_ACCOUNT`
- `OPENVIKING_USER`
- `OPENVIKING_AGENT_ID`
- `OPENVIKING_CLI_CONFIG_FILE` or `~/.openviking/ovcli.conf`

The MCP cache renderer also resolves `OPENVIKING_MCP_URL` when set.

## Validation

```bash
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory
```

Then inspect the cached copy under `~/.codex/plugins/cache/monlor-marketplace/openviking-memory/`.
