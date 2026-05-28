## Context

The repository currently ships two OpenViking plugin variants: `openviking-memory` with bundled `.mcp.json`, and `openviking-memory-no-mcp` with the same hooks but no bundled MCP config. The hook scripts already work without Codex-side MCP wiring, but the plugin manifest, skill, README, and tests define the no-MCP variant as "user-managed MCP." That wording pushes agents toward searching for `.mcp.json` or asking users to configure Codex MCP, which conflicts with the intended setup of reusing an OpenViking MCP that is already exposed by the host's existing MCPHub integration.

This change is cross-cutting because the plugin name, marketplace entry, documentation, tests, and install validation scripts all encode the old behavior. The plugin manifest format in this repository does not provide a dedicated way to declare "reuse an MCP that the host already mounted into the session," so the design must express that contract through naming, guidance, and tests instead of new runtime wiring.

## Goals / Non-Goals

**Goals:**
- Replace the misleading `openviking-memory-no-mcp` name with `openviking-mcphub`
- Keep the hook-only packaging model with no bundled `.mcp.json`
- Instruct agents to use the current runtime's OpenViking MCP when MCPHub already exposes it
- Define a safe fallback where the plugin still provides hook-driven recall/capture even when direct MCP tools are unavailable
- Update repository validation and docs so the renamed plugin is consistently represented

**Non-Goals:**
- Adding a new OpenViking MCP bridge or modifying the bundled `openviking-memory` plugin
- Teaching the plugin manifest to auto-discover or mount host MCP servers
- Changing the OpenViking hook scripts' memory retrieval behavior or server-side URI layout

## Decisions

### Keep the plugin hook-only and do not add bundled MCP wiring

The renamed plugin will continue to omit `.mcp.json` and `mcpServers` from its manifest. This preserves the packaging boundary: the plugin contributes hooks and guidance, while the host environment remains responsible for whether OpenViking MCP tools are available in the current session.

Alternative considered:
- Add a plugin-local `.mcp.json` again. Rejected because it would collapse this variant back into the full bundled-MCP plugin and would not represent the "reuse existing MCPHub" intent.

### Model MCPHub access as a session-provided dependency expressed in guidance

Because the repository does not have a manifest field for "depends on a shared MCP already mounted by the host," the contract will be expressed in the plugin's display text, skill instructions, README, and tests. Those artifacts must consistently say:
- prefer the current session's OpenViking MCP when it is already available
- do not tell the user to search for or maintain `.mcp.json` for this plugin variant
- fall back to hook-only behavior when direct MCP tools are not available in the session

Alternative considered:
- Add host discovery logic to the plugin scripts. Rejected because the hooks do not control the model tool registry, and probing external Codex config would recreate the misleading behavior we are trying to remove.

### Rename the plugin instead of keeping the old name with new semantics

The old name encodes the wrong mental model: "no-mcp" sounds like "there is no MCP unless you configure it yourself." Renaming the plugin to `openviking-mcphub` makes the dependency boundary explicit and gives documentation a clearer anchor for explaining that MCP access is expected to come from MCPHub rather than bundled plugin wiring.

Alternative considered:
- Keep `openviking-memory-no-mcp` and only rewrite the docs. Rejected because the stale name would continue to imply manual MCP setup and would make marketplace listings harder to understand.

### Treat documentation and validation files as part of the runtime contract

The repository's README, marketplace metadata, install scripts, and tests materially shape how Codex users and agents activate plugins. This change will therefore update those surfaces alongside the plugin root so the renamed variant remains discoverable, installable, and validated under the new contract.

## Risks / Trade-offs

- [Host runtime does not expose OpenViking MCP in the current session] → Document a hook-only fallback and avoid promising guaranteed direct MCP access
- [Plugin rename breaks existing install references] → Mark the rename as breaking and include migration notes in docs and task planning
- [Guidance remains ambiguous and agents keep searching local config] → Replace all "install/configure yourself" wording and back it with regression tests
- [Validation scripts miss an old plugin reference] → Update marketplace, bootstrap, smoke-test, and manifest checks together

## Migration Plan

1. Introduce the renamed plugin root and update marketplace metadata to publish `openviking-mcphub`
2. Update repository documentation and validation scripts to reference the new plugin name and expected no-bundled-MCP file layout
3. Replace guidance and tests that assert manual `.mcp.json` management with guidance and tests that assert session-provided MCPHub usage
4. Remove or retire remaining `openviking-memory-no-mcp` references once install and validation flows pass

Rollback strategy:
- Revert the rename and restore old marketplace/script references if the renamed plugin cannot be installed cleanly or if migration costs prove too disruptive

## Open Questions

- Should the old plugin name remain as a compatibility alias for one release, or should the rename be immediate and exclusive?
- If the host exposes OpenViking tools under a name other than the plugin's wording, do we want the skill text to mention alternate labels, or stay generic with "current session's OpenViking MCP"?
