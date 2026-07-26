---
name: slide-gen
description: Use when creating editable PowerPoint/PPTX decks with the local YAML-to-PPTX slide generator, especially when the recipient needs to edit the deck in PowerPoint. Use for internal decks, business proposals, product intros, meeting materials, manuals, concept explanations, or technical/math slides that must be PPTX. Do not use for HTML/PDF/URL-shareable polished web decks; use slide-web for those.
---

## Quick reference

```bash
cd ~/develop/slide-gen
npm run validate -- examples/<name>.yaml   # YAML検証のみ
npm run deck     -- examples/<name>.yaml   # 検証 + PPTX生成
# 出力: output/<name>.pptx
```

## Role
社内スライド生成キットを使って、崩れず・AIっぽくない・再利用可能なPowerPoint資料を作る専門家。

## When to use
- 「PowerPointで編集できるスライドを作って」「PPTXで納品したい」
- 「スライドを作って」のうち、受け手が PowerPoint で編集する前提のもの
- 「プロダクト紹介」「事業比較」「マニュアル」「発表スライド」
- 数式・表を含む技術的なプレゼン

## When not to use
- HTML / PDF / URL共有を前提にした polished deck → **slide-web** を使う
- 受け手が編集しない提案書、会社紹介、ピッチ、研究発表 → **slide-web** を優先する
- Webページ・UIコンポーネントの作成
- 長文ドキュメント（MarkdownやWord向け）
- スプレッドシート・集計表

## Project location & file conventions
- スライドキット: `~/develop/slide-gen/`（TypeScript + PptxGenJS）
- yaml: `examples/YYYY-MM-DD-<topic>.yaml`（例: `2026-05-01-startup-industries.yaml`）
- 出力: `output/<同名>.pptx`
- 一時ファイル（コミットしないもの）: `*.local.yaml`（gitignore済み）

## Process (初版生成)

1. **ヒアリング**（情報が不足している場合のみ）
   - 対象読者・ゴール・おおよその枚数・トーン（executive / technical / casual）

2. **アウトライン作成**
   - ストーリーラインを整理する
   - 使うレイアウトを決める（`references/layout-catalog.md`）

3. **slide-spec.yaml を作成**
   - `references/yaml-schema.md` のスキーマに従う
   - 数式は `references/math-guide.md` を参照
   - 文字量・行数の制限を守る（`references/design-rules.md`）

4. **生成と検証**
   ```bash
   cd ~/develop/slide-gen
   npm run deck -- examples/<name>.yaml
   ```

5. **修正**（validate で問題があれば）
   - エラーに従い yaml を修正して再生成

## Iteration workflow（修正依頼への対応）

人間から「3枚目のここを直して」「全体的に短く」などの指示が来た場合：

1. **yaml を直接編集する**（生成済み PPTX は絶対に編集しない）
2. `npm run deck` で再生成する
3. 生成された pptx のパスを伝える

### よくある修正指示の解釈

| 指示 | 対応 |
|------|------|
| 「短く」「もっと簡潔に」 | bullets / rows / cards を減らす |
| 「分けて」「1枚に詰まりすぎ」 | 1スライドを2スライドに分割 |
| 「順番変えて」「最後に持ってきて」 | yaml の slides 配列を並べ替え |
| 「色変えて」「ブランドに合わせて」 | `src/theme.ts` の `colors` を編集 |
| 「フォント変えて」 | `src/theme.ts` の `font` を編集 |
| 「もう少し詳しく」 | bullets を増やす or 章扉+詳細スライドに分解 |

## Constraints
- PowerPointを直接編集しない。必ず `src/layouts/` の定義済みレイアウトを使う
- 座標を直接指定しない（layout 関数が管理する）
- `safeText()` / `safeBullets()` を通じてテキストを渡す
- 1スライド1メッセージの原則
- 本文は最大5行、箇条書きは最大6項目
- 表は最大6行（超える場合は分割または付録へ）
- 色・フォント・余白は `src/theme.ts` から参照する

## Known limitations
- 未対応: チャート / 画像埋め込み / カスタムブランド色UI / PDF出力 / フォント自動置換
- 上限: math 最大3式 / 表 最大6行 / bullets 最大6項目 / cards 最大3
- 詳細・回避策: `references/limitations.md`

## References
詳細は以下を読む（必要なときだけ）:
- `references/layout-catalog.md` — 使えるレイアウトと使い分け
- `references/design-rules.md` — デザインルール・アンチパターン
- `references/yaml-schema.md` — slide-spec.yaml の完全スキーマ
- `references/math-guide.md` — 数式の書き方と制限
- `references/limitations.md` — 既知の制限・回避策
- `references/extension-guide.md` — 新レイアウト追加・拡張手順
