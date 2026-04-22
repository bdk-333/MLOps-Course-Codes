"""Tiny stand-in for a prediction script.

Loads a saved model and an input batch, computes a matrix-multiply "prediction",
prints the shape + first row. Two CLI arguments, both paths:

    python simple_mlops/predict.py <model_path> <data_path>

In the container, the paths are expected to be mount targets — see the
``predict.dockerfile`` header for the exact ``docker run`` invocation.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np


def main() -> None:
    parser = argparse.ArgumentParser(description="Dummy predictor for the Docker exercise.")
    parser.add_argument("model_path", type=Path, help="Path to the saved model (.npy).")
    parser.add_argument("data_path", type=Path, help="Path to the input array (.npy).")
    args = parser.parse_args()

    print(f"Loading model from {args.model_path}")
    weights = np.load(args.model_path)

    print(f"Loading input data from {args.data_path}")
    data = np.load(args.data_path)

    preds = data @ weights

    print(f"Input shape:   {data.shape}")
    print(f"Weights shape: {weights.shape}")
    print(f"Output shape:  {preds.shape}")
    print(f"First row:     {preds[0]}")


if __name__ == "__main__":
    main()
