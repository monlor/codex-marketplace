#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <target-project> [caveman|rtk|codegraph ...]" >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_PROJECT="$(cd "$1" && pwd)"
shift || true

CODEX_HOME_DIR="$TARGET_PROJECT/.codex-home"
CONFIG_PATH="$CODEX_HOME_DIR/config.toml"
TEMPLATE_PATH="$REPO_ROOT/config/ai/codex/config.toml"
MARKETPLACE_NAME="monlor-marketplace"

if [ "$#" -eq 0 ]; then
  set -- caveman rtk codegraph
fi

mkdir -p "$CODEX_HOME_DIR"

if [ ! -f "$CONFIG_PATH" ]; then
  cp "$TEMPLATE_PATH" "$CONFIG_PATH"
fi

CODEX_HOME="$CODEX_HOME_DIR" codex plugin marketplace add "$REPO_ROOT" >/dev/null

for plugin in "$@"; do
  case "$plugin" in
    caveman|rtk|codegraph|openviking-memory|openviking-memory-no-mcp)
      CODEX_HOME="$CODEX_HOME_DIR" codex plugin add "$plugin@$MARKETPLACE_NAME" >/dev/null
      case "$plugin" in
        openviking-memory|openviking-memory-no-mcp)
          "$SCRIPT_DIR/render-openviking-plugin-cache.sh" "$CODEX_HOME_DIR" "$plugin" >/dev/null
          ;;
      esac
      ;;
    *)
      echo "unknown plugin: $plugin" >&2
      exit 1
      ;;
  esac
done

echo "Project-scoped Codex home prepared at $CODEX_HOME_DIR"
echo "Run with: CODEX_HOME=$CODEX_HOME_DIR codex"
