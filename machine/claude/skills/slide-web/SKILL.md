---
name: slide-web
description: Use when creating HTML/PDF-based presentation slides, polished proposals, company/product overviews, pitch decks, academic/research presentations, progress reports, internal meeting decks, or any web-published slide material. Output is Slidev HTML (browser-previewable, animatable, URL-shareable) with optional PDF export. Use slide-web when the recipient mainly reads/views the deck; use slide-gen when the recipient needs an editable PowerPoint deck.
---

## Quick Reference

```bash
cd ~/develop/slide-web
npm install

npm run new -- <topic> <profile> <internal|external> [brand]
npm run dev -- slides/<YYYY-MM-DD-topic>/slides.md
npm run build -- slides/<YYYY-MM-DD-topic>/slides.md
npm run export -- slides/<YYYY-MM-DD-topic>/slides.md --output slides/<YYYY-MM-DD-topic>/<topic>.pdf
```

Examples:

```bash
npm run new -- product-intro product-company-overview external
npm run new -- weekly progress-report internal
npm run new -- research-update academic-research external default
```

## Role

Use the Slidev-based `~/develop/slide-web/` kit to create polished HTML/PDF decks from structured Markdown. Treat the deck as a composition of:

- profile: what kind of deck this is
- pattern: what each slide is doing
- theme: internal or external visual density
- brand: company/product visual tokens and assets

## Use Slide-Gen Instead When

- The recipient must edit the result in PowerPoint.
- The output must be a native PPTX with editable shapes.
- The task is mainly PPTX automation rather than an HTML/PDF/URL-shareable deck.

## Required Reading

Before creating or heavily editing a deck, read only the relevant files:

- `~/develop/slide-web/AGENTS.md`
- `~/develop/slide-web/BUILD.md`
- `~/develop/slide-web/references/profile-selector.md`
- `~/develop/slide-web/references/visual-direction.md`
- The selected `~/develop/slide-web/references/profiles/<profile>.md`
- Pattern files under `references/patterns/` only when needed
- `brands/<brand>/brand.md` and `theme.css` when a brand is specified

## Profiles

Supported profiles:

- `consulting-proposal`: executive proposal and decision material
- `service-proposal`: customer-facing service or solution proposal
- `product-company-overview`: company, product, business, or technology overview
- `startup-pitch`: investor, contest, or partner pitch
- `academic-research`: university, seminar, research, or technical presentation
- `progress-report`: weekly, monthly, project, or research progress report
- `internal-meeting`: internal meeting, decision memo, discussion deck

If the user does not specify a profile, choose one from `profile-selector.md`. Ask only when the reader, goal, or usage would materially change the profile.

## Process

1. Select profile, theme, and brand.
   - Use `external` for proposals, public material, company/product overviews, pitches, and formal research presentations.
   - Use `internal` for internal meetings, progress reports, and working sessions.
   - Use `default` brand unless the user provides a brand.
2. Draft the structure from the selected profile.
   - Do not fix slide count upfront.
   - Let information volume, presentation time, and reading context drive split/merge decisions.
   - Move dense details to appendix.
3. Create the deck:
   ```bash
   npm run new -- <topic> <profile> <theme> <brand>
   ```
4. Edit `slides/<deck>/slides.md`.
   - Use per-slide `class` values such as `cover`, `summary`, `problem`, `solution`, `comparison`, `roadmap`, `metrics`, `status`, `decision`, `next-actions`.
   - Prefer existing classes, theme tokens, and brand variables over one-off CSS.
5. Build or preview.
   ```bash
   npm run build -- slides/<deck>/slides.md
   ```
   Use `npm run dev` when visual iteration is needed.
6. Export PDF with the standard per-slide path when PDF delivery is needed.
   ```bash
   npm run export -- slides/<deck>/slides.md --output slides/<deck>/<topic>.pdf
   ```
   Use `npm run export:onepiece` only when intentionally debugging Slidev's one-piece `/print` route or when validating TOC/cross-slide links.
7. Perform visual QA before reporting completion.

## Visual QA

Check:

- The first two or three slides match the selected profile's job.
- Each slide has one main message.
- Text, tables, and notes fit within the slide.
- The deck is not just title + bullets repeated.
- Pattern classes are used consistently.
- No invented colors, fonts, gradients, or decorative icons were added.
- If PDF export matters, the deck still makes sense when animations are static.
- Confirm PDF page count and text extraction for important submissions when possible.

## Iteration

| Request | Response |
|---|---|
| Shorter | Reduce bullets, merge low-value slides, move detail to appendix |
| More detail | Add evidence slides or appendix; do not overload existing slides |
| Change order | Reorder sections in `slides.md` |
| Change theme | Update deck-local `style.css` imports |
| Use brand | Add or update `brands/<name>/` assets and variables |
| More visual | Convert bullets into existing pattern classes before adding CSS |

## Constraints

- Never edit generated HTML/PDF/dist output directly.
- Do not write coordinates, one-off colors, or inline styles in manuscripts.
- Do not invent brand colors or logo treatments.
- Use existing profile, pattern, theme, and brand structure.
- Keep body text within the slide-kit limits unless the content is explicitly appendix material.
