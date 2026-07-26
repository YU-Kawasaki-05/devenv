---
name: thinking-space
description: Turn finished thinking — a decision, strategy review, kill-or-pivot/decision-grade analysis, option exploration, or research — into a polished, browsable HTML "session" under develop/thinking-space, and register it in the hub index. Produces a typography-first decision log that is readable by both experts and beginners (easy summary, plain-language notes, glossary tooltips). Use when the user wants to reflect/capture/log thinking into HTML, "思考をHTMLにして", "thinking-space に反映", "意思決定/検討をHTML化", "decision log を作って", or to update an existing thinking-space session after a conclusion changed. Render as a step separate from thinking (prefer a subagent) — never interleave HTML writing with the analysis itself.
---

# Thinking Space

Render already-converged thinking into a self-contained HTML decision log under `develop/thinking-space`, then register it in the hub so it is browsable and reviewable over time.

## Core principle: separate thinking from rendering

Do **not** interleave HTML authoring with the analysis. Thinking and rendering are different modes and pollute each other. Sequence them:

1. **Phase 1 — Think.** Finish the analysis first (in the conversation, or via skills like decision-grade-review / kill-or-pivot, or a thinking subagent). Converge to a verdict before touching HTML.
2. **Phase 2 — Render.** Hand the converged thinking to a rendering step — **preferably a fresh subagent** — whose only job is to produce the HTML. The subagent works from the *thinking brief*, not from the messy thinking transcript.

This keeps each mode clean and matches how the log should read: conclusion → evidence → validation → next steps.

## Phase 1 — Produce a thinking brief

Before rendering, write a compact **thinking brief** (plain text) capturing only the converged content:

- **Title**, one-line **lede**, **date** (YYYY-MM-DD), confidence.
- **Verdict(s)**: 1–3 badges, each GO / 要検証 / Kill / neutral.
- **Easy summary**: 3–6 sentences a non-expert understands, no jargon.
- **Sections** in order (conclusion → reasoning → options/comparison → stakeholders → timeline → validation → next steps), each with its key points, tables, and any candidate cards.
- **Evidence level** per major claim (fact / inference / assumption), and **citations** (URLs); mark anything unverified.
- **Glossary**: jargon terms used, with one-line plain definitions.

If the thinking is not yet converged, finish it first (or delegate the analysis to a subagent). Do not start rendering on unsettled thinking.

## Phase 2 — Render (delegate to a subagent)

Default to spawning a fresh subagent for rendering. Give it the brief + this skill path; keep the analysis transcript out. Suggested subagent prompt:

```
Use the thinking-space skill at ~/.claude/skills/thinking-space to render the
following thinking brief into an HTML session under ~/develop/thinking-space.

Steps:
1. Read SKILL.md and references/components.md in the skill.
2. Run scripts/new_session.py with the brief's slug/date/title/summary to scaffold
   the session, bootstrap the design system, and register the hub entry.
3. Fill the session index.html from the brief using the components in
   references/components.md (conclusion → reasoning → options → stakeholders →
   timeline → validation → next steps → glossary → sources). Keep the mandatory
   beginner layer (easy summary, かみくだき notes, term tooltips, glossary).
4. Complete the hub entry's tags (3–6) and verdicts.
5. Verify with scripts/render_check.py (light + --dark) and fix any layout/contrast issues.
Return the session file path.

THINKING BRIEF:
<paste the brief here>
```

If not delegating, perform the same steps inline — but only after Phase 1 is done.

### Step 1 — Scaffold + bootstrap + register

```bash
scripts/new_session.py --slug <kebab-slug> --date <YYYY-MM-DD> \
  --title "<title>" --summary "<one-line>" \
  [--space ~/develop/thinking-space] [--eyebrow "..."] [--process "..."] [--confidence Medium]
```

This: copies `assets/theme.css` + `assets/app.js` + the hub `index.html` into the space **only if missing** (never clobbers); creates `sessions/<date>_<slug>/index.html` from the template with hero metadata filled; inserts a skeleton hub entry. Pass `--date` explicitly — scripts cannot know "today"; use the date from context.

### Step 2 — Fill the session HTML

Open `sessions/<date>_<slug>/index.html`, replace the `{{PLACEHOLDERS}}`, and build the body using **references/components.md** (the component catalog — read it). Map brief → components via the table at the end of that file. Requirements:

- **Beginner + expert both** (the user requires this): keep the `.easy` summary, add `.plain` "かみくだくと" notes under hard sections, wrap jargon in `.term` tooltips (`tabindex="0"`), and include a `.glossary`.
- **Typography-first, color = meaning** (green=肯定/解説, 黄=注意, 赤=否定, 藍=重要). No gratuitous decoration.
- **TOC ↔ section ids must match** (drives scroll-spy).
- CSS/JS paths are `../../assets/...`. Do not add new CSS — compose with existing classes.
- **Never fabricate** facts/citations; mark unverified sources with `.unverified`.

### Step 3 — Complete the hub entry

Edit the entry that `new_session.py` inserted in `index.html`'s `THINKING_SESSIONS` array: fill `tags` (3–6) and `verdicts` (`{kind, tag, label}`, kind = go/warn/kill/neutral).

### Step 4 — Verify

```bash
scripts/render_check.py <session/index.html>            # light, single PNG (short pages)
scripts/render_check.py <session/index.html> --dark     # dark theme
scripts/render_check.py <session/index.html> --tiles    # long pages: full page → readable 3200px tiles
```

Read the PNG(s); check hierarchy, spacing, color meaning, mobile-safe tables (must scroll, not break), and contrast in both themes. Fix issues. If no Chromium, open the file in a browser to verify.

> Decision logs are usually long (often >10000px). The default single screenshot only captures the top — use `--tiles` to slice the whole page into readable tiles (needs Pillow), and `--dark` to spot-check contrast. Delete the generated PNG(s) when done so they don't ship with the session.

## Updating an existing session

When a premise changed, **update in place** — keep the slug/path stable (stable URL), evolve the content, and sync the hub entry's `summary`/`verdicts`. Do not spawn a new session for the same line of thinking. Re-run `render_check.py` after edits.

## Layout

```
develop/thinking-space/
├── index.html                          # hub (browse/search/filter; data-driven)
├── assets/{theme.css, app.js}          # shared design system (single source of truth)
└── sessions/<date>_<slug>/index.html   # one session = one decision log
```

Bundled resources:
- `assets/` — `theme.css`, `app.js`, `hub-template.html`, `session-template.html` (copied into the space as needed).
- `references/components.md` — the HTML component catalog + brief→component mapping. **Read before rendering.**
- `scripts/` — `new_session.py` (scaffold/bootstrap/register), `render_check.py` (headless screenshot verify).
