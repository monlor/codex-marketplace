# codegraph

`codegraph` is the only plugin in this repository that exposes MCP.

## Host Dependency

This plugin expects a working `codegraph` binary on `PATH`.

## Behavior

- when `codegraph` is available, the plugin starts `codegraph serve --mcp`
- when `codegraph` is missing, startup fails with an actionable message

## Validation

```bash
plugins/codegraph/scripts/check-codegraph.sh
plugins/codegraph/scripts/check-codegraph.sh --json
plugins/codegraph/scripts/codegraph-mcp.sh
```

This plugin uses the repo-level `scripts/check-external-cli.mjs` checker with
[`external-cli.json`](/Users/monlor/Workspace/codex-marketplace/plugins/codegraph/external-cli.json).

If the host runtime is missing, both commands fail fast with setup guidance.
