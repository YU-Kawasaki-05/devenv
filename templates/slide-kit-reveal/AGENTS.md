# AGENTS.md — {{PROJECT_NAME}}

This project is part of the **slide-kit-reveal** profile (managed by `~/develop/devenv/`).
The rules below are the source of truth for all slide-kit-reveal projects.
Project-specific build commands and file layout live in `BUILD.md` (read it before running anything).

## Purpose

reveal.js を使ったブラウザネイティブの高品質 HTML スライドを生成する。
AI は `<section>` タグの中に HTML を直接書く。Markdown 中間形式を使わない。
reveal.js がナビゲーション・全画面・PDF エクスポートを担当する。

## Required reading before generating

新しいデッキを作る前に必ず読む:

1. `~/develop/slide-web-new/DESIGN.md` — デザインシステム全体の概要とトークン定義
2. `~/develop/slide-web-new/profiles/<selected>.md` — 選択したプロファイルの作法
3. `~/develop/slide-web-new/DESIGN/patterns/` の関連パターン — 構成参考例

読まずに生成しない。

## Absolute rules (all slide-kit-reveal projects)

- **AI は HTML を直接書く**。Markdown を経由しない。
- **レイアウトは `DESIGN/tokens.css` のユーティリティクラスと自由な HTML で構成する**。
- **DESIGN.md を読んでからデッキ生成を始める**。
- **プロファイルは必ずユーザーに選ばせる**。自動選択しない。
- **カバースライドは唯一の固定テンプレート**。`DESIGN/patterns/cover` の通りに従う。それ以外のスライドはパターンを参考に自由に構成する。
- **brand は profile のアクセントカラーより優先**。color conflict を検知したらユーザーに警告する。
- **インラインスタイルで色・フォントを指定しない**。必ず CSS 変数をユーティリティクラス経由で参照する。
- **1スライド1メッセージ**。詰め込み禁止、迷ったら分割する。
- **テキスト量の上限を守る**:
  - 本文: 最大5行
  - bullets: 最大6項目
  - 表: 最大6行（超えたら付録または分割）
  - cards: 最大3枚
- **強調色は1色のみ**（accent color）。複数色での装飾は禁止。
- **装飾より情報設計を優先**。グラデ・シャドウ・過剰アイコンは AI 臭の原因。
- **枚数は固定しない**。情報量・発表時間・配布 or 投影に応じて統合・分割・appendix 化を判断する。

## Design direction

- 白〜ごく薄いグレー背景（tokens.css の `--color-bg` 参照）
- 余白を広く取る（`--spacing-*` トークン参照）
- フォントサイズは大きめ、行間は広め（`--font-*` トークン参照）
- 罫線は薄く（`--color-border` 参照）
- 角丸カードを基調、シャープな矩形は最小限
- 参考トーン: Notion / Linear / Stripe / Apple Keynote

## Workflow

1. **プロファイル選択**
   - 利用可能なプロファイルを列挙し、ユーザーに選択を求める
   - オプション: brand 指定があれば `brands/<name>/` を確認する
2. **必読ファイルを読む**
   - `DESIGN.md` + `profiles/<selected>.md` + 関連 patterns を読む
   - brand 指定がある場合は `brands/<name>/` も読む
3. **アウトライン提案**
   - スライドごとに「タイトル・キーメッセージ・レイアウト説明」を提示する
   - ユーザーの承認または修正を得てから次に進む
4. **HTML 生成**
   - 承認済みアウトラインに基づき `index.html` を生成する
   - cover パターンは DESIGN/patterns/cover の通りに従う
5. **ビジュアル QA チェックリスト**（生成後、完了報告前に必ず実施）
   - [ ] 全スライドにタイトルが存在するか
   - [ ] テキスト量が上限内か（本文5行・bullets6項目）
   - [ ] インラインスタイルで色・フォントを指定していないか
   - [ ] brand / profile のアクセントカラーが正しく適用されているか
   - [ ] カバーパターンが仕様通りか
   - [ ] 数式（KaTeX）・図（Mermaid）の構文が正しいか

## Math & diagrams

- **数式**: KaTeX 構文（`$$...$$` ブロック、`$...$` インライン）— ブラウザでレンダリング
- **図表**: Mermaid 構文（`<pre class="mermaid">` ブロック）— ブラウザでレンダリング
- **TikZ 図**: `pdflatex + dvisvgm` でコンパイルして SVG 出力。失敗時は Mermaid での再レンダリングを提案する

### Mermaid 使用ルール（必読）

```html
<!-- ✅ 正しい書き方 -->
<pre class="mermaid">
flowchart LR
  A["ノードA<br/>2行目"]:::box --> B["ノードB"]:::highlight
  classDef box fill:#F3F4F6,stroke:#374151,color:#111827
  classDef highlight fill:#374151,stroke:#374151,color:#ffffff
</pre>
```

- **`theme: 'base'` 必須** — `mermaid.initialize()` で `theme: 'base'` を指定すること。`'neutral'` では `classDef` の fill が上書きされる
- **`htmlLabels: true` 必須** — ノードの改行に `<br/>` を使うために必要
- **`%%{init:...}%%` 禁止** — ダイアグラムごとの init ディレクティブは `mermaid.initialize()` と競合して描画失敗する
- **`\n` ではなく `<br/>`** — ノードラベルの改行は `<br/>` を使う（`htmlLabels: true` が前提）
- **エッジラベルはクォートなし** — `-->|発症|` で十分。`-->|"発症"|` はエラーになることがある
- `classDef` はダイアグラムの末尾に書く

## Iteration patterns

| 指示                       | 対応                                        |
|----------------------------|---------------------------------------------|
| 「短く」「もっと簡潔に」   | bullets / rows / cards を減らす             |
| 「1枚に詰まりすぎ」        | 1スライドを2枚に分割                        |
| 「順番変えて」             | index.html の `<section>` 順を並べ替える    |
| 「色変えて」「ブランドに」 | CSS 変数（tokens.css / brand theme.css）    |
| 「フォント変えて」         | CSS 変数                                    |
| 「もう少し詳しく」         | bullets 増やす or 章扉+詳細に分解           |

## Anti-patterns (do NOT do)

- `index.html` を納品後に直接編集する（編集して再生成する）
- インラインスタイルで色・フォント・余白を指定する
- ユーザーに確認せず profile を自動選択する
- アウトライン提案なしにいきなり HTML を生成する
- グラデーション・シャドウ・複数アクセントカラーで装飾する
- 1スライドに複数メッセージを詰める
- DESIGN.md を読まずにデッキを生成する

## Safety

- 破壊的コマンド（`git push --force`, `rm -rf` 等）は人間の明示的指示なしに実行しない
- `decks/` ディレクトリ以外への書き込みは原則禁止
- 機密情報を含むスライドを生成する場合、共有先を必ず確認する

## Preview — 必ずプロジェクトルートから起動する

```bash
# ✅ 正しい起動方法
python3 -m http.server 8080 --directory ~/develop/slide-web-new
# → open: http://localhost:8080/decks/<YYYY-MM-DD-topic>/

# ❌ 間違い（CSS が 404 になりスタイルが一切適用されない）
# python3 -m http.server 8080 --directory ~/develop/slide-web-new/decks/<deck>
```

**理由:** `index.html` の CSS パス `../../DESIGN/tokens.css` はプロジェクトルートを基準とした相対パス。
デッキディレクトリをサーバールートにすると上位への参照が遮断され、白紙または極小表示になる。

## PDF エクスポート

```bash
# decktape を使う（推奨。reveal.js に最適化されたヘッドレス PDF 生成）
npx decktape reveal \
  http://localhost:8080/decks/<YYYY-MM-DD-topic>/ \
  decks/<YYYY-MM-DD-topic>/<topic>.pdf \
  --size 1280x720

# または export-pdf.sh スクリプト（サーバー自動起動・停止）
bash ~/develop/slide-web-new/scripts/export-pdf.sh <YYYY-MM-DD-topic>
```

decktape を使う理由: fragment（アニメーション要素）を正しく静的化し、スライド境界が正確。
ブラウザの `?print-pdf` 印刷よりも安定して高品質な PDF が得られる。

## Project-specific bits

→ `BUILD.md` を読むこと。以下の内容が書かれている:
- スタック（reveal.js / KaTeX / Mermaid / TikZ）
- ディレクトリ構造とファイル命名規則
- 新規デッキのスキャフォールドコマンド
- プレビュー・TikZ コンパイル・PDF エクスポートの手順
- プロファイル一覧
- 既知の注意点
