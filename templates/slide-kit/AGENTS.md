# AGENTS.md — {{PROJECT_NAME}}

This project is part of the **slide-kit** profile (managed by `~/develop/devenv/`).
The rules below are the source of truth for all slide-kit projects.
Project-specific build commands and file layout live in `BUILD.md` (read it before running anything).

## Purpose

崩れず・AIっぽくない・再利用可能なスライド資料をコードから生成する。
受け手が「人間が時間をかけて作った資料」と感じる品質を、コード化された部品で再現可能にする。

## Absolute rules (all slide-kit projects)

- **AIに座標を考えさせない**。スライドは必ず定義済みレイアウト／テーマから組み立てる。
- **1スライド1メッセージ**。詰め込み禁止、迷ったら分割する。
- **テキスト量の上限を守る**。違反した時点で分割または要約。
  - 本文: 最大5行
  - bullets: 最大6項目
  - 表: 最大6行（超えたら付録または分割）
  - cards: 最大3枚
- **色・フォント・余白はテーマトークンから参照する**。直書き禁止。
- **強調色は1色のみ**（accent color）。複数色での装飾は禁止。
- **装飾より情報設計を優先**。グラデ／影／過剰アイコンは AI 臭の原因。
- **テキストは safe ラッパー経由で渡す**（safeText / safeBullets 等、プロジェクトごとに定義）。

## Design direction

- 白〜ごく薄いグレー背景（例: `#F7F7F3`）
- 余白を広く取る（端から最低 ~0.5inch / ~50px 相当）
- フォントサイズは大きめ、行間は広め
- 罫線は薄く（`#E5E7EB` 系）
- 角丸カードを基調、シャープな矩形は最小限
- 参考トーン: Notion / Linear / Stripe / Apple Keynote

## Common workflow

1. **ヒアリング**（情報が不足している場合のみ）
   - 対象読者・ゴール・おおよその枚数・トーン（executive / technical / casual）
2. **アウトライン作成**
   - ストーリーラインを整理してから部品を選ぶ
3. **スライド原稿の作成**
   - プロジェクト固有のスキーマで原稿を書く（YAML or Markdown、`BUILD.md` 参照）
4. **生成 & 検証**
   - プロジェクト固有のビルドコマンドを実行（`BUILD.md` 参照）
   - 検証エラーが出たら原稿を修正して再生成、PPTX/HTMLの直接編集はしない
5. **修正対応**
   - 原稿（YAML / Markdown）を直接編集して再生成。出力ファイルを直接編集しない。

## Iteration patterns

| 指示                       | 対応                                |
|----------------------------|-------------------------------------|
| 「短く」「もっと簡潔に」   | bullets / rows / cards を減らす     |
| 「1枚に詰まりすぎ」        | 1スライドを2枚に分割                |
| 「順番変えて」             | 原稿の slides 配列を並べ替え        |
| 「色変えて」「ブランドに」 | テーマトークン (theme / theme file) |
| 「フォント変えて」         | テーマトークン                      |
| 「もう少し詳しく」         | bullets 増やす or 章扉+詳細に分解   |

## Anti-patterns (do NOT do)

- 出力ファイル (`.pptx` / `.html`) を直接編集する
- 座標やピクセル値を原稿に書く
- AI が新しい配色・フォント・装飾を勝手に追加する
- 1スライドに複数メッセージを詰める
- 表が画面に収まらないまま放置する
- ブランドガイドにない色を「アクセント」と称して導入する

## Safety

- 破壊的コマンド (`git push --force`, `rm -rf`, etc.) は人間の明示的指示なしに実行しない
- 出力ディレクトリ以外への書き込みは原則禁止
- 機密情報を含むスライドを生成する場合、共有先を必ず確認

## Project-specific bits

→ `BUILD.md` を読むこと。以下の内容が書かれている:
- ビルド／プレビュー／検証コマンド
- ディレクトリ構造とファイル命名規則
- 原稿スキーマの参照先
- そのプロジェクト固有の制限・拡張ポイント
