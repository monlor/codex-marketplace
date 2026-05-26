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

TEST_HOME="$TMP_DIR/home"
mkdir -p "$TEST_HOME"

HOME="$TEST_HOME" "$SCRIPT_DIR/install-marketplace.sh" caveman rtk codegraph >/dev/null

HOME="$TEST_HOME" codex plugin marketplace list | grep -q 'monlor-marketplace'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'caveman'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'rtk'
HOME="$TEST_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'codegraph'

grep -q '\[plugins."caveman@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"
grep -q '\[plugins."rtk@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"
grep -q '\[plugins."codegraph@monlor-marketplace"\]' "$TEST_HOME/.codex/config.toml"

OV_HOME="$TMP_DIR/openviking-home"
mkdir -p "$OV_HOME"

HOME="$OV_HOME" "$SCRIPT_DIR/install-marketplace.sh" openviking-memory openviking-memory-no-mcp >/dev/null

HOME="$OV_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory'
HOME="$OV_HOME" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory-no-mcp'

grep -q '\[plugins."openviking-memory@monlor-marketplace"\]' "$OV_HOME/.codex/config.toml"
grep -q '\[plugins."openviking-memory-no-mcp@monlor-marketplace"\]' "$OV_HOME/.codex/config.toml"

OV_CACHE_ROOT="$OV_HOME/.codex/plugins/cache/monlor-marketplace"
find "$OV_CACHE_ROOT/openviking-memory" -name hooks.json -exec grep -qv '__OPENVIKING_PLUGIN_ROOT__' {} \;
find "$OV_CACHE_ROOT/openviking-memory-no-mcp" -name hooks.json -exec grep -qv '__OPENVIKING_PLUGIN_ROOT__' {} \;
find "$OV_CACHE_ROOT/openviking-memory" -name .mcp.json -exec grep -q '"url": "http://127.0.0.1:1933/mcp"' {} \;

echo "Global install flow validated in $TEST_HOME/.codex"
