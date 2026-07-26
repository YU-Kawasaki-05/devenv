# Components catalog — Thinking Space session HTML

レンダリング担当が「思考ブリーフ → HTML部品」を組み立てるための部品集。
すべて `assets/theme.css` のクラスに対応。新しいCSSは足さない（既存クラスで組む）。

## 目次
- [グローバル原則](#グローバル原則)
- [ページ骨格](#ページ骨格)
- [初心者レイヤー（必須）](#初心者レイヤー必須)
- [結論・判定](#結論判定)
- [本文・強調](#本文強調)
- [表](#表)
- [カード / 比較](#カード--比較)
- [候補カード（深掘り）](#候補カード深掘り)
- [タイムライン](#タイムライン)
- [検証（週次）](#検証週次)
- [次の一手](#次の一手)
- [用語ツールチップ + 用語集](#用語ツールチップ--用語集)
- [出典](#出典)
- [思考ブリーフ → 部品の対応表](#思考ブリーフ--部品の対応表)

---

## グローバル原則
- **タイポグラフィ優先 / 余白多め / 色は抑制。** AI的な過剰装飾（むやみな絵文字・グラデ・影）は禁止。
- 色は**意味**にのみ使う: 緑=肯定/やさしい解説, 黄=注意/要検証, 赤=否定/危険, アクセント(藍)=重要。
- 各セクションは `<section id="..." class="section">` → 中に `<div class="prose">`。
- セクション見出しは `<span class="section__num">NN — ラベル</span>` + `<h2 class="section-head">…</h2>`。
- **すべての section id を TOC (`.toc`) と一致させる。** ずれると追従ハイライトが効かない。
- 専門的な内容ほど、直後に「やさしい言い換え」を添える（`.plain`）。

## ページ骨格
```html
<div class="progress"></div>
<button class="theme-toggle" aria-label="テーマ切替">☾</button>
<header class="wrap hero"> … </header>
<div class="doc">
  <nav class="toc" aria-label="目次"> … </nav>
  <main> <section> … </section> … <footer class="prose foot"> … </footer> </main>
</div>
<script src="../../assets/app.js"></script>
```
- CSS/JS 参照は必ず `../../assets/`（セッションは2階層下）。
- 文書言語は `<html lang="ja">`。

### ヒーロー
```html
<header class="wrap hero">
  <p class="eyebrow">意思決定レビュー · Decision-Grade</p>
  <h1>タイトル</h1>
  <p class="lede">1〜2文。<strong>核</strong>を太字で。</p>
  <div class="meta-row"><span>2026.06.28</span><span class="dot"></span><span>プロセス</span><span class="dot"></span><span>確信度 Medium</span></div>
  <div class="verdicts"><!-- 結論バッジ 1〜3個 --></div>
</header>
```

## 初心者レイヤー（必須）
判断ログは専門家にも初心者にも読めること。3点セットを必ず入れる。

**(1) やさしい要約**（ヒーロー直後・専門用語ゼロ）:
```html
<div class="easy">
  <span class="easy__label">◍ 5分で分かる（専門用語なし）</span>
  <h3>いま何を考えているか</h3>
  <p><strong>持っているもの：</strong>…</p>
  <p><strong>今の結論：</strong>…<span class="q">強調したい一節</span>…</p>
</div>
```

**(2) かみくだき注**（難しいセクションの見出し直下）:
```html
<div class="plain"><b>かみくだくと</b><span>専門用語を使わない一言要約。</span></div>
```

**(3) 用語ツールチップ + 用語集**（下記「用語ツールチップ」参照）。

## 結論・判定
**結論バッジ**（ヒーロー内 `.verdicts`）。`vbadge--go|warn|kill|neutral`：
```html
<span class="vbadge vbadge--go"><span class="tag">GO</span>やること</span>
<span class="vbadge vbadge--warn"><span class="tag">要検証</span>保留中の論点 <small>補足</small></span>
<span class="vbadge vbadge--kill"><span class="tag">しない</span>やめること</span>
```

**重要コールアウト**（本文中の強調ブロック）。左ボーダー色を変えて意味付け:
```html
<div class="callout"><p class="callout__label">最重要の理由</p><p>…</p></div>
<div class="callout" style="border-left-color:var(--go)">…肯定/結論…</div>
<div class="callout" style="border-left-color:var(--warn)">…注意/両刃…</div>
```

**プルクオート**（最重要の1行。セリフ体で1つだけ）:
```html
<blockquote class="pullquote">…核心の一文…<span class="mark">強調語</span>…</blockquote>
```

## 本文・強調
- 段落 `<p>`、太字 `<strong>`、取り消し（却下した旧案）`<span class="del">旧案</span>`。
- 箇条書き `<ul>/<ol>`。
- 証拠レベルのチップ（主張の根拠を明示）: `chip--fact`(緑)/`chip--infer`(藍)/`chip--assume`(黄)/`chip--judge`(灰)。
```html
<span class="chip chip--fact">FACT</span> <span class="chip chip--assume">Weak</span>
```
- 致命度/相性チップ: `chip--hi`(赤)/`chip--mid`(黄)/`chip--lo`(灰/緑系)。
- 強調チップ: `chip--lead`(本命/藍ベタ)/`chip--entry`(入口/藍淡)。

## 表
横スクロール対応のラッパで必ず包む（モバイルで崩れない）:
```html
<div class="table-scroll">
  <table>
    <thead><tr><th>列</th>…</tr></thead>
    <tbody>
      <tr><td>…</td></tr>
      <tr class="is-lead"><td>強調行</td>…</tr> <!-- 本命行に is-lead -->
    </tbody>
  </table>
</div>
```

## カード / 比較
```html
<div class="grid grid--2">  <!-- grid--2 / grid--3 -->
  <div class="card"><strong>見出し</strong><p>…</p></div>
</div>
```
**2項対立（例: レッドオーシャン vs 白地）**:
```html
<div class="grid grid--2">
  <div class="arena arena--red"><span class="arena__tag">RED OCEAN — 入るな</span><h3>…</h3><ul>…</ul><p class="verdict-line">→ 結論</p></div>
  <div class="arena arena--white"><span class="arena__tag">WHITE SPACE</span><h3>…</h3><ul>…</ul><p class="verdict-line">→ 結論</p></div>
</div>
```
**資産/要素リスト（keep/drop + 星）**:
```html
<ul class="assets">
  <li class="keep"><span class="ic">●</span><div><b>残す資産</b><span class="d">説明</span></div><span class="star">最重要</span></li>
  <li class="drop"><span class="ic">✕</span><div><b>捨てる</b><span class="d">説明</span></div></li>
</ul>
```

## 候補カード（深掘り）
選択肢を1枚ずつ詳細化（dt/dd）。本命は `cand--lead`:
```html
<div class="cand cand--lead">
  <span class="cand__tag">本命 B</span>
  <h3>候補名</h3>
  <dl>
    <dt>何をする</dt><dd>…</dd>
    <dt>使う資産</dt><dd>…</dd>
    <dt>法務の肝</dt><dd>…</dd>
    <dt>最大リスク</dt><dd>…</dd>
  </dl>
</div>
```

## タイムライン
時系列（規制・経緯など）。node の色で重大度:
```html
<ul class="timeline">
  <li><span class="node"></span><div class="when">2025.08 · 出典</div><div class="what">出来事</div><div class="why">含意</div></li>
  <li><span class="node node--warn"></span>…</li>
  <li><span class="node node--kill"></span>…</li>
</ul>
```

## 検証（週次）
1/2/4週などの実験計画。各カードに成功/失敗の基準:
```html
<div class="weeks">
  <div class="week">
    <div class="week__hd">1週</div><h4>テスト名</h4><p>やること。</p>
    <div class="crit crit--ok"><span class="k">○</span><span>成功基準</span></div>
    <div class="crit crit--no"><span class="k">✕</span><span>失敗基準</span></div>
  </div>
</div>
```

## 次の一手
```html
<div class="actions">
  <div class="action action--now"><span class="lab">今すぐ</span><p>…</p></div>
  <div class="action action--stop"><span class="lab">やるな</span><p>…</p></div>
  <div class="action action--kill"><span class="lab">Kill if</span><p>…</p></div>
  <div class="action action--up"><span class="lab">Double down if</span><p>…</p></div>
</div>
```

## 用語ツールチップ + 用語集
**インライン用語**（初出に点線＋ホバー/タップ定義）。`tabindex="0"` を必ず付ける:
```html
<span class="term" tabindex="0" data-def="やさしい1〜2文の定義。">専門用語</span>
```
**用語集セクション**（末尾近く）:
```html
<div class="glossary">
  <div class="gloss"><b>用語</b><span>定義。</span></div>
</div>
```

## 出典
```html
<ul class="cites">
  <li><span class="src">出典名</span><br><a href="https://…">短縮URL表記</a></li>
  <li><span class="unverified">⚠ 一次未確認</span> 二次情報の説明 <a href="…">URL</a></li>
</ul>
```
- **事実は捏造しない。** 確認できた一次/二次情報のみ。未確認は `.unverified` で明示。

---

## 思考ブリーフ → 部品の対応表
| 思考ブリーフの要素 | 使う部品 |
|---|---|
| 全体を一言で（素人向け） | `.easy`（やさしい要約） |
| 判定（GO/要検証/Kill 等）＋確信度 | ヒーロー `.verdicts` + 結論セクション |
| 一番刺さる1行 | `.pullquote` |
| 主張＋その根拠の強さ | `.callout` + 証拠チップ（fact/infer/assume） |
| 選択肢の一覧比較 | `.table-scroll` + `table`（本命行に `is-lead`） |
| 本命を1つずつ深掘り | `.cand`（`cand--lead`） |
| 2項対立・トレードオフ | `.arena`（red/white）or `.grid--2` の `.card` |
| 残す/捨てる資産 | `.assets`（keep/drop） |
| 関係者ごとの損得 | `table`（ステークホルダー / 欲しいもの / 降りるトリガー） |
| 時系列・経緯 | `.timeline` |
| 検証計画（期間×基準） | `.weeks` |
| 次アクション（今すぐ/やめる/分岐） | `.actions` |
| 専門用語 | `.term` ツールチップ + `.glossary` |
| 根拠資料 | `.cites`（未確認は `.unverified`） |

**鉄則:** どのセクションも「専門家が速く読める」かつ「初心者が `.plain`・`.term`・`.easy` で追える」の両立。判断は**結論→根拠→検証→次手**の順に流す。
