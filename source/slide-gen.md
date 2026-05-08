結論から言うと、**かなり実現可能**です。
ただし「AIに自由にスライドを作らせる」のではなく、**AIには“決められた部品を選んで埋める”だけにさせる**設計にするのが重要です。

一番おすすめは、会社用の「スライド生成リポジトリ」を1つ作り、そこに以下を入れる構成です。

```txt
company-slide-kit/
  AGENTS.md
  CLAUDE.md
  package.json
  src/
    generate.ts
    theme.ts
    layouts/
      title.ts
      section.ts
      agenda.ts
      two-column.ts
      table.ts
      chart.ts
      diagram.ts
      quote.ts
      closing.ts
    components/
      text.ts
      table.ts
      chart.ts
      card.ts
      icon.ts
      footer.ts
    validators/
      overflow-check.ts
      design-lint.ts
  templates/
    brand-master.pptx
  examples/
    sales-proposal.yaml
    project-report.yaml
  output/
```

## まず考え方：PowerPointテンプレートだけでは足りない

PowerPointの`.potx`や`.pptx`テンプレートを作るだけでも一定の効果はあります。
ただ、Claude CodeやCodexで大量生成するなら、それだけでは不十分です。

なぜなら、AIが直接PowerPointを編集すると、

「なんとなく見た目は整っているが、文字がはみ出す」
「表がスライド下に突き抜ける」
「図形の位置が微妙にズレる」
「ページによって余白・フォントサイズ・色がブレる」

という問題が出やすいからです。

なので理想は、**PowerPointテンプレート + コード化されたレイアウトシステム + AI向け指示ファイル**の3点セットです。

## おすすめ実装：PptxGenJSを中心にする

現実的には、JavaScript/TypeScriptの **PptxGenJS** を使うのがかなり相性良いです。PptxGenJSはNode、React、Vite、Electron、ブラウザなどからPowerPointを生成でき、TypeScript定義や多数のデモも提供されています。([gitbrent.github.io][1])

特に今回の目的に合うポイントはここです。

PptxGenJSは**Slide Master Layouts**をコードで定義できるため、会社のロゴ、フッター、ページ番号、背景、ブランドカラーなどを共通化できます。([gitbrent.github.io][2])

また、表については`autoPage`があり、行がスライドから溢れる場合に新しいスライドを追加する仕組みがあります。([gitbrent.github.io][3])

さらに、棒グラフ、折れ線、円グラフ、コンボチャート、3Dチャートなどのチャート生成にも対応しています。([gitbrent.github.io][4])

つまり、**タイトル、2カラム、表、チャート、図解、カード型レイアウト**をコード部品として用意しておけば、AIはそれらを呼び出して資料を作れます。

## Claude Code / Codexでの使い方

### Claude Code側

Claude Codeには、プロジェクトごとの永続的な指示として`CLAUDE.md`を置けます。公式ドキュメントでも、`CLAUDE.md`はプロジェクトの永続コンテキストを与えるための仕組みとして説明されています。([Claude][5])

さらに、Claude CodeにはSkills、Hooks、Subagentsなどがあります。SkillsはClaude Codeの能力を拡張する仕組みで、HooksはClaude Codeのライフサイクル中にシェルコマンドやHTTPエンドポイントなどを自動実行できます。([Claude][6])

今回なら、たとえばこう使います。

```txt
.claude/
  skills/
    company-slides/
      SKILL.md
  agents/
    slide-designer.md
    slide-reviewer.md
  commands/
    make-deck.md
    review-deck.md
```

Claude Codeにはこう指示します。

```md
# CLAUDE.md

このリポジトリは会社用PowerPoint資料を生成するためのものです。

## 絶対ルール

- PowerPointを直接自由編集しない
- 必ず src/layouts/ の定義済みレイアウトを使う
- 新しいスライドを作るときは layouts の関数を追加する
- 文字量が多い場合は1枚に詰め込まず、複数スライドに分割する
- 1スライド1メッセージ
- 本文は最大5行
- 表は最大6行まで。超える場合は分割または付録へ送る
- 生成後に npm run validate を必ず実行する
- 生成後に npm run export:pdf を実行して確認する
```

### Codex側

Codexでは、公式に`AGENTS.md`によるカスタム指示が説明されています。Codexは作業前に`AGENTS.md`を読み、プロジェクト固有のルールや期待値を共有できます。([OpenAI Developers][7])

また、Codexのカスタマイズでは、`AGENTS.md`、pre-commit hooks、linters、skills、MCP、subagentsなどを使う構成が案内されています。([OpenAI Developers][8])

`AGENTS.md`にはこう書くと良いです。

```md
# AGENTS.md

このリポジトリでは、会社用のPowerPoint資料をコード生成します。

## 目的

AIっぽく見えない、洗練された、崩れにくい業務資料を作る。

## 制約

- スライドは必ず定義済みレイアウトから作成する
- 自由な座標指定は禁止。ただし layout ファイル内では許可
- テキストは必ず safeText() を通す
- 表は safeTable() を通す
- 図解は diagram components を使う
- 色、フォント、余白は theme.ts から参照する
- 生成後は npm run validate を実行する
- validate が失敗したら修正する

## デザイン方針

- 白背景またはごく薄いグレー背景
- 余白を広く取る
- 1スライド1メッセージ
- 装飾より情報設計を優先
- 見出しは短く、本文は少なく
- 表は詰め込まず、カード化・分割を優先
```

## 崩れないスライド生成のコツ

一番大事なのは、**AIに座標を考えさせないこと**です。

悪い例はこれです。

```ts
slide.addText("売上推移", { x: 0.7, y: 0.5, w: 8, h: 0.5 });
slide.addText(longText, { x: 0.7, y: 1.2, w: 8, h: 4 });
```

これだと、文章量が変わっただけで崩れます。

良い例はこれです。

```ts
addTwoColumnSlide(pptx, {
  title: "売上推移から見る今期の課題",
  left: {
    type: "chart",
    chart: salesChart,
  },
  right: {
    type: "bullets",
    items: [
      "既存顧客売上は安定",
      "新規獲得単価が上昇",
      "第3四半期以降は商談化率の改善が必要",
    ],
  },
});
```

AIには「このレイアウトを使って、ここに内容を入れる」だけをやらせます。

## 用意すべきスライド部品

最低限、以下をテンプレート化すると業務資料の8割は作れます。

| 種類                 | 用途     |
| ------------------ | ------ |
| Title              | 表紙     |
| Section            | 章扉     |
| Agenda             | 目次     |
| Executive Summary  | 要約     |
| Problem / Solution | 課題と打ち手 |
| Two Column         | 左右比較   |
| 3 Cards            | 3要素整理  |
| Table              | 比較表・一覧 |
| Chart              | グラフ    |
| Timeline           | スケジュール |
| Process            | 業務フロー  |
| Before / After     | 改善提案   |
| KPI Dashboard      | 数値報告   |
| Appendix           | 補足     |
| Closing            | 最終ページ  |

この中でも特に重要なのは、**Table、Chart、Diagram**です。
AIっぽい資料は、だいたい「テキストだけ」「余白がない」「図が雑」「表が詰まりすぎ」でバレます。

## デザインを“AIっぽくなく”するコツ

AIっぽくない資料にするには、派手なグラデーションや過剰なアイコンを避けたほうが良いです。

おすすめは、こういう方向です。

```txt
方向性：
- Notion / Linear / Stripe / Apple Keynote 系
- 余白広め
- 色数少なめ
- フォントサイズ大きめ
- 図形は角丸カード中心
- 罫線は薄く
- 強調色は1色だけ
- 本文は短く
```

具体的には、

```ts
export const theme = {
  colors: {
    bg: "F7F7F3",
    surface: "FFFFFF",
    text: "1E1E1E",
    muted: "6B7280",
    line: "E5E7EB",
    accent: "2563EB",
    accentSoft: "DBEAFE",
  },
  font: {
    heading: "Aptos Display",
    body: "Aptos",
    mono: "Aptos Mono",
  },
  spacing: {
    pageX: 0.65,
    pageTop: 0.45,
    gap: 0.22,
  },
};
```

日本語資料なら、フォントは環境依存を考えて、

```txt
Windows中心：Yu Gothic / Yu Gothic UI / Meiryo
Mac中心：Hiragino Sans
PowerPoint標準寄り：Aptos + 游ゴシック
```

あたりが無難です。

## はみ出し対策

はみ出し対策は、**生成後レビュー**ではなく、**生成時点で防ぐ**べきです。

具体的には、以下のような関数を用意します。

```ts
safeText({
  text,
  maxChars: 90,
  maxLines: 5,
  shrinkToFit: true,
  overflowStrategy: "split-slide",
});
```

方針はこうです。

| 問題        | 対策            |
| --------- | ------------- |
| 本文が長すぎる   | 箇条書きに要約       |
| 箇条書きが多すぎる | 2枚に分割         |
| 表が長すぎる    | autoPageまたは分割 |
| セル内の文字が長い | 改行・短縮・注釈化     |
| 図が複雑すぎる   | 2段階の図に分ける     |
| タイトルが長い   | サブタイトルへ逃がす    |

PptxGenJSの表にはauto-pagingがありますが、万能ではありません。表が大きい資料では「自動改ページに任せる」より、**最大行数を決めてAIに分割させる**ほうが品質が安定します。PptxGenJSのHTMLテーブル変換でも、セル単位のCSSは対応する一方、入れ子テーブルや単語単位のスタイルには制約があります。([gitbrent.github.io][9])

## 生成フローの理想形

AIにいきなりPowerPointを作らせるのではなく、次の流れにします。

```txt
1. ユーザーが資料の目的を伝える
2. AIがアウトラインを作る
3. AIが slide-spec.yaml を作る
4. 生成スクリプトが pptx を作る
5. validate で文字量・表・余白・禁止色をチェック
6. PDF化して見た目を確認
7. 必要ならAIが修正
```

`slide-spec.yaml`の例です。

```yaml
title: "生成AI活用による営業資料作成の効率化"
audience: "経営会議"
tone: "executive"
slides:
  - layout: title
    title: "生成AI活用による営業資料作成の効率化"
    subtitle: "テンプレート化による品質と速度の両立"

  - layout: executive-summary
    title: "要点"
    bullets:
      - "資料作成の属人性を下げられる"
      - "ブランド統一とレイアウト崩れ防止が重要"
      - "AIには自由作成ではなく定義済み部品を使わせる"

  - layout: two-column
    title: "従来方式と提案方式"
    leftTitle: "従来"
    leftBullets:
      - "担当者ごとにデザインが異なる"
      - "修正に時間がかかる"
      - "表や図が崩れやすい"
    rightTitle: "提案方式"
    rightBullets:
      - "レイアウトをコード化"
      - "Claude Code / Codexで自動生成"
      - "検証スクリプトで品質担保"
```

AIにはこのYAMLだけを編集させる。
PowerPoint生成の実体はコードが担当する。
これが一番安定します。

## 事例として参考になる方向性

大企業のブランドガイドラインやデザインシステムは、多くの場合「色・余白・タイポグラフィ・コンポーネント」を定義しています。スライド生成でも同じ考え方を使うべきです。

つまり、PowerPointを「毎回手作業でデザインするもの」ではなく、**UIコンポーネントのように再利用するもの**として扱います。

特に参考にしたいのは以下の考え方です。

```txt
Webデザインシステム的な考え方：
- theme tokens
- components
- layout primitives
- validation
- lint
- examples
- usage rules
```

スライドでいうと、

```txt
theme tokens      → 色、フォント、余白
components        → カード、ラベル、表、チャート、吹き出し
layout primitives → 1カラム、2カラム、3カード、タイムライン
validation        → 文字量、行数、表の行数、色の使用制限
lint              → 禁止フォント、禁止色、過剰文字数
examples          → 良い資料のサンプル
usage rules       → AI向けの作成ルール
```

です。

## Claude Code / Codexにやらせる具体的なコマンド

たとえばClaude Codeにこう頼めるようにします。

```txt
このメモをもとに、経営会議向けの10枚の提案資料を作って。
company-slide-kitのルールに従い、まずslide-spec.yamlを作成し、
その後npm run deckでpptxを生成し、npm run validateで修正して。
```

Codexにも同じように頼めます。

```txt
AGENTS.mdのルールに従って、examples/project-report.yamlを参考に、
新しい営業提案資料を作成してください。
既存レイアウトを優先し、必要な場合のみ新しいlayout関数を追加してください。
```

## 実装するなら最初に作るべきもの

最初から完璧なテンプレートを作るより、まず以下を作るのが良いです。

```txt
第1段階：
- theme.ts
- 8種類の基本レイアウト
- slide-spec.yaml形式
- pptx生成スクリプト
- 文字量チェック
- サンプル資料1本

第2段階：
- 表レイアウト
- チャートレイアウト
- タイムライン
- 業務フロー図
- PDF出力確認
- screenshot比較

第3段階：
- Claude Code Skill
- Codex用AGENTS.md
- 社内用プロンプト集
- デザインレビュー用subagent
- CIでの自動検証
```

最初のMVPは、8レイアウトで十分です。

```txt
1. title
2. section
3. agenda
4. executive-summary
5. two-column
6. three-cards
7. table
8. closing
```

## 最終的な理想像

最終的には、こういう運用にできます。

```txt
ユーザー：
「この議事録から、役員向けの報告資料を作って」

Claude Code / Codex：
1. 議事録を要約
2. 資料構成を作成
3. slide-spec.yamlを作成
4. 会社テンプレートでpptx生成
5. 文字量・表・図・余白を検証
6. pptxとpdfを出力
```

この方式なら、**資料作成の速度はかなり上がる**と思います。
特に、毎回ゼロからスライドを作るのではなく、**構造化されたYAML → コード生成 → PowerPoint出力**にすると、AIっぽさもレイアウト崩れもかなり抑えられます。

## 私のおすすめ結論

やるなら、この方針が一番いいです。

```txt
PowerPointテンプレート単体ではなく、
「会社用スライド生成キット」を作る。

中身は、
- PptxGenJS
- TypeScript
- theme.ts
- layout components
- slide-spec.yaml
- AGENTS.md
- CLAUDE.md
- Claude Code Skill
- validate script
で構成する。
```

そしてAIには、

```txt
デザインを考えさせるのではなく、
決められた美しい部品を選ばせる。
```

これが一番安定します。

[1]: https://gitbrent.github.io/PptxGenJS/?utm_source=chatgpt.com "Home | PptxGenJS"
[2]: https://gitbrent.github.io/PptxGenJS/docs/masters/?utm_source=chatgpt.com "Masters and Placeholders | PptxGenJS"
[3]: https://gitbrent.github.io/PptxGenJS/docs/api-tables.html?utm_source=chatgpt.com "Tables | PptxGenJS"
[4]: https://gitbrent.github.io/PptxGenJS/docs/api-charts/?utm_source=chatgpt.com "Charts | PptxGenJS"
[5]: https://code.claude.com/docs/en/memory?utm_source=chatgpt.com "How Claude remembers your project - Claude Code Docs"
[6]: https://code.claude.com/docs/en/skills?utm_source=chatgpt.com "Extend Claude with skills - Claude Code Docs"
[7]: https://developers.openai.com/codex/guides/agents-md?utm_source=chatgpt.com "Custom instructions with AGENTS.md – Codex"
[8]: https://developers.openai.com/codex/concepts/customization?utm_source=chatgpt.com "Customization – Codex"
[9]: https://gitbrent.github.io/PptxGenJS/docs/html-to-powerpoint.html?utm_source=chatgpt.com "HTML to PowerPoint | PptxGenJS"
