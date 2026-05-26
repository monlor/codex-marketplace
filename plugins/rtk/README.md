# rtk

`rtk` is a skill and script plugin. It does not expose MCP.

## Host Dependency

This plugin expects the `rtk` binary to already be available on `PATH`.

## Validation

```bash
plugins/rtk/scripts/check-rtk.sh
plugins/rtk/scripts/check-rtk.sh --json
plugins/rtk/scripts/rtk.sh --version
```

This plugin uses the repo-level `scripts/check-external-cli.mjs` checker with
[`external-cli.json`](/Users/monlor/Workspace/codex-marketplace/plugins/rtk/external-cli.json).

If `rtk` is missing, the plugin remains installed but wrapper commands fail fast
with setup guidance instead of silently falling back.
