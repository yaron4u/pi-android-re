# Architecture Patterns

## Project Layouts

## 1) Single Script

Use for one-off automation with limited scope.

- `script.py`
- Optional: `tests/test_script.py`

## 2) Small Package (Recommended)

Use when logic is reusable or growing.

- `src/<package>/__init__.py`
- `src/<package>/core.py`
- `src/<package>/cli.py`
- `tests/`
- `pyproject.toml`

## 3) Service + Repository Split

Use when external systems are involved.

- `service` layer: business rules/use-cases.
- `repository` layer: DB/API/file access.
- Keep repositories dumb; keep business logic in services.

## Rules

- Dependency direction: CLI -> service -> repository.
- Keep side effects at boundaries.
- Pass dependencies explicitly (constructor/function args).
- Prefer composition over inheritance.
- Use dataclasses/typed models for payloads.

## CLI Pattern

- Parse args in `cli.py`.
- Call pure/service functions.
- Convert exceptions to user-friendly errors + exit codes.
