#!/usr/bin/env bash
# Exercises/Hydra/demo.sh — end-to-end runner for the Hydra exercise.
# Run from inside Exercises/Hydra/ after completing the refactor.
#
# What it does (short):
#   1. Creates a uv-managed venv and installs the package editable.
#   2. Runs the default training config with epochs=1 (fast smoke test).
#   3. Shows a CLI-override run and an experiment=exp2 swap.
#   4. Runs the reproducibility check across two identical-seed runs.
set -euo pipefail

# --- 1. Environment --------------------------------------------------------
# Install uv once: curl -LsSf https://astral.sh/uv/install.sh | sh  (macOS/Linux)
#                  powershell -c "irm https://astral.sh/uv/install.ps1 | iex"  (Windows)
uv venv                                    # alt: python -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate                  # Windows: .venv\Scripts\activate
uv pip install -e .                        # alt: pip install -e .

# --- 2. Default run (short smoke test) -------------------------------------
# Trains for 1 epoch so the demo finishes quickly. Drop `epochs=1` for a real run.
python vae_mnist.py epochs=1

# --- 3. Reproducibility check ---------------------------------------------
# Second run with the same seed — paired with the run above, the saved weights
# must match tensor-by-tensor.
python vae_mnist.py epochs=1

# Pick the two most recent run directories under outputs/ and compare them.
RUN_DIRS=$(find outputs -mindepth 2 -maxdepth 2 -type d | sort | tail -n 2)
RUN1=$(echo "$RUN_DIRS" | sed -n '1p')
RUN2=$(echo "$RUN_DIRS" | sed -n '2p')
echo "Comparing $RUN1 vs $RUN2"
python reproducibility_tester.py "$RUN1" "$RUN2"

# --- 4. CLI override --------------------------------------------------------
# Change a single hyperparameter at the command line (no code edit, no YAML edit).
python vae_mnist.py epochs=1 lr=5e-4

# --- 5. Experiment swap -----------------------------------------------------
# Swap the entire experiment bundle — pulls in conf/experiment/exp2.yaml.
python vae_mnist.py experiment=exp2 epochs=1

echo "demo.sh finished. Latest run output: $(find outputs -mindepth 2 -maxdepth 2 -type d | sort | tail -n 1)"
