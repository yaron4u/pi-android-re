# Code Review Checklist

## Correctness

- [ ] Behavior matches requirement.
- [ ] Edge cases handled.
- [ ] Exceptions are specific and meaningful.

## Readability & Design

- [ ] Functions are small and focused.
- [ ] No dead code or commented-out code.
- [ ] Clear boundaries between logic and I/O.

## Typing & Docs

- [ ] Public APIs fully typed.
- [ ] Docstrings present where needed.
- [ ] No unnecessary `Any`.

## Testing

- [ ] Tests cover happy path + failure path.
- [ ] Fixtures are scoped and explicit.
- [ ] No flaky/non-deterministic tests.
- [ ] Coverage gate met.

## Tooling

- [ ] `ruff check .` passes.
- [ ] `black --check .` passes.
- [ ] `isort --check-only .` passes.
- [ ] `mypy .` passes.
- [ ] `pytest` passes.

## Security & Ops

- [ ] No secrets in code.
- [ ] Input/path handling is safe.
- [ ] Logs are useful and not noisy.
