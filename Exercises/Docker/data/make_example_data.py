"""Generate a small input array used by the predict image.

Run once from the exercise root:

    python data/make_example_data.py

Creates ``data/example_images.npy`` with shape (8, 10) so it matrix-multiplies
cleanly against the (10, 3) weight matrix produced by ``train.py``.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np


def main() -> None:
    out = Path(__file__).parent / "example_images.npy"
    rng = np.random.default_rng(7)
    data = rng.normal(size=(8, 10))
    np.save(out, data)
    print(f"Wrote {out} with shape {data.shape}")


if __name__ == "__main__":
    main()
