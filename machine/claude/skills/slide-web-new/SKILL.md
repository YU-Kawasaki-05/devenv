---
name: slide-web-new
description: Use when creating high-quality HTML presentation slides — proposals, pitches, academic presentations, product overviews, company/service introductions, internal meeting decks, or workshop materials. Output is a single reveal.js HTML file (browser-viewable, full-screen, PDF-exportable via ?print-pdf). Design quality is the primary goal: typography-first, whitespace-generous, AI-default decoration is forbidden. Use slide-web-new when design quality matters. Use slide-gen when the recipient needs an editable PowerPoint.
---

## Quick Reference

```bash
# Scaffold a new deck
bash ~/develop/slide-web-new/scripts/new-deck.sh <topic> <profile> [brand]

# Preview — ⚠️ must serve from PROJECT ROOT (not deck dir)
python3 -m http.server 8080 --directory ~/develop/slide-web-new
# Then open: http://localhost:8080/decks/<YYYY-MM-DD-topic>/
# (Serving from the deck dir makes ../../DESIGN/tokens.css return 404 → broken styles)

# Compile TikZ figure to SVG
bash ~/develop/slide-web-new/scripts/tikz-to-svg.sh input.tex decks/<deck>/assets/figure.svg

# PDF export (decktape — global install済み)
bash ~/develop/slide-web-new/scripts/export-pdf.sh <YYYY-MM-DD-topic>
# → decks/<deck>/<topic>.pdf に出力。サーバー未起動なら自動起動
```

## Profiles

| Profile | Use case |
|---|---|
| `proposal` | Business proposals, consulting recommendations, executive decision docs |
| `overview` | Company, team, service, or project introductions (general) |
| `product-overview` | Product features, capabilities, technical walkthroughs |
| `pitch` | Investor pitches, startup competitions, partner pitches |
| `academic` | University presentations, research talks, seminar reports |
| `internal` | Internal meetings, progress reports, decision memos |
| `workshop` | Training, onboarding, tutorials, hands-on sessions |

## Required reading before generating

Always read in this order:
1. `~/develop/slide-web-new/AGENTS.md`
2. `~/develop/slide-web-new/BUILD.md`
3. `~/develop/slide-web-new/DESIGN.md`
4. `~/develop/slide-web-new/profiles/<selected>.md`
5. Relevant patterns from `~/develop/slide-web-new/DESIGN/patterns/`

## Workflow (always follow this order)

1. **Profile selection** — Ask the user to choose a profile. Never auto-select.
2. **Read design system** — DESIGN.md + selected profile
3. **Propose outline** — For each slide: title + key message + evidence / assumption + layout description + decision role
4. **User approves** — Do not generate HTML until proposal is approved
5. **Generate** — Create the complete `decks/YYYY-MM-DD-<topic>/index.html`
6. **QA checklist** — Verify before reporting done (see below)

## QA checklist (run before reporting complete)

- [ ] Every slide has exactly one main message
- [ ] No hardcoded colors — only CSS custom properties
- [ ] Cover slide uses the cover.html pattern structure
- [ ] No AI-default decoration (no gradients, no drop shadows, no clip-art)
- [ ] Text fits within slide bounds (no overflows)
- [ ] Profile accent color is used consistently
- [ ] Mermaid/KaTeX blocks are valid syntax
- [ ] Browser QA was run with `scripts/qa-deck.js <deck-name>` when available; report any remaining warnings

## Proposal quality gate

For `proposal`, do not accept an outline that is only a sequence of topics. Each slide must earn its place in the decision argument:

- **Decision role:** why this slide is needed for approval or action
- **Evidence / assumption:** observed symptom, source, data, or clearly labeled assumption
- **Visual job:** how the layout makes the idea faster to grasp than bullets
- **Tradeoff:** where relevant, what is intentionally not included yet

If these fields are weak, revise the outline before generating HTML.

## Mermaid diagrams — known gotchas

```html
<!-- ✅ Correct -->
<pre class="mermaid">
flowchart LR
  A["ノードA<br/>2行目"]:::box --> B["ノードB"]:::hi
  classDef box fill:#F3F4F6,stroke:#374151,color:#111827
  classDef hi fill:#374151,stroke:#374151,color:#ffffff
</pre>
```

- `mermaid.initialize()` must set `theme: 'base'` and `flowchart: { htmlLabels: true }`
- **Never** add `%%{init:...}%%` inside a diagram — it conflicts with the global init and causes silent render failure (blank box)
- Use `<br/>` for line breaks in node labels, not `\n`
- Edge labels: use `-->|label|` without quotes

## Key constraints

- Never select a profile without asking the user
- Never generate HTML without proposing the outline first
- Never use hardcoded colors — always `var(--accent)`, `var(--text)`, etc.
- Never add decoration not defined in DESIGN.md
- Patterns in `DESIGN/patterns/` are reference examples, not mandatory templates
- Exception: `cover.html` pattern structure is required for the first slide
- Brand always overrides profile accent color; warn if aesthetic conflict
- TikZ compile failure → offer Mermaid re-render as fallback
