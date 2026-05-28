## 1. Rename and republish the plugin variant

- [x] 1.1 Rename the `openviking-memory-no-mcp` plugin root and manifest identity to `openviking-mcphub`
- [x] 1.2 Update marketplace metadata, bootstrap/install scripts, and repository docs to reference `openviking-mcphub`
- [x] 1.3 Preserve the hook-only package layout by ensuring the renamed plugin still ships hooks and skills but no bundled `.mcp.json`

## 2. Replace manual-MCP guidance with MCPHub-first guidance

- [x] 2.1 Rewrite the renamed plugin's manifest interface text, skill guidance, and README to prefer the current session's OpenViking MCP from MCPHub
- [x] 2.2 Remove instructions that tell users or agents to install, search for, or maintain OpenViking `.mcp.json` in Codex user or project config for this plugin variant
- [x] 2.3 Document the fallback behavior where direct MCP access may be absent but hook-driven recall/capture still remains available

## 3. Update regression coverage and validate install flows

- [x] 3.1 Replace the old `openviking-memory-no-mcp` guidance tests with coverage for `openviking-mcphub` naming and MCPHub-first wording
- [x] 3.2 Update validation and smoke-test assertions to use the new plugin name and expected artifact layout
- [x] 3.3 Run the relevant repository validation and test commands and resolve any failures caused by the rename
