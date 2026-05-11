# GitHub Copilot Instructions — {{PROJECT_NAME}}

This project is part of the **slide-kit** profile (managed by `~/develop/devenv/`).

## Required reading

- **`AGENTS.md`** — source of truth for slide-kit rules (design, constraints, workflow)
- **`BUILD.md`** — project-specific build commands, directory layout, content schema

Read both files before suggesting edits.

## Key rules for Copilot suggestions

- Suggest edits to **source manuscripts** (YAML / Markdown), never to generated output (`.pptx` / `.html` / `.pdf`)
- Do **not** suggest hard-coded coordinates, pixel values, or one-off colors — always reference theme tokens
- Respect text-count limits: 5 body lines, 6 bullets, 6 table rows, 3 cards per slide
- One message per slide; if a suggestion would put two messages on one slide, split into two
- Match the existing manuscript style — do not introduce new schema fields, layouts, or themes without explicit instruction
- Do not auto-suggest decorative elements (gradients, shadows, extra icons, multiple accent colors)

## What to avoid suggesting

- Direct edits to files in `output/`, `dist/`, or any build artifact directory
- Coordinate/pixel/font-size literals in manuscripts
- "Cleanup" refactors of theme files unless asked
- New dependencies — flag them for human review instead
