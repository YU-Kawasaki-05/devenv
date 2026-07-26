# Layout Catalog

slide-spec.yaml で指定できるレイアウト一覧。

## 基本8レイアウト（MVP）

| layout | 用途 | 主なフィールド |
|--------|------|--------------|
| `title` | 表紙 | title, subtitle |
| `section` | 章扉 | title, subtitle |
| `agenda` | 目次 | title, items[] |
| `executive-summary` | 要点まとめ（冒頭・結論） | title, bullets[] |
| `two-column` | 左右比較・グラフ＋説明 | title, leftTitle, left{}, rightTitle, right{} |
| `three-cards` | 3要素の並列説明 | title, cards[]{title, body} |
| `table` | 比較表・一覧 | title, headers[], rows[][], caption |
| `closing` | 最終ページ | title, subtitle, content |

## 拡張レイアウト

| layout | 用途 | 主なフィールド |
|--------|------|--------------|
| `math` | 数式・定理・アルゴリズム | title, math（単一または配列）, content |

## レイアウト選択ガイド

```
表紙 → title
章の区切り → section
全体像の先出し → agenda
結論を先に言う → executive-summary
比較・対比 → two-column
3つの要素 → three-cards
一覧・比較表 → table
数式・定理 → math
最後のページ → closing
```

## column type 一覧（two-column の left/right）

| type | 内容 |
|------|------|
| `bullets` | 箇条書きリスト（items[] で指定） |
| `text` | 段落テキスト（text で指定） |
| `math` | 数式（math で指定） |

## 1スライドあたりの推奨量

| 要素 | 上限 |
|------|------|
| 本文行数 | 5行 |
| 箇条書き | 6項目 |
| 表の行数 | 6行（超えたら分割） |
| タイトル文字数 | 30文字 |
| 数式（math） | 3式まで |
