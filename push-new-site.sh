#!/usr/bin/env bash
# =============================================================================
# Initialize the dereksleepfield.com repo locally and push to GitHub.
# Run from this folder (the new site staging directory) on your real terminal.
# =============================================================================

set -euo pipefail

# 1. Clean up the half-broken .git created by the sandbox
rm -rf _broken-git .git

# 2. Init repo
git init
git branch -M main
git config user.name "Derek Wakefield"
git config user.email "dw043@bucknell.edu"

# 3. Stage and commit
git add -A
git commit -m "Initial commit: migrate Writing/Presentations/Apps/Games from webs-aight

Migrated from github.com/DerekSleepfield/webs-aight on 2026-05-26:
- writing.qmd + posts/ (personal, bobology, notes, short-stories)
- presentations.qmd + presentations/ (bobology, other)
- apps.qmd + apps/
- games.qmd + games/
- Root-level standalone HTML content (Bobble Canon, Mind Palace, etc.)
- assets/ PDFs and PPTXs for lecture decks

New: Quiet Library theme (themes.css), index.qmd landing,
cross-links to derekwakefield.com in navbar + footer."

# 4. Set remote and push
# (If you prefer SSH, swap to: git@github.com:DerekSleepfield/dereksleepfield.com.git)
git remote add origin https://github.com/DerekSleepfield/dereksleepfield.com.git
git push -u origin main

echo
echo "✓ Pushed to https://github.com/DerekSleepfield/dereksleepfield.com"
echo
echo "Next:"
echo "  1. Go to https://github.com/DerekSleepfield/dereksleepfield.com/settings/pages"
echo "  2. Build and deployment → Source: Deploy from a branch"
echo "  3. Branch: main / (root) → Save"
echo "  4. Custom domain: dereksleepfield.com → Save"
echo "  5. Check 'Enforce HTTPS' once the cert provisions (~5–10 min)"
