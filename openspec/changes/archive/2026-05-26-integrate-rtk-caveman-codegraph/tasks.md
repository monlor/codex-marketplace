## 1. Repository Foundation

- [x] 1.1 Create the repo-local marketplace structure under `.agents/plugins/marketplace.json`
- [x] 1.2 Create `plugins/rtk`, `plugins/caveman`, and `plugins/codegraph` with valid `.codex-plugin/plugin.json` manifests
- [x] 1.3 Add shared repository documentation describing the marketplace layout and plugin installation model

## 2. Plugin Bundles

- [x] 2.1 Implement the `caveman` plugin as a skill-first bundle with usage prompts and plugin metadata
- [x] 2.2 Implement the `rtk` plugin as a skill/script bundle with documented wrapper usage and validation commands
- [x] 2.3 Implement the `codegraph` plugin with `.mcp.json`, startup guidance, and plugin-local discovery instructions
- [x] 2.4 Ensure each plugin exposes only the surfaces it actually needs and remove unused MCP/app declarations

## 3. Project-Scoped Installation Flow

- [x] 3.1 Add project-scoped install instructions for enabling one plugin or all bundled plugins from the repo marketplace
- [x] 3.2 Add prerequisite checks and documented degraded behavior for missing `rtk` or `codegraph` host runtimes
- [x] 3.3 Add verification steps showing how a user confirms each plugin is discoverable and ready inside Codex

## 4. Validation and Polish

- [x] 4.1 Validate all plugin manifests and marketplace metadata against the Codex plugin structure
- [x] 4.2 Test the documented install flow against a sample project-scoped setup without relying on global `.codex` instructions
- [x] 4.3 Finalize README and troubleshooting notes for dependency boundaries, activation steps, and known limitations
