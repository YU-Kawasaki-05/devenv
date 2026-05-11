# BUILD.md — slide-gen (PPTX output)

Project-specific commands and structure. Common slide-kit rules: see `AGENTS.md`.

## Stack

- TypeScript + [PptxGenJS](https://gitbrent.github.io/PptxGenJS/) (PPTX generation)
- [MathJax](https://www.mathjax.org/) (equation rendering)
- YAML-driven manuscript → PPTX via code-defined layouts

## Commands

```bash
cd {{PROJECT_PATH}}

npm install                              # first time only
npm run validate -- examples/<name>.yaml # schema/limit validation
npm run deck     -- examples/<name>.yaml # validate + generate PPTX
# output → output/<name>.pptx
```

## Manuscript convention

- Location: `examples/YYYY-MM-DD-<topic>.yaml`
  - Example: `examples/2026-05-01-startup-industries.yaml`
- Temporary / uncommitted variants: `*.local.yaml` (gitignored)
- Output: `output/<same-name>.pptx` (gitignored)

## Directory layout

```
src/
  types.ts        — type definitions (incl. SlideLayout union)
  theme.ts        — design tokens (colors, fonts, spacing)
  math.ts         — MathJax rendering
  generate.ts     — main generation logic (layout dispatch)
  validate.ts     — YAML schema + limit checks
  index.ts        — CLI entry point
  layouts/        — one file per layout (title, two-column, table, ...)
  components/     — shared components (footer, safeText, ...)
examples/         — slide-spec YAML manuscripts
output/           — generated PPTX (gitignored)
```

## Schema & layout reference

`slide-spec.yaml` schema, available layouts, math syntax, design rules, and known
limitations are documented under `~/.claude/skills/slide-gen/references/`:

- `layout-catalog.md` — which layouts exist and when to use each
- `design-rules.md` — anti-patterns, do/don't examples
- `yaml-schema.md` — full schema reference
- `math-guide.md` — equation syntax and constraints
- `limitations.md` — known issues and workarounds
- `extension-guide.md` — adding new layouts

## Adding a new layout

1. `src/layouts/<name>.ts` に layout 関数を追加
2. `src/layouts/index.ts` にエクスポート追加
3. `src/generate.ts` の switch 文に case 追加
4. `src/validate.ts` に検証ルール追加
5. `src/types.ts` の `SlideLayout` union に追加
6. `~/.claude/skills/slide-gen/references/layout-catalog.md` に説明追加

## Hard limits (slide-gen specific)

| 項目     | 上限   | 超過時の対応             |
|----------|--------|--------------------------|
| math     | 3式/枚 | 分割 or 付録             |
| 表行数   | 6行    | 分割 or `autoPage`       |
| bullets  | 6項目  | 分割 or 章扉化           |
| cards    | 3枚    | 別レイアウトに変更       |
| 本文行数 | 5行    | 要約 or 分割             |

これらは `src/validate.ts` で機械的にチェックされる。

## Known limitations

未対応: チャート埋め込み / 画像埋め込み / カスタムブランド色UI / 直接PDF出力 / フォント自動置換

詳細・回避策: `~/.claude/skills/slide-gen/references/limitations.md`

## Iteration workflow

ユーザーから修正依頼が来たとき:

1. **YAML を直接編集**する（生成済み PPTX は絶対に触らない）
2. `npm run deck -- examples/<name>.yaml` で再生成
3. 生成された pptx のパスをユーザーに伝える
