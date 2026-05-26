#!/usr/bin/env bash
set -euo pipefail

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

ensure_plugin_hooks_enabled() {
  local codex_home="$1"
  local config_path="$codex_home/config.toml"

  mkdir -p "$codex_home"
  touch "$config_path"

  if ! grep -Eq '^[[:space:]]*plugin_hooks[[:space:]]*=' "$config_path"; then
    printf '\nplugin_hooks = true\n' >>"$config_path"
  fi
}

TEST_HOME="$TMP_DIR/home"
mkdir -p "$TEST_HOME"

ensure_plugin_hooks_enabled "$TEST_HOME/.codex"
HOME="$TEST_HOME" codex plugin marketplace add "$REPO_ROOT" >/dev/null
HOME="$TEST_HOME" codex plugin add caveman@monlor-marketplace >/dev/null
HOME="$TEST_HOME" codex plugin add rtk@monlor-marketplace >/dev/null
HOME="$TEST_HOME" codex plugin add codegraph@monlor-marketplace >/dev/null

HOME="$TEST_HOME" codex plugin marketplace list | grep -q 'monlor-marketplace'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'caveman'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'rtk'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'codegraph'

grep -q '\[plugins."caveman@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"
grep -q '\[plugins."rtk@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"
grep -q '\[plugins."codegraph@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"
grep -Eq '^[[:space:]]*plugin_hooks[[:space:]]*=[[:space:]]*true' "$TEST_HOME/.codex/config.toml"

OV_HOME="$TMP_DIR/openviking-home"
mkdir -p "$OV_HOME"

ensure_plugin_hooks_enabled "$OV_HOME/.codex"
HOME="$OV_HOME" codex plugin marketplace add "$REPO_ROOT" >/dev/null
HOME="$OV_HOME" codex plugin add openviking-memory@monlor-marketplace >/dev/null
HOME="$OV_HOME" codex plugin add openviking-memory-no-mcp@monlor-marketplace >/dev/null

HOME="$OV_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory'
HOME="$OV_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory-no-mcp'

grep -q '\[plugins."openviking-memory@monlor-marketplace"\]' "$OV_HOME/.codex/config.toml"
grep -q '\[plugins."openviking-memory-no-mcp@monlor-marketplace"\]' "$OV_HOME/.codex/config.toml"
grep -Eq '^[[:space:]]*plugin_hooks[[:space:]]*=[[:space:]]*true' "$OV_HOME/.codex/config.toml"

OV_CACHE_ROOT="$OV_HOME/.codex/plugins/cache/monlor-marketplace"
OV_PLUGIN_ROOT="$(find "$OV_CACHE_ROOT/openviking-memory" -path '*/.codex-plugin/plugin.json' -print -quit | xargs dirname | xargs dirname)"
OV_NO_MCP_PLUGIN_ROOT="$(find "$OV_CACHE_ROOT/openviking-memory-no-mcp" -path '*/.codex-plugin/plugin.json' -print -quit | xargs dirname | xargs dirname)"

test -n "$OV_PLUGIN_ROOT"
test -n "$OV_NO_MCP_PLUGIN_ROOT"

! rg -n '__OPENVIKING_PLUGIN_ROOT__' "$OV_CACHE_ROOT/openviking-memory" >/dev/null
! rg -n '__OPENVIKING_PLUGIN_ROOT__' "$OV_CACHE_ROOT/openviking-memory-no-mcp" >/dev/null
find "$OV_CACHE_ROOT/openviking-memory" -name hooks.json -exec grep -q 'node ${PLUGIN_ROOT}/scripts/session-start-commit.mjs' {} \;
find "$OV_CACHE_ROOT/openviking-memory-no-mcp" -name hooks.json -exec grep -q 'node ${PLUGIN_ROOT}/scripts/session-start-commit.mjs' {} \;
find "$OV_CACHE_ROOT/openviking-memory" -name .mcp.json -exec grep -q '"url": "http://127.0.0.1:1933/mcp"' {} \;
find "$TEST_HOME/.codex/plugins/cache/monlor-marketplace/codegraph" -name .mcp.json -exec grep -q 'plugins/cache/monlor-marketplace/codegraph' {} \;

SESSION_START_OUTPUT="$(printf '%s\n' '{"source":"startup","session_id":"smoke-session"}' | PLUGIN_ROOT="$OV_PLUGIN_ROOT" node "$OV_PLUGIN_ROOT/scripts/session-start-commit.mjs")"
AUTO_RECALL_OUTPUT="$(printf '%s\n' '{"prompt":"remember project setup"}' | PLUGIN_ROOT="$OV_PLUGIN_ROOT" node "$OV_PLUGIN_ROOT/scripts/auto-recall.mjs")"

printf '%s' "$SESSION_START_OUTPUT" | jq -e '. | type == "object"' >/dev/null
printf '%s' "$AUTO_RECALL_OUTPUT" | jq -e '. | type == "object"' >/dev/null

echo "Direct Codex install flow validated in $TEST_HOME/.codex"
