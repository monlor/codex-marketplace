#!/usr/bin/env bash
set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required for validation." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

MARKETPLACE="$REPO_ROOT/.agents/plugins/marketplace.json"
PLUGINS=(caveman rtk codegraph openviking-memory openviking-memory-no-mcp)

jq -e '.name == "monlor-marketplace"' "$MARKETPLACE" >/dev/null
jq -e '.plugins | length == 5' "$MARKETPLACE" >/dev/null

for plugin in "${PLUGINS[@]}"; do
  manifest="$REPO_ROOT/plugins/$plugin/.codex-plugin/plugin.json"
  jq -e --arg name "$plugin" '.name == $name' "$manifest" >/dev/null
done

test ! -f "$REPO_ROOT/plugins/caveman/.mcp.json"
test ! -f "$REPO_ROOT/plugins/rtk/.mcp.json"
test -f "$REPO_ROOT/plugins/codegraph/.mcp.json"
test -f "$REPO_ROOT/plugins/openviking-memory/.mcp.json"
test ! -f "$REPO_ROOT/plugins/openviking-memory-no-mcp/.mcp.json"
test -f "$REPO_ROOT/plugins/openviking-memory/hooks/hooks.json"
test -f "$REPO_ROOT/plugins/openviking-memory-no-mcp/hooks/hooks.json"
test -f "$REPO_ROOT/scripts/render-openviking-plugin-cache.sh"

jq -e '.mcpServers.codegraph.command == "bash"' \
  "$REPO_ROOT/plugins/codegraph/.mcp.json" >/dev/null

jq -e '.mcpServers.codegraph.args[0] == "-lc"' \
  "$REPO_ROOT/plugins/codegraph/.mcp.json" >/dev/null

jq -e '.mcpServers.codegraph.args[1] | contains("codegraph-mcp.sh")' \
  "$REPO_ROOT/plugins/codegraph/.mcp.json" >/dev/null

jq -e '.mcpServers["openviking-memory"].url == "__OPENVIKING_MCP_URL__"' \
  "$REPO_ROOT/plugins/openviking-memory/.mcp.json" >/dev/null

echo "Marketplace metadata and plugin manifests validated."
