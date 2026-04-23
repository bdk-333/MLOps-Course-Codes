# Exercises/Hydra/demo.ps1 - end-to-end runner for the Hydra exercise (Windows / PowerShell).
# Run from inside Exercises/Hydra/ after completing the refactor:
#   .\demo.ps1
# If Windows blocks the script, you may need to run once:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#
# This is a line-for-line mirror of demo.sh - same commands, same order,
# just the Windows-flavored activation path and output handling.
#
# What it does (short):
#   1. Creates a uv-managed venv and installs the package editable.
#   2. Runs the default training config with epochs=1 (fast smoke test).
#   3. Shows a CLI-override run and an experiment=exp2 swap.
#   4. Runs the reproducibility check across two identical-seed runs.

$ErrorActionPreference = 'Stop'   # mirror of `set -e`

# --- 1. Environment --------------------------------------------------------
# Install uv once (Windows):
#   powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
uv venv                                       # alt: python -m venv .venv
. .\.venv\Scripts\Activate.ps1                # Linux/Mac: source .venv/bin/activate
uv pip install -e .                           # alt: pip install -e .

# --- 2. Default run (short smoke test) -------------------------------------
# Trains for 1 epoch so the demo finishes quickly. Drop `epochs=1` for a real run.
python vae_mnist.py epochs=1

# --- 3. Reproducibility check ---------------------------------------------
# Second run with the same seed - paired with the run above, the saved weights
# must match tensor-by-tensor.
python vae_mnist.py epochs=1

# Pick the two most recent run directories under outputs/ and compare them.
$RunDirs = Get-ChildItem -Path outputs -Recurse -Directory |
    Where-Object { $_.FullName -match '[\\/]outputs[\\/][^\\/]+[\\/][^\\/]+$' } |
    Sort-Object FullName
$Run1 = $RunDirs[-2].FullName
$Run2 = $RunDirs[-1].FullName
Write-Host "Comparing $Run1 vs $Run2"
python reproducibility_tester.py $Run1 $Run2

# --- 4. CLI override --------------------------------------------------------
# Change a single hyperparameter at the command line (no code edit, no YAML edit).
python vae_mnist.py epochs=1 lr=5e-4

# --- 5. Experiment swap -----------------------------------------------------
# Swap the entire experiment bundle - pulls in conf/experiment/exp2.yaml.
python vae_mnist.py experiment=exp2 epochs=1

$Latest = (Get-ChildItem -Path outputs -Recurse -Directory |
    Where-Object { $_.FullName -match '[\\/]outputs[\\/][^\\/]+[\\/][^\\/]+$' } |
    Sort-Object FullName)[-1].FullName
Write-Host "demo.ps1 finished. Latest run output: $Latest"
