# slide-spec.yaml Schema

## トップレベル

```yaml
title: string           # 資料タイトル（必須）
author: string          # 作成者名（任意）
date: string            # 日付 YYYY-MM-DD（任意）
audience: string        # 対象読者（任意）
tone: executive | technical | casual   # トーン（任意、デフォルト: executive）
slides:                 # スライド配列（必須）
  - layout: ...
```

## 各 layout のフィールド

### title
```yaml
- layout: title
  title: "プロダクト紹介"
  subtitle: "〇〇チーム向け説明資料"
```

### section
```yaml
- layout: section
  title: "第1章：市場背景"
  subtitle: "なぜ今この事業が必要か"   # 任意
```

### agenda
```yaml
- layout: agenda
  title: "アジェンダ"
  items:
    - title: "市場背景"
      description: "業界の現状と課題"   # 任意
    - title: "提案内容"
    - title: "投資対効果"
```

### executive-summary
```yaml
- layout: executive-summary
  title: "要点"
  bullets:
    - "AIによる資料作成の自動化で、週あたり10時間を削減できる"
    - "初期投資は3ヶ月で回収見込み"
    - "段階導入により既存業務への影響を最小化"
```

### two-column
```yaml
- layout: two-column
  title: "現状と提案の比較"
  leftTitle: "現状"
  left:
    type: bullets
    items:
      - "手作業でスライド作成"
      - "品質がばらつく"
  rightTitle: "提案方式"
  right:
    type: bullets
    items:
      - "YAMLから自動生成"
      - "品質を一定に保てる"
```

```yaml
# math を含む two-column の例
- layout: two-column
  title: "コスト関数の比較"
  leftTitle: "L1正則化"
  left:
    type: math
    math: "L = \\sum_{i} (y_i - \\hat{y}_i)^2 + \\lambda \\sum_j |w_j|"
  rightTitle: "L2正則化"
  right:
    type: math
    math: "L = \\sum_{i} (y_i - \\hat{y}_i)^2 + \\lambda \\sum_j w_j^2"
```

### three-cards
```yaml
- layout: three-cards
  title: "3つのメリット"
  cards:
    - title: "速い"
      body: "資料作成時間を80%削減"
    - title: "崩れない"
      body: "定義済みレイアウトで品質を保証"
    - title: "統一感"
      body: "ブランドカラー・フォントを自動適用"
```

### table
```yaml
- layout: table
  title: "競合比較"
  caption: "2024年度調査"   # 任意
  headers: ["項目", "自社", "競合A", "競合B"]
  rows:
    - ["価格", "¥10,000/月", "¥15,000/月", "¥12,000/月"]
    - ["サポート", "24時間", "平日のみ", "24時間"]
    - ["API", "あり", "なし", "あり"]
```

### math
```yaml
- layout: math
  title: "ベイズの定理"
  math:
    - "P(A|B) = \\frac{P(B|A)\\,P(A)}{P(B)}"
    - "P(B) = \\sum_i P(B|A_i)\\,P(A_i)"
  content: "条件付き確率の更新則。事前確率 P(A) を観測 B で更新して事後確率 P(A|B) を得る。"
```

### closing
```yaml
- layout: closing
  title: "ご清聴ありがとうございました"
  subtitle: "質問・フィードバックはお気軽に"
  content: "yuu.kawasaki@example.com"   # 任意
```

## 注意事項
- math フィールドには LaTeX 文字列を書く（`$$` 囲み不要）
- バックスラッシュは YAML でエスケープ不要（ダブルクォートなら `\\`、シングルクォートなら `\`）
- 表の行数が6を超える場合は複数スライドに分割する
