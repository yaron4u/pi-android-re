# Coding Standards

## Style & Layout

- Follow PEP 8.
- Keep functions small and single-purpose.
- Prefer explicit names over clever code.
- Keep module-level constants uppercase.

## Typing

- Use type hints on all public functions/methods.
- Prefer concrete types in boundaries (`Path`, `dict[str, Any]`, etc.).
- Use `TypedDict`/`dataclass` for structured data.
- Avoid `Any` unless unavoidable.

## Docstrings

- Public modules/classes/functions require docstrings.
- Use concise imperative style.
- Include args/returns/raises when non-trivial.

## Error Handling

- Never use bare `except:`.
- Catch specific exceptions.
- Raise meaningful exceptions with context.
- Fail fast on invalid state.
- For CLI: convert exceptions to clean error messages and non-zero exit codes.

## Logging

- Use `logging.getLogger(__name__)` in modules.
- Configure logging in entrypoint (`__main__`), not libraries.
- Use structured, actionable messages.

## I/O & Paths

- Use `pathlib.Path`.
- Always specify encoding for text files.
- Use context managers for resources.

## Async (if used)

- Do not block event loop with sync I/O.
- Use `asyncio.gather` for independent concurrent tasks.
- Enforce cancellation-safe cleanup.
