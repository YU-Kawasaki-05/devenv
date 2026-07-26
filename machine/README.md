# machine/ — マシン環境の正本 (dotfiles + セットアップ)

`~/develop/` プロジェクトへの agent 設定配布 (templates/) に加えて、
**マシン自体の開発環境** (シェル・git・SSH 設定・Claude Code のユーザーレベル設定) をここで管理する。

```
machine/
├── Brewfile           # Mac: Homebrew 一括インストール定義
├── setup-mac.sh       # Mac: 環境セットアップ (冪等)
├── link-claude.sh     # WSL/Mac 共通: ~/.claude, ~/.agents を devenv 正本へ symlink
├── clone-repos.sh     # 全リポジトリ clone (冪等)
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

## 運用ルール

- **skill や CLAUDE.md を変更したいときは devenv 側 (ここ) を編集**する。
  `~/.claude/skills` は symlink なので、編集後 commit → 他マシンで pull すれば同期される。
- `settings.json` は Claude Code が動的に書き換えるため symlink 管理しない。
  共通化したい設定が増えたら `settings.template.json` に反映する。
- 新しいツールを入れたら `Brewfile` にも追記する。
