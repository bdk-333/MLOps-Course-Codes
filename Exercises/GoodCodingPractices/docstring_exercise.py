"""Starter for the 'Code Documentation' sub-exercise.

Goal: bring every function, class, and module-level object up to PEP 257 with
Google-style docstrings (matching the Ruff config in pyproject.toml).

Run `ruff check .` — every `D...` warning you see here is on purpose.
"""

from __future__ import annotations


# TODO: this module-level constant has no docstring / comment about what it means.
LEARNING_RATE = 1e-3


def train(model, dataset, epochs=10):
    # TODO: write a Google-style docstring describing args, returns, and raises.
    for epoch in range(epochs):
        model.fit(dataset)
    return model


def evaluate(model, dataset):
    # Summary line only - no args/returns section, no blank line before return.
    """Evaluate a model."""
    return model.score(dataset)


class DataLoader:
    # TODO: class is completely undocumented. Add a one-line summary + short
    # description of what it does and how to use it.

    def __init__(self, path, batch_size=32, shuffle=True):
        self.path = path
        self.batch_size = batch_size
        self.shuffle = shuffle

    def __iter__(self):
        # TODO: describe what iterating yields.
        ...


def _private_helper(x):
    # Leading underscore means "private". Pydocstyle still wants a docstring
    # unless you configure it otherwise. Add one.
    return x * 2
