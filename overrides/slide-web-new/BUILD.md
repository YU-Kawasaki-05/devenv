# BUILD.md — slide-web-new (reveal.js HTML output)

Project-specific commands and structure. Common slide-kit-reveal rules: see `AGENTS.md`.

## Stack

- [reveal.js](https://revealjs.com/) 4.x — CDN
- [KaTeX](https://katex.org/) — CDN, ブラウザ内数式レンダリング
- [Mermaid](https://mermaid.js.org/) — CDN, ブラウザ内図表レンダリング
- pdflatex + dvisvgm — TikZ 図のコンパイル（環境にインストール済み）
- decktape — PDF エクスポート（グローバルインストール済み）

## Directory layout

```
~/develop/slide-web-new/
├── DESIGN.md
├── DESIGN/
│   ├── tokens.css
│   ├── direction.md
│   └── patterns/          ← 25種 HTML スニペット（参照用）
├── profiles/              ← 7種 プロファイル定義
├── brands/
│   └── default/
├── templates/
│   └── deck.html          ← new-deck.sh が使う雛形
├── decks/                 ← 生成成果物（gitignore 推奨）
│   └── YYYY-MM-DD-<topic>/
│       ├── index.html
│       └── assets/
└── scripts/
    ├── new-deck.sh
    ├── tikz-to-svg.sh
    └── export-pdf.sh
```

## Commands

```bash
# 新規デッキのスキャフォールド
bash ~/develop/slide-web-new/scripts/new-deck.sh <topic> <profile> [brand]
# → decks/YYYY-MM-DD-<topic>/index.html を作成

# ブラウザでプレビュー
# ⚠️ サーバーは必ずプロジェクトルートから起動すること
#    デッキディレクトリから起動すると ../../DESIGN/tokens.css が 404 になりスタイルが崩れる
python3 -m http.server 8080 --directory ~/develop/slide-web-new
# → open: http://localhost:8080/decks/<YYYY-MM-DD-topic>/

# ファイルを直接開く場合（file:// は相対パスが正しく解決される）
open ~/develop/slide-web-new/decks/<YYYY-MM-DD-topic>/index.html

# TikZ 図を SVG にコンパイル
bash ~/develop/slide-web-new/scripts/tikz-to-svg.sh input.tex decks/<deck>/assets/figure.svg

# PDF エクスポート（decktape）
bash ~/develop/slide-web-new/scripts/export-pdf.sh <YYYY-MM-DD-topic>
# → decks/<YYYY-MM-DD-topic>/<topic>.pdf に出力
# サーバー未起動の場合は自動で起動・完了後に停止する
```

## Profiles

資料の目的に応じて profile を選ぶ。詳細は `profiles/<profile>.md` を読む。

| Profile | 用途 |
|---|---|
| `proposal` | 提案書・経営向け意思決定資料 |
| `overview` | 会社・チーム・サービス紹介（汎用） |
| `product-overview` | プロダクト説明・機能紹介 |
| `pitch` | ピッチ・投資家・事業コンテスト向け |
| `academic` | 学術発表・ゼミ・研究報告 |
| `internal` | 社内MTG・進捗報告・意思決定メモ |
| `workshop` | 研修・ハンズオン・チュートリアル |

## Design system

| ファイル | 内容 |
|---|---|
| `DESIGN.md` | デザインシステム概要・使い方 |
| `DESIGN/tokens.css` | CSS 変数・ユーティリティクラス定義 |
| `DESIGN/direction.md` | ビジュアル方針・参考トーン |
| `DESIGN/patterns/` | スライド構成のパターン例（参照用・cover のみ固定） |

## Known notes

- **プレビューはプロジェクトルートをサーバールートにすること**（上記 Commands 参照）
- CDN 依存のためオフライン環境では動作しない。オフライン時は reveal.js をローカルインストールする
- TikZ のコンパイルには pdflatex と dvisvgm が必要（この環境では両方インストール済み）
- Mermaid・KaTeX はブラウザレンダリングのためビルドステップ不要
- PDF エクスポートは decktape が最も品質が高い（fragment の静的化・スライド境界が正確）
- decktape はグローバルインストール済み（`npm install -g decktape --ignore-scripts` で導入）
- Chromium は `/usr/bin/chromium-browser`（システム）を使用。`PUPPETEER_EXECUTABLE_PATH` で変更可能
- `--ignore-scripts` を使う理由: puppeteer が Chromium を自動ダウンロードしようとして失敗するため
