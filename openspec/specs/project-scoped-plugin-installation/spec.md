# project-scoped-plugin-installation Specification

## Purpose
TBD - created by archiving change integrate-rtk-caveman-codegraph. Update Purpose after archive.
## Requirements
### Requirement: Installation flow SHALL support project-scoped activation
The repository SHALL document and structure plugin installation so that a user can enable the plugins for a project without defaulting to global Codex state changes.

#### Scenario: User installs plugins for one project
- **WHEN** a user follows the documented installation flow for a target project
- **THEN** the flow uses project-scoped marketplace and plugin references by default
- **THEN** the flow does not require editing `~/.codex/AGENTS.md` or other global instruction files as its primary path

### Requirement: Plugins SHALL document host dependencies and validation steps
Each plugin SHALL document its required host dependencies, expected activation steps, and a validation method so users can understand what remains outside the plugin boundary. When a plugin depends on a shared MCP that is already provided by the current session, the documentation SHALL describe that dependency as session-provided and SHALL NOT require users to maintain unrelated user or project MCP config unless that configuration is genuinely part of the plugin's activation path.

#### Scenario: User verifies prerequisites before enablement
- **WHEN** a user reads the plugin documentation before enabling a plugin
- **THEN** the documentation lists any required host binaries, runtime tools, network assumptions, or session-provided shared MCP dependencies
- **THEN** the documentation provides at least one command or check that confirms the plugin is ready to use

### Requirement: Missing host prerequisites SHALL fail with actionable guidance
If a plugin depends on a host prerequisite that is not available, the plugin integration SHALL fail with actionable guidance or a documented degraded mode instead of silently succeeding.

#### Scenario: CodeGraph binary is unavailable
- **WHEN** a user enables the `codegraph` plugin on a machine without a usable `codegraph` runtime
- **THEN** the plugin reports that the prerequisite is missing
- **THEN** the plugin points the user to the documented setup or fallback path

