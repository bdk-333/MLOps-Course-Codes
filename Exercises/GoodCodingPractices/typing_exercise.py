"""Starter for the 'Type hints + mypy' sub-exercise.

Add type annotations so `mypy .` exits 0. The pyproject config runs mypy in
strict mode, so EVERY function needs full annotations (args + return).

You have two stylistic choices for how to write the hints:

1. Legacy style — works on Python 3.7+:
       from typing import List, Optional, Callable
       def f(xs: List[int], cb: Optional[Callable[[int], int]] = None) -> int: ...

2. Modern style — requires Python 3.10+ (the project targets 3.11):
       from collections.abc import Callable
       def f(xs: list[int], cb: Callable[[int], int] | None = None) -> int: ...

Either is fine. Pick one and be consistent.
"""

from __future__ import annotations


def add(a, b):
    return a + b


def mean(values):
    return sum(values) / len(values)


def first_or_default(items, default=None):
    # Should return either an item from `items` or `default`.
    return items[0] if items else default


def apply(values, func):
    # `func` is a callable from int to int.
    return [func(v) for v in values]


def parse_config(config):
    # `config` is a dict keyed by str with arbitrary values.
    name = config["name"]
    epochs = config["epochs"]
    return name, epochs


class Model:
    def __init__(self, name, layers):
        self.name = name
        self.layers = layers      # list of ints, e.g. [784, 128, 10]

    def summary(self):
        return f"{self.name}: {'->'.join(str(n) for n in self.layers)}"
