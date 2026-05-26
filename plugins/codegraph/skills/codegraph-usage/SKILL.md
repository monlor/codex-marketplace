---
name: codegraph-usage
description: Use CodeGraph for structure, symbol lookup, impact analysis, and codebase navigation when the runtime is available.
license: MIT
---

# CodeGraph for Codex

Use CodeGraph when the current project already has a `.codegraph/` directory.

- Prefer CodeGraph MCP for structure, symbols, callers, callees, and impact analysis.
- If the repo is not initialized yet, run `codegraph init -i`.
- After large file changes, run `codegraph sync` if graph results look stale.

## Validation

```bash
<plugin root>/scripts/check-codegraph.sh
```
