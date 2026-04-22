"""Tiny stand-in for a training script.

We're not actually fitting a model here — the point of this exercise is the
container lifecycle, not the ML. The script:

    1. Samples a deterministic random matrix of "weights".
    2. Saves it to ``models/trained_model.npy``.
    3. Prints a message so students can see output in ``docker logs``.

Typical usage inside a container:

    docker run --name exp1 \\
        -v ${PWD}/models:/app/models \\
        train:latest

The ``-v`` mount is what lets the saved model appear on the host after the
container exits.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np


def main() -> None:
    parser = argparse.ArgumentParser(description="Dummy trainer for the Docker exercise.")
    parser.add_argument(
        "--out",
        type=Path,
        default=Path("models/trained_model.npy"),
        help="Where to save the 'trained' model (inside the container).",
    )
    parser.add_argument("--seed", type=int, default=42, help="RNG seed for reproducibility.")
    args = parser.parse_args()

    print("Starting dummy training run...")
    rng = np.random.default_rng(args.seed)
    weights = rng.normal(size=(10, 3))

    args.out.parent.mkdir(parents=True, exist_ok=True)
    np.save(args.out, weights)
    print(f"Trained dummy model saved to {args.out}")
    print(f"Weight matrix shape: {weights.shape}")


if __name__ == "__main__":
    main()
