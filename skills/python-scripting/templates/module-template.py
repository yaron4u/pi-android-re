"""Core module template."""

from __future__ import annotations

import logging
from dataclasses import dataclass
from pathlib import Path

logger = logging.getLogger(__name__)


@dataclass(slots=True)
class Item:
    """Structured input item."""

    name: str
    value: int


def parse_items(path: Path) -> list[Item]:
    """Parse items from a UTF-8 text file."""
    lines = path.read_text(encoding="utf-8").splitlines()
    items: list[Item] = []

    for line in lines:
        if not line.strip():
            continue
        name, raw_value = line.split(",", maxsplit=1)
        items.append(Item(name=name.strip(), value=int(raw_value.strip())))

    return items


def total_value(items: list[Item]) -> int:
    """Return sum of item values."""
    return sum(item.value for item in items)
