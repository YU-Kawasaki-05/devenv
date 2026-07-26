---
name: slide-web-new
description: Use when creating high-quality HTML presentation slides — proposals, pitches, academic presentations, product overviews, company/service introductions, internal meeting decks, or workshop materials. Output is a single reveal.js HTML file (browser-viewable, full-screen, PDF-exportable). Design quality is the primary goal: typography-first, whitespace-generous, AI-default decoration is forbidden. Use slide-web-new when design quality matters. Use slide-gen when the recipient needs an editable PowerPoint.
---

# slide-web-new — Quick Reference

## Scaffold a new deck

```bash
bash ~/develop/slide-web-new/scripts/new-deck.sh <topic> <profile> [brand]
# → creates ~/develop/slide-web-new/decks/YYYY-MM-DD-<topic>/index.html
```

## Preview — serve from PROJECT ROOT

```bash
# ✅ Correct
python3 -m http.server 8080 --directory ~/develop/slide-web-new
# open: http://localhost:8080/decks/<YYYY-MM-DD-topic>/

# ❌ Wrong — CSS at ../../DESIGN/tokens.css returns 404, styles break
# python3 -m http.server 8080 --directory ~/develop/slide-web-new/decks/<deck>
```

## PDF export

```bash
# decktape (globally installed)
bash ~/develop/slide-web-new/scripts/export-pdf.sh <YYYY-MM-DD-topic>
# → decks/<deck>/<topic>.pdf  Server auto-starts if not running.
```

## Profile list

| Profile | Use case |
|---|---|
| `proposal` | Business proposals, executive decision documents |
| `overview` | Company, team, service, or project introduction |
| `product-overview` | Product features, capabilities, technical walkthroughs |
| `pitch` | Investor pitches, startup competitions |
| `academic` | Academic presentations, research talks, seminar reports |
| `internal` | Internal meetings, progress reports, decision memos |
| `workshop` | Training, onboarding, tutorials |

## Key workflow

1. **Ask the user to select a profile** (never auto-select — always show the list above)
2. **Read required files**: `DESIGN.md` + `profiles/<selected>.md` + relevant patterns from `DESIGN/patterns/`
3. **Propose outline**: one entry per slide — title, key message, layout description
4. **Get user approval** before generating
5. **Generate `index.html`** following the approved outline
6. **Run visual QA checklist** before reporting done

## Design system

| Path | Contents |
|---|---|
| `~/develop/slide-web-new/DESIGN.md` | Design system overview, how to use tokens and patterns |
| `~/develop/slide-web-new/DESIGN/tokens.css` | CSS variables and utility classes |
| `~/develop/slide-web-new/DESIGN/direction.md` | Visual direction and reference tone |
| `~/develop/slide-web-new/DESIGN/patterns/` | Slide composition patterns (reference; cover is the only fixed template) |
| `~/develop/slide-web-new/profiles/` | Per-profile rules and conventions |
| `~/develop/slide-web-new/brands/` | Brand theme files (CSS variables + assets) |

## Stack

- reveal.js 4.x (CDN) — navigation, fullscreen, PDF export
- KaTeX (CDN) — math: `$$...$$` blocks, `$...$` inline
- Mermaid (CDN) — diagrams: ` ```mermaid ` blocks
- pdflatex + dvisvgm — TikZ figure compilation; fall back to Mermaid on failure

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
- **Never** add `%%{init:...}%%` inside a diagram — conflicts with global init → blank box
- Use `<br/>` for line breaks in node labels, not `\n`
- Edge labels: use `-->|label|` without quotes

## Key constraints

- Always use CSS variables via utility classes — never inline styles for colors/fonts
- Cover pattern is fixed; all other slides are composed freely
- brand accent overrides profile accent; warn user if aesthetic conflict detected
- Propose outline first, generate HTML after approval
- Do not edit `index.html` after delivery — edit and regenerate
