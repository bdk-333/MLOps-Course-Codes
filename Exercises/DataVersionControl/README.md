# Exercise: Data Version Control (DVC)

**Course:** SE 489 — MLOps (Week 3, Reproducibility in MLOps)


This package contains a tiny starter dataset (`data/sample_cars.csv`) plus config files
you'll use to practice versioning data with [DVC](https://dvc.org/) and a Google Drive
remote.

> ⚠️ **Heads up: you must set up a custom Google OAuth client before `dvc push`.**
> The default DVC app is blocked by Google ([issue #10516](https://github.com/iterative/dvc/issues/10516)).
> The exercise walks you through creating your own `client_id` / `client_secret`
> in Google Cloud Console — do that step FIRST, or your first `dvc push` will fail with
> *"This app is blocked"*.

## What's in this folder

| File | Purpose |
| --- | --- |
| `data/sample_cars.csv` | Small starter dataset (~20 rows). You'll add/modify rows to create v2. |
| `pyproject.toml` | Pinned DVC + dvc-gdrive versions so everyone is on the same page. |
| `.dvcignore` | Standard ignore template for DVC-tracked folders. |
| `demo.sh` | Annotated walkthrough of the full `dvc init` → `push` → `checkout` flow. |

## Quick start

```bash
# 1. Create and activate a virtual env (Python 3.11 recommended)
python -m venv .venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate

# 2. Install DVC + Google Drive extension
pip install -U pip
pip install "dvc>=3.60" "dvc-gdrive>=3.0.1"

# 3. Verify install
dvc --version
```

Then follow the exercise page step-by-step. Before your first `dvc push`, you'll
need:

- A Google account
- A Google Cloud project with the **Drive API** enabled
- An **OAuth 2.0 Client ID** (Desktop app type) — copy the `client_id` and `client_secret`
- A folder on Google Drive where DVC can push data (copy its folder ID from the URL)

## Rules of the game

1. **Don't commit `.venv/` or the raw `data/sample_cars.csv`** — that's what DVC is for.
   The exercise walks you through `dvc add data/` which will put `data/` into `.gitignore`
   automatically.
2. **Commit the `.dvc` metafiles** (`data.dvc`, `.dvc/config`) so teammates can `dvc pull`.
3. **Never commit `gdrive-user-credentials.json`** or your OAuth client secret to Git.


