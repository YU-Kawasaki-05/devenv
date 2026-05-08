# devenv — Agent Instructions (Codex / Generic)

## Project Purpose
AI 協働開発環境のセットアップと管理。Skills・設定ファイル・dotfiles を管理する。

## Always follow
- Skills を変更するときは SKILL.md の frontmatter (name / description) を必ず更新する
- scripts/ 内のファイルを実行する前に内容を確認する
- シェルコマンドの実行は最小限にする

## Skills location
- `.agents/skills/<name>/SKILL.md` — このプロジェクトの Codex Skills
- `~/.claude/skills/<name>/SKILL.md` — 個人用 Claude Skills

## Templates (配布元)
- `templates/<profile>/` 以下が各プロジェクトの真実源
- 配布は `scripts/sync.sh <project>` (一方向)。事前に `--dry-run` または `scripts/diff.sh` で確認
- `manifest.yml` に project → profile の対応を記述

## Tooling
- 依存関係のインストールが必要な場合は先に確認する
- パッケージマネージャーはシステムのものを使用する
