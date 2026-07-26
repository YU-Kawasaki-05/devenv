# CLAUDE.md — {{PROJECT_NAME}}

このプロジェクトは **slide-kit-reveal** profile（`~/develop/devenv/` 管理）に属する。

## 必読

- **`AGENTS.md`** — slide-kit-reveal 共通の原則・制約・デザイン方針（真の情報源）
- **`BUILD.md`** — このプロジェクト固有のビルドコマンド・ディレクトリ構造・スタック詳細
- **`DESIGN.md`** — デザインシステム（tokens / patterns / direction）

新しいデッキを作る前に必ず全て読む。

## Claude 固有の注意

- グローバル Skill（`slide-web-new`）から発火された場合も、上記ファイルのルールを優先する
- プロファイルはユーザーに明示的に選ばせる。自動選択しない
- アウトライン提案を経ずに `index.html` を生成しない
- `index.html` は生成成果物。納品後に直接編集せず、編集して再生成する
- 数式は KaTeX 構文、図表は Mermaid 構文を使う（ブラウザレンダリング）
- TikZ はコンパイル失敗時に Mermaid 代替を提案する

## グローバル指示との関係

`~/.claude/CLAUDE.md`（ユーザー全体指示）と本ファイルが矛盾した場合は本ファイル優先。
ただし「コミットはユーザーが明示した時のみ」「破壊的操作は事前確認」等の安全ルールは常に有効。
