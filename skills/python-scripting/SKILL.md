---
name: python-scripting
description: Build production-quality Python scripts with strict standards for typing, testing, tooling, architecture, and review hygiene.
---

# Python Scripting Skill

Create high-quality Python scripts and small Python utilities with strict engineering discipline.

## Required Reference Loading

Always load these before implementation:

1. `references/coding-standards.md`
2. `references/testing-standards.md`
3. `references/tooling.md`
4. `references/architecture-patterns.md`
5. `references/code-review-checklist.md`

If templates are needed, load:

- `templates/module-template.py`
- `templates/cli-template.py`
- `templates/pyproject-template.toml`

## Execution Workflow

1. Clarify intent: module, CLI, automation script, or mini package.
2. Pick layout from `architecture-patterns.md`.
3. Generate code from the matching template.
4. Enforce coding rules (typing, docstrings, error handling, logging).
5. Add tests using `pytest` patterns and fixtures.
6. Configure tooling from `tooling.md` in `pyproject.toml` and hooks.
7. Run quality gates mentally (ruff, mypy, tests, coverage).
8. Output only ready-to-run files/commands.

## Quality Bar (Non-Negotiable)

- Full type hints.
- No bare `except`.
- Structured logging, no stray prints in libraries.
- Deterministic tests with fixtures.
- Coverage gate enabled.
- Lint + type-check clean.

## Tooling & Accuracy

- Use Context7 MCP to verify third-party library APIs before coding.
- Use web search/scrape if behavior is uncertain or version-sensitive.
- Never guess signatures.

## Output Contract

When asked to create scripts/projects, produce:

1. File tree
2. Complete file contents
3. Test files
4. Tooling config (`pyproject.toml`, hooks when relevant)
5. Run commands (`ruff`, `mypy`, `pytest`, coverage)
