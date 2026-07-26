# WSL2 の開発環境を MacBook Pro に移す手順

**Mac を触ったことがない前提**で書いてあります。上から順にコピペしていけば終わります。
分からない用語は各セクションの「これは何?」を読んでください。

所要時間は **1〜2 時間**（うち大半は Homebrew と TeX のダウンロード待ちで、放置していればよい）。

---

## 0. 先に知っておくべき Mac の基礎

### ターミナルの開き方

`Command (⌘) + Space` → `terminal` と入力 → `Enter`。
これが WSL の Ubuntu ターミナルに相当します。黒い画面が出れば OK。

### WSL と違うところ

| | WSL2 (Ubuntu) | Mac |
|---|---|---|
| シェル | bash | **zsh**（設定ファイルが `.bashrc` → `.zshrc` になる） |
| パッケージ管理 | `apt install` | **`brew install`**（Homebrew。最初に入れる） |
| ホームディレクトリ | `/home/yukawasaki` | **`/Users/<ユーザー名>`**（`~` で書けば同じ） |
| クリップボード | `clip.exe` | `pbcopy` / `pbpaste` |

**`~` は「ホームディレクトリ」を意味する記号**で、Mac でも WSL でも同じように使えます。
だから手順書の `~/develop` はそのままコピペして大丈夫です。

### コピペの注意

- 行頭の `$` や `#` は**入力しない**（プロンプト記号やコメントです）
- コマンドを貼ったら `Enter` を押す
- パスワードを聞かれたら **Mac のログインパスワード**を入力（打っても画面に何も出ないのが正常）

---

## 1. Command Line Tools を入れる

**これは何?** git やコンパイラなどの基本ツール一式。Mac には最初入っていません。

```sh
xcode-select --install
```

ダイアログが出るので「インストール」をクリック。5〜10 分待ちます。
「既にインストールされています」と言われたらそのまま次へ。

### `install requested for command line developer tools` と出て止まった場合

**これは正常なメッセージです。** このコマンドは「インストールを要求した」と表示して
**すぐプロンプトに戻る**設計で、実際の作業は別に出る GUI ダイアログが担当します。
ターミナル側は何も進みません。

まず入っているか確認:

```sh
xcode-select -p
```

`/Library/Developer/CommandLineTools` と出れば**もう入っています**。次へ進んでください。

`error: unable to find utility` なら未インストールなので、ダイアログを探します。
他のウィンドウの裏や別のデスクトップに隠れがちなので、`F3`（Mission Control）や
Dock に増えたアイコンを確認してください。

ダイアログが見つからないときは、ターミナルだけで入れられます:

```sh
softwareupdate --list
```

`Command Line Tools for Xcode-16.x` のような項目が出るので、その名前をそのまま指定:

```sh
sudo softwareupdate --install "Command Line Tools for Xcode-16.2"
```

（`16.2` は `--list` で出た実際の名前に合わせる）

**それでも面倒なら、この章は飛ばして構いません。**
次の章の Homebrew インストーラが Command Line Tools を自動で入れてくれます。

### 確認

```sh
git --version
```

`git version 2.xx.x` のように出れば成功です。

---

## 2. セットアップスクリプトを走らせる

**これは何?** Homebrew（Mac のパッケージ管理）を入れて、必要なツール・フォント・設定を
`devenv` リポジトリの定義どおりに一括で入れます。中身は `machine/setup-mac.sh`。

```sh
mkdir -p ~/develop
cd ~/develop
git clone https://github.com/YU-Kawasaki-05/devenv.git
bash devenv/machine/setup-mac.sh
```

### 途中で起きること

1. **Homebrew のインストール** — パスワードを聞かれます（Mac のログインパスワード）。
   `Press RETURN to continue` と出たら `Enter`。
2. **ツールのダウンロード** — ここが長い。特に `texlive` は数 GB あり **30〜60 分**かかります。
   放置して構いません。
   > 急いでいる場合: `Ctrl + C` で止めて `~/develop/devenv/machine/Brewfile` の
   > `brew "texlive"` の行頭に `#` を付けてコメントアウトし、スクリプトを再実行。
   > スライドの PDF 出力が必要になった時点で入れ直せます。
3. **設定ファイルのリンク** — `.zshrc` / `.gitconfig` などが devenv を指すようになります。
   既存ファイルがあれば `.bak.<日時>` という名前で自動退避されるので、失われません。

### スクリプトは何度でも実行できる

途中で失敗しても、原因を直して**もう一度同じコマンドを実行すれば大丈夫**です
（冪等に作ってあります。入っているものは飛ばされます）。

### 終わったら

ターミナルを**一度閉じて開き直します**（設定を読み込ませるため）。そして確認:

```sh
brew --version    # Homebrew x.x.x
node --version    # v22.x.x
gh --version      # gh version 2.xx.x
```

---

## 3. SSH 鍵を移す（ここだけ手作業）

**これは何?** GitHub に「自分だ」と証明するための秘密の鍵ファイルです。
パスワードと同じくらい大事なので、**クラウドストレージや Slack では絶対に送らない**でください。

個人用 (`id_ed25519`) と仕事用 (`id_ed25519_fouryou`) の 2 つあります。

### 3-1. WSL 側でまとめる

WSL のターミナルで:

```sh
cd ~
tar czf ssh-keys.tar.gz .ssh/id_ed25519 .ssh/id_ed25519.pub .ssh/id_ed25519_fouryou .ssh/id_ed25519_fouryou.pub
cp ssh-keys.tar.gz /mnt/c/Users/yuukw/Downloads/
```

Windows の `ダウンロード` フォルダに `ssh-keys.tar.gz` が現れます。

> **デスクトップに置かないこと。** このPCのデスクトップは OneDrive 同期対象
> (`C:\Users\yuukw\OneDrive\デスクトップ`) なので、置いた瞬間に秘密鍵が
> Microsoft のクラウドにアップロードされてしまいます。
> `ダウンロード` フォルダは同期対象外なので安全です。

### 3-2. Mac に渡す

**USB メモリ**が確実です。Windows のエクスプローラーで `ダウンロード` から USB に
`ssh-keys.tar.gz` を**移動**（コピーではなく移動。Windows 側に残さない）。

USB を Mac に挿すと、デスクトップまたは Finder のサイドバーに USB が現れます。
そこから `ダウンロード` フォルダにドラッグしてください。

### 3-3. Mac 側で展開して登録

```sh
cd ~
tar xzf ~/Downloads/ssh-keys.tar.gz
chmod 600 ~/.ssh/id_ed25519 ~/.ssh/id_ed25519_fouryou
chmod 644 ~/.ssh/id_ed25519.pub ~/.ssh/id_ed25519_fouryou.pub
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
ssh-add --apple-use-keychain ~/.ssh/id_ed25519_fouryou
```

> `chmod 600` は「自分以外は読めない」設定。SSH はこれが緩いと鍵を使ってくれません。
> `--apple-use-keychain` は Mac のキーチェーンに覚えさせるオプションで、
> これをやっておくと**次回以降は自動で鍵が使われます**（WSL でやっていた ssh-agent の
> 自動起動スクリプトは Mac では不要）。

### 3-4. つながるか確認

```sh
ssh -T git@github.com
ssh -T git@github.com-fouryou
```

初回は `Are you sure you want to continue connecting?` と聞かれるので `yes` + `Enter`。

- 1 つ目 → `Hi YU-Kawasaki-05! You've successfully authenticated...`
- 2 つ目 → `Hi yu-kawasaki-fouryou! ...`

と出れば成功です。`does not provide shell access` は正常な文言なので気にしないでください。

### 3-5. 鍵ファイルの後片付け（重要）

```sh
rm ~/Downloads/ssh-keys.tar.gz
```

さらに以下からも消してください:

- **USB メモリ**（Windows でゴミ箱に入れたあと、ゴミ箱も空にする）
- **WSL 側**: `rm ~/ssh-keys.tar.gz`
- **Windows の `ダウンロード` フォルダ**（3-2 で移動していれば既に無いはず）

---

## 4. GitHub CLI にログイン（2 アカウント）

**これは何?** `gh` は GitHub をコマンドから操作するツール。
HTTPS 接続時のパスワード代わりにもなります。個人と仕事の 2 回ログインします。

```sh
gh auth login
```

対話式に聞かれるので、こう答えます:

| 質問 | 答え |
|---|---|
| What account do you want to log into? | `GitHub.com` |
| What is your preferred protocol...? | `HTTPS` |
| Authenticate Git with your GitHub credentials? | `Yes` |
| How would you like to authenticate? | `Login with a web browser` |

8 桁のコード（例 `A1B2-C3D4`）が表示されるのでコピーし、`Enter` でブラウザが開きます。
コードを貼って認証してください。

**個人アカウント (YU-Kawasaki-05) が終わったら、もう一度同じコマンド**を実行して
仕事アカウント (yu-kawasaki-fouryou) も追加します。

確認:

```sh
gh auth status
```

2 つのアカウントに `✓ Logged in` が付いていれば OK。

---

## 5. リポジトリを全部持ってくる

```sh
bash ~/develop/devenv/machine/clone-repos.sh
```

18 個のリポジトリが `~/develop/` 以下に並びます。
**WSL で作業していたブランチに自動で切り替わります**（`premake` なら
`feat/nominee-linking-and-polish` など）。

このスクリプトも何度実行しても安全です（既にあるものは `skip` と表示されて飛ばされます）。

### 依存パッケージを入れる

リポジトリごとに、作業を始めるときに:

```sh
cd ~/develop/premake
pnpm install
```

（`node_modules` は git に入れていないので各マシンで入れ直します）

---

## 5b. VS Code の拡張機能を入れる

まず VS Code から `code` コマンドを使えるようにします。
VS Code を起動して `Command + Shift + P` → `Shell Command: Install 'code' command in PATH` を実行。

そのあとターミナルで:

```sh
bash ~/develop/devenv/machine/install-vscode-extensions.sh
```

`machine/vscode-extensions.txt` に書かれた 23 個が入ります（既に入っているものは `skip` と出て飛ばされます）。
入れ終わったら VS Code を再起動してください。

拡張を増やしたら、リストも更新しておくと次のマシンで再現できます:

```sh
code --list-extensions > ~/develop/devenv/machine/vscode-extensions.txt
```

> ⚠️ 上のコマンドはファイル内のコメント（カテゴリ分けの見出し）を消してしまいます。
> 分類を残したい場合は `vscode-extensions.txt` を直接編集して 1 行足してください。

---

## 6. GitHub 経由で移せないもの

| 対象 | なぜ | どうする |
|---|---|---|
| `~/develop/rio/` 直下 | クライアント案件の機密ファイル（**本番ログイン情報を含む**） | 下記 6-1 の tar 転送 |
| `~/develop/univ/` | 3.2GB、271MB の pptx が GitHub の 100MB 制限超 | 下記 6-2（急がなければ後回しで OK） |
| 各プロジェクトの `.env` | API キーなど。git 管理外 | 必要になったら個別にコピー or 再発行 |
| `~/NoovaInc/` | 移行対象外と判断 | 何もしない |

### 6-1. rio の作業ファイル

`rio-corp-systems`（コード）は clone 済みなので、**その外側にある作業ファイルだけ**運びます。
`worktrees/` と `.worktrees/` は git のワークツリー（コードの複製）で合計 1.9GB あるため除外し、
Mac 側で必要になったら作り直します。除外すると 10MB 程度に収まります。

```sh
# WSL 側
cd ~/develop
tar czf rio-work.tar.gz \
  --exclude='rio/rio-corp-systems' \
  --exclude='rio/worktrees' \
  --exclude='rio/.worktrees' \
  rio/
cp rio-work.tar.gz /mnt/c/Users/yuukw/Downloads/
```

> ⚠️ **この tar には `rio/.secrets/` が入ります。** 中身は rio-ai-system.com 本番環境の
> ログイン情報（URL・ユーザー・パスワード）で、**git 管理外＝どこにもバックアップがない**
> ファイルです。SSH 鍵とまったく同じ扱いをしてください:
> OneDrive 同期対象のデスクトップに置かない / クラウドや Slack で送らない /
> USB は使用後にゴミ箱も空にする。

```sh
# Mac 側（USB からコピーした後）
cd ~/develop
tar xzf ~/Downloads/rio-work.tar.gz
chmod 700 ~/develop/rio/.secrets
chmod 600 ~/develop/rio/.secrets/*
rm ~/Downloads/rio-work.tar.gz
```

転送後は WSL 側の `rm ~/develop/rio-work.tar.gz` も忘れずに。

ワークツリーが必要になったら Mac で作り直します:

```sh
cd ~/develop/rio/rio-corp-systems
git worktree add ../worktrees/t2 <ブランチ名>
```

### 6-2. univ（大学資料・約 2GB）

大きいので**外付け SSD / USB での転送**を推奨。急がなければ後回しで構いません。

```sh
# WSL 側（node_modules を除いて約 2GB）
cd ~/develop
tar czf univ.tar.gz --exclude='node_modules' univ/
```

```sh
# Mac 側
cd ~/develop
tar xzf /Volumes/<USBの名前>/univ.tar.gz
```

> GitHub の `YU-Kawasaki-05/univ` (private) は空のまま存在しています。
> 将来 GitHub で管理したくなったら、大きい講義資料を `.gitignore` に入れた上で
> `git filter-repo` で履歴から 100MB 超のファイルを落とす作業が必要です。

### 6-3. その他の設定（必要になったときで OK）

| 対象 | 中身 | おすすめの方法 |
|---|---|---|
| `~/.aws/` | AWS の認証情報 | tar 転送、または `aws configure` で入れ直す |
| `~/.supabase/access-token` | Supabase のトークン | `npx supabase login` で再ログインが楽 |
| `~/.codex/` | Codex CLI の設定・履歴 | `config.toml` `AGENTS.md` `prompts/` `rules/` `skills/` をコピー。`auth.json` は再ログイン推奨 |
| `~/.claude/projects/*/memory/` | Claude Code の記憶 | コピーすると過去の文脈を引き継げる（任意） |

---

## 7. 動作確認チェックリスト

上から順に試して、全部 ✓ になれば移行完了です。

```sh
node --version                                   # v22.x
git config user.email                            # yuu.kw5.sea@gmail.com（個人）
git -C ~/develop/rio/rio-corp-systems config user.email   # yuu.kawasaki@fouryou.co.jp（仕事）
gh auth status                                   # ✓ が 2 つ
claude                                           # 起動して /pr-review 等の skill が 16 個見える
git -C ~/develop/premake pull                    # SSH でエラーなく通る
latexmk --version                                # TeX（Brewfile で texlive を入れた場合）
codex --version                                  # ChatGPT 拡張のインストール後に有効になる
```

> `codex` は VS Code の ChatGPT 拡張に同梱されたバイナリを直接呼ぶ仕組み（`.zshrc` で定義）。
> 5b の拡張機能インストールが済んでいないと `codex CLI が見つかりません` になります。

**git のメールアドレスがフォルダによって自動で切り替わる**のがポイントです。
`~/develop/rio/` と `evs-...` の中だけ仕事用のアドレスになります（`.gitconfig` の
`includeIf` で設定済み）。仕事のコミットに個人アドレスが付く事故を防ぐためです。

---

## 8. 移行後の運用（ここが大事）

**設定の正本は `~/develop/devenv/machine/` です。WSL と Mac の両方がここを見ています。**

`~/.claude/skills` や `~/.gitconfig` は devenv への symlink（ショートカット）になっているので、
**どちらのマシンで編集しても、実体は devenv の中の同じファイル**が変わります。

だから設定を変えたら:

```sh
cd ~/develop/devenv
git add -A
git commit -m "設定を変更した内容"
git push
```

そして**もう一方のマシンで**:

```sh
cd ~/develop/devenv && git pull
```

これで 2 台が揃います。片方だけで編集して放置すると、次に pull したとき衝突するので、
**変えたら push、作業前に pull** を習慣にしてください。

新しいツールを `brew install` したら `machine/Brewfile` にも 1 行足しておくと、
次にマシンを買ったときまた 1 コマンドで済みます。
