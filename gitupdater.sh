#!/bin/zsh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

./backup.sh

git add .
git commit -m "Update Mac settings"
git push
