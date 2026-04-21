"""Compare two trained VAE models tensor-by-tensor.

Usage:
    python reproducibility_tester.py <run_dir_1> <run_dir_2>

Each run directory must contain a `trained_model.pt` saved by `vae_mnist.py`.
If any pair of parameters differs, a RuntimeError is raised. Otherwise the
script exits silently — that silence is the pass signal.
"""
import sys

import torch
from model import Decoder, Encoder, Model  # noqa: F401

if __name__ == "__main__":
    print(sys.argv)

    exp1 = sys.argv[1]
    exp2 = sys.argv[2]

    print(f"Comparing run {exp1} to {exp2}")

    model1 = torch.load(f"{exp1}/trained_model.pt")
    model2 = torch.load(f"{exp2}/trained_model.pt")

    for p1, p2 in zip(model1.parameters(), model2.parameters()):
        if not torch.allclose(p1, p2):
            raise RuntimeError("Difference in parameters! Your script is not fully reproducible!")
