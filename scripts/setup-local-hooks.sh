#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_DIR="${SCRIPT_DIR:h}"

git -C "$REPO_DIR" config core.hooksPath .githooks
"$REPO_DIR/scripts/ensure-latex-workshop-relative-links.py"

echo "Enabled macsettings Git hooks for this clone."
