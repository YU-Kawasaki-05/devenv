# Known Limitations

slide-gen キットの現状の制限と回避策。

## 未対応の機能（将来対応予定）

| 機能 | 現状 | 当面の回避策 |
|------|------|-------------|
| チャート（棒・折れ線・円） | 未実装 | `table` レイアウトで数値を見せる、または画像化して挿入待ち |
| 画像埋め込み | 未実装（math のみ画像化） | スクリーンショットが必要なら別途 PowerPoint で追加 |
| カスタムブランド色UI | yaml から指定不可 | `src/theme.ts` の `colors` を直接編集 |
| PDF出力 | 未実装 | LibreOffice で `soffice --headless --convert-to pdf output/*.pptx` |
| カスタムフォント置換 | yaml から指定不可 | `src/theme.ts` の `font` を直接編集 |
| 動的ページ番号スキップ（章扉除外） | 全スライドで連番 | 必要なら手動で footer ロジック調整 |

## 数値上限

| 要素 | 上限 | 理由 |
|------|------|------|
| math 数式数 / スライド | 3式 | レンダリング負荷 + 視認性 |
| 表の行数 | 6行 | はみ出し防止 |
| bullets | 6項目 | 認知負荷の上限 |
| three-cards のカード数 | 3枚（最低2枚） | レイアウト前提 |
| agenda items | 7項目 | 縦方向に収まる上限 |
| executive-summary bullets | 5項目 | 視認性 |
| タイトル文字数 | 40文字 | 1行に収まる目安 |
| bullet 1項目の文字数 | 100文字 | 折り返し抑制 |

これらを超えた場合は validation でエラーになる。指示通り **yaml を分割する** こと。

## トラブルシューティング

### `npm run deck` が失敗する

```
Error: Cannot find module 'mathjax-full'
```
→ `npm install` を実行（依存関係未インストール）

```
Error: Input buffer has corrupt header: glib: XML parse error
```
→ MathJax の SVG 変換失敗。LaTeX 構文を確認（バックスラッシュは yaml で `\\` または シングルクォート）

### Validation エラー

```
[Slide N] table.rows: Table too long (7 rows, max 6)
```
→ 表を 2スライドに分割する。"上位 N位" "その他" のように分ける

```
[Slide N] three-cards.cards: Too few cards (1, min 2)
```
→ `three-cards` ではなく `executive-summary` レイアウトを使う

### 生成後の pptx で起きやすい問題

| 症状 | 原因 | 対処 |
|------|------|------|
| 文字が四角に化ける | Windows に Yu Gothic がない | `theme.ts` の font を `Meiryo` に変更 |
| 数式が表示されない | sharp が未インストール | `npm install sharp` |
| 表がはみ出す | セル文字数オーバー | yaml の rows のセル文字数を 60 字以下に |
| カードの文字がはみ出す | body が長すぎる | 120字以内に収める |
| 全体が左上に寄る | theme と layout のサイズ不一致 | `theme.slide` と `pptx.layout` 整合を確認 |

## 環境前提

- WSL2 / Ubuntu
- Node.js 20以上
- 出力PPTXは Windows 側で開くこと前提（フォントは Windows のものを参照）
- LibreOffice で開く場合、フォント差分で見た目が変わる可能性あり
