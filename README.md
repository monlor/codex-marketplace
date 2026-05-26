# monlor-marketplace

Repo-local Codex marketplace for five tooling plugins:

- `caveman`: terse response mode as a skill-first plugin
- `rtk`: `rtk` wrapper guidance plus host-runtime checks
- `codegraph`: CodeGraph MCP bridge plus prerequisite checks
- `openviking-memory`: OpenViking long-term memory with bundled MCP wiring
- `openviking-memory-no-mcp`: OpenViking long-term memory hooks without bundled MCP wiring

## Layout

```text
.agents/plugins/marketplace.json   Marketplace metadata
config/ai/codex/config.toml        Project baseline for project-scoped CODEX_HOME
plugins/caveman                    Skill-only plugin
plugins/rtk                        Skill + shell wrapper plugin
plugins/codegraph                  Skill + MCP plugin
plugins/openviking-memory          Hook + MCP plugin
plugins/openviking-memory-no-mcp   Hook-only plugin
scripts/bootstrap-project-home.sh  Project-scoped installer
scripts/check-external-cli.mjs     Shared external CLI checker
scripts/render-openviking-plugin-cache.sh  Cache placeholder renderer for OpenViking plugins
scripts/validate-marketplace.sh    Manifest and layout validation
scripts/smoke-test-install.sh      Isolated install-flow test
```

## Plugin Boundaries

| Plugin | Surfaces | Host prerequisite | Degraded behavior |
| --- | --- | --- | --- |
| `caveman` | `skills/` | none | fully usable after install |
| `rtk` | `skills/`, `scripts/` | `rtk` on `PATH` | wrapper exits with setup guidance |
| `codegraph` | `skills/`, `.mcp.json`, `scripts/` | `codegraph` on `PATH` | MCP wrapper exits with setup guidance |
| `openviking-memory` | `skills/`, `hooks/`, `.mcp.json`, `scripts/` | reachable OpenViking server | hooks and MCP are inert until configured |
| `openviking-memory-no-mcp` | `skills/`, `hooks/`, `scripts/` | reachable OpenViking server | hooks are inert until configured |

`caveman`, `rtk`, and `openviking-memory-no-mcp` intentionally do not ship MCP config for the hook-only variant. `codegraph` and `openviking-memory` ship MCP config.

## Project-Scoped Install

Default flow uses a project-owned `CODEX_HOME` instead of `~/.codex`.

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project
```

That command:

1. creates `/path/to/target-project/.codex-home/config.toml` from [`config/ai/codex/config.toml`](/Users/monlor/Workspace/monlor-marketplace/config/ai/codex/config.toml)
2. adds this repo as a local marketplace inside that project-scoped `CODEX_HOME`
3. installs and enables `caveman`, `rtk`, and `codegraph`

To install one plugin instead of the default set:

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project caveman
./scripts/bootstrap-project-home.sh /path/to/target-project rtk
./scripts/bootstrap-project-home.sh /path/to/target-project codegraph
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-memory
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-memory-no-mcp
```

To use that isolated Codex state:

```bash
CODEX_HOME=/path/to/target-project/.codex-home codex
```

This flow does not require editing `~/.codex/AGENTS.md` or your global `~/.codex/config.toml`.

## Verification

List the marketplace from the project-scoped home:

```bash
CODEX_HOME=/path/to/target-project/.codex-home codex plugin marketplace list
CODEX_HOME=/path/to/target-project/.codex-home codex plugin list --marketplace monlor-marketplace
```

Check each plugin:

```bash
plugins/caveman/README.md
plugins/rtk/scripts/check-rtk.sh
plugins/codegraph/scripts/check-codegraph.sh
plugins/openviking-memory/README.md
plugins/openviking-memory-no-mcp/README.md
```

Expected results:

- `caveman`: install succeeds with no extra runtime
- `rtk`: `check-rtk.sh` prints version details or a missing-runtime message
- `codegraph`: `check-codegraph.sh` prints version details or a missing-runtime message
- `openviking-memory`: install succeeds, then `render-openviking-plugin-cache.sh` resolves hook and MCP placeholders in the cached copy
- `openviking-memory-no-mcp`: install succeeds, then `render-openviking-plugin-cache.sh` resolves hook placeholders in the cached copy

## Validation

Validate the repository structure and manifest JSON:

```bash
./scripts/validate-marketplace.sh
```

Run the install smoke test in a temporary project directory:

```bash
./scripts/smoke-test-install.sh
```

## Shared External CLI Checks

`rtk` and `codegraph` both use the shared
[`scripts/check-external-cli.mjs`](/Users/monlor/Workspace/codex-marketplace/scripts/check-external-cli.mjs)
checker instead of maintaining separate runtime-detection logic.

Each plugin supplies its own
[`external-cli.json`](./plugins/rtk/external-cli.json) or
[`external-cli.json`](./plugins/codegraph/external-cli.json) with:

- `command`
- `versionArgs`
- `minVersion` when needed
- plugin-specific missing and degraded-behavior messaging
- platform-specific or default install hints

You can run the checker directly:

```bash
node scripts/check-external-cli.mjs plugins/rtk/external-cli.json
node scripts/check-external-cli.mjs plugins/codegraph/external-cli.json --json
```

## Troubleshooting

### `rtk` missing

`plugins/rtk/scripts/check-rtk.sh` exits non-zero and prints:

- that `rtk` is not on `PATH`
- that the plugin still installs but command-wrapping is unavailable
- that the user should install `rtk` before relying on the wrapper

### `codegraph` missing

`plugins/codegraph/scripts/check-codegraph.sh` exits non-zero and prints:

- that `codegraph` is not on `PATH`
- that the `codegraph` plugin cannot start its MCP bridge
- that the user should install or expose the `codegraph` binary first

### MCP startup still fails

Inspect the project-scoped home first:

```bash
CODEX_HOME=/path/to/target-project/.codex-home codex doctor
CODEX_HOME=/path/to/target-project/.codex-home codex plugin list --marketplace monlor-marketplace
```

Then verify the cached plugin copy under the same `CODEX_HOME` contains `codegraph/.mcp.json`.

### OpenViking hooks do not run

The OpenViking plugins require a post-install cache render because Codex hook subprocesses do not receive a usable plugin-root path.

Run:

```bash
./scripts/render-openviking-plugin-cache.sh /path/to/target-project/.codex-home openviking-memory
./scripts/render-openviking-plugin-cache.sh /path/to/target-project/.codex-home openviking-memory-no-mcp
```
