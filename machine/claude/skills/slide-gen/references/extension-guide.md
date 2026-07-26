# Extension Guide

slide-gen キットを拡張する手順。

## 新しいレイアウトを追加する

### 例: `quote` レイアウト（引用・名言を大きく見せる）を追加する場合

更新が必要なファイルは **5つ**：

#### 1. `src/types.ts` — 型に layout 名を追加

```typescript
export type SlideLayout =
  | 'title'
  | 'section'
  // ...
  | 'quote';     // ← 追加

export interface Slide {
  // ...
  quote?: string;       // ← 必要なら新フィールド
  attribution?: string; // ← 必要なら新フィールド
}
```

#### 2. `src/layouts/<name>.ts` — レイアウト本体を新規作成

```typescript
import type PptxGenJS from 'pptxgenjs';
import { theme } from '../theme.js';
import { addFooter } from '../components/footer.js';
import type { Slide } from '../types.js';

export function addQuoteSlide(
  pptx: PptxGenJS,
  slide: Slide,
  num: number,
  total: number,
): void {
  const s = pptx.addSlide();
  const { colors, font, slide: sz, spacing, fontSize } = theme;

  s.background = { color: colors.bg };

  s.addText(`"${slide.quote ?? ''}"`, {
    x: spacing.x, y: spacing.contentTop,
    w: sz.w - spacing.x * 2, h: spacing.contentH * 0.6,
    fontSize: 28,
    italic: true,
    color: colors.heading,
    fontFace: font.heading,
    align: 'center',
    valign: 'middle',
  });

  if (slide.attribution) {
    s.addText(`— ${slide.attribution}`, {
      x: spacing.x, y: spacing.contentTop + spacing.contentH * 0.65,
      w: sz.w - spacing.x * 2, h: 0.5,
      fontSize: fontSize.body,
      color: colors.muted,
      fontFace: font.body,
      align: 'center',
    });
  }

  addFooter(s, num, total);
}
```

#### 3. `src/layouts/index.ts` — エクスポート追加

```typescript
export { addQuoteSlide } from './quote.js';
```

#### 4. `src/generate.ts` — switch 文に case 追加

```typescript
case 'quote':
  addQuoteSlide(pptx, slide, num, total);
  break;
```

#### 5. `src/validate.ts` — 検証ルール追加

```typescript
const validLayouts = new Set([
  'title', 'section', /* ... */, 'quote',  // ← 追加
]);

// 必要なら専用ルール
if (layout === 'quote' && !slide.quote) {
  errors.push({ slide: num, layout, field: 'quote', message: 'quote layout requires a quote field.' });
}
```

#### 6. references/ 更新（任意だが推奨）

- `layout-catalog.md` に新レイアウトを追記
- `yaml-schema.md` に yaml 例を追記

## デザインを変える（ブランドカラー対応）

`src/theme.ts` の `colors` を編集する。

```typescript
colors: {
  accent: '2563EB',        // ← ブランド色1（強調色）
  accentDark: '1D4ED8',    // ← ブランド色1の暗色
  accentSoft: 'DBEAFE',    // ← ブランド色1の薄色
  heading: '111827',       // ← 見出し色
  // ...
}
```

ブランド色を変えるときは、accent / accentDark / accentSoft の3階調を作る（HSL で L を ±20 ずつずらすと自然）。

## フォントを変える

`src/theme.ts` の `font` を編集：

```typescript
font: {
  heading: 'Meiryo',       // ← Windows標準。Yu Gothic がない環境向け
  body: 'Meiryo',
}
```

候補:
- 日本語: `Yu Gothic` / `Meiryo` / `Hiragino Sans`（Mac）/ `Noto Sans CJK JP`（Linux）
- 英数字: `Aptos`（Office 2021+）/ `Segoe UI` / `Helvetica`

## 新しい Validation ルールを足す

`src/validate.ts` の `validateSpec` 関数に push 文を追加。例: bullet の文字数チェックを 80 → 60 に変えたい：

```typescript
slide.bullets.forEach((b, bi) => {
  if (b.length > 60) {  // ← 100 から変更
    errors.push({ slide: num, layout, field: `bullets[${bi}]`, message: `Bullet too long (${b.length} chars, max 60).` });
  }
});
```

## 新しいフィールドを追加する

例: 全スライドに `notes` （話者ノート）を埋め込みたい場合

1. `types.ts` の `Slide` インターフェースに `notes?: string` を追加（既にある）
2. 各 layout 関数で受け取り、`s.addNotes(slide.notes)` を呼ぶ共通処理を `components/` に切り出す
3. すべての layout から呼ぶ

## CI で自動検証する

`package.json` に validate スクリプトを使った CI を組み込めば、yaml 変更時にレイアウト崩れを事前に検出できる：

```yaml
# .github/workflows/validate.yml
- run: npm install
- run: |
    for f in examples/*.yaml; do
      npm run validate -- "$f" || exit 1
    done
```
