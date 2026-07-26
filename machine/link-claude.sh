#!/usr/bin/env bash
# ~/.claude / ~/.agents を devenv 正本への symlink に切り替える (WSL / Mac 共通・冪等)
set -euo pipefail

MACHINE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_SRC="$MACHINE/claude"

backup_and_link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup: $dst -> $dst.bak.*"
  fi
  ln -sfn "$src" "$dst"
  echo "link: $dst -> $src"
}

mkdir -p ~/.claude ~/.agents

backup_and_link "$CLAUDE_SRC/skills"    ~/.claude/skills
backup_and_link "$CLAUDE_SRC/commands"  ~/.claude/commands
backup_and_link "$CLAUDE_SRC/CLAUDE.md" ~/.claude/CLAUDE.md

# Codex / 他エージェントからも同じ skills を参照
backup_and_link "$CLAUDE_SRC/skills" ~/.agents/skills

# settings.json は環境依存の追記 (permissions 等) が起こるため symlink せず初期化のみ
if [ ! -f ~/.claude/settings.json ]; then
  cp "$CLAUDE_SRC/settings.template.json" ~/.claude/settings.json
  echo "init: ~/.claude/settings.json (from template)"
fi
