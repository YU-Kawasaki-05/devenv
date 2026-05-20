# job-hunt — Agent Instructions (Codex / Generic)

## Project Purpose

就職活動専用ディレクトリ。企業リサーチ・書類作成・面接準備・応募管理を行う。

## Always follow

- 書類を作成するときは必ず `self/` を参照してから書く
- `entries/` に保存するファイルはバージョン番号を付ける（`es_v1.md` → `es_v2.md`）
- 既存バージョンを上書きしない。改善版は新バージョンとして保存する
- `experiences/` に追加するときは既存ファイルの最大番号 +1 で連番命名する
- git commit はユーザーが明示的に求めたときのみ行う

## Directory layout

```
self/
  profile.md
  strengths.md
  experiences/001_経験名.md, 002_...
  pr_templates.md
companies/
  <会社名>/               # 単体企業
  <グループ名>/<部門名>/  # グループ企業の複数部門（例: PwC/コンサルティング/）
  <グループ名>/_overview.md  # グループ共通情報（任意）
  # 各ディレクトリ内: research.md, questions.md, entries/<type>_v<N>.md, interview/prep.md, log.md
docs/
  resume.md
  portfolio.md
tracker.md
notes/作業アーカイブ/YYYY-MM-DD_作業名.md
```

## Skills location

`.agents/skills/<name>/SKILL.md`

## Skills available

- `self-analysis` — 自己分析の棚卸し → `self/` に保存
- `company-research` — 企業リサーチ → `companies/<path>/research.md` に保存
- `doc-writer` — 設問への回答・書類作成 → `entries/` にバージョン付きで保存
- `interview-prep` — 面接想定Q&A生成・面接後メモ
- `job-tracker` — 応募状況の更新（tracker.md + Notion MCP）

## Notion MCP

Notion MCP が有効な場合、`job-tracker` は `tracker.md` と Notion DB を両方更新する。
MCP が無効な場合は `tracker.md` のみ更新する。

## Tooling

- Web検索は `company-research` で積極的に使用する
- シェルコマンドの実行は最小限にする
- 依存関係のインストールが必要な場合は先に確認する

## Skill・設定の修正方法

このプロジェクトの設定ファイルは **devenv** (`~/develop/devenv/`) で一元管理されている。

| 修正内容 | 編集先 |
|---------|--------|
| Skill の動作 | `templates/job-hunt/.agents/skills/<name>/SKILL.md` |
| Codex の動作・ルール | `templates/job-hunt/AGENTS.md` |
| Claude の動作・ルール | `templates/job-hunt/CLAUDE.md` |
| Slash Command | `templates/job-hunt/.claude/commands/<name>.md` |

編集後: `scripts/sync.sh /home/yukawasaki/develop/job-hunt --dry-run` で確認 → `--dry-run` を外して反映
