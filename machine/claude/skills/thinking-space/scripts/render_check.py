#!/usr/bin/env python3
"""
Render a Thinking Space HTML file to a PNG with headless Chromium, for visual
self-verification (the agent should Read the PNG and inspect layout/contrast).

Usage:
  render_check.py <path-to.html> [--out /tmp/ts-check.png] [--width 1280] [--height 2200] [--dark]
  render_check.py <path-to.html> --tiles            # full page, sliced into readable tiles
  render_check.py <path-to.html> --tiles --dark     # same, dark theme

--dark forces dark theme by injecting data-theme="dark" into a temp copy (so the
screenshot is not dependent on prefers-color-scheme / localStorage).

--tiles captures a tall page and slices it into vertical tiles (default 3200px)
so a long decision log can be Read at full resolution instead of one giant,
downscaled PNG. Needs Pillow; without it, falls back to the single screenshot.

Exits non-zero if no Chromium binary is found (then verify by opening in a browser).
"""
import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

CANDIDATES = ["chromium", "chromium-browser", "google-chrome", "google-chrome-stable", "chrome"]


def find_chromium() -> str | None:
    for name in CANDIDATES:
        path = shutil.which(name)
        if path:
            return path
    return None


def tile_image(png_path: str, tile_h: int) -> int:
    """Slice a tall screenshot into readable vertical tiles (trims trailing
    background whitespace first). Falls back gracefully if Pillow is missing."""
    try:
        from PIL import Image
    except Exception:
        print(f"[OK] screenshot: {png_path}")
        print("[WARN] Pillow not found — --tiles skipped; review this single PNG.")
        return 0
    im = Image.open(png_path).convert("RGB")
    w, h = im.size
    px = im.load()
    bg = px[2, 2]
    sample = range(0, w, max(1, w // 40))
    # find the last row that is not pure background → trim the blank tail
    last = h
    y = h - 1
    while y > 0:
        if not all(px[x, y] == bg for x in sample):
            last = min(h, y + 48)
            break
        y -= 6
    content = im.crop((0, 0, w, last))
    ch = content.size[1]
    base = Path(png_path)
    n = max(1, (ch + tile_h - 1) // tile_h)
    outs = []
    for i in range(n):
        top = i * tile_h
        bottom = min(ch, top + tile_h)
        tp = base.with_name(f"{base.stem}-{i + 1}{base.suffix}")
        content.crop((0, top, w, bottom)).save(tp)
        outs.append(str(tp))
    base.unlink(missing_ok=True)  # drop the oversized full image
    print(f"[OK] {n} tile(s) of {tile_h}px from full page (content height {ch}px):")
    for o in outs:
        print("  " + o)
    print("Read each tile and check: hierarchy, spacing, color meaning, mobile-safe tables, contrast.")
    print("(delete tiles after reviewing)")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description="Headless screenshot of a session HTML.")
    ap.add_argument("html", help="path to the .html file")
    # Default next to the HTML (under $HOME in real use) — sandboxed Chromium
    # builds (e.g. snap) cannot read/write /tmp paths outside $HOME. Delete after reading.
    ap.add_argument("--out", default=None, help="output PNG (default: <html dir>/ts-render-check.png)")
    ap.add_argument("--width", type=int, default=1280)
    ap.add_argument("--height", type=int, default=2200)
    ap.add_argument("--dark", action="store_true", help="force dark theme")
    ap.add_argument("--tiles", action="store_true", help="slice the full page into readable vertical tiles (needs Pillow)")
    ap.add_argument("--tile-h", type=int, default=3200, help="tile height in px when --tiles (default 3200)")
    args = ap.parse_args()
    if args.tiles and args.height == 2200:
        args.height = 16000  # capture a tall page, then slice it

    html_path = Path(args.html).resolve()
    if not html_path.exists():
        print(f"[ERROR] not found: {html_path}")
        return 1
    out_path = args.out or str(html_path.parent / "ts-render-check.png")

    chromium = find_chromium()
    if not chromium:
        print("[WARN] no Chromium found (" + ", ".join(CANDIDATES) + ").")
        print("       Verify manually by opening the file in a browser:")
        print(f"       file://{html_path}")
        return 2

    target = html_path
    tmp = None
    if args.dark:
        # force dark + strip app.js so it doesn't reset theme; keep relative asset paths valid
        text = html_path.read_text(encoding="utf-8")
        text = text.replace('data-theme="light"', 'data-theme="dark"')
        text = "\n".join(l for l in text.splitlines() if "app.js" not in l)
        tmp = html_path.parent / "_ts_dark_preview.html"
        tmp.write_text(text, encoding="utf-8")
        target = tmp

    cmd = [
        chromium, "--headless=new", "--no-sandbox", "--disable-gpu",
        "--hide-scrollbars", "--force-device-scale-factor=1",
        "--virtual-time-budget=2000",
        f"--window-size={args.width},{args.height}",
        f"--screenshot={out_path}",
        f"file://{target}",
    ]
    try:
        subprocess.run(cmd, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=90)
    except Exception as e:  # noqa: BLE001 (system boundary: external binary)
        print(f"[ERROR] chromium failed: {e}")
        if tmp and tmp.exists():
            tmp.unlink()
        return 1
    finally:
        if tmp and tmp.exists():
            tmp.unlink()

    if os.path.exists(out_path):
        if args.tiles:
            return tile_image(out_path, args.tile_h)
        print(f"[OK] screenshot: {out_path}")
        print("Read this PNG and check: hierarchy, spacing, color meaning, mobile-safe tables, contrast.")
        print("(delete it after reviewing)")
        return 0
    print("[ERROR] screenshot not produced (sandboxed Chromium cannot use paths outside $HOME — keep output under the thinking-space)")
    return 1


if __name__ == "__main__":
    sys.exit(main())
