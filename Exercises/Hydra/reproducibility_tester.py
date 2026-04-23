"""Compare two trained VAE models tensor-by-tensor.

Usage:
    python reproducibility_tester.py <run_dir_1> <run_dir_2>

Each run directory must contain a `trained_model.pt` saved by `vae_mnist.py`.
On success, prints a short confirmation. On mismatch, raises RuntimeError.

Note on PyTorch 2.6+:
    In PyTorch 2.6 the default of `torch.load` flipped to `weights_only=True`,
    which refuses to unpickle anything that isn't on an explicit safe-globals
    allowlist. Because `vae_mnist.py` calls `torch.save(model, ...)` (the
    full `nn.Module` object, not a state_dict), the pickle contains every
    nested class used by the model: our `Model`/`Encoder`/`Decoder`, plus
    `torch.nn.Linear`, `torch.nn.Sequential`, activation functions, etc.
    Allow-listing each one is brittle, so we pass `weights_only=False`.

    `weights_only=False` re-enables arbitrary code execution during
    unpickling - do NOT use it on checkpoints you got from the internet.
    It's appropriate here because these files are produced by this same
    exercise, in this same venv, seconds before they're loaded.

    The cleaner long-term fix would be to change `vae_mnist.py` to save
    `model.state_dict()` (which the weights-only loader supports out of
    the box) and rebuild the model here before comparing - left as a
    deliberate extension for students who want to go further.
"""
import sys

import torch

from model import Decoder, Encoder, Model  # noqa: F401 - needed so pickle can resolve class paths

if __name__ == "__main__":
    print(sys.argv)

    exp1 = sys.argv[1]
    exp2 = sys.argv[2]

    print(f"Comparing run {exp1} to {exp2}")

    # weights_only=False: we trust these checkpoints (we just saved them).
    # See module docstring for why this is OK in this exercise.
    model1 = torch.load(f"{exp1}/trained_model.pt", weights_only=False)
    model2 = torch.load(f"{exp2}/trained_model.pt", weights_only=False)

    n_tensors = 0
    n_elements = 0
    for p1, p2 in zip(model1.parameters(), model2.parameters()):
        if p1.shape != p2.shape:
            msg = f"Shape mismatch at tensor {n_tensors}: {tuple(p1.shape)} vs {tuple(p2.shape)}"
            raise RuntimeError(msg)
        if not torch.allclose(p1, p2):
            max_diff = (p1 - p2).abs().max().item()
            msg = (
                f"Difference in parameters! Tensor {n_tensors} differs by up to "
                f"{max_diff:.3e}. Your script is not fully reproducible!"
            )
            raise RuntimeError(msg)
        n_tensors += 1
        n_elements += p1.numel()

    print(
        f"OK: {n_tensors} parameter tensors ({n_elements:,} scalar values) "
        "match within tolerance. Reproducibility check PASSED."
    )
