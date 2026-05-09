"""CLI template."""

from __future__ import annotations

import argparse
import logging
from pathlib import Path

from your_package.module import parse_items, total_value

logger = logging.getLogger(__name__)


def build_parser() -> argparse.ArgumentParser:
    """Build CLI argument parser."""
    parser = argparse.ArgumentParser(description="Example CLI")
    parser.add_argument("input", type=Path, help="Path to input file")
    parser.add_argument("--verbose", action="store_true", help="Enable debug logs")
    return parser


def run(input_path: Path) -> int:
    """Run CLI workflow."""
    items = parse_items(input_path)
    result = total_value(items)
    logger.info("total=%s", result)
    print(result)
    return 0


def main() -> int:
    """CLI entrypoint."""
    parser = build_parser()
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(asctime)s %(levelname)s %(name)s - %(message)s",
    )

    try:
        return run(args.input)
    except FileNotFoundError:
        logger.error("Input file not found: %s", args.input)
        return 2
    except ValueError as exc:
        logger.error("Invalid input format: %s", exc)
        return 3


if __name__ == "__main__":
    raise SystemExit(main())
