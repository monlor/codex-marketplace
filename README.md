# codex-marketplace

Local Codex marketplace for these plugins:

- `caveman`: terse response mode as a skill-first plugin
- `rtk`: `rtk` wrapper guidance plus host-runtime checks
- `codegraph`: CodeGraph MCP bridge plus prerequisite checks
- `openviking-memory`: OpenViking long-term memory with bundled MCP wiring
- `openviking-memory-no-mcp`: OpenViking long-term memory hooks without bundled MCP wiring

## Quick Start

Fastest path for a target project:

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project
```

That script:

1. creates `/path/to/target-project/.codex-home/config.toml` from [`config/ai/codex/config.toml`](/Users/monlor/Workspace/codex-marketplace/config/ai/codex/config.toml)
2. adds this repo as a local marketplace to that project-scoped `CODEX_HOME`
3. installs `caveman`, `rtk`, and `codegraph`

Start Codex with that isolated home:

```bash
CODEX_HOME=/path/to/target-project/.codex-home codex
```

This keeps the setup project-local and avoids changing your global `~/.codex/config.toml`.

Repository name: `codex-marketplace`

Codex marketplace name: `monlor-marketplace`

## Add This Marketplace

Add the marketplace to your default Codex setup:

```bash
codex plugin marketplace add /absolute/path/to/codex-marketplace
```

Add it to a project-scoped Codex home instead:

```bash
CODEX_HOME=/path/to/project/.codex-home codex plugin marketplace add /absolute/path/to/codex-marketplace
```

## View Marketplaces And Plugins

List configured marketplaces:

```bash
codex plugin marketplace list
```

List plugins from this marketplace:

```bash
codex plugin list --marketplace monlor-marketplace
```

If you are using a project-scoped home, prefix the same commands with `CODEX_HOME=/path/to/project/.codex-home`.

## Install Plugins

Install any plugin from this marketplace:

```bash
codex plugin add caveman@monlor-marketplace
codex plugin add rtk@monlor-marketplace
codex plugin add codegraph@monlor-marketplace
codex plugin add openviking-memory@monlor-marketplace
codex plugin add openviking-memory-no-mcp@monlor-marketplace
```

Project-scoped example:

```bash
CODEX_HOME=/path/to/project/.codex-home codex plugin add caveman@monlor-marketplace
```

Or use the bootstrap script to install one or more plugins into a project-local Codex home:

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project caveman
./scripts/bootstrap-project-home.sh /path/to/target-project rtk
./scripts/bootstrap-project-home.sh /path/to/target-project codegraph
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-memory
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-memory-no-mcp
```

## Plugin Notes

| Plugin | What it adds | Host prerequisite | Degraded behavior |
| --- | --- | --- | --- |
| `caveman` | skills only | none | fully usable after install |
| `rtk` | skills and shell wrapper | `rtk` on `PATH` | wrapper exits with setup guidance |
| `codegraph` | skills, MCP bridge, wrapper script | `codegraph` on `PATH` | MCP wrapper exits with setup guidance |
| `openviking-memory` | skills, hooks, MCP config | reachable OpenViking server | hooks and MCP stay inert until configured |
| `openviking-memory-no-mcp` | skills and hooks only | reachable OpenViking server | hooks stay inert until configured |

`caveman`, `rtk`, and `openviking-memory-no-mcp` intentionally do not ship MCP config for the hook-only variant.

## Troubleshooting

If `rtk` is missing:

- `plugins/rtk/scripts/check-rtk.sh` exits non-zero
- the plugin still installs, but command wrapping is unavailable

If `codegraph` is missing:

- `plugins/codegraph/scripts/check-codegraph.sh` exits non-zero
- the plugin cannot start its MCP bridge until the `codegraph` binary is available

If MCP startup still fails:

```bash
codex doctor
codex plugin list --marketplace monlor-marketplace
```

If OpenViking hooks do not run, render placeholders in the cached plugin copy:

```bash
./scripts/render-openviking-plugin-cache.sh /path/to/project/.codex-home openviking-memory
./scripts/render-openviking-plugin-cache.sh /path/to/project/.codex-home openviking-memory-no-mcp
```

## Development

Repository layout:

```text
.agents/plugins/marketplace.json   Marketplace metadata
config/ai/codex/config.toml        Baseline config for project-scoped CODEX_HOME
plugins/caveman                    Skill-only plugin
plugins/rtk                        Skill + shell wrapper plugin
plugins/codegraph                  Skill + MCP plugin
plugins/openviking-memory          Hook + MCP plugin
plugins/openviking-memory-no-mcp   Hook-only plugin
scripts/bootstrap-project-home.sh  Project-scoped installer
scripts/check-external-cli.mjs     Shared external CLI checker
scripts/render-openviking-plugin-cache.sh  Cache placeholder renderer
scripts/validate-marketplace.sh    Manifest and layout validation
scripts/smoke-test-install.sh      Isolated install-flow test
```

Validate the repository structure and manifest JSON:

```bash
./scripts/validate-marketplace.sh
```

Run the install smoke test in a temporary project directory:

```bash
./scripts/smoke-test-install.sh
```

`rtk` and `codegraph` both use the shared
[`scripts/check-external-cli.mjs`](/Users/monlor/Workspace/codex-marketplace/scripts/check-external-cli.mjs)
checker instead of maintaining separate runtime-detection logic.

You can run the checker directly:

```bash
node scripts/check-external-cli.mjs plugins/rtk/external-cli.json
node scripts/check-external-cli.mjs plugins/codegraph/external-cli.json --json
```
