# WSL2 → MacBook Pro (M2 Pro) 移行手順

WSL2 (Ubuntu 22.04) の開発環境を Mac に再現するための手順書。
自動化できる部分は `setup-mac.sh` / `clone-repos.sh` に任せ、秘密情報の移動だけ手作業で行う。

## 全体像

| 対象 | 移行方法 |
|---|---|
| CLI ツール・フォント・TeX | `Brewfile` (Homebrew) |
| Node (旧 nvm) | mise に移行 (`setup-mac.sh` が node@22 を導入) |
| シェル設定 | `dotfiles/zshrc` (bash → zsh 移植済み) |
| git 設定 (2 identity) | `dotfiles/gitconfig` + `gitconfig-fouryou` (includeIf で自動切替) |
| SSH 設定 | `dotfiles/ssh_config` (鍵本体は手動コピー) |
| Claude Code 設定 | `claude/` (skills / commands / CLAUDE.md を symlink 配布) |
| リポジトリ (18 個) | `clone-repos.sh` で GitHub から clone |
| rio 直下の作業ファイル | **tar で手動転送 (機密のため GitHub 経由禁止)** |
| univ (大学資料 3.2GB) | **tar で手動転送 (GitHub の 100MB 制限超のため)** |
| ~/.aws, ~/.supabase, ~/.codex | 手動コピー (秘密情報を含む) |

### リポジトリの public / private 方針

スライドツール群は「仕組み」と「生成物」を分離してある:

| repo | 可視性 | 内容 |
|---|---|---|
| `slide-gen` / `slide-web` / `slide-web-new` / `atcoder` | public | ツール・デザインシステム・テンプレート |
| `slide-web-new-decks` | **private** | 生成した deck (事業情報・クライアント言及を含む) |
| `thinking-space` | **private** | 意思決定ログ (事業戦略) |
| `job-hunt` / `wit` | private | 就活・リサーチ |

`slide-web-new/decks/` は親 repo が gitignore した**入れ子 repo**。
パスを変えずに公開範囲だけ分離するための構成なので、clone 時は親と子の両方が必要
(`clone-repos.sh` が両方 clone する)。deck を追加したら `decks/` 側で別途 commit すること。

## 手順

### 1. Mac 初期準備

```sh
xcode-select --install   # Command Line Tools (git が使えるようになる)
```

### 2. devenv を clone してセットアップ実行

最初は SSH 鍵がないので HTTPS で clone する:

```sh
mkdir -p ~/develop && cd ~/develop
git clone https://github.com/YU-Kawasaki-05/devenv.git
bash devenv/machine/setup-mac.sh
```

Homebrew → Brewfile → dotfiles → mise (node@22) → npm globals (claude-code, decktape) → Claude 設定 symlink まで自動で入る。
※ texlive は数 GB あるので時間がかかる。急ぐ場合は Brewfile の texlive を一時コメントアウト。

### 3. SSH 鍵の転送 (手動・慎重に)

WSL 側で鍵を tar 化:

```sh
# WSL 側
cd ~ && tar czf ssh-keys.tar.gz .ssh/id_ed25519 .ssh/id_ed25519.pub .ssh/id_ed25519_fouryou .ssh/id_ed25519_fouryou.pub
```

転送は **同一 LAN 内の scp / USB メモリ / AirDrop (Windows側にコピーしてから)** など、クラウドストレージを経由しない方法で。Mac 側で:

```sh
cd ~ && tar xzf ssh-keys.tar.gz
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_fouryou
chmod 644 ~/.ssh/*.pub
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_fouryou
rm ~/ssh-keys.tar.gz   # 転送元・転送媒体からも必ず削除
ssh -T git@github.com          # → Hi YU-Kawasaki-05!
ssh -T git@github.com-fouryou  # → Hi yu-kawasaki-fouryou!
```

devenv の remote を SSH に切替:

```sh
git -C ~/develop/devenv remote set-url origin git@github.com:YU-Kawasaki-05/devenv.git
```

### 4. gh CLI 認証 (2 アカウント)

```sh
gh auth login   # ブラウザで YU-Kawasaki-05
gh auth login   # もう一度実行して yu-kawasaki-fouryou を追加
gh auth status  # 両方 ✓ を確認
```

### 5. 全リポジトリ clone

```sh
bash ~/develop/devenv/machine/clone-repos.sh
```

### 6. rio 直下の作業ファイル (機密・git 管理外) を tar 転送

クライアント情報を含むため GitHub には置かない。SSH 鍵と同じ経路で:

```sh
# WSL 側 (rio-corp-systems は clone 済みなので除外)
cd ~/develop && tar czf rio-work.tar.gz --exclude='rio/rio-corp-systems' --exclude='rio/worktrees' rio/
# Mac 側
cd ~/develop && tar xzf rio-work.tar.gz && rm rio-work.tar.gz
```

worktrees/ は Mac 側で `git worktree add` し直す方が安全。

### 6b. univ (大学資料) を tar 転送

3.2GB あり、271MB の pptx が GitHub の 100MB 制限を超えるため GitHub には置けない。
外部ドライブか同一 LAN の scp で転送する:

```sh
# WSL 側 — node_modules と .git を除けば約 2GB
cd ~/develop && tar czf univ.tar.gz --exclude='node_modules' univ/
# Mac 側
cd ~/develop && tar xzf univ.tar.gz && rm univ.tar.gz
```

GitHub の `YU-Kawasaki-05/univ` (private) は空のまま存在する。
今後 GitHub で管理したい場合は大きい講義資料を除外した `.gitignore` を作り、
`git filter-repo` で履歴から 100MB 超のオブジェクトを落とす必要がある。

### 7. その他の秘密情報 (必要になったタイミングでよい)

| 対象 | 内容 | 移行 |
|---|---|---|
| `~/.aws/` | AWS credentials | tar 転送 or `aws configure` で再設定 |
| `~/.supabase/access-token` | Supabase CLI トークン | `npx supabase login` で再ログインが簡単 |
| `~/.codex/` | Codex CLI 設定・履歴 | `config.toml` / `AGENTS.md` / `prompts/` / `rules/` / `skills/` をコピー。`auth.json` は再ログイン推奨 |
| `~/.claude/projects/*/memory/` | Claude Code の記憶 | コピーすると会話の記憶を引き継げる (任意) |
| 各プロジェクトの `.env*` | API キー類 | git 管理外なので個別にコピー or 再発行 |

### 8. 動作確認チェックリスト

- [ ] `node -v` → v22.x (mise)
- [ ] `git config user.email` → 個人メール / `~/develop/rio/` 内で fouryou メール
- [ ] `gh auth status` → 2 アカウント
- [ ] `claude` 起動 → skills 16 個が見える (`/pr-review` 等)
- [ ] `git -C ~/develop/premake pull` などが SSH で通る
- [ ] TeX: `latexmk --version` / 日本語フォント: スライドの PDF export

## WSL 側の今後

devenv が skills / dotfiles の正本になったので、**設定変更は devenv 側を編集して commit → 各マシンで pull** が基本フロー。
WSL 側の `~/.claude/skills` 等はすでに devenv への symlink に切替済み。
