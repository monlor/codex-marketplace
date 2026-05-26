# caveman

`caveman` is a skill-first Codex plugin. It adds no MCP servers and requires no host runtime.

## What It Does

- defaults to terse technical output
- strips filler
- keeps commands, blockers, risk, and verification details

## Validation

After installing the plugin:

```bash
CODEX_HOME=/path/to/project/.codex-home codex plugin list --marketplace codex-tooling-local
```

Then start Codex from the same `CODEX_HOME` and request `caveman` mode in a prompt.
