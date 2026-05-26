#!/usr/bin/env bash
set -euo pipefail

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found on PATH." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MARKETPLACE_NAME="monlor-marketplace"
REMOTE_URL="${CODEX_MARKETPLACE_REMOTE:-$(git -C "$REPO_ROOT" remote get-url origin)}"

if [ "$#" -eq 0 ]; then
  set -- caveman rtk codegraph
fi

codex plugin marketplace add "$REMOTE_URL" >/dev/null

for plugin in "$@"; do
  case "$plugin" in
    caveman|rtk|codegraph|openviking-memory|openviking-memory-no-mcp)
      codex plugin add "$plugin@$MARKETPLACE_NAME" >/dev/null
      case "$plugin" in
        openviking-memory|openviking-memory-no-mcp)
          "$SCRIPT_DIR/render-openviking-plugin-cache.sh" "${HOME}/.codex" "$plugin" >/dev/null
          ;;
      esac
      ;;
    *)
      echo "unknown plugin: $plugin" >&2
      exit 1
      ;;
  esac
done

echo "Marketplace installed from $REMOTE_URL"
echo "Plugins ready in ~/.codex"
