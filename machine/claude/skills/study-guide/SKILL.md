---
name: study-guide
description: Use when creating a self-contained HTML learning guide for any technical concept — algorithms, data structures, CS theory, programming patterns, frameworks, math. Produces a polished, interactive browser-viewable file in textbook/. Trigger: user says "教材を作って", "HTMLで説明して", "わかりやすく解説して", "学習ガイドを作って", or asks to explain a concept for a textbook entry.
---

## What this skill produces

A single self-contained HTML file in `textbook/XXX_トピック名.html`.

- **自己完結** — 外部CDN・フォント・画像ゼロ。ブラウザで直接開ける
- **インタラクティブ** — トピックに合わせたシミュレーション・可視化
- **デザイン一貫** — 全ファイルが同一デザインシステムを使う
- **汎用** — アルゴリズム・CS理論・フレームワーク・数学など問わない

---

## Process

### Step 1: トピック分析

まずトピックを分類する：

| カテゴリ | 例 | インタラクティブ要素 |
|---|---|---|
| **グラフアルゴリズム** | BFS, DFS, ダイクストラ, クラスカル | SVG グラフ + ステップ実行 |
| **ソート・探索** | クイックソート, 二分探索 | SVG 配列アニメーション |
| **データ構造** | スタック, キュー, ヒープ, トライ木 | SVG 操作シミュレーション |
| **動的計画法** | ナップサック, LCS, 編集距離 | DPテーブル + セルハイライト |
| **数学・理論** | 素数篩, GCD, 組み合わせ論 | 計算ステップ可視化 |
| **プログラミングパターン** | クロージャ, ジェネレータ, Hooks | コード比較 + 動作トレース |
| **ネットワーク・OS** | TCP/IP, スケジューリング | 状態遷移図 + ステップ実行 |

インタラクティブ要素は「そのトピックで一番わかりにくい部分」に絞る。すべてにアニメーションをつけない。

### Step 2: ファイル番号の決定

```bash
ls textbook/ | sort  # 既存ファイルを確認
# → 001_BFS最短経路.html なら次は 002
```

形式: `XXX_トピック名.html`（XXX = 3桁ゼロ埋め）

### Step 3: コンテンツ設計

**必須セクション**（この順序）：
1. **問題/概念の本質** — 「何を解くものか」「どこで使うか」を1段落で
2. **なぜこれを選ぶのか** — 代替手法との比較表
3. **仕組み/手順** — ステップ形式で
4. **インタラクティブ演習** — シミュレーション（後述）
5. **実装** — シンタックスハイライト付きコード + 注釈付きコード
6. **計算量** — 時間・空間の両方
7. **よくある落とし穴** — 実際に踏みやすいもの4-5件
8. **実装チェックリスト** — テストケース付き

**省略可能**：
- 歴史的背景（試験範囲外なら不要）
- 高度な変形・応用（入門ガイドでは省く）

### Step 4: 生成 → 検証

生成後に必ず確認：
- `python3 -c "import html.parser; ..."` で構造チェック
- JSの波括弧バランス確認
- getElementById で参照するすべてのIDがHTML内に存在するか確認

---

## Design System

**このセクションの値は全ガイドで変えない。**

### CSS Custom Properties（必ずこの変数名を使う）

```css
:root {
  /* Backgrounds */
  --bg:        #07101C;
  --surface:   #0D1A28;
  --card:      #112236;
  --card-hi:   #152840;
  --border:    #1C3352;
  --border-2:  #264870;

  /* Semantic accent colors */
  --cyan:      #00C2E0;   /* primary / active state */
  --cyan-dim:  rgba(0,194,224,.12);
  --violet:    #8B5CF6;   /* goal / special state */
  --violet-dim:rgba(139,92,246,.14);
  --green:     #10B981;   /* success / found / path */
  --green-dim: rgba(16,185,129,.14);
  --amber:     #F59E0B;   /* queued / warning */
  --amber-dim: rgba(245,158,11,.14);
  --red:       #EF4444;   /* danger / error */
  --red-dim:   rgba(239,68,68,.12);

  /* Text */
  --txt:       #B8CDE0;
  --txt-hi:    #E0EDF8;
  --txt-muted: #3F6080;
  --txt-ghost: #112236;   /* ghost number behind headings */

  /* Fonts */
  --mono: ui-monospace,'Cascadia Code','SF Mono','Fira Code',Menlo,monospace;
  --sans: system-ui,-apple-system,'Segoe UI','Hiragino Sans','Noto Sans JP',sans-serif;

  /* Layout */
  --nav-w: 224px;
  --r: 7px;
}
```

### Typography Rules

- **見出し（h1, h2, section titles）** → `font-family: var(--mono)` — タイポグラフィ自体がテクニカルな主題を反映する
- **ボディテキスト** → `font-family: var(--sans)`
- **コード・ラベル・数値** → `font-family: var(--mono)`
- セクション番号は `var(--cyan)` で単色指定

### Ghost Section Numbers

各セクションの右端に大きな数字をゴーストとして配置する。コンテンツ背後に沈むことで視覚的な深みが出る：

```css
.sec { position: relative; }
.sec-ghost {
  position: absolute;
  right: -10px; top: -18px;
  font-family: var(--mono);
  font-size: 80px; font-weight: 800;
  color: var(--txt-ghost);       /* ほぼ見えない */
  line-height: 1;
  pointer-events: none;
  user-select: none;
  z-index: 0;
}
.sec-hd h2 { position: relative; z-index: 1; }  /* ghostの上に重ねる */
```

HTML:
```html
<section class="sec" id="s1">
  <div class="sec-hd">
    <div class="sec-num">1</div>
    <h2>セクションタイトル</h2>
    <div class="sec-ghost">1</div>
  </div>
  ...
</section>
```

---

## Component Patterns

以下のコンポーネントをコピーして使う。**クラス名は変えない**（デザイン一貫性のため）。

### Card（情報強調）

```html
<!-- cyan: キーポイント / green: 成功・推奨 / amber: 注意 / red: 危険 -->
<div class="card cyan">
  <div class="card-title">タイトル</div>
  <p>本文</p>
</div>
```

CSS（省略なし）:
```css
.card {
  background: var(--card); border: 1px solid var(--border);
  border-radius: var(--r); padding: 18px 22px; margin-bottom: 14px;
}
.card.cyan  { border-left: 3px solid var(--cyan);  background: var(--cyan-dim); }
.card.green { border-left: 3px solid var(--green); background: var(--green-dim); }
.card.amber { border-left: 3px solid var(--amber); background: var(--amber-dim); }
.card.red   { border-left: 3px solid var(--red);   background: var(--red-dim); }
.card-title {
  font-family: var(--mono); font-size: 12px; font-weight: 700;
  letter-spacing: .05em; text-transform: uppercase; margin-bottom: 8px;
}
.card.cyan .card-title  { color: var(--cyan); }
.card.green .card-title { color: var(--green); }
.card.amber .card-title { color: var(--amber); }
.card.red   .card-title { color: var(--red); }
```

### Comparison Table（アルゴリズム/手法の比較）

```html
<div class="tbl-wrap">
  <table class="tbl">
    <thead><tr><th>手法</th><th>特徴</th><th>この問題</th></tr></thead>
    <tbody>
      <tr>
        <td><span class="algo">BFS<small>幅優先探索</small></span></td>
        <td>近い順に展開</td>
        <td><span class="badge ok">✓ 最適</span></td>
      </tr>
    </tbody>
  </table>
</div>
```

バッジ: `.badge.ok`（緑）`.badge.ng`（赤）`.badge.so`（黄）

### Step-by-Step（アルゴリズム手順）

```html
<div class="steps">
  <div class="step-row">
    <div class="step-n">1</div>
    <div>
      <div class="step-title">ステップタイトル</div>
      <div class="step-desc">説明文</div>
    </div>
  </div>
</div>
```

### Code Block（シンタックスハイライト）

外部ライブラリ不使用。spanでトークンを手動でマークアップ：

```html
<div class="code-box">
  <div class="code-top">
    <div class="code-dots"><div class="cd"></div><div class="cd"></div><div class="cd"></div></div>
    <span class="code-lang">Python 3</span>
    <button class="copy-btn" onclick="copyCode()">copy</button>
  </div>
  <pre><span class="kw">from</span> collections <span class="kw">import</span> <span class="cls">deque</span>
<span class="cmt"># コメント</span>
<span class="fn">print</span>(<span class="num">42</span>)
</pre>
</div>
```

スパンクラス: `.kw`（キーワード、赤系） `.fn`（関数名、紫系） `.cls`（クラス名、青系） `.str`（文字列、水色） `.num`（数値、青） `.cmt`（コメント、グレー斜体）

### Annotated Code（行注釈付きコード）

```html
<div class="ann-code">
  <div class="ann-row hl">
    <div class="ann-ln">6</div>
    <div class="ann-code-cell"><span class="kw">for</span> x <span class="kw">in</span> items:</div>
    <div class="ann-note cyan">なぜこう書くか、の説明</div>
  </div>
</div>
```

### Pitfall Card（よくある落とし穴）

```html
<div class="pit">
  <div class="pit-hd">
    <div class="pit-n">1</div>
    <div class="pit-title">落とし穴のタイトル</div>
  </div>
  <div class="pit-body">何が起きるか・なぜ間違えるか</div>
  <div class="pit-fix">修正方法（"→ fix: " prefix は CSS ::before で自動付与）</div>
</div>
```

### Checklist

```html
<ul class="checklist">
  <li><span class="ck">✓</span><span>確認項目。<code>コード例</code>を含められる</span></li>
</ul>
```

---

## Interactive Visualization Patterns

### パターン A: ステップ実行シミュレーター（最頻出）

グラフ走査・ソート・探索など「状態が変わるアルゴリズム」に使う。

**構成要素：**
- SVG グラフ/配列（ドットグリッド背景付き）
- ステップ配列（JS）で各ステップの「全状態」を保持
- ← → ボタン + AutoPlay + キーボードナビ
- サイドパネル（キュー/スタック/その他の状態表示）
- ログパネル（その時点での操作をモノスペースで表示）
- 答えが出たら `.answer-box` を表示

**JS パターン：**
```javascript
const STEPS = [
  {
    title: "初期状態",
    // その時点での完全な状態を保持（差分ではなく全量）
    nodes: { A: 'queued', B: 'default', ... },
    edges: { 'A-B': 'default', ... },
    queue: [{n:'A', d:0}],
    log: ['<span class="op-title">初期化</span>', '<span class="op-line hi">ENQUEUE A</span>'],
    answer: null
  },
  // ...
];

let cur = 0, autoTimer = null;

function applyStep(idx) {
  cur = idx;
  const s = STEPS[idx];
  // DOMを更新 (状態 → スタイルのマッピングを関数化すると綺麗)
  // ボタン状態
  document.getElementById('prevBtn').disabled = idx <= 0;
  document.getElementById('nextBtn').disabled = idx >= STEPS.length - 1;
  // 進捗バー
  document.getElementById('progFill').style.width = ((idx+1)/STEPS.length*100) + '%';
}

function go(dir) {
  const n = cur + dir;
  if (n >= 0 && n < STEPS.length) applyStep(n);
}

document.addEventListener('keydown', e => {
  if (e.key === 'ArrowRight' || e.key === 'ArrowDown') go(1);
  if (e.key === 'ArrowLeft'  || e.key === 'ArrowUp')   go(-1);
});

applyStep(0);
```

**SVG ノード状態カラー：**
```javascript
const NODE_COLORS = {
  default:  { fill:'#112236', stroke:'#1C3352', text:'#B8CDE0', ring: null },
  queued:   { fill:'#1A2D10', stroke:'#F59E0B', text:'#E2EDF8', ring:'rgba(245,158,11,.3)' },
  current:  { fill:'#00C2E0', stroke:'#00C2E0', text:'#07101C', ring:'rgba(0,194,224,.35)' },
  visited:  { fill:'#0F1E30', stroke:'#264870', text:'#3F6080', ring: null },
  path:     { fill:'#0D2A1E', stroke:'#10B981', text:'#E2EDF8', ring:'rgba(16,185,129,.3)' },
  special:  { fill:'#150D2A', stroke:'#8B5CF6', text:'#B8CDE0', ring:'rgba(139,92,246,.25)' },
};
```

**SVG エッジアニメーション（CSS）：**
```css
.edge { transition: stroke .3s; }
.edge.active  { stroke: var(--cyan) !important; stroke-dasharray: 6 3;
                animation: dash-travel .5s linear infinite; }
.edge.on-path { stroke: var(--green) !important; stroke-width: 2.5 !important; }
@keyframes dash-travel { to { stroke-dashoffset: -9; } }
@media (prefers-reduced-motion: reduce) {
  .edge.active { animation: none; stroke-dasharray: none; }
}
```

**SVG バックグラウンドドットグリッド：**
```svg
<defs>
  <pattern id="dots" width="22" height="22" patternUnits="userSpaceOnUse">
    <circle cx="11" cy="11" r=".6" fill="#1C3352"/>
  </pattern>
</defs>
<rect width="100%" height="100%" fill="url(#dots)"/>
```

### パターン B: DPテーブル可視化

DP問題用。セルをハイライトしながら遷移を追う。

- `<table>` で行列を描く。各セルに `id="cell-i-j"` を付与
- STEPS配列でその時点でのテーブル全量を保持
- 現在の更新セルを `var(--cyan)` でハイライト
- 参照セルを `var(--amber-dim)` でハイライト

### パターン C: コード比較（パターン/アンチパターン）

フレームワーク・パターン説明用。左右に「悪い例」「良い例」を並べる。

```html
<div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;">
  <div>
    <div style="font-family:var(--mono);font-size:11px;color:var(--red);margin-bottom:8px;">✗ Before</div>
    <div class="code-box">...</div>
  </div>
  <div>
    <div style="font-family:var(--mono);font-size:11px;color:var(--green);margin-bottom:8px;">✓ After</div>
    <div class="code-box">...</div>
  </div>
</div>
```

### パターン D: インタラクティブ不要のケース

概念説明・理論・計算量分析など「動かすより読む方が速い」トピックには無理に入れない。代わりに annotated code や comparison table を充実させる。

**インタラクティブを入れない条件：**
- ステップが1-2しかない
- テキスト説明の方が明快
- 視覚的に表現できるグラフ/配列構造がない

---

## Layout Structure（全ガイド共通のHTML骨格）

```html
<div class="app">
  <!-- 固定左ナビ（セクションリンク + 進捗バー） -->
  <nav class="nav">
    <div class="nav-top"><!-- ファイル番号 + トピック名 --></div>
    <div class="nav-links"><!-- .nav-a[data-s="s1"] × セクション数 --></div>
    <div class="nav-foot"><!-- 進捗バー --></div>
  </nav>

  <main class="main">
    <!-- コンパクトなヒーロー（グラデーションヒーローは使わない） -->
    <header class="hero">
      <div class="hero-chips"><!-- トピックタグ --></div>
      <h2><!-- タイトル --></h2>
      <p><!-- 一文説明 --></p>
      <div class="hero-meta"><!-- 難易度・計算量・目標時間・キーAPI --></div>
    </header>

    <div class="body">
      <!-- §1〜§8 セクション -->
    </div>
    <footer><!-- トピック名 + メッセージ + ファイル番号 --></footer>
  </main>
</div>
```

TOCスクロールスパイ（全ガイドで必須）：
```javascript
const spy = new IntersectionObserver(entries => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      document.querySelectorAll('.nav-a[data-s]')
        .forEach(a => a.classList.toggle('active', a.dataset.s === e.target.id));
    }
  });
}, { rootMargin: '-15% 0px -65% 0px', threshold: 0 });
document.querySelectorAll('.sec').forEach(s => spy.observe(s));
```

---

## Quality Checklist

生成後にこれを確認してから完了報告する：

**構造**
- [ ] HTMLタグの開閉が整合している
- [ ] JSの波括弧・丸括弧バランスが取れている（`{` count == `}` count）
- [ ] `getElementById()` で参照するIDが全てHTMLに存在する

**デザイン**
- [ ] CSS変数は全て `:root` 内で定義されている
- [ ] 外部CDN・webfont URLは一切ない（自己完結）
- [ ] `prefers-reduced-motion` でアニメーションが止まる
- [ ] モバイル（≤840px）でサイドバーが非表示になる
- [ ] テーブル・コードブロックに `overflow-x: auto` がある

**コンテンツ**
- [ ] 全8セクションが揃っている
- [ ] インタラクティブ要素がある（不要と判断した場合は理由を明記）
- [ ] テストケースが最低3件ある（正常・到達不能/エラー・境界値）
- [ ] ghost セクション番号が入っている

**ファイル**
- [ ] `textbook/XXX_トピック名.html` に保存されている
- [ ] 番号が既存ファイルと重複していない

---

## CLAUDE.md への追記

新しいガイドを作ったら、`develop/atcoder/CLAUDE.md` の Textbook セクションに追記する：

```markdown
- `002_DFS深さ優先.html` — DFS・バックトラッキングの基礎
```

---

## 禁止事項

- 外部 CDN（highlight.js, D3.js, Chart.js 等）の読み込み ← CSPで弾かれる可能性＆自己完結が崩れる
- グラデーションのヒーローバナー ← AI生成デザインのデフォルト外観
- emoji を主要セクションマーカーとして使う ← デコレーション優先になる
- アニメーションを「見栄えのため」だけに入れる ← 状態遷移を説明するときのみ
- lorem ipsum / プレースホルダーコンテンツ ← 必ず実際の入力例・コードで埋める
- `.card` を全セクションに多用する ← 強調が薄れる。本当に重要な1-2箇所だけ
