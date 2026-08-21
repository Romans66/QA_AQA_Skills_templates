#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATALOG_DIR="${SKILL_CATALOG_DIR:-$PROJECT_DIR/catalog}"
LAYER_DIR="${SKILL_LAYER_DIR:-$HOME/.local/share/assistant-skills}"
INDEX_FILE="$LAYER_DIR/.catalog-index"

mkdir -p "$LAYER_DIR"

declare -a current=()

is_current() {
  local candidate="$1"
  local entry
  for entry in "${current[@]}"; do
    [[ "$entry" == "$candidate" ]] && return 0
  done
  return 1
}

created=0
kept=0
removed=0

while IFS= read -r manifest; do
  source_dir="$(dirname "$manifest")"
  entry="$(basename "$source_dir")"
  destination="$LAYER_DIR/$entry"
  current+=("$entry")

  if [[ -L "$destination" ]] && [[ "$(readlink "$destination")" == "$source_dir" ]]; then
    kept=$((kept + 1))
    continue
  fi

  if [[ -e "$destination" ]] || [[ -L "$destination" ]]; then
    if [[ ! -L "$destination" ]]; then
      echo "SKIP  $entry (destination is not a link)"
      continue
    fi
    rm "$destination"
  fi

  ln -s "$source_dir" "$destination"
  echo "LINK  $entry"
  created=$((created + 1))
done < <(find "$CATALOG_DIR" -type f -name SKILL.md | LC_ALL=C sort)

if [[ -f "$INDEX_FILE" ]]; then
  while IFS= read -r entry; do
    [[ -n "$entry" ]] || continue
    is_current "$entry" && continue
    destination="$LAYER_DIR/$entry"
    if [[ -L "$destination" ]]; then
      rm "$destination"
      echo "DROP  $entry"
      removed=$((removed + 1))
    fi
  done < "$INDEX_FILE"
fi

tmp_index="$(mktemp "${TMPDIR:-/tmp}/skill-catalog.XXXXXX")"
if [[ ${#current[@]} -gt 0 ]]; then
  printf '%s\n' "${current[@]}" | LC_ALL=C sort -u > "$tmp_index"
else
  : > "$tmp_index"
fi
mv "$tmp_index" "$INDEX_FILE"

echo "Library ready: $((created + kept)) entries ($created linked, $removed removed)"
