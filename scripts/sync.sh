#!/usr/bin/env bash
# devenv sync — one-way deploy from templates/<profile>/ to a target project.
#
# Usage:
#   scripts/sync.sh <project-path> [--dry-run] [--profile <name>]
#
# Behavior:
#   - Resolves profile from manifest.yml unless --profile is given.
#   - Stages templates into a tmp dir, substitutes {{PROJECT_PATH}} /
#     {{PROJECT_NAME}} in whitelisted extensions, then rsync to the target.
#   - Copies (overwrites) matching paths only; unrelated files in the project
#     (e.g. .claude/settings.local.json, source code, docs/) are untouched.
#   - Files that exist only in the project are NOT deleted (safe-side).
#   - --dry-run shows rsync's itemize-changes output without writing.

set -euo pipefail

DEVENV_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$DEVENV_ROOT/templates"
MANIFEST="$DEVENV_ROOT/manifest.yml"
export DEVENV_OVERRIDES_DIR="$DEVENV_ROOT/overrides"
# shellcheck source=_lib.sh
source "$DEVENV_ROOT/scripts/_lib.sh"

usage() { sed -n '2,16p' "$0"; exit 1; }

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
[[ ! -d "$TARGET" ]] && { echo "target not found: $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
TARGET_NAME="$(basename "$TARGET")"

[[ -z "$PROFILE" ]] && PROFILE="$(resolve_profile "$TARGET_NAME" "$MANIFEST")"
[[ -z "$PROFILE" ]] && { echo "no profile resolved for '$TARGET_NAME'. pass --profile <name> or add to manifest.yml" >&2; exit 1; }

SRC_DIR="$TEMPLATES_DIR/$PROFILE"
[[ ! -d "$SRC_DIR" ]] && { echo "profile not found: $SRC_DIR" >&2; exit 1; }

STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT
stage_template "$SRC_DIR" "$STAGE_DIR" "$TARGET" "$TARGET_NAME"

OVERLAY_NOTE="(none)"
[[ -d "$DEVENV_OVERRIDES_DIR/$TARGET_NAME" ]] && OVERLAY_NOTE="$DEVENV_OVERRIDES_DIR/$TARGET_NAME"

echo "==> sync"
echo "    profile  : $PROFILE"
echo "    source   : $SRC_DIR"
echo "    overrides: $OVERLAY_NOTE"
echo "    target   : $TARGET"
echo "    dry-run  : $DRY_RUN"
echo

RSYNC_OPTS=(-a --itemize-changes)
[[ $DRY_RUN -eq 1 ]] && RSYNC_OPTS+=(-n)

shopt -s dotglob nullglob
ANY_CHANGE=0
for entry in "$STAGE_DIR"/*; do
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

[[ $ANY_CHANGE -eq 0 ]] && echo "no changes — target already matches profile."
[[ $DRY_RUN -eq 1 ]] && { echo; echo "(dry-run: nothing was written)"; }
