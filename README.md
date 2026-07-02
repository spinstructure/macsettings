# macsettings

Selective backup of my Mac settings.

This repository stores readable, reviewable configuration files that are useful when setting up a new Mac or recovering my working environment. It is **not** a full system backup.

Use **Time Machine** for full-machine recovery. Use this repository for selected dotfiles, editor settings, package lists, app preferences, and non-sensitive macOS preference summaries.

## External apps and tools

This repository backs up or records settings/state for the following external apps and tools:

| App/tool | What is backed up or recorded |
|---|---|
| [Zsh](https://www.zsh.org/) | Shell startup files such as `.zshrc`, `.zprofile`, and `.zshenv` |
| [Vim](https://www.vim.org/) | Vim configuration via `.vimrc` |
| [Git](https://git-scm.com/) | Sanitized Git configuration and global ignore file |
| [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) | User settings, keybindings, snippets, and extension list |
| [Stats](https://mac-stats.com/) | Sanitized Stats app preferences from the `eu.exelban.Stats` macOS preferences domain |
| [Codex](https://developers.openai.com/codex/) | Sanitized user-level Codex config files, not auth/session/history |
| [ChatGPT](https://openai.com/chatgpt/download/) | Sanitized macOS app preferences only, not app-support/session data |
| [Claude](https://claude.ai/download) | Sanitized Claude Desktop app preferences only, not app-support/session data |
| [Claude Code](https://www.anthropic.com/claude-code) | Sanitized selected user-level settings, agents, skills, and commands |
| [Homebrew](https://brew.sh/) | Package/app state via [`Brewfile`](https://docs.brew.sh/Brew-Bundle-and-Brewfile) |
| [Gitleaks](https://github.com/gitleaks/gitleaks) | Optional secret scanning before commit/push |
| [TruffleHog](https://github.com/trufflesecurity/trufflehog) | Optional secret scanning before commit/push |

## What is backed up

The main script is:

```bash
./backup.sh
```

It backs up:

```text
shell/
  .zshrc
  .zprofile
  .zshenv

vim/
  .vimrc

git/
  .gitconfig
  .gitignore_global

vscode-insiders/
  settings.json
  keybindings.json
  extensions.txt
  snippets/

apps/
  stats/
    eu.exelban.Stats.plist

  codex/
    config.toml
    *.config.toml

  chatgpt/
    <ChatGPT bundle id>.plist

  claude-code/
    settings.json
    CLAUDE.md
    agents/
    skills/
    commands/

  claude-desktop/
    com.anthropic.claudefordesktop.plist

macos/
  summaries/
    dock.txt
    finder.txt
    menu-bar.txt
    screenshots.txt

Brewfile
```

## What is intentionally not backed up

Do **not** put the following in this repository:

```text
SSH private keys
API keys
access tokens
passwords
.env files
browser profiles
raw credential files
private local machine settings
full ~/Library/Application Support folders
full ~/Library/Preferences folder
full ~/.codex folder
full ~/.claude folder
~/.claude.json
```

This repository is public, so every committed file should be safe to share.

## Privacy and sanitization

The backup script sanitizes copied files before they are written to the repository. It redacts common private patterns such as:

```text
email addresses
absolute home-directory paths
API-key-like strings
Bearer tokens
private-key blocks
credential-looking JSON/TOML/YAML fields
credential-looking plist fields
UUIDs
```

This is a safety net, not a guarantee. The script therefore also avoids copying high-risk directories such as full app-support folders, browser profiles, `~/.claude.json`, Codex auth/session/history files, and broad macOS defaults plists.

## Git identity

The backup script sanitizes `~/.gitconfig` before copying it into the repository.

It removes fields such as:

```ini
[user]
    name = ...
    email = ...
    signingkey = ...
```

Keep personal Git identity in a private local file instead, for example:

```bash
git config --global include.path ~/.gitconfig.private
```

with `~/.gitconfig.private` containing:

```ini
[user]
    name = Your Name
    email = your_email_at_example_dot_com
```

Do not commit `~/.gitconfig.private`.

## Running a backup

From the repository root:

```bash
./backup.sh
```

If the optional secret scanners find possible secrets, the script exits with a nonzero status and tells you not to commit or push.

If the backup completes cleanly, commit and push with:

```bash
git add .
git commit -m "Update Mac settings"
git push
```

There is also a convenience script:

```bash
./gitupdater.sh
```

It runs `./backup.sh`, then commits and pushes only if `backup.sh` exits successfully.

## Secret scanning

The backup script optionally runs [Gitleaks](https://github.com/gitleaks/gitleaks) and [TruffleHog](https://github.com/trufflesecurity/trufflehog):

```bash
gitleaks
trufflehog
```

Install them with:

```bash
brew install gitleaks trufflehog
```

These scans are safety checks. They do not replace judgment about what belongs in a public repository.

## Homebrew restore

The script writes a [`Brewfile`](https://docs.brew.sh/Brew-Bundle-and-Brewfile) for [Homebrew](https://brew.sh/).

On a new Mac, after installing Homebrew, packages can be restored with:

```bash
brew bundle --file Brewfile
```

Review the `Brewfile` before using it, since it records installed formulae, casks, taps, and other package-manager state.

## Visual Studio Code Insiders

The script backs up [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) user settings from:

```text
~/Library/Application Support/Code - Insiders/User
```

It also tries to record installed extensions using:

```bash
code-insiders --list-extensions
```

If the `code-insiders` command is not installed in the shell PATH, the script falls back to the app-bundle path:

```text
/Applications/Visual Studio Code - Insiders.app/Contents/Resources/app/bin/code-insiders
```

## Stats app

The script backs up settings for the [Stats](https://mac-stats.com/) menu-bar system monitor app.

The backed-up file is:

```text
apps/stats/eu.exelban.Stats.plist
```

This is exported from the macOS preferences domain:

```text
eu.exelban.Stats
```

Do not back up Stats cache folders. The preferences plist is enough for app settings.

## AI apps

The script backs up only selected, sanitized settings for [Codex](https://developers.openai.com/codex/), [ChatGPT](https://openai.com/chatgpt/download/), [Claude](https://claude.ai/download), and [Claude Code](https://www.anthropic.com/claude-code).

It intentionally avoids full app-support folders and known high-risk auth/session/history files.

## macOS settings

The repository stores selected macOS preference summaries rather than broad exported defaults plists.

Broad defaults plists such as `com.apple.finder.plist`, `com.apple.dock.plist`, and `NSGlobalDomain.plist` can contain recent folders, cloud-drive account names, and other private paths. For a public repository, summaries are safer.

Examples include:

```text
Dock size/autohide/orientation
Finder path bar/status bar/hidden-file settings
menu bar and status item settings
screenshot settings
```

Read these files first:

```text
macos/summaries/dock.txt
macos/summaries/finder.txt
macos/summaries/menu-bar.txt
macos/summaries/screenshots.txt
```
