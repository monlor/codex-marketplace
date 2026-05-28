# codex-marketplace

Codex marketplace for these plugins:

- `caveman`: terse response mode as a skill-first plugin
- `rtk`: `rtk` wrapper guidance plus host-runtime checks
- `codegraph`: CodeGraph MCP bridge plus prerequisite checks
- `openviking-memory`: OpenViking long-term memory with bundled MCP wiring
- `openviking-mcphub`: OpenViking long-term memory hooks that reuse session-provided MCPHub access

## Quick Start

Add this marketplace:

```bash
codex plugin marketplace add https://github.com/monlor/codex-marketplace.git
```

Repository name: `codex-marketplace`

Codex marketplace name: `monlor-marketplace`

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
codex plugin add openviking-mcphub@monlor-marketplace
```

If you use plugin hooks, ensure they are enabled in your target Codex config:

```bash
plugin_hooks = true
```

Recommended default bundle:

```bash
codex plugin add caveman@monlor-marketplace
codex plugin add rtk@monlor-marketplace
codex plugin add codegraph@monlor-marketplace
```

## Optional Isolated Setup

If you explicitly want a project-local Codex home instead of the global default, use the bootstrap script:

```bash
./scripts/bootstrap-project-home.sh /path/to/target-project
./scripts/bootstrap-project-home.sh /path/to/target-project caveman
./scripts/bootstrap-project-home.sh /path/to/target-project rtk
./scripts/bootstrap-project-home.sh /path/to/target-project codegraph
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-memory
./scripts/bootstrap-project-home.sh /path/to/target-project openviking-mcphub
```

## Plugin Notes

| Plugin | What it adds | Host prerequisite | Degraded behavior |
| --- | --- | --- | --- |
| `caveman` | skills only | none | fully usable after install |
| `rtk` | skills and shell wrapper | `rtk` on `PATH` | wrapper exits with setup guidance |
| `codegraph` | skills, MCP bridge, wrapper script | `codegraph` on `PATH` | MCP wrapper exits with setup guidance |
| `openviking-memory` | skills, hooks, MCP config | reachable OpenViking server | hooks and MCP stay inert until configured |
| `openviking-mcphub` | skills and hooks only | reachable OpenViking server and session-provided OpenViking MCP via MCPHub for direct tools | hook-driven recall/capture still works when direct MCP tools are absent |

`caveman`, `rtk`, and `openviking-mcphub` intentionally do not ship bundled MCP config.

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

If OpenViking hooks do not run:

- ensure `plugin_hooks = true`
- trust the plugin hooks when Codex prompts for approval
- confirm your Codex runtime supports plugin hook env vars such as `PLUGIN_ROOT`
- for direct MCP access in the hook-only variant, ensure the current session already exposes OpenViking through MCPHub

## Development

Repository layout:

```text
.agents/plugins/marketplace.json   Marketplace metadata
config/ai/codex/config.toml        Baseline config for optional project-scoped installs
plugins/caveman                    Skill-only plugin
plugins/rtk                        Skill + shell wrapper plugin
plugins/codegraph                  Skill + MCP plugin
plugins/openviking-memory          Hook + MCP plugin
plugins/openviking-mcphub          Hook-only plugin with session-provided MCPHub dependency
scripts/bootstrap-project-home.sh  Optional project-scoped installer
scripts/check-external-cli.mjs     Shared external CLI checker
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
