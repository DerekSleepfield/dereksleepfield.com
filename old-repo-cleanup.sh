#!/usr/bin/env bash
# =============================================================================
# Removes the four migrated sections (Writing, Presentations, Apps, Games)
# from the derekwakefield.com repo (webs-aight).
#
# DO NOT RUN until dereksleepfield.com is live and the migration is verified.
# After running, commit + push to derekwakefield.com.
#
# This script DELETES files. Review the list below before executing.
# =============================================================================

set -euo pipefail

REPO="/Users/derekwakefield/Documents/Projects/webs-aight"

if [ ! -d "$REPO/.git" ]; then
  echo "ERROR: $REPO is not a git repo. Aborting." >&2
  exit 1
fi

cd "$REPO"

echo "Branch: $(git rev-parse --abbrev-ref HEAD)"
echo "Uncommitted changes:"
git status --short | head -20
echo
read -p "Proceed with removal? [y/N] " ok
[[ "$ok" =~ ^[yY] ]] || { echo "Aborted."; exit 0; }

# -----------------------------------------------------------------------------
# 1. Listing pages
# -----------------------------------------------------------------------------
git rm -f writing.qmd presentations.qmd apps.qmd games.qmd

# -----------------------------------------------------------------------------
# 2. Subdirectories (post .qmd files)
# -----------------------------------------------------------------------------
git rm -rf posts/ presentations/ apps/ games/

# -----------------------------------------------------------------------------
# 3. Root-level content HTML files
# -----------------------------------------------------------------------------
git rm -f \
  a-voice-that-listens.html \
  bob-is-you.html \
  bobbish-in-4-voices.html \
  bobble-canon.html \
  friends-we-find.html \
  gem-wars-lore.html \
  introduction-to-bobology.html \
  on-cognitive-capture.html \
  sinatra-2016-memo.html \
  the-4b-framework.html \
  the-wand-and-the-hand.html \
  when-anthills-decay.html \
  where-the-anthill-was.html \
  design-directions.html \
  mind-palace.html \
  gem-in-eyes-intro.html \
  wor-gems.html \
  citation-timeline.html \
  citation_timeline.html

# -----------------------------------------------------------------------------
# 4. assets/ PDFs and PPTXs migrated to the new site
#    (kept: cv.docx, cv.pdf, headshot.jpg, headshot_full.jpg, README.md)
# -----------------------------------------------------------------------------
git rm -f \
  assets/bob-is-you.pdf \
  assets/bob-is-you.pptx \
  assets/bobbish.pdf \
  assets/how-to-engage-in-politics-as-faculty.pdf \
  assets/introduction-to-bobology.pdf \
  assets/introduction-to-bobology.pptx \
  assets/the-4b-framework.pdf \
  assets/the-4b-framework.pptx \
  assets/the-wand-and-the-hand.pdf

# -----------------------------------------------------------------------------
# 5. _quarto.yml — drop the four navbar entries, add cross-link to new site
# -----------------------------------------------------------------------------
python3 - <<'PYEOF'
import re, pathlib
p = pathlib.Path("_quarto.yml")
text = p.read_text()

# 5a. Remove the four navbar entries for Writing, Presentations, Apps, Games.
pattern = re.compile(
    r"\n      - text: \"(?:Writing|Presentations|Apps|Games)\"\n"
    r"        href: (?:writing|presentations|apps|games)\.qmd",
    re.MULTILINE,
)
text = pattern.sub("", text)

# 5b. Add a navbar right: block with a "Creative writing →" link.
# Old _quarto.yml has no navbar right: — we insert one immediately before page-footer:.
# (Script runs once; no need to detect existing right: blocks.)
nav_right_block = (
    "    right:\n"
    "      - text: \"Creative writing →\"\n"
    "        href: https://dereksleepfield.com\n"
)
text = text.replace("  page-footer:", nav_right_block + "  page-footer:")

# 5c. Add a footer-right link to the new site. Anchor on the github icon entry.
footer_link = (
    "      - text: \"Creative writing →\"\n"
    "        href: https://dereksleepfield.com\n"
)
text = re.sub(
    r"(      - icon: github\n        href: https://github\.com/DerekSleepfield\n)",
    r"\1" + footer_link,
    text, count=1,
)

p.write_text(text)
print("Updated _quarto.yml — removed 4 nav items, added Creative writing → cross-link (navbar + footer).")
PYEOF
git add _quarto.yml

# -----------------------------------------------------------------------------
# 6. now.qmd — fix the one inbound link to the migrated bobble-canon
# -----------------------------------------------------------------------------
python3 - <<'PYEOF'
import pathlib
p = pathlib.Path("now.qmd")
text = p.read_text()
old = "posts/2026-05-09-bobble-canon.qmd"
new = "https://dereksleepfield.com/posts/bobology/2026-05-09-bobble-canon.html"
if old in text:
    p.write_text(text.replace(old, new))
    print(f"Updated now.qmd — bobble-canon link → {new}")
else:
    print("now.qmd: no bobble-canon link found (already fixed?)")
PYEOF
git add now.qmd

# -----------------------------------------------------------------------------
# 7. Show diff summary
# -----------------------------------------------------------------------------
echo
echo "=== STAGED CHANGES ==="
git status --short
echo
echo "Next:  quarto render  &&  git commit -m 'Move Writing/Presentations/Apps/Games to dereksleepfield.com' && git push"
