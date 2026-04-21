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

```bash
# 1. Create an environment (Python 3.11 recommended)
python -m venv .venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate

# 2. Install
pip install -e .

# 3. After you've done the refactor, try it:
python vae_mnist.py                          # default run
python vae_mnist.py epochs=5 lr=5e-4         # override via CLI
python vae_mnist.py experiment=exp2          # swap experiment config

# 4. Verify reproducibility (two runs with the same seed → identical weights)
python vae_mnist.py
python vae_mnist.py
python reproducibility_tester.py outputs/<run1>/ outputs/<run2>/
```

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
