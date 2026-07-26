# devenv — Claude Instructions

このリポジトリは AI 協働開発環境のセットアップと管理を目的とする。

## Context
- 開発環境設定・dotfiles・Skills・エージェント設定の管理
- Claude Code / Codex / GitHub Copilot の設定を集約する場所

## Key Paths
- `machine/` — **マシン環境の正本**（dotfiles / Brewfile / Mac セットアップ / Claude ユーザー設定）。詳細は `machine/README.md`
- `~/.claude/skills/` — 個人用 Claude Skills → **`machine/claude/skills/` への symlink**
- `~/.claude/commands/` — 個人用グローバル Slash Commands → **`machine/claude/commands/` への symlink**
- `~/.claude/CLAUDE.md` — 個人用グローバル指示 → **`machine/claude/CLAUDE.md` への symlink**
- `~/.gitconfig`, `~/.gitconfig-fouryou` — → **`machine/dotfiles/` への symlink**
- `.claude/skills/` — プロジェクト固有 Skills（このリポジトリ）
- `.agents/skills/` — Codex 用 Skills（このリポジトリ）
- `.github/skills/` — GitHub Copilot 用 Skills（このリポジトリ）
- `templates/<profile>/` — 配下の develop プロジェクトに配布する正本 (base)
- `overrides/<project-name>/` — base 上に重ねるプロジェクト固有ファイル
- `manifest.yml` — プロジェクト名 → profile の対応表
- `scripts/sync.sh`, `scripts/diff.sh` — 配布・差分確認 (`scripts/_lib.sh` から共有関数を読む)

## Slash Commands の配置方針
| 種別 | 場所 | 用途 |
|------|------|------|
| 個人グローバル | `~/.claude/commands/<name>/` | 全プロジェクトで使いたいプロンプト（要件定義など） |
| プロジェクト共通 | `templates/<profile>/.claude/commands/<name>/` | チーム全員が使うべきプロンプト（devenv 経由で配布） |
| プロジェクト固有 | `overrides/<project>/.claude/commands/<name>/` | そのプロジェクトだけのプロンプト |

現在の個人グローバルコマンド: `machine/claude/commands/要件定義/`（v2・8 ファイル: 要件定義 / 外部設計 / 技術設計 / 整合性チェック / doc 生成 2 種 / 変更リクエスト / README）

## Templates / sync workflow
- 各プロジェクトの `.codex/`, `.agents/skills/`, `CLAUDE.md`, `AGENTS.md` の真実源は `templates/<profile>/` に置く
- 変更は templates 側に入れて、`scripts/sync.sh <project> --dry-run` で差分確認 → 問題なければ `--dry-run` を外して反映
- 一方向のみ。プロジェクト固有の変更は手動で templates に反映するルール
- `manifest.yml` に載っていないプロジェクトは未管理（移行作業中・固有差異が残る）

## Rules
- このリポジトリの変更は環境全体に影響する。慎重に変更する
- **このリポジトリは public**。使用例やドキュメントに実案件名・クライアント名・事業数値を書かない
- `machine/claude/` 以下は WSL / Mac 両方の `~/.claude/` から symlink で参照されている。
  ここを編集すると即座に両マシンの Claude Code の挙動が変わる（要 commit & push で同期）
- Skills を追加する際は既存パターンに合わせた SKILL.md を作成する
- scripts/ に実行スクリプトを追加するときは必ず内容を確認してから実行する
- `templates/` を編集したらすぐに sync しない。まず `--dry-run` と `diff.sh` で影響範囲を確認する
