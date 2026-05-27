#!/usr/bin/env bash
set -euo pipefail

json=false
if [[ "${1:-}" == "--json" ]]; then
  json=true
  shift
fi

if [[ $# -ne 0 ]]; then
  echo "Unexpected argument: $1" >&2
  exit 2
fi

command_name="rtk"
missing_message="rtk host runtime not found on PATH."
install_hint="Install rtk before relying on this plugin's command wrapper."

resolved_path="$(command -v "$command_name" 2>/dev/null || true)"

if [[ -z "$resolved_path" ]]; then
  if $json; then
    printf '{"ok":false,"name":"%s","command":"%s","reason":"missing_command","message":"%s","installHint":"%s"}\n' \
      "$command_name" "$command_name" "$missing_message" "$install_hint"
  else
    printf '%s\n%s\n' "$missing_message" "$install_hint" >&2
  fi
  exit 2
fi

if ! version_output="$("$resolved_path" --version 2>&1)"; then
  if $json; then
    escaped_output="$(printf '%s' "$version_output" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
    printf '{"ok":false,"name":"%s","command":"%s","path":"%s","reason":"version_check_failed","message":"Version command failed.","output":%s}\n' \
      "$command_name" "$command_name" "$resolved_path" "$escaped_output"
  else
    printf 'Version check failed for %s at %s.\n%s\n' "$command_name" "$resolved_path" "$version_output" >&2
  fi
  exit 2
fi

if $json; then
  escaped_output="$(printf '%s' "$version_output" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')"
  printf '{"ok":true,"name":"%s","command":"%s","path":"%s","versionOutput":%s}\n' \
    "$command_name" "$command_name" "$resolved_path" "$escaped_output"
else
  printf '%s\n' "$resolved_path"
fi
