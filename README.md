# devenv

`~/develop/` 配下のプロジェクトに配布する agent 設定 (Claude / Codex / Copilot) の正本リポジトリ。

## レイアウト

```
devenv/
├── templates/
│   └── <profile>/             # プロジェクトに配布される真実源
│       ├── CLAUDE.md
│       ├── AGENTS.md
│       ├── .codex/
│       │   ├── agents/        # Codex agent toml 群
│       │   ├── hooks/         # Codex hook python 群
│       │   ├── config.toml
│       │   └── hooks.json
│       └── .agents/skills/    # 共通 skill 群 (SKILL.md + agents/ + references/)
├── scripts/
│   ├── sync.sh                # templates/<profile>/ → 対象プロジェクト (一方向)
│   └── diff.sh                # 差分確認
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
- `templates/<profile>/` に存在するパスのみ touch する。プロジェクト固有のファイル (例: `.claude/settings.local.json`、`docs/`、ソースコード) には触らない。
- プロジェクト側にしかないファイルは削除しない (安全側のデフォルト)。
- `manifest.yml` に登録されていない project は `--profile <name>` で明示的に指定する。

### 別プロファイルを当てる

```bash
scripts/sync.sh ../some_other_repo --profile docs-first-web --dry-run
```

## 既知の制約 / 今後の作業

- `.codex/config.toml` 内の `[projects."/home/yukawasaki/develop/Ardors-website"]` がハードコード。schedule_app などにも同じパスが書かれている (元コピー時から)。今後トークン置換 (例: `{{PROJECT_PATH}}`) を入れて sync 時に置換する予定。
- `lifeapp` は同じ skill 名を持つが drift 済み。docs-first-web に統合する前に差分解析が必要。
- `jovin` は CLAUDE.md が空。中身を確認してから profile を決める。
- slide-gen は `~/.claude/skills/`、`~/.agents/skills/`、`develop/slide-gen/` の三重存在で、整理は次フェーズ。

## profile 一覧

| profile | 用途 | 適用プロジェクト |
|---|---|---|
| `docs-first-web` | docs-first な Web プロジェクト共通 (Codex agents/hooks + 9 共通 skills) | Ardors-website, schedule_app |
