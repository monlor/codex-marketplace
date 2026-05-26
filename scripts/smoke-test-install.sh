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

PROJECT_DIR="$TMP_DIR/sample-project"
mkdir -p "$PROJECT_DIR"

"$SCRIPT_DIR/bootstrap-project-home.sh" "$PROJECT_DIR" caveman rtk codegraph >/dev/null

CODEX_HOME="$PROJECT_DIR/.codex-home" codex plugin marketplace list | grep -q 'monlor-marketplace'
CODEX_HOME="$PROJECT_DIR/.codex-home" codex plugin list --marketplace monlor-marketplace | grep -q 'caveman'
CODEX_HOME="$PROJECT_DIR/.codex-home" codex plugin list --marketplace monlor-marketplace | grep -q 'rtk'
CODEX_HOME="$PROJECT_DIR/.codex-home" codex plugin list --marketplace monlor-marketplace | grep -q 'codegraph'

grep -q '\[plugins."caveman@monlor-marketplace"\]' "$PROJECT_DIR/.codex-home/config.toml"
grep -q '\[plugins."rtk@monlor-marketplace"\]' "$PROJECT_DIR/.codex-home/config.toml"
grep -q '\[plugins."codegraph@monlor-marketplace"\]' "$PROJECT_DIR/.codex-home/config.toml"

OV_PROJECT_DIR="$TMP_DIR/openviking-project"
mkdir -p "$OV_PROJECT_DIR"

"$SCRIPT_DIR/bootstrap-project-home.sh" "$OV_PROJECT_DIR" openviking-memory openviking-memory-no-mcp >/dev/null

CODEX_HOME="$OV_PROJECT_DIR/.codex-home" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory'
CODEX_HOME="$OV_PROJECT_DIR/.codex-home" codex plugin list --marketplace monlor-marketplace | grep -q 'openviking-memory-no-mcp'

grep -q '\[plugins."openviking-memory@monlor-marketplace"\]' "$OV_PROJECT_DIR/.codex-home/config.toml"
grep -q '\[plugins."openviking-memory-no-mcp@monlor-marketplace"\]' "$OV_PROJECT_DIR/.codex-home/config.toml"

OV_CACHE_ROOT="$OV_PROJECT_DIR/.codex-home/plugins/cache/monlor-marketplace"
find "$OV_CACHE_ROOT/openviking-memory" -name hooks.json -exec grep -qv '__OPENVIKING_PLUGIN_ROOT__' {} \;
find "$OV_CACHE_ROOT/openviking-memory-no-mcp" -name hooks.json -exec grep -qv '__OPENVIKING_PLUGIN_ROOT__' {} \;
find "$OV_CACHE_ROOT/openviking-memory" -name .mcp.json -exec grep -q '"url": "http://127.0.0.1:1933/mcp"' {} \;

echo "Project-scoped install flow validated in $PROJECT_DIR"
