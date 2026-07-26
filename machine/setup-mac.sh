#!/usr/bin/env bash
# Mac 開発環境セットアップ (冪等: 何度実行しても安全)
# 前提: このリポジトリ (devenv) が ~/develop/devenv に clone 済みであること
set -euo pipefail

MACHINE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> 1/6 Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "==> 2/6 Brewfile"
brew bundle --file="$MACHINE/Brewfile"

echo "==> 3/6 dotfiles"
link_dotfile() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.bak.$(date +%Y%m%d%H%M%S)"
    echo "backup: $dst"
  fi
  ln -sfn "$src" "$dst"
  echo "link: $dst -> $src"
}
link_dotfile "$MACHINE/dotfiles/zshrc"             ~/.zshrc
link_dotfile "$MACHINE/dotfiles/gitconfig"         ~/.gitconfig
link_dotfile "$MACHINE/dotfiles/gitconfig-fouryou" ~/.gitconfig-fouryou

# ssh config は symlink 不可 (パーミッション要件) のためコピー
mkdir -p ~/.ssh && chmod 700 ~/.ssh
if [ ! -f ~/.ssh/config ] || ! cmp -s "$MACHINE/dotfiles/ssh_config" ~/.ssh/config; then
  [ -f ~/.ssh/config ] && cp ~/.ssh/config ~/.ssh/config.bak
  cp "$MACHINE/dotfiles/ssh_config" ~/.ssh/config
  chmod 600 ~/.ssh/config
  echo "copy: ~/.ssh/config"
fi

echo "==> 4/6 mise (Node)"
mise use --global node@22
mise install

echo "==> 5/6 npm globals"
eval "$(mise activate bash)"
npm install -g @anthropic-ai/claude-code decktape

echo "==> 6/6 Claude / agent 設定"
bash "$MACHINE/link-claude.sh"

cat <<'EOF'

✅ セットアップ完了。残りの手動ステップ:
  1. SSH 鍵を ~/.ssh/ に配置 (MIGRATION.md 参照) して:
       chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_fouryou
       ssh-add --apple-use-keychain ~/.ssh/id_ed25519
       ssh-add --apple-use-keychain ~/.ssh/id_ed25519_fouryou
  2. gh auth login (個人 / fouryou の 2 アカウント)
  3. bash machine/clone-repos.sh で全リポジトリを clone
詳細は machine/MIGRATION.md を参照。
EOF
