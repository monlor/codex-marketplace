## MODIFIED Requirements

### Requirement: Plugins SHALL document host dependencies and validation steps
Each plugin SHALL document its required host dependencies, expected activation steps, and a validation method so users can understand what remains outside the plugin boundary. When a plugin depends on a shared MCP that is already provided by the current session, the documentation SHALL describe that dependency as session-provided and SHALL NOT require users to maintain unrelated user or project MCP config unless that configuration is genuinely part of the plugin's activation path.

#### Scenario: User verifies prerequisites before enablement
- **WHEN** a user reads the plugin documentation before enabling a plugin
- **THEN** the documentation lists any required host binaries, runtime tools, network assumptions, or session-provided shared MCP dependencies
- **THEN** the documentation provides at least one command or check that confirms the plugin is ready to use

