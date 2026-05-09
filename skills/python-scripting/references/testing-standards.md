# Testing Standards

## Framework

- Use `pytest`.
- Mirror source layout under `tests/`.
- Name test files `test_*.py`.

## Patterns

- Arrange / Act / Assert structure.
- One behavioral concern per test.
- Parametrize repeated input/output cases.
- Prefer black-box tests over internals.

## Fixtures

- Keep fixtures explicit and scoped (`function` by default).
- Use factory fixtures for complex object creation.
- Avoid overusing `autouse`.

## Isolation

- No real network calls in unit tests.
- Use temporary directories (`tmp_path`) for filesystem operations.
- Mock boundaries, not core logic.

## Coverage Gates

- Enforce minimum line coverage (recommended >= 90% for scripts/libs).
- Add branch coverage when logic branches are critical.
- Coverage failures must fail CI.

## Reliability

- Tests must be deterministic.
- Freeze randomness/time where needed.
- No hidden dependency on env state.
