#!/usr/bin/env python3
"""Validate minimal calendar event payload fields before a write."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import sys


REQUIRED = ["title", "start_time", "end_time", "timezone", "transparency", "visibility"]
VALID_TRANSPARENCY = {"transparent", "opaque"}
VALID_VISIBILITY = {"private", "default", "public"}


def parse_iso(value: str) -> dt.datetime:
    return dt.datetime.fromisoformat(value.replace("Z", "+00:00"))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("payload", help="Path to JSON payload, or '-' for stdin")
    args = parser.parse_args()

    raw = sys.stdin.read() if args.payload == "-" else open(args.payload, encoding="utf-8").read()
    data = json.loads(raw)

    errors: list[str] = []
    for key in REQUIRED:
        if not data.get(key):
            errors.append(f"missing required field: {key}")

    if data.get("transparency") and data["transparency"] not in VALID_TRANSPARENCY:
        errors.append("transparency must be transparent or opaque")
    if data.get("visibility") and data["visibility"] not in VALID_VISIBILITY:
        errors.append("visibility must be private, default, or public")

    if data.get("start_time") and data.get("end_time"):
        try:
            start = parse_iso(data["start_time"])
            end = parse_iso(data["end_time"])
            if end <= start:
                errors.append("end_time must be after start_time")
        except ValueError as exc:
            errors.append(f"invalid ISO datetime: {exc}")

    sensitive = ["test_center_id", "registration_number", "password", "invoice", "home_address"]
    for key in sensitive:
        if data.get(key):
            errors.append(f"sensitive field should not be in calendar payload: {key}")

    if errors:
        for error in errors:
            print(f"ERROR: {error}", file=sys.stderr)
        return 1

    print("OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
