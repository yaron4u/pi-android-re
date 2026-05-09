# Tooling Standards

## Core Toolchain

- **ruff**: linting + many style checks.
- **mypy**: static type checking.
- **black**: formatter.
- **isort**: import ordering.
- **pytest**: tests.
- **coverage.py / pytest-cov**: coverage gates.
- **pre-commit**: local gate before commits.

## Recommended Workflow

1. `ruff check .`
2. `black .`
3. `isort .`
4. `mypy .`
5. `pytest --cov`

## pre-commit

Include hooks for:

- trailing-whitespace
- end-of-file-fixer
- check-yaml
- ruff
- black
- isort
- mypy (optional in hook, mandatory in CI)

## Environment & Packaging

- Use **uv** for fast env/dependency workflows when available.
- Keep lockfiles committed where project policy requires.
- For matrix testing or env orchestration, use **tox**.

## CI Gates (minimum)

- Lint must pass.
- Formatting must be clean.
- Type checks must pass.
- Tests + coverage threshold must pass.
