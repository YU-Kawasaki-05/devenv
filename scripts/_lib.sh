#!/usr/bin/env bash
# Shared helpers for sync.sh / diff.sh.
# Source this file; it provides:
#   resolve_profile <project-basename> <manifest-path>  → echoes profile name
#   stage_template <src-dir> <stage-dir> <target-path> <target-name>
#     → copies templates into stage-dir and substitutes {{PROJECT_PATH}} /
#       {{PROJECT_NAME}} in whitelisted file extensions.

# Whitelisted extensions for token substitution.
DEVENV_SUBST_EXTENSIONS=(toml json md py sh yaml yml)

resolve_profile() {
  local name="$1" manifest="$2"
  [[ -f "$manifest" ]] || return 0
  awk -v name="$name" '
    /^projects:/ {in_p=1; next}
    in_p && /^[^[:space:]]/ {in_p=0}
    in_p && $1 == name":" {sub(/^[^:]+:[[:space:]]*/, ""); gsub(/["'\''[:space:]]/, ""); print; exit}
  ' "$manifest"
}

stage_template() {
  local src="$1" stage="$2" target_path="$3" target_name="$4"
  cp -a "$src/." "$stage/"

  local find_args=(-type f \()
  local first=1
  for ext in "${DEVENV_SUBST_EXTENSIONS[@]}"; do
    if [[ $first -eq 1 ]]; then first=0; else find_args+=(-o); fi
    find_args+=(-name "*.${ext}")
  done
  find_args+=(\))

  while IFS= read -r -d '' f; do
    sed -i "s|{{PROJECT_PATH}}|$target_path|g; s|{{PROJECT_NAME}}|$target_name|g" "$f"
  done < <(find "$stage" "${find_args[@]}" -print0)
}
