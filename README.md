# macsettings

Selective backup of my Mac settings.

This repository stores readable, reviewable configuration files that are useful when setting up a new Mac or recovering my working environment. It is **not** a full system backup.

Use **Time Machine** for full-machine recovery. Use this repository for selected dotfiles, editor settings, package lists, selected app preferences, and non-sensitive macOS preference summaries.

## External apps and tools

This repository backs up or records settings/state for the following external apps and tools:

| App/tool | What is backed up or recorded |
|---|---|
| [Zsh](https://www.zsh.org/) | Shell startup files such as `.zshrc`, `.zprofile`, and `.zshenv` |
| [Vim](https://www.vim.org/) | Vim configuration via `.vimrc` |
| [Git](https://git-scm.com/) | Sanitized Git configuration and global ignore file |
| [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) | User settings, keybindings, snippets, extension list, and generated folder documentation |
| [Stats](https://mac-stats.com/) | Sanitized Stats app preferences from the `eu.exelban.Stats` macOS preferences domain, if present |
| [Homebrew](https://brew.sh/) | Package/app state via [`Brewfile`](https://docs.brew.sh/Brew-Bundle-and-Brewfile) |
| [Codex CLI](https://learn.chatgpt.com/docs/non-interactive-mode) | Regenerates the VS Code Insiders settings documentation from the sanitized `settings.json` |
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
  README.md
  settings.json
  keybindings.json
  extensions.txt
  snippets/

macos/
  summaries/
    dock.txt
    finder.txt
    menu-bar.txt
    screenshots.txt

Brewfile
```

Depending on what exists on the local machine, the backup script may also create sanitized app-preference files such as Stats preferences. Do not commit app-preference files unless you are comfortable making their sanitized contents public.

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
AI app/agent configuration and session state
full ~/Library/Application Support folders
full ~/Library/Preferences folder
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

This is a safety net, not a guarantee.

The script avoids broad macOS defaults plists, because they can contain recent folders, cloud-drive account names, and other private paths.

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

The VS Code Insiders README step requires an installed and authenticated
`codex` command. The generator runs Codex with a read-only sandbox and an
ephemeral session. Set `CODEX_BIN` if the executable has a nonstandard name or
location.

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

The VS Code Insiders backup is documented in:

```text
vscode-insiders/README.md
```

That folder README explains the backed-up VS Code Insiders files:

```text
vscode-insiders/settings.json
vscode-insiders/keybindings.json
vscode-insiders/extensions.txt
vscode-insiders/snippets/
```

The folder README is generated from `vscode-insiders/settings.json` by:

```text
scripts/update-vscode-insiders-readme.sh
```

The main `backup.sh` script runs this generator automatically after copying and
sanitizing the VS Code Insiders settings. The sanitized settings are supplied to
Codex as prompt context. A hash marker prevents another Codex call when the
settings have not changed.

To regenerate the VS Code Insiders README manually:

```bash
./scripts/update-vscode-insiders-readme.sh
```

### Optional local pre-commit hook

A local Git pre-commit hook can regenerate `vscode-insiders/README.md` automatically whenever `vscode-insiders/settings.json` is staged.

The repository includes a tracked hook at:

```text
.githooks/pre-commit
```

Enable tracked hooks for this clone with:

```bash
git config core.hooksPath .githooks
```

The hook regenerates and stages `vscode-insiders/README.md` only when
`vscode-insiders/settings.json` is staged. The `core.hooksPath` setting is local
to each clone.

## Stats app

The script can back up settings for the [Stats](https://mac-stats.com/) menu-bar system monitor app, if Stats preferences are present locally.

The possible backed-up file is:

```text
apps/stats/eu.exelban.Stats.plist
```

This is exported from the macOS preferences domain:

```text
eu.exelban.Stats
```

Do not back up Stats cache folders. The preferences plist is enough for app settings, and it should be committed only after checking that its sanitized contents are safe to publish.

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
