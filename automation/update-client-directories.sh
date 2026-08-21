#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUTOMATION_DIR="$PROJECT_DIR/automation"
REGISTRY_FILE="${SKILL_CLIENT_REGISTRY:-$PROJECT_DIR/settings/clients.list}"
LAYER_DIR="${SKILL_LAYER_DIR:-$HOME/.local/share/assistant-skills}"

[[ -f "$REGISTRY_FILE" ]] || exit 0

while read -r _label relative_path _strategy; do
  [[ -z "${relative_path:-}" ]] && continue
  [[ "${_label:-}" == \#* ]] && continue
  destination="$HOME/$relative_path"

  [[ -L "$destination" ]] && continue
  if [[ -d "$destination" ]] && [[ -f "$destination/.skill-library-links" ]]; then
    SKILL_LAYER_DIR="$LAYER_DIR" bash "$AUTOMATION_DIR/link-library-entries.sh" "$destination" >/dev/null
  fi
done < "$REGISTRY_FILE"
