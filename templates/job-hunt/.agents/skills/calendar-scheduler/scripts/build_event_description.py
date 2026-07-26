#!/usr/bin/env python3
"""Build a concise job-hunt calendar event description from JSON."""

from __future__ import annotations

import argparse
import json
import sys
from typing import Any


def lines_from(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, list):
        return [str(v) for v in value if str(v).strip()]
    if str(value).strip():
        return [str(value)]
    return []


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("payload", help="Path to JSON payload, or '-' for stdin")
    args = parser.parse_args()

    raw = sys.stdin.read() if args.payload == "-" else open(args.payload, encoding="utf-8").read()
    data = json.loads(raw)

    company = data.get("company", "企業")
    label = data.get("label") or data.get("event_type") or "就活予定"
    deadline = data.get("deadline")
    strict = data.get("strict", True)

    out: list[str] = [f"{company} {label}。", ""]
    if deadline:
        suffix = " 厳守" if strict else ""
        out.append(f"期限: {deadline}{suffix}")

    actions = lines_from(data.get("actions"))
    if actions:
        out.append("対応:")
        out.extend(f"- {a}" for a in actions)

    requirements = lines_from(data.get("requirements"))
    if requirements:
        out.append("注意:")
        out.extend(f"- {r}" for r in requirements)

    status = lines_from(data.get("status"))
    if status:
        out.append("状態:")
        out.extend(f"- {s}" for s in status)

    print("\n".join(out).strip())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
