#!/usr/bin/env bash
# devenv diff — show diff between profile template and a target project.
#
# Usage:
#   scripts/diff.sh <project-path> [--profile <name>] [--names-only]

set -euo pipefail

DEVENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$DEVENV_ROOT/templates"
MANIFEST="$DEVENV_ROOT/manifest.yml"

NAMES_ONLY=0
PROFILE=""
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --names-only) NAMES_ONLY=1; shift ;;
    --profile) PROFILE="$2"; shift 2 ;;
    -*) echo "unknown flag: $1" >&2; exit 2 ;;
    *) TARGET="$1"; shift ;;
  esac
done

[[ -z "$TARGET" ]] && { echo "usage: scripts/diff.sh <project-path> [--profile <name>] [--names-only]" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
TARGET_NAME="$(basename "$TARGET")"

if [[ -z "$PROFILE" && -f "$MANIFEST" ]]; then
  PROFILE="$(awk -v name="$TARGET_NAME" '
    /^projects:/ {in_p=1; next}
    in_p && /^[^[:space:]]/ {in_p=0}
    in_p && $1 == name":" {sub(/^[^:]+:[[:space:]]*/, ""); gsub(/["'\''[:space:]]/, ""); print; exit}
  ' "$MANIFEST")"
fi
[[ -z "$PROFILE" ]] && { echo "no profile resolved for '$TARGET_NAME'" >&2; exit 1; }

SRC_DIR="$TEMPLATES_DIR/$PROFILE"
[[ -d "$SRC_DIR" ]] || { echo "profile not found: $SRC_DIR" >&2; exit 1; }

shopt -s dotglob nullglob
for entry in "$SRC_DIR"/*; do
  rel="$(basename "$entry")"
  src="$entry"
  dst="$TARGET/$rel"

  if [[ ! -e "$dst" ]]; then
    echo "MISSING in project: $rel"
    continue
  fi

  if [[ $NAMES_ONLY -eq 1 ]]; then
    diff -rq "$src" "$dst" 2>&1 | sed "s|$src|template/$rel|g; s|$dst|project/$rel|g"
  else
    diff -ruN "$src" "$dst" 2>&1 | sed "s|$src|template/$rel|g; s|$dst|project/$rel|g"
  fi
done
