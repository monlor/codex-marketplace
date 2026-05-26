# codex-tooling-plugin-bundles Specification

## Purpose
TBD - created by archiving change integrate-rtk-caveman-codegraph. Update Purpose after archive.
## Requirements
### Requirement: Repository SHALL publish three installable tooling plugins
The repository SHALL publish three separate Codex plugins named for `rtk`, `caveman`, and `codegraph`, with each plugin stored in its own plugin root and exposed through a valid Codex plugin manifest.

#### Scenario: Plugin roots are present
- **WHEN** a consumer inspects the repository plugin layout
- **THEN** the repository contains separate plugin directories for `rtk`, `caveman`, and `codegraph`
- **THEN** each plugin directory contains a valid `.codex-plugin/plugin.json` entry point

### Requirement: Each plugin SHALL declare only the capabilities it actually implements
Each plugin SHALL expose only the Codex surfaces required for its own behavior, so that `caveman` remains skill-oriented, `rtk` remains skill/script-oriented, and `codegraph` exposes MCP integration without forcing unrelated runtime surfaces.

#### Scenario: Plugin surface matches capability type
- **WHEN** a consumer reviews the plugin manifests and companion files
- **THEN** the `caveman` plugin does not require MCP configuration
- **THEN** the `rtk` plugin does not require MCP configuration unless explicitly needed by its implementation
- **THEN** the `codegraph` plugin includes MCP configuration for code graph access

### Requirement: Repository SHALL provide a marketplace entry for bundled discovery
The repository SHALL provide marketplace metadata that allows Codex to discover the bundled plugins from one source repository while preserving plugin-level installation boundaries.

#### Scenario: Marketplace advertises bundled plugins
- **WHEN** a consumer installs from the repository marketplace definition
- **THEN** Codex can discover `rtk`, `caveman`, and `codegraph` as separate installable plugin entries

