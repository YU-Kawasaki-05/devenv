#!/usr/bin/env bash
# devenv sync — one-way deploy from templates/<profile>/ to a target project.
#
# Usage:
#   scripts/sync.sh <project-path> [--dry-run] [--profile <name>]
#
# Behavior:
#   - Resolves the profile from manifest.yml unless --profile is given.
#   - Copies template files into the target project, OVERWRITING matching paths.
#   - Does NOT delete files that exist only on the project side (safe-side default).
#   - Does NOT touch files outside the template's path set
#     (e.g. .claude/settings.local.json, source code, docs/, node_modules/).
#   - --dry-run shows rsync's itemize-changes output without writing.

set -euo pipefail

DEVENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$DEVENV_ROOT/templates"
MANIFEST="$DEVENV_ROOT/manifest.yml"

usage() {
  sed -n '2,15p' "$0"
  exit 1
}

DRY_RUN=0
PROFILE=""
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --profile) PROFILE="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) echo "unknown flag: $1" >&2; exit 2 ;;
    *)
      if [[ -z "$TARGET" ]]; then TARGET="$1"; else echo "extra arg: $1" >&2; exit 2; fi
      shift ;;
  esac
done

[[ -z "$TARGET" ]] && usage

if [[ ! -d "$TARGET" ]]; then
  echo "target not found: $TARGET" >&2
  exit 1
fi
TARGET="$(cd "$TARGET" && pwd)"
TARGET_NAME="$(basename "$TARGET")"

# Resolve profile from manifest.yml when not given.
# manifest.yml format (no external yaml parser required):
#   projects:
#     <name>: <profile>
if [[ -z "$PROFILE" ]]; then
  if [[ -f "$MANIFEST" ]]; then
    PROFILE="$(awk -v name="$TARGET_NAME" '
      /^projects:/ {in_p=1; next}
      in_p && /^[^[:space:]]/ {in_p=0}
      in_p && $1 == name":" {sub(/^[^:]+:[[:space:]]*/, ""); gsub(/["'\''[:space:]]/, ""); print; exit}
    ' "$MANIFEST")"
  fi
fi

if [[ -z "$PROFILE" ]]; then
  echo "no profile resolved for '$TARGET_NAME'. pass --profile <name> or add to manifest.yml" >&2
  exit 1
fi

SRC_DIR="$TEMPLATES_DIR/$PROFILE"
if [[ ! -d "$SRC_DIR" ]]; then
  echo "profile not found: $SRC_DIR" >&2
  exit 1
fi

echo "==> sync"
echo "    profile : $PROFILE"
echo "    source  : $SRC_DIR"
echo "    target  : $TARGET"
echo "    dry-run : $DRY_RUN"
echo

# Use rsync per top-level entry in template, so we only touch managed paths.
# This avoids deleting unrelated project files even with future --delete.
RSYNC_OPTS=(-a --itemize-changes)
[[ $DRY_RUN -eq 1 ]] && RSYNC_OPTS+=(-n)

shopt -s dotglob nullglob
ANY_CHANGE=0
for entry in "$SRC_DIR"/*; do
  rel="$(basename "$entry")"
  if [[ -d "$entry" ]]; then
    out="$(rsync "${RSYNC_OPTS[@]}" "$entry/" "$TARGET/$rel/")"
  else
    out="$(rsync "${RSYNC_OPTS[@]}" "$entry" "$TARGET/$rel")"
  fi
  if [[ -n "$out" ]]; then
    ANY_CHANGE=1
    echo "[$rel]"
    echo "$out"
    echo
  fi
done

if [[ $ANY_CHANGE -eq 0 ]]; then
  echo "no changes — target already matches profile."
fi

if [[ $DRY_RUN -eq 1 ]]; then
  echo
  echo "(dry-run: nothing was written)"
fi
