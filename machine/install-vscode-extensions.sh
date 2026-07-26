#!/usr/bin/env bash
# vscode-extensions.txt の拡張機能を一括インストール (冪等)
set -uo pipefail

MACHINE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIST="$MACHINE/vscode-extensions.txt"

if ! command -v code >/dev/null 2>&1; then
  cat >&2 <<'EOF'
code コマンドが見つかりません。VS Code を起動して:
  Command+Shift+P → "Shell Command: Install 'code' command in PATH" を実行
してから再度このスクリプトを走らせてください。
EOF
  exit 1
fi

installed="$(code --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"

while read -r ext; do
  ext="${ext%%#*}"                      # 行内コメントを除去
  ext="$(echo "$ext" | tr -d '[:space:]')"
  [ -z "$ext" ] && continue
  if echo "$installed" | grep -qx "$(echo "$ext" | tr '[:upper:]' '[:lower:]')"; then
    echo "skip (already): $ext"
  else
    echo "install: $ext"
    code --install-extension "$ext" --force >/dev/null 2>&1 \
      || echo "!! FAILED: $ext"
  fi
done < "$LIST"

echo ""
echo "完了。VS Code を再起動すると全て有効になります。"
