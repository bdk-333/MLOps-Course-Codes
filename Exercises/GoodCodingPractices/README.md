# Exercise: Good Coding Practices

**Course:** SE 489 — MLOps (Week 3, Reproducibility in MLOps)

This package contains starter code for three sub-exercises that go with the Good Coding Practices lesson:

| File | Sub-exercise | What to fix |
| --- | --- | --- |
| `docstring_exercise.py` | Code documentation | Missing / incomplete docstrings, wrong PEP 257 style |
| `style_exercise.py` | Code styling with Ruff | Inconsistent formatting, unused imports, line length, etc. |
| `typing_exercise.py` | Type hints + mypy | Missing type annotations on functions and variables |

`pyproject.toml` provides a minimal Ruff + mypy configuration you can use as-is.

## Quick start

```bash
# create and activate a virtual env
python -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate

# install the tools
pip install ruff mypy           # or: uv tool install ruff && uv tool install mypy

# lint
ruff check .

# auto-fix what Ruff can safely fix
ruff check . --fix

# format
ruff format .

# type-check
mypy .
```

## Rules of the game

1. **Don't edit `pyproject.toml`** unless the exercise explicitly asks you to — the goal is to get the code to pass with the given config.
2. Work through the files in the order above. Each one depends a little on the habits you built in the previous one.
3. When you think you're done, run `ruff check . && ruff format --check . && mypy .` — all three should exit 0.


