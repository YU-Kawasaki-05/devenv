# job-hunt — Claude Instructions

就職活動専用ディレクトリ。企業リサーチ・書類作成・面接準備・応募管理を AI と協働して行う。

## Key Paths

- `self/` — 自己分析素材（全書類の共通素材置き場）
  - `profile.md` — 基本情報・略歴
  - `strengths.md` — 強み・弱み・価値観
  - `experiences/` — 経験の棚卸し（`001_経験名.md` 形式）
  - `pr_templates.md` — 自己PR素材集
- `companies/<path>/` — 企業ごとのディレクトリ
  - `<path>` は **単体企業** なら `<会社名>/`、**グループ企業の複数部門** なら `<グループ名>/<部門名>/`
  - 例: `companies/LayerX/` / `companies/PwC/コンサルティング/`
  - グループ共通情報は `companies/<グループ名>/_overview.md` に置く（任意）
  - `research.md` — 企業リサーチ
  - `questions.md` — 設問一覧
  - `entries/` — 提出書類（`<type>_v<N>.md` 形式）
  - `interview/prep.md` — 面接準備、`interview/log.md` — 面接後記録
- `docs/` — 共通書類（履歴書・ポートフォリオ等）
- `tracker.md` — 応募状況一覧
- `notes/作業アーカイブ/` — 作業記録（`YYYY-MM-DD_作業名.md` 形式）

## Skills

- `self-analysis` — 自己分析の棚卸しと `self/` への保存
- `company-research` — 企業リサーチと `companies/<path>/research.md` への保存
- `doc-writer` — 設問への回答作成・書類生成
- `interview-prep` — 面接想定Q&A生成・面接後メモ記録
- `job-tracker` — 応募状況の更新（tracker.md + Notion MCP）

## Slash Commands

- `/work-log` — 今日の作業を `notes/作業アーカイブ/YYYY-MM-DD_作業名.md` に記録

## Skill・設定の修正方法

このプロジェクトの設定ファイルは **devenv** で一元管理されている。直接このディレクトリを編集するのではなく、以下の手順で修正する。

| 修正内容 | 編集先 | 反映コマンド |
|---------|--------|-------------|
| Skill の動作を変える | `~/develop/devenv/templates/job-hunt/.agents/skills/<name>/SKILL.md` | `scripts/sync.sh /home/yukawasaki/develop/job-hunt` |
| Claude の動作・ルールを変える | `~/develop/devenv/templates/job-hunt/CLAUDE.md` | 同上 |
| Codex の動作を変える | `~/develop/devenv/templates/job-hunt/AGENTS.md` | 同上 |
| Slash Command を追加・変更する | `~/develop/devenv/templates/job-hunt/.claude/commands/<name>.md` | 同上 |

**反映手順:**
1. `cd ~/develop/devenv && scripts/sync.sh /home/yukawasaki/develop/job-hunt --dry-run` で差分確認
2. 問題なければ `--dry-run` を外して実行

## Rules

- 書類を作成するときは必ず `self/` を参照してから書く
- entries/ の保存はバージョン番号を付ける（`es_v1.md`, `es_v2.md`）
- 既存バージョンは絶対に上書きしない。改善版は新バージョンとして保存する
- `experiences/` に追加するときは 001 から連番で命名する（既存最大番号 +1）
- Notion MCP が有効な場合、job-tracker は `tracker.md` と Notion DB を両方更新する
- git commit はユーザーが明示的に求めたときのみ行う
- 個人情報（氏名・連絡先）を含むファイルは `git push` 前にユーザーに確認する
