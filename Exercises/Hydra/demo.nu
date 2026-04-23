#!/usr/bin/env nu
# Exercises/Hydra/demo.nu - end-to-end runner for the Hydra exercise.
#
# Cross-platform: identical commands work on Windows, macOS, and Linux.
# Requires: nushell (https://www.nushell.sh) - install via:
#   winget install nushell           # Windows
#   brew install nushell             # macOS
#   cargo install nu                 # any platform
#
# Run from inside Exercises/Hydra/ after completing the refactor:
#   nu demo.nu
#
# What it does (short):
#   1. Creates a uv-managed venv and activates it.
#   2. Runs the default training config with epochs=1 (fast smoke test).
#   3. Re-runs with the same seed and reproducibility-checks them.
#   4. Shows a CLI override and an experiment swap.

# Exit on any non-zero command exit (nu equivalent of `set -e`)
$env.config.error_style = "fancy"

# --- 1. Environment --------------------------------------------------------
# Install uv once (any platform):
#   Windows:     powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
#   macOS/Linux: curl -LsSf https://astral.sh/uv/install.sh | sh
print "[1/5] Creating venv + installing package ..."
uv venv

# Activate the venv by prepending its bin dir to PATH (nu-native; no
# activate-script sourcing needed, works identically on every OS).
let venv_bin = if $nu.os-info.name == "windows" {
    (pwd | path join ".venv" "Scripts")
} else {
    (pwd | path join ".venv" "bin")
}
$env.PATH = ($env.PATH | prepend $venv_bin)
$env.VIRTUAL_ENV = (pwd | path join ".venv")

uv pip install -e .

# --- 2. Default run (short smoke test) -------------------------------------
# Trains for 1 epoch so the demo finishes quickly. Drop `epochs=1` for a real run.
print "\n[2/5] Default run (epochs=1) ..."
python vae_mnist.py epochs=1

# --- 3. Reproducibility check ---------------------------------------------
# Second run with the same seed - paired with the run above, the saved
# weights must match tensor-by-tensor.
print "\n[3/5] Second run (same seed) ..."
python vae_mnist.py epochs=1

# Pick the two most recent run directories under outputs/<date>/<time>/
let run_dirs = (
    ls outputs
    | where type == dir
    | each { |d| ls $d.name | where type == dir }
    | flatten
    | sort-by name
)
let run1 = ($run_dirs | get name | get (($run_dirs | length) - 2))
let run2 = ($run_dirs | last | get name)
print $"\nComparing ($run1) vs ($run2)"
python reproducibility_tester.py $run1 $run2

# --- 4. CLI override --------------------------------------------------------
# Change a single hyperparameter at the command line (no code edit, no YAML edit).
print "\n[4/5] CLI override (lr=5e-4) ..."
python vae_mnist.py epochs=1 lr=5e-4

# --- 5. Experiment swap -----------------------------------------------------
# Swap the entire experiment bundle - pulls in conf/experiment/exp2.yaml.
print "\n[5/5] Experiment swap (experiment=exp2) ..."
python vae_mnist.py experiment=exp2 epochs=1

let latest = (
    ls outputs
    | where type == dir
    | each { |d| ls $d.name | where type == dir }
    | flatten
    | sort-by name
    | last
    | get name
)
print $"\ndemo.nu finished. Latest run output: ($latest)"
