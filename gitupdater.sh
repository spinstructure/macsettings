#!/bin/zsh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

./backup.sh

if [ -z "$(git status --porcelain)" ]; then
  echo "No backup changes to commit."
  exit 0
fi

git add -A

echo
echo "Changes to be committed:"
git status --short

git commit -m "Update Mac settings"
git push
