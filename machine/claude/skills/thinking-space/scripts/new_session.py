#!/usr/bin/env python3
"""
Scaffold a new Thinking Space session and register it in the hub.

- Bootstraps the design system (assets/theme.css, assets/app.js) and hub
  (index.html) into the target space if they are missing (never clobbers
  existing files).
- Creates sessions/<date>_<slug>/index.html from the session template, with
  hero metadata filled in. Remaining {{PLACEHOLDERS}} are for the renderer to
  fill using references/components.md.
- Registers the session in the hub's THINKING_SESSIONS array (inserts a skeleton
  entry; the renderer fills tags/verdicts).

Usage:
  new_session.py --slug premake-pivot --date 2026-06-28 --title "premake — 何に賭けるか" \
                 --summary "一文要約" [--space ~/develop/thinking-space] \
                 [--eyebrow "意思決定レビュー · Decision-Grade"] [--process "kill-or-pivot → decision-grade"] \
                 [--confidence Medium] [--force] [--no-register]

Date must be passed explicitly (scripts cannot reliably know "today").
"""
import argparse
import json
import os
import re
import shutil
import sys
from pathlib import Path

SKILL_ROOT = Path(__file__).resolve().parent.parent
ASSETS = SKILL_ROOT / "assets"
DEFAULT_SPACE = Path(os.path.expanduser("~/develop/thinking-space"))
SLUG_RE = re.compile(r"^[a-z0-9][a-z0-9-]*$")
DATE_RE = re.compile(r"^\d{4}-\d{2}-\d{2}$")
MARKER = "/* <<NEW_SESSIONS>> */"


def copy_if_missing(src: Path, dst: Path) -> str:
    if dst.exists():
        return f"keep   {dst}"
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(src, dst)
    return f"create {dst}"


def fill_template(text: str, mapping: dict) -> str:
    for key, val in mapping.items():
        text = text.replace("{{" + key + "}}", val)
    return text


def register_in_hub(hub_path: Path, date: str, title: str, href: str, summary: str) -> str:
    html = hub_path.read_text(encoding="utf-8")
    if f'"{href}"' in html or f"'{href}'" in html:
        return "hub: already registered (skipped)"
    entry = (
        "\n  {\n"
        f"    date: {json.dumps(date, ensure_ascii=False)},\n"
        f"    title: {json.dumps(title, ensure_ascii=False)},\n"
        f"    href: {json.dumps(href, ensure_ascii=False)},\n"
        f"    summary: {json.dumps(summary, ensure_ascii=False)},\n"
        "    tags: [],        // TODO(renderer): 3〜6個\n"
        "    verdicts: []     // TODO(renderer): {kind:'go|warn|kill|neutral', tag, label}\n"
        "  },"
    )
    if MARKER in html:
        html = html.replace(MARKER, MARKER + entry, 1)
        hub_path.write_text(html, encoding="utf-8")
        return "hub: registered (fill tags/verdicts)"
    # fallback: marker missing (hand-edited hub, or consumed by an earlier
    # session). Insert right after the array opening and re-add the marker so
    # future runs auto-register again.
    anchor = "window.THINKING_SESSIONS = ["
    idx = html.find(anchor)
    if idx != -1:
        at = idx + len(anchor)
        html = html[:at] + "\n  " + MARKER + entry + html[at:]
        hub_path.write_text(html, encoding="utf-8")
        return "hub: registered via array anchor (marker restored; fill tags/verdicts)"
    return (
        "hub: could not auto-register (no marker, no array) — add manually:\n" + entry
    )


def main() -> int:
    ap = argparse.ArgumentParser(description="Scaffold a Thinking Space session.")
    ap.add_argument("--slug", required=True, help="kebab-case slug (e.g. premake-pivot)")
    ap.add_argument("--date", required=True, help="YYYY-MM-DD (pass today's date explicitly)")
    ap.add_argument("--title", required=True)
    ap.add_argument("--summary", default="")
    ap.add_argument("--space", default=str(DEFAULT_SPACE), help="thinking-space root")
    ap.add_argument("--eyebrow", default="意思決定レビュー")
    ap.add_argument("--process", default="thinking → render")
    ap.add_argument("--confidence", default="Medium")
    ap.add_argument("--force", action="store_true", help="overwrite existing session")
    ap.add_argument("--no-register", action="store_true", help="skip hub registration")
    args = ap.parse_args()

    if not SLUG_RE.match(args.slug):
        print(f"[ERROR] slug must be kebab-case [a-z0-9-]: {args.slug!r}")
        return 1
    if not DATE_RE.match(args.date):
        print(f"[ERROR] date must be YYYY-MM-DD: {args.date!r}")
        return 1

    space = Path(os.path.expanduser(args.space)).resolve()
    space.mkdir(parents=True, exist_ok=True)

    print("space:", space)
    # 1) bootstrap design system + hub (idempotent, never clobber)
    print(" ", copy_if_missing(ASSETS / "theme.css", space / "assets" / "theme.css"))
    print(" ", copy_if_missing(ASSETS / "app.js", space / "assets" / "app.js"))
    print(" ", copy_if_missing(ASSETS / "hub-template.html", space / "index.html"))

    # 2) scaffold session
    session_dir = space / "sessions" / f"{args.date}_{args.slug}"
    session_file = session_dir / "index.html"
    if session_file.exists() and not args.force:
        print(f"[ERROR] session exists (use --force): {session_file}")
        return 1
    session_dir.mkdir(parents=True, exist_ok=True)
    tpl = (ASSETS / "session-template.html").read_text(encoding="utf-8")
    tpl = fill_template(
        tpl,
        {
            "TITLE": args.title,
            "SUMMARY": args.summary,
            "DATE": args.date.replace("-", "."),
            "EYEBROW": args.eyebrow,
            "PROCESS": args.process,
            "CONFIDENCE": args.confidence,
        },
    )
    session_file.write_text(tpl, encoding="utf-8")
    print("  create", session_file)

    # 3) register in hub
    if not args.no_register:
        href = f"sessions/{args.date}_{args.slug}/index.html"
        print(" ", register_in_hub(space / "index.html", args.date, args.title, href, args.summary))

    print("\nNext: fill the {{PLACEHOLDERS}} and add sections in")
    print(f"  {session_file}")
    print("using patterns in references/components.md, then complete the hub entry's tags/verdicts.")
    print(f"Verify: scripts/render_check.py {session_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
