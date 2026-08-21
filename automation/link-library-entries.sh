#!/usr/bin/env bash
set -euo pipefail

CLIENT_DIR="${1:-}"
LAYER_DIR="${SKILL_LAYER_DIR:-$HOME/.local/share/assistant-skills}"
RECORD_FILE_NAME=".skill-library-links"

if [[ -z "$CLIENT_DIR" ]]; then
  echo "Usage: $0 <client-skills-directory>" >&2
  exit 2
fi

if [[ ! -d "$LAYER_DIR" ]]; then
  echo "Skill layer does not exist: $LAYER_DIR" >&2
  exit 1
fi

mkdir -p "$CLIENT_DIR"
RECORD_FILE="$CLIENT_DIR/$RECORD_FILE_NAME"

declare -a now=()

contains() {
  local candidate="$1"
  shift || true
  local item
  for item in "$@"; do
    [[ "$item" == "$candidate" ]] && return 0
  done
  return 1
}

linked=0
kept=0
removed=0
skipped=0

while IFS= read -r source; do
  entry="$(basename "$source")"
  [[ "$entry" == .* ]] && continue
  destination="$CLIENT_DIR/$entry"
  resolved="$source"
  [[ -L "$source" ]] && resolved="$(readlink "$source")"
  now+=("$entry")

  if [[ -L "$destination" ]] && [[ "$(readlink "$destination")" == "$resolved" ]]; then
    kept=$((kept + 1))
    continue
  fi

  if [[ -e "$destination" ]] || [[ -L "$destination" ]]; then
    if [[ ! -L "$destination" ]]; then
      skipped=$((skipped + 1))
      continue
    fi
    rm "$destination"
  fi

  ln -s "$resolved" "$destination"
  linked=$((linked + 1))
done < <(find "$LAYER_DIR" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) | LC_ALL=C sort)

if [[ -f "$RECORD_FILE" ]]; then
  while IFS= read -r entry; do
    [[ -n "$entry" ]] || continue
    contains "$entry" "${now[@]}" && continue
    destination="$CLIENT_DIR/$entry"
    if [[ -L "$destination" ]]; then
      rm "$destination"
      removed=$((removed + 1))
    fi
  done < "$RECORD_FILE"
fi

tmp_record="$(mktemp "${TMPDIR:-/tmp}/skill-client.XXXXXX")"
if [[ ${#now[@]} -gt 0 ]]; then
  printf '%s\n' "${now[@]}" | LC_ALL=C sort -u > "$tmp_record"
else
  : > "$tmp_record"
fi
mv "$tmp_record" "$RECORD_FILE"

echo "Client ready: $((linked + kept)) entries ($linked linked, $removed removed, $skipped preserved)"
