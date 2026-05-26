#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <codex-home> <openviking-memory|openviking-memory-no-mcp>" >&2
  exit 1
fi

CODEX_HOME="$(cd "$1" && pwd)"
PLUGIN_NAME="$2"
MARKETPLACE_NAME="monlor-marketplace"
OVCLI_CONF="${OPENVIKING_CLI_CONFIG_FILE:-$HOME/.openviking/ovcli.conf}"
DEFAULT_MCP_URL="http://127.0.0.1:1933/mcp"

case "$PLUGIN_NAME" in
  openviking-memory|openviking-memory-no-mcp)
    ;;
  *)
    echo "unsupported plugin: $PLUGIN_NAME" >&2
    exit 1
    ;;
esac

resolve_mcp_url() {
  if [ -n "${OPENVIKING_MCP_URL:-}" ]; then
    printf '%s' "$OPENVIKING_MCP_URL"
    return
  fi
  if [ -n "${OPENVIKING_URL:-}" ]; then
    printf '%s/mcp' "${OPENVIKING_URL%/}"
    return
  fi
  if [ -f "$OVCLI_CONF" ] && command -v node >/dev/null 2>&1; then
    local from_conf
    from_conf="$(node -e '
      try {
        const c = JSON.parse(require("node:fs").readFileSync(process.argv[1], "utf8"));
        if (typeof c.url === "string" && c.url) {
          process.stdout.write(c.url.replace(/\/+$/, "") + "/mcp");
        }
      } catch {}
    ' "$OVCLI_CONF" 2>/dev/null || true)"
    if [ -n "$from_conf" ]; then
      printf '%s' "$from_conf"
      return
    fi
  fi
  printf '%s' "$DEFAULT_MCP_URL"
}

detect_api_key() {
  if [ -n "${OPENVIKING_API_KEY:-}" ] || [ -n "${OPENVIKING_BEARER_TOKEN:-}" ]; then
    echo "1"
    return
  fi
  if [ -f "$OVCLI_CONF" ] && command -v node >/dev/null 2>&1; then
    node -e '
      try {
        const c = JSON.parse(require("node:fs").readFileSync(process.argv[1], "utf8"));
        process.stdout.write(c.api_key ? "1" : "0");
      } catch { process.stdout.write("0"); }
    ' "$OVCLI_CONF" 2>/dev/null || echo "0"
    return
  fi
  echo "0"
}

CACHE_ROOT="$CODEX_HOME/plugins/cache/$MARKETPLACE_NAME/$PLUGIN_NAME"
if [ ! -d "$CACHE_ROOT" ]; then
  echo "plugin cache not found: $CACHE_ROOT" >&2
  exit 1
fi

MCP_URL="$(resolve_mcp_url)"
HAS_API_KEY="$(detect_api_key)"
UPDATED=0

for CACHE_DIR in "$CACHE_ROOT"/*; do
  [ -d "$CACHE_DIR" ] || continue

  HOOKS_JSON="$CACHE_DIR/hooks/hooks.json"
  if [ -f "$HOOKS_JSON" ]; then
    CACHE_ESC="$(printf '%s' "$CACHE_DIR" | sed -e 's/[\\/&]/\\&/g')"
    sed -i.bak -e "s/__OPENVIKING_PLUGIN_ROOT__/$CACHE_ESC/g" "$HOOKS_JSON"
    rm -f "${HOOKS_JSON}.bak"
    UPDATED=1
  fi

  MCP_JSON="$CACHE_DIR/.mcp.json"
  if [ -f "$MCP_JSON" ]; then
    node -e '
      const fs = require("node:fs");
      const file = process.argv[1];
      const url = process.argv[2];
      const hasKey = process.argv[3];
      const json = JSON.parse(fs.readFileSync(file, "utf8"));
      const server = json.mcpServers && json.mcpServers["openviking-memory"];
      if (!server) process.exit(0);
      server.url = url;
      if (hasKey === "1") {
        server.bearer_token_env_var = "OPENVIKING_API_KEY";
      } else {
        delete server.bearer_token_env_var;
      }
      fs.writeFileSync(file, JSON.stringify(json, null, 2) + "\n");
    ' "$MCP_JSON" "$MCP_URL" "$HAS_API_KEY"
    UPDATED=1
  fi
done

if [ "$UPDATED" -eq 0 ]; then
  echo "nothing rendered for $PLUGIN_NAME under $CACHE_ROOT" >&2
  exit 1
fi

echo "Rendered cached plugin copy for $PLUGIN_NAME in $CODEX_HOME"
