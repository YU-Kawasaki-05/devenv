# devenv

`~/develop/` 配下のプロジェクトに配布する agent 設定 (Claude / Codex / Copilot) の正本リポジトリ。

> **新規メンバーの方へ**: まず [`docs/`](docs/) のマニュアルから読んでください。セットアップ手順や日々の使い方が日本語でまとまっています。
> このファイル (README.md) は devenv 自体の仕組みリファレンスです。

## レイアウト

```
devenv/
├── templates/
│   └── <profile>/             # プロジェクトに配布される真実源 (base)
│       ├── CLAUDE.md
│       ├── AGENTS.md
│       ├── .codex/
│       │   ├── agents/        # Codex agent toml 群
│       │   ├── hooks/         # Codex hook python 群
│       │   ├── config.toml
│       │   └── hooks.json
│       └── .agents/skills/    # 共通 skill 群 (SKILL.md + agents/ + references/)
├── overrides/
│   └── <project-name>/        # 任意。base 上に重ねるプロジェクト固有ファイル
├── scripts/
│   ├── _lib.sh                # 共有ヘルパー (resolve_profile / stage_template)
│   ├── sync.sh                # templates/<profile>/ + overrides/<project>/ → 対象 (一方向)
│   └── diff.sh                # 差分確認
├── docs/                      # チーム向けマニュアル (新メンバーはまずここ)
├── manifest.yml               # プロジェクト名 → profile 対応
├── CLAUDE.md / AGENTS.md      # この repo の作業指示
└── README.md
```

## 使い方

### プロジェクトと正本の差分を見る

```bash
scripts/diff.sh ../Ardors-website                  # ファイル単位の diff
scripts/diff.sh ../Ardors-website --names-only     # 変更ファイル名のみ
```

### 配布 (一方向)

```bash
scripts/sync.sh ../Ardors-website --dry-run        # rsync の itemize-changes でプレビュー
scripts/sync.sh ../Ardors-website                   # 実際に上書き
```

挙動:
- `templates/<profile>/` を tmp に staging → `overrides/<project-name>/` があれば上に重ねる → トークン置換 → rsync。
- `templates/<profile>/` か `overrides/<project>/` に存在するパスのみ touch する。プロジェクト固有のファイル (例: `.claude/settings.local.json`、`docs/`、ソースコード) には触らない。
- プロジェクト側にしかないファイルは削除しない (安全側のデフォルト)。
- `manifest.yml` に登録されていない project は `--profile <name>` で明示的に指定する。

### Overrides (プロジェクト固有の上書き)

base profile を共有しつつ、特定ファイルだけプロジェクト固有にしたい場合:

```
overrides/<project-name>/
  CLAUDE.md                                   # base の CLAUDE.md を上書き
  .codex/hooks/check_bash_command.py          # 特定 hook のみ別ロジック
  .agents/skills/backend-bugfix/scripts/verify.sh  # サブディレクトリも可
```

挙動:
- base を staging に展開した直後に、`overrides/<project-name>/` の内容が `cp -a` で同 staging に重ねコピーされる。**ファイル単位の上書き**であり、base に存在するが override にも存在するファイルだけが置換される。
- override にだけ存在するファイルは追加配布される。
- base にあって override にないファイルはそのまま base 版が使われる。
- override 内のファイルにも `{{PROJECT_PATH}}` / `{{PROJECT_NAME}}` トークンが効く。

例: `lifeapp` は `docs-first-web` profile を使いつつ、CLAUDE.md / AGENTS.md / config.toml / check_bash_command.py / backend-bugfix の verify.sh を `overrides/lifeapp/` で固有版に差し替える。

### 別プロファイルを当てる

```bash
scripts/sync.sh ../some_other_repo --profile docs-first-web --dry-run
```

## 既知の制約 / 今後の作業

- `lifeapp`, `marubo_ai` への実 sync は dry-run 検証のみ。実際の上書きはユーザー承認待ち (どちらも override で固有版を保持する設計)。
- `jovin` は CLAUDE.md が空 → manifest に pending として明記。
- `evs-AI...`, `univ`, `marubo_forPractice`, `NoovaInc/` は manifest に out of scope と明記。

## profile / overrides 一覧

| project | profile | overrides |
|---|---|---|
| Ardors-website | `docs-first-web` | なし |
| schedule_app | `docs-first-web` | なし |
| lifeapp | `docs-first-web` | `overrides/lifeapp/` (CLAUDE.md, AGENTS.md, .codex/config.toml, .codex/hooks/check_bash_command.py, .agents/skills/backend-bugfix/scripts/verify.sh) |
| marubo_ai | `docs-first-web` | `overrides/marubo_ai/` (CLAUDE.md のみ) |
| slide-gen | `slide-kit` | `overrides/slide-gen/BUILD.md` (PPTX 固有のビルドコマンド・ディレクトリ構造) |
| slide-web | `slide-kit` | `overrides/slide-web/BUILD.md` (Slidev 固有のビルドコマンド・ディレクトリ構造) |

## グローバル skills の慣習

`~/.agents/skills/` 配下は `~/.claude/skills/` への symlink ファーム (Codex/別エージェント側からも同じ実体を共有)。新しいグローバル skill を追加するときは:
```bash
ln -s ~/.claude/skills/<skill-name> ~/.agents/skills/<skill-name>
```
で他ツール用にも参照を張る。
