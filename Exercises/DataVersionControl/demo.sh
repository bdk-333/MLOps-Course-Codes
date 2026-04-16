#!/usr/bin/env bash
# =============================================================================
# SE 489 — Data Version Control exercise walkthrough
# =============================================================================
# DO NOT run this as a script on your first pass — read it line by line and
# run each command yourself so you understand what it does.
#
# Prereqs (see the exercise page for the detailed prerequisite section):
#   1. DVC + dvc-gdrive installed:   pip install "dvc>=3.60" "dvc-gdrive>=3.0.1"
#   2. Your OWN Google Cloud OAuth client created (Desktop app type), with
#      the Drive API enabled. Export the client id/secret as env vars OR be
#      ready to paste them when prompted:
#        export GDRIVE_CLIENT_ID='your-client-id.apps.googleusercontent.com'
#        export GDRIVE_CLIENT_SECRET='your-client-secret'
#   3. A Google Drive folder to push into. Copy its folder ID from the URL
#      (the long string after /folders/).
#        export GDRIVE_FOLDER_ID='your-folder-id'
# =============================================================================

set -e

# --- Step 1: Init DVC ------------------------------------------------------
# DVC reuses the surrounding git repo. Creates .dvc/ with config + cache.
dvc init
git add .dvc/.gitignore .dvc/config .dvcignore
git commit -m "Initialize DVC"

# --- Step 2: Register the Google Drive remote ------------------------------
dvc remote add -d storage "gdrive://${GDRIVE_FOLDER_ID}"

# Custom OAuth client — THIS is the step that saves us from "App blocked".
dvc remote modify storage gdrive_client_id     "${GDRIVE_CLIENT_ID}"
dvc remote modify storage gdrive_client_secret "${GDRIVE_CLIENT_SECRET}"

git add .dvc/config
git commit -m "Add GDrive remote"

# --- Step 3: Version the data ---------------------------------------------
# `dvc add` replaces the actual data with a tiny .dvc pointer file and adds
# the raw data to .gitignore. Commit the pointer, not the data.
dvc add data
git add data.dvc data/.gitignore     # paths depend on your layout
git commit -m "Initial dataset v1"
git tag -a v1.0 -m "data v1.0"

# --- Step 4: Push to Google Drive -----------------------------------------
# First push will open a browser for OAuth. Sign in and accept.
# Subsequent pushes reuse the cached token.
dvc push

# --- Step 5: Simulate updating the data -----------------------------------
echo "Ford,F-150,1995,16.0,8,205,4500,USA" >> data/sample_cars.csv

dvc add data
git add data.dvc
git commit -m "Add 1990s pickup to dataset (v2)"
git tag -a v2.0 -m "data v2.0"
dvc push

# --- Step 6: Time-travel to v1 --------------------------------------------
# `git checkout` moves the .dvc pointer; `dvc checkout` restores the data
# that pointer references from the cache (or re-fetches from the remote).
git checkout v1.0
dvc checkout
wc -l data/sample_cars.csv   # should be back to 21 lines (header + 20 rows)

# Return to latest
git checkout main
dvc checkout
