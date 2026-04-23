# Hydra — Configuration Management for a PyTorch VAE

Refactor a standalone PyTorch VAE training script (`vae_mnist.py`) so that **all
hyperparameters live in YAML**, experiments are swappable from the command line,
and every run is captured with its full config for reproducibility.

Follow the exercise page for the step-by-step narrative. The files here are the
starter scaffold you edit.

## Files

| File | What it is | Do you edit it? |
| --- | --- | --- |
| `vae_mnist.py` | Pre-Hydra training script with `# TODO:` markers | **Yes** — this is the main thing you refactor |
| `model.py` | Encoder / Decoder / Model definitions | **No** — leave it alone |
| `reproducibility_tester.py` | Compares two saved models tensor-by-tensor | **No** — just run it |
| `conf/config.yaml` | Empty base config (scaffold) | **Yes** — fill in hyperparameters + `defaults` |
| `conf/experiment/` | Per-experiment config group | **Yes** — add `exp1.yaml`, `exp2.yaml` |
| `pyproject.toml` | Dependency pins | No |

## Quick start

This exercise uses **Python 3.11**. Pick the workflow that matches the tool you
already have installed.

```bash
# Install uv once (if you don't have it):
#   curl -LsSf https://astral.sh/uv/install.sh | sh            # macOS/Linux
#   powershell -c "irm https://astral.sh/uv/install.ps1 | iex" # Windows

# 1. Create an environment and install
uv venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate
uv pip install -e .

# 2. After you've done the refactor, try it:
python vae_mnist.py                          # default run
python vae_mnist.py epochs=5 lr=5e-4         # override via CLI
python vae_mnist.py experiment=exp2          # swap experiment config

# 3. Verify reproducibility (two runs with the same seed → identical weights)
python vae_mnist.py
python vae_mnist.py
python reproducibility_tester.py outputs/<run1>/ outputs/<run2>/
```

### Alternative (plain pip)

```bash
python -m venv .venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate
pip install -e .
```

### End-to-end dry run

Three equivalent runners are provided; pick whichever shell you prefer:

```nu
nu demo.nu           # cross-platform (Windows / macOS / Linux) - recommended
```

```bash
bash demo.sh         # macOS / Linux / WSL / Git Bash
```

```powershell
.\demo.ps1          # Windows PowerShell (no extra install needed)
```

Each runs a short default training, a second same-seed run + the
reproducibility check, a CLI override, and an `experiment=exp2` swap -
useful as a smoke test once your refactor is done, and as a reference
if you get stuck on the manual steps.

> **Nushell install** (one time): `winget install nushell` on Windows,
> `brew install nushell` on macOS, or `cargo install nu` anywhere.
> The `.nu` script is the preferred course-wide option because a single
> file runs identically on every OS.

> **PowerShell execution policy**: if Windows blocks `.\demo.ps1` the
> first time, run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass`
> once per terminal session.

## Key conventions for this exercise

- Use `@hydra.main(version_base="1.3", config_path="conf", config_name="config")`
- Save model and images under `HydraConfig.get().runtime.output_dir`, **not**
  `os.getcwd()` — Hydra no longer changes the working directory by default.
- Config group folder is **`conf/experiment/`** (singular). The CLI override is
  `experiment=exp2` and the `defaults:` entry is `- experiment: exp1`.
- Seed everything: Python `random`, `numpy`, `torch`, `torch.cuda`. Set
  `cudnn.deterministic = True` and `cudnn.benchmark = False` when using GPU.

## Gotchas

- `cudnn.deterministic = True` can slow GPU training. Worth it for this exercise.
- If Hydra complains it can't find `config.yaml`, make sure you run the script
  from the folder that contains `conf/` (the exercise root).
- Hydra writes each run's artifacts (config, log, your saved files) into a new
  timestamped folder under `outputs/`. Look there after each run.
- **PyTorch 2.6+ and `torch.load`**: in PyTorch 2.6 the default flipped to
  `weights_only=True`, which refuses to unpickle custom classes. Because
  `vae_mnist.py` saves the **full `Model` object** (not a state_dict) with
  `torch.save(model, ...)`, the pickle pulls in every nested class
  (`Linear`, `Sequential`, your `Model`/`Encoder`/`Decoder`, ...) -
  allow-listing all of them is brittle, so `reproducibility_tester.py`
  loads with `weights_only=False`. That's appropriate here because the
  checkpoints are produced by this same exercise seconds before being
  loaded; **do not** copy that pattern when loading checkpoints from the
  internet. A cleaner alternative for a real project: save `state_dict()`
  instead of the full model.
