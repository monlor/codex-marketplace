# codex-marketplace

Codex marketplace for these plugins:

- `caveman`: terse response mode as a skill-first plugin
- `rtk`: `rtk` wrapper guidance plus host-runtime checks
- `codegraph`: CodeGraph MCP bridge plus prerequisite checks
- `openviking-memory`: OpenViking long-term memory with bundled MCP wiring
- `openviking-memory-no-mcp`: OpenViking long-term memory hooks without bundled MCP wiring

## Quick Start

Add this marketplace from the remote Git repository:

```bash
./scripts/install-marketplace.sh
```

Repository name: `codex-marketplace`

Codex marketplace name: `monlor-marketplace`

## Add This Marketplace

Add the marketplace:

```bash
codex plugin marketplace add https://github.com/monlor/codex-marketplace.git
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

## Install Plugins

Install any plugin from this marketplace:

```bash
codex plugin add caveman@monlor-marketplace
codex plugin add rtk@monlor-marketplace
codex plugin add codegraph@monlor-marketplace
codex plugin add openviking-memory@monlor-marketplace
codex plugin add openviking-memory-no-mcp@monlor-marketplace
```

Or install the default bundle with one command:

```bash
./scripts/install-marketplace.sh
```

Install a custom plugin set:

```bash
./scripts/install-marketplace.sh caveman
./scripts/install-marketplace.sh rtk
./scripts/install-marketplace.sh codegraph
./scripts/install-marketplace.sh openviking-memory
./scripts/install-marketplace.sh openviking-memory-no-mcp
```

## Optional Isolated Setup

If you explicitly want a project-local Codex home instead of the global default, use the bootstrap script:

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project
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
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory
./scripts/render-openviking-plugin-cache.sh ~/.codex openviking-memory-no-mcp
```

## Development

Repository layout:

```text
.agents/plugins/marketplace.json   Marketplace metadata
config/ai/codex/config.toml        Baseline config for optional project-scoped installs
plugins/caveman                    Skill-only plugin
plugins/rtk                        Skill + shell wrapper plugin
plugins/codegraph                  Skill + MCP plugin
plugins/openviking-memory          Hook + MCP plugin
plugins/openviking-memory-no-mcp   Hook-only plugin
scripts/bootstrap-project-home.sh  Optional project-scoped installer
scripts/install-marketplace.sh     Default global installer
scripts/check-external-cli.mjs     Shared external CLI checker
scripts/render-openviking-plugin-cache.sh  Cache placeholder renderer
scripts/validate-marketplace.sh    Manifest and layout validation
scripts/smoke-test-install.sh      Global install-flow test
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
