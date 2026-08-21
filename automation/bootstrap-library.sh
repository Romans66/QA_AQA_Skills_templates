#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AUTOMATION_DIR="$PROJECT_DIR/automation"
LAYER_DIR="${SKILL_LAYER_DIR:-$HOME/.local/share/assistant-skills}"
REGISTRY_FILE="${SKILL_CLIENT_REGISTRY:-$PROJECT_DIR/settings/clients.list}"
HOOK_PATH="$PROJECT_DIR/.git/hooks/post-merge"
BLOCK_START="# skill-library:begin"
BLOCK_END="# skill-library:end"

echo "Preparing skill library"
echo "Catalog: $PROJECT_DIR/catalog"
echo "Layer:   $LAYER_DIR"

SKILL_LAYER_DIR="$LAYER_DIR" bash "$AUTOMATION_DIR/rebuild-library-links.sh"

connected=0

attach_client() {
  local label="$1"
  local destination="$2"
  local strategy="${3:-auto}"
  local parent
  parent="$(dirname "$destination")"

  if [[ ! -d "$parent" ]] && [[ ! -d "$(dirname "$parent")" ]]; then
    return
  fi

  if [[ -L "$destination" ]]; then
    if [[ "$(readlink "$destination")" == "$LAYER_DIR" ]]; then
      echo "READY $label"
      connected=$((connected + 1))
    else
      echo "SKIP  $label (another link exists)"
    fi
    return
  fi

  if [[ -e "$destination" ]] && [[ ! -d "$destination" ]]; then
    echo "SKIP  $label (a file exists at destination)"
    return
  fi

  if [[ "$strategy" == "merge" ]] || { [[ "$strategy" == "auto" ]] && [[ -d "$destination" ]]; }; then
    mkdir -p "$destination"
    SKILL_LAYER_DIR="$LAYER_DIR" bash "$AUTOMATION_DIR/link-library-entries.sh" "$destination" >/dev/null
    echo "READY $label (entries linked)"
  else
    mkdir -p "$parent"
    ln -s "$LAYER_DIR" "$destination"
    echo "READY $label (layer linked)"
  fi
  connected=$((connected + 1))
}

if [[ -f "$REGISTRY_FILE" ]]; then
  while read -r label relative_path strategy; do
    [[ -z "${label:-}" ]] && continue
    [[ "$label" == \#* ]] && continue
    attach_client "$label" "$HOME/$relative_path" "${strategy:-auto}"
  done < "$REGISTRY_FILE"
fi

install_refresh_hook() {
  local hook="$1"
  local filtered
  filtered="$(mktemp "${TMPDIR:-/tmp}/skill-hook.XXXXXX")"
  local inside=false
  local legacy_lines=0

  if [[ -f "$hook" ]]; then
    while IFS= read -r line; do
      if [[ "$line" == "$BLOCK_START" ]]; then
        inside=true
        continue
      fi
      if [[ "$line" == "$BLOCK_END" ]]; then
        inside=false
        continue
      fi
      [[ "$inside" == true ]] && continue
      if [[ "$line" == "# ai-skills-sync" ]]; then
        legacy_lines=2
        continue
      fi
      if [[ "$legacy_lines" -gt 0 ]]; then
        legacy_lines=$((legacy_lines - 1))
        continue
      fi
      printf '%s\n' "$line" >> "$filtered"
    done < "$hook"
  fi

  {
    printf '\n%s\n' "$BLOCK_START"
    printf 'bash %q 2>/dev/null || true\n' "$AUTOMATION_DIR/rebuild-library-links.sh"
    printf 'bash %q 2>/dev/null || true\n' "$AUTOMATION_DIR/update-client-directories.sh"
    printf '%s\n' "$BLOCK_END"
  } >> "$filtered"

  mv "$filtered" "$hook"
  chmod +x "$hook"
}

if [[ -d "$PROJECT_DIR/.git" ]]; then
  mkdir -p "$(dirname "$HOOK_PATH")"
  install_refresh_hook "$HOOK_PATH"
  echo "Hook:    installed"
else
  echo "Hook:    skipped (no .git directory)"
fi

echo "Clients: $connected connected"
echo "Done"
