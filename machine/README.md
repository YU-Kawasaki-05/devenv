# machine/ — マシン環境の正本 (dotfiles + セットアップ)

`~/develop/` プロジェクトへの agent 設定配布 (templates/) に加えて、
**マシン自体の開発環境** (シェル・git・SSH 設定・Claude Code のユーザーレベル設定) をここで管理する。

```
machine/
├── Brewfile           # Mac: Homebrew 一括インストール定義
├── setup-mac.sh       # Mac: 環境セットアップ (冪等)
├── link-claude.sh     # WSL/Mac 共通: ~/.claude, ~/.agents を devenv 正本へ symlink
├── clone-repos.sh     # 全リポジトリ clone (冪等)
├── vscode-extensions.txt        # VS Code 拡張機能リスト (23 個)
├── install-vscode-extensions.sh # 上記を一括インストール (冪等)
├── MIGRATION.md       # WSL → Mac 移行手順書
├── dotfiles/
│   ├── zshrc              # → ~/.zshrc (Mac)
│   ├── gitconfig          # → ~/.gitconfig (2 identity, includeIf)
│   ├── gitconfig-fouryou  # → ~/.gitconfig-fouryou
│   └── ssh_config         # → ~/.ssh/config (コピー配布)
└── claude/            # Claude Code ユーザーレベル設定の正本
    ├── CLAUDE.md          # → ~/.claude/CLAUDE.md (symlink)
    ├── skills/            # → ~/.claude/skills, ~/.agents/skills (symlink)
    ├── commands/          # → ~/.claude/commands (symlink)
    └── settings.template.json  # settings.json の初期値 (symlink せずコピー)
```

## WSL 側もこの正本を参照している

移行元の WSL2 環境も以下を devenv への symlink に切り替えてあるので、
**設定はどちらのマシンで編集しても同じ正本に入る**:

| リンク元 | 正本 |
|---|---|
| `~/.claude/skills`, `~/.agents/skills` | `machine/claude/skills` |
| `~/.claude/commands` | `machine/claude/commands` |
| `~/.claude/CLAUDE.md` | `machine/claude/CLAUDE.md` |
| `~/.gitconfig`, `~/.gitconfig-fouryou` | `machine/dotfiles/gitconfig*` |

WSL のシェルは bash のまま (`~/.bashrc` は symlink 化していない)。
Mac は zsh なので `dotfiles/zshrc` を使う。共通化したい設定は両方に書く。

## 運用ルール

- **skill や CLAUDE.md を変更したいときは devenv 側 (ここ) を編集**する。
  `~/.claude/skills` は symlink なので、編集後 commit → 他マシンで pull すれば同期される。
- `settings.json` は Claude Code が動的に書き換えるため symlink 管理しない。
  共通化したい設定が増えたら `settings.template.json` に反映する。
- 新しいツールを入れたら `Brewfile` にも追記する。
- VS Code 拡張を増やしたら `vscode-extensions.txt` にも 1 行足す
  (`code --list-extensions` で上書きするとカテゴリのコメントが消えるので注意)。
- `codex` コマンドは VS Code の ChatGPT 拡張に同梱されたバイナリを直接呼んでいる。
  WSL は `~/.vscode-server/.../bin/linux-x86_64/codex` (`.bash_aliases`)、
  Mac は `~/.vscode/.../bin/darwin-arm64/codex` (`dotfiles/zshrc`) とパスが異なる。
