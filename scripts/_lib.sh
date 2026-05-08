#!/usr/bin/env bash
# Shared helpers for sync.sh / diff.sh.
# Source this file; it provides:
#   resolve_profile <project-basename> <manifest-path>
#       echoes the profile name (or empty if not in manifest)
#   stage_template <src-dir> <stage-dir> <target-path> <target-name>
#       copies templates into stage-dir, then optionally overlays
#       overrides/<target-name>/ on top, then substitutes
#       {{PROJECT_PATH}} / {{PROJECT_NAME}} in whitelisted files.

# Whitelisted extensions for token substitution.
DEVENV_SUBST_EXTENSIONS=(toml json md py sh yaml yml)

resolve_profile() {
  local name="$1" manifest="$2"
  [[ -f "$manifest" ]] || return 0
  awk -v name="$name" '
    /^projects:/ {in_p=1; next}
    in_p && /^[^[:space:]]/ {in_p=0}
    in_p && $1 == name":" {
      sub(/^[^:]+:[[:space:]]*/, "")   # drop "key: "
      sub(/[[:space:]]*#.*$/, "")      # drop trailing comment
      gsub(/["'\''[:space:]]/, "")     # strip quotes/spaces
      print; exit
    }
  ' "$manifest"
}

# Lay down the base profile, then optionally overlay project-specific overrides.
# DEVENV_OVERRIDES_DIR (optional, exported by caller) controls overlay lookup.
stage_template() {
  local src="$1" stage="$2" target_path="$3" target_name="$4"
  cp -a "$src/." "$stage/"

  # Overlay overrides/<target-name>/ on top, if present.
  if [[ -n "${DEVENV_OVERRIDES_DIR:-}" && -d "${DEVENV_OVERRIDES_DIR}/${target_name}" ]]; then
    cp -a "${DEVENV_OVERRIDES_DIR}/${target_name}/." "$stage/"
  fi

  # Build find expression for whitelisted extensions.
  local find_args=(-type f \()
  local first=1 ext
  for ext in "${DEVENV_SUBST_EXTENSIONS[@]}"; do
    if [[ $first -eq 1 ]]; then first=0; else find_args+=(-o); fi
    find_args+=(-name "*.${ext}")
  done
  find_args+=(\))

  while IFS= read -r -d '' f; do
    sed -i "s|{{PROJECT_PATH}}|$target_path|g; s|{{PROJECT_NAME}}|$target_name|g" "$f"
  done < <(find "$stage" "${find_args[@]}" -print0)
}
