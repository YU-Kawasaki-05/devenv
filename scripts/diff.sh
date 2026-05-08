#!/usr/bin/env bash
# devenv diff — show diff between profile template (with tokens substituted)
# and a target project.
#
# Usage:
#   scripts/diff.sh <project-path> [--profile <name>] [--names-only]

set -euo pipefail

DEVENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$DEVENV_ROOT/templates"
MANIFEST="$DEVENV_ROOT/manifest.yml"
export DEVENV_OVERRIDES_DIR="$DEVENV_ROOT/overrides"
# shellcheck source=_lib.sh
source "$DEVENV_ROOT/scripts/_lib.sh"

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

[[ -z "$PROFILE" ]] && PROFILE="$(resolve_profile "$TARGET_NAME" "$MANIFEST")"
[[ -z "$PROFILE" ]] && { echo "no profile resolved for '$TARGET_NAME'" >&2; exit 1; }

SRC_DIR="$TEMPLATES_DIR/$PROFILE"
[[ -d "$SRC_DIR" ]] || { echo "profile not found: $SRC_DIR" >&2; exit 1; }

STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT
stage_template "$SRC_DIR" "$STAGE_DIR" "$TARGET" "$TARGET_NAME"

shopt -s dotglob nullglob
for entry in "$STAGE_DIR"/*; do
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
