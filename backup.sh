#!/bin/zsh
set -euo pipefail

echo "Starting macsettings backup..."

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

# This public backup intentionally excludes AI app/agent state and settings.
rm -rf apps/codex apps/chatgpt apps/claude-code apps/claude-desktop

mkdir -p shell vim git vscode-insiders apps/stats macos/summaries

sanitize_home_path_in_file () {
  local file="$1"
  local replacement="$2"

  if [ -f "$file" ]; then
    REPLACEMENT="$replacement" perl -0pi -e '
      BEGIN {
        $home = $ENV{"HOME"};
        $replacement = $ENV{"REPLACEMENT"};
      }
      s/\Q$home\E/$replacement/g;
    ' "$file"
  fi
}

sanitize_private_info_in_file () {
  local file="$1"

  if [ ! -f "$file" ]; then
    return
  fi

  sanitize_home_path_in_file "$file" "\$HOME"

  perl -0pi -e '
    # Email addresses
    s/[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}/<EMAIL_REDACTED>/g;

    # Common API-key/token forms
        s/sk-proj-[A-Za-z0-9_\-]{20,}/<API_KEY_REDACTED>/g;
    s/sk-[A-Za-z0-9_\-]{20,}/<API_KEY_REDACTED>/g;
    s/ghp_[A-Za-z0-9_]{20,}/<GITHUB_TOKEN_REDACTED>/g;
    s/github_pat_[A-Za-z0-9_]+/<GITHUB_TOKEN_REDACTED>/g;
    s/AKIA[0-9A-Z]{16}/<AWS_ACCESS_KEY_REDACTED>/g;

    # Bearer <REDACTED>
    s/Bearer\s+[A-Za-z0-9._\-\/+=]+/Bearer <REDACTED>/g;

    # Private key blocks
    s/-----BEGIN [A-Z ]*PRIVATE KEY-----.*?-----END [A-Z ]*PRIVATE KEY-----/<PRIVATE_KEY_REDACTED>/gs;

    # JSON/TOML/YAML-ish sensitive keys
    s/("(?:api[_-]?key|token|access[_-]?token|refresh[_-]?token|secret|client[_-]?secret|password|session|auth)"\s*[:=]\s*)("[^"]*"|[^\s,\n]+)/$1"<REDACTED>"/gi;
    s/((?:api[_-]?key|token|access[_-]?token|refresh[_-]?token|secret|client[_-]?secret|password|session|auth)\s*[:=]\s*)("[^"]*"|[^\s,\n]+)/$1"<REDACTED>"/gi;

    # XML plist sensitive keys
    s/(<key>[^<]*(?:api[_-]?key|token|access[_-]?token|refresh[_-]?token|secret|client[_-]?secret|password|session|auth)[^<]*<\/key>\s*<string>)[^<]*(<\/string>)/$1<REDACTED>$2/gi;

    # UUIDs can identify local app/device state. Usually not useful in a public settings repo.
    s/\b[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}\b/<UUID_REDACTED>/g;
  ' "$file"
}

sanitize_dir_files () {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    return
  fi

  while IFS= read -r copied_file; do
    sanitize_private_info_in_file "$copied_file"
  done < <(find "$dir" -type f \( \
    -name "*.json" -o \
    -name "*.md" -o \
    -name "*.toml" -o \
    -name "*.yaml" -o \
    -name "*.yml" -o \
    -name "*.plist" -o \
    -name "*.txt" \
  \))
}

remove_ai_references_in_file () {
  local file="$1"

  if [ ! -f "$file" ]; then
    return
  fi

  perl -0pi -e '
    my $terms = qr/(codex|chatgpt|claude|anthropic|openai|copilot|aider|cursor|windsurf|ollama|perplexity|gemini|grok|mistral)/i;

    # Remove complete lines mentioning common AI tools/apps/extensions.
    s/^.*$terms.*\n//mg;

    # Clean up common trailing-comma damage in JSON-like files after line removal.
    s/,\s*([}\]])/$1/g;
    s/([{\[])\s*,/$1/g;
  ' "$file"
}

remove_ai_references_in_dir () {
  local dir="$1"

  if [ ! -d "$dir" ]; then
    return
  fi

  while IFS= read -r copied_file; do
    remove_ai_references_in_file "$copied_file"
  done < <(find "$dir" -type f \( \
    -name "*.json" -o \
    -name "*.md" -o \
    -name "*.toml" -o \
    -name "*.yaml" -o \
    -name "*.yml" -o \
    -name "*.plist" -o \
    -name "*.txt" \
  \))
}

copy_file_if_exists () {
  local src="$1"
  local dest="$2"
  local home_replacement="${3:-}"

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"

    if [ -n "$home_replacement" ]; then
      sanitize_home_path_in_file "$dest" "$home_replacement"
    fi

    echo "Copied: $src -> $dest"
  else
    echo "Skipped missing file: $src"
  fi
}

copy_private_file_if_exists () {
  local src="$1"
  local dest="$2"

  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    sanitize_private_info_in_file "$dest"
    echo "Copied sanitized: $src -> $dest"
  else
    echo "Skipped missing file: $src"
  fi
}

copy_dir_if_exists () {
  local src="$1"
  local dest="$2"

  if [ -d "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"
    cp -R "$src" "$dest"
    echo "Copied directory: $src -> $dest"
  else
    echo "Skipped missing directory: $src"
  fi
}

copy_private_dir_if_exists () {
  local src="$1"
  local dest="$2"

  if [ -d "$src" ]; then
    copy_dir_if_exists "$src" "$dest"
    sanitize_dir_files "$dest"
    echo "Sanitized directory: $dest"
  else
    echo "Skipped missing directory: $src"
  fi
}

backup_gitconfig () {
  local src="$HOME/.gitconfig"
  local dest="git/.gitconfig"

  if [ ! -f "$src" ]; then
    echo "Skipped missing file: $src"
    return
  fi

  mkdir -p git
  cp "$src" "$dest"

  # Remove personal identity and credential-related Git config.
  if command -v git >/dev/null 2>&1; then
    git config --file "$dest" --remove-section user 2>/dev/null || true
    git config --file "$dest" --remove-section credential 2>/dev/null || true
    git config --file "$dest" --remove-section github 2>/dev/null || true
    git config --file "$dest" --remove-section http 2>/dev/null || true

    git config --file "$dest" --unset-all user.name 2>/dev/null || true
    git config --file "$dest" --unset-all user.email 2>/dev/null || true
    git config --file "$dest" --unset-all user.signingkey 2>/dev/null || true
    git config --file "$dest" --unset-all commit.template 2>/dev/null || true
    git config --file "$dest" --unset-all credential.helper 2>/dev/null || true
    git config --file "$dest" --unset-all credential.username 2>/dev/null || true
    git config --file "$dest" --unset-all github.user 2>/dev/null || true
    git config --file "$dest" --unset-all github.token 2>/dev/null || true

    git config --file "$dest" --get-regexp '^(credential|github|http)\.' 2>/dev/null \
      | while read -r key rest; do
          git config --file "$dest" --unset-all "$key" 2>/dev/null || true
        done
  fi

  sanitize_private_info_in_file "$dest"
  sanitize_home_path_in_file "$dest" "~"

  echo "Copied sanitized: $src -> $dest"
}

read_default () {
  local domain="$1"
  local key="$2"

  if [ "$domain" = "NSGlobalDomain" ]; then
    defaults read -g "$key" 2>/dev/null || echo "<unset>"
  else
    defaults read "$domain" "$key" 2>/dev/null || echo "<unset>"
  fi
}

echo
echo "Backing up shell settings..."
copy_private_file_if_exists "$HOME/.zshrc" shell/.zshrc
copy_private_file_if_exists "$HOME/.zprofile" shell/.zprofile
copy_private_file_if_exists "$HOME/.zshenv" shell/.zshenv

echo
echo "Backing up Vim settings..."
copy_private_file_if_exists "$HOME/.vimrc" vim/.vimrc

echo
echo "Backing up Git settings..."
backup_gitconfig
copy_private_file_if_exists "$HOME/.gitignore_global" git/.gitignore_global

echo
echo "Backing up VS Code Insiders settings..."
VSCODE_USER="$HOME/Library/Application Support/Code - Insiders/User"

copy_private_file_if_exists "$VSCODE_USER/settings.json" vscode-insiders/settings.json
copy_private_file_if_exists "$VSCODE_USER/keybindings.json" vscode-insiders/keybindings.json
copy_private_dir_if_exists "$VSCODE_USER/snippets" vscode-insiders/snippets

remove_ai_references_in_file vscode-insiders/settings.json
remove_ai_references_in_file vscode-insiders/keybindings.json
remove_ai_references_in_dir vscode-insiders/snippets

CODE_INSIDERS_APP="/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders"

if command -v code-insiders >/dev/null 2>&1; then
  code-insiders --list-extensions > vscode-insiders/extensions.txt
  remove_ai_references_in_file vscode-insiders/extensions.txt
  echo "Wrote: vscode-insiders/extensions.txt"
elif [ -x "$CODE_INSIDERS_APP" ]; then
  "$CODE_INSIDERS_APP" --list-extensions > vscode-insiders/extensions.txt
  remove_ai_references_in_file vscode-insiders/extensions.txt
  echo "Wrote: vscode-insiders/extensions.txt using app bundle path"
else
  echo "Skipped VS Code Insiders extensions: code-insiders command not found"
fi

echo
echo "Backing up Stats app settings..."
STATS_DOMAIN="eu.exelban.Stats"
STATS_PREF="$HOME/Library/Preferences/${STATS_DOMAIN}.plist"
STATS_DEST="apps/stats/eu.exelban.Stats.plist"

mkdir -p apps/stats

if defaults read "$STATS_DOMAIN" >/dev/null 2>&1; then
  defaults export "$STATS_DOMAIN" "$STATS_DEST" 2>/dev/null || true

  if [ -f "$STATS_DEST" ]; then
    plutil -convert xml1 "$STATS_DEST" 2>/dev/null || true
    sanitize_private_info_in_file "$STATS_DEST"
    echo "Exported sanitized Stats settings: $STATS_DOMAIN -> $STATS_DEST"
  fi
elif [ -f "$STATS_PREF" ]; then
  cp "$STATS_PREF" "$STATS_DEST"
  plutil -convert xml1 "$STATS_DEST" 2>/dev/null || true
  sanitize_private_info_in_file "$STATS_DEST"
  echo "Copied sanitized Stats preferences: $STATS_PREF -> $STATS_DEST"
else
  echo "Skipped Stats settings: no Stats preferences found"
fi

echo
echo "Backing up Homebrew package list..."
if command -v brew >/dev/null 2>&1; then
  brew bundle dump --file Brewfile --force
  sanitize_private_info_in_file Brewfile
  remove_ai_references_in_file Brewfile
  echo "Wrote sanitized Brewfile with AI-related entries removed"
else
  echo "Skipped Brewfile: brew command not found"
fi

echo
echo "Backing up selected macOS settings summaries..."

# Broad exports such as com.apple.finder.plist and com.apple.dock.plist can contain
# recent folders, Google Drive account names, and other private paths. Do not keep them.
rm -rf macos/defaults
rm -f macos/defaults-snapshot.txt

{
  echo "# Dock summary"
  echo

  echo "tilesize:"
  read_default com.apple.dock tilesize

  echo
  echo "magnification:"
  read_default com.apple.dock magnification

  echo
  echo "autohide:"
  read_default com.apple.dock autohide

  echo
  echo "orientation:"
  read_default com.apple.dock orientation

  echo
  echo "show-recents:"
  read_default com.apple.dock show-recents

  echo
  echo "mru-spaces:"
  read_default com.apple.dock mru-spaces
} > macos/summaries/dock.txt

{
  echo "# Menu bar / status item summary"
  echo

  echo "NSStatusItemSpacing:"
  read_default NSGlobalDomain NSStatusItemSpacing

  echo
  echo "NSStatusItemSelectionPadding:"
  read_default NSGlobalDomain NSStatusItemSelectionPadding

  echo
  echo "systemuiserver menu extras:"
  read_default com.apple.systemuiserver menuExtras
} > macos/summaries/menu-bar.txt

{
  echo "# Finder summary"
  echo

  echo "AppleShowAllFiles:"
  read_default com.apple.finder AppleShowAllFiles

  echo
  echo "AppleShowAllExtensions:"
  read_default NSGlobalDomain AppleShowAllExtensions

  echo
  echo "ShowPathbar:"
  read_default com.apple.finder ShowPathbar

  echo
  echo "ShowStatusBar:"
  read_default com.apple.finder ShowStatusBar

  echo
  echo "FXPreferredViewStyle:"
  read_default com.apple.finder FXPreferredViewStyle
} > macos/summaries/finder.txt

{
  echo "# Screenshot summary"
  echo

  echo "location:"
  read_default com.apple.screencapture location

  echo
  echo "type:"
  read_default com.apple.screencapture type

  echo
  echo "disable-shadow:"
  read_default com.apple.screencapture disable-shadow
} > macos/summaries/screenshots.txt

sanitize_dir_files macos/summaries
echo "Wrote sanitized macOS summaries"

echo
echo "Running optional secret scans..."

SECRETS_FOUND=0

if command -v gitleaks >/dev/null 2>&1; then
  echo
  echo "Running gitleaks on git history..."
  if ! gitleaks git . --verbose --redact=100; then
    echo "WARNING: gitleaks found possible secrets in git history."
    SECRETS_FOUND=1
  fi

  echo
  echo "Running gitleaks on current files..."
  if ! gitleaks dir . --verbose --redact=100; then
    echo "WARNING: gitleaks found possible secrets in current files."
    SECRETS_FOUND=1
  fi
else
  echo "Skipped gitleaks: command not found. Install with: brew install gitleaks"
fi

if command -v trufflehog >/dev/null 2>&1; then
  echo
  echo "Running TruffleHog on current files..."
  if ! trufflehog filesystem . --results=verified,unknown; then
    echo "WARNING: TruffleHog found possible secrets in current files."
    SECRETS_FOUND=1
  fi

  echo
  echo "Running TruffleHog on git history..."
  if ! trufflehog git "file://$PWD" --results=verified,unknown; then
    echo "WARNING: TruffleHog found possible secrets in git history."
    SECRETS_FOUND=1
  fi
else
  echo "Skipped TruffleHog: command not found. Install with: brew install trufflehog"
fi

echo

if [ "$SECRETS_FOUND" -ne 0 ]; then
  echo "Backup finished, but possible secrets were detected."
  echo "Do not commit or push until you inspect the scanner output."
  exit 2
fi

echo "Backup complete."
echo "AI-related app/agent state and common AI-tool references were excluded from this backup."
echo
echo "To commit and push the backup, run:"
echo "  git add ."
echo "  git commit -m \"Update Mac settings\""
echo "  git push"
