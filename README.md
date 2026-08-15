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
| [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/) | User settings, keybindings, snippets, extension list, generated folder documentation, and a reproducible LaTeX Workshop PDF-link integration |
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

### Relative TeX-line links in LaTeX Workshop PDFs

Some generated PDFs use privacy-safe links such as
`https://vscode-insiders.invalid/source.tex:1500:1`. LaTeX Workshop's
PDF.js viewer normally permits only ordinary web links, so the repository
includes an idempotent local installer:

```text
scripts/ensure-latex-workshop-relative-links.py
```

The installer finds every installed `james-yu.latex-workshop-*` extension
version, verifies the expected viewer source layout, saves the unmodified file
as `viewer.js.macsettings-backup`, and adds a narrow handler for the reserved
`vscode-insiders.invalid` authority. The handler resolves the source filename
relative to the directory containing the open PDF and falls back to the first
workspace folder only when the PDF client cannot be identified. It rejects
parent-directory components and does not change ordinary web links.

This integration modifies the locally installed LaTeX Workshop extension; it
is not a VS Code setting and is therefore not carried by `settings.json` or
Settings Sync.

#### Behavior after updates

- A routine VS Code Insiders application update normally leaves installed
  extension files alone, although an accompanying extension update can still
  replace the patched file.
- A LaTeX Workshop update normally creates or replaces an extension-version
  directory. The newly active version may therefore be unpatched until the
  installer runs again.
- The installer runs automatically from `backup.sh` and from the tracked
  `pre-commit`, `pre-push`, `post-merge`, `post-checkout`, and `post-rewrite`
  hooks. These cover the normal macsettings backup, commit, push, pull, branch
  checkout, and rebase workflows.
- An extension update does not itself run a macsettings Git hook. To restore
  the feature immediately after updating LaTeX Workshop, run the installer
  directly.
- If a future LaTeX Workshop release changes the relevant source layout, the
  installer exits with a clear error rather than applying a speculative patch.
  The installer must then be reviewed and adapted for that release.
- Whenever the installer reports that it changed an extension, run
  **Developer: Reload Window** in VS Code Insiders before testing the links.

Git deliberately does not enable hooks supplied by a newly cloned repository.
After cloning on a new Mac, install LaTeX Workshop and run this one-time setup:

```bash
./scripts/setup-local-hooks.sh
```

Run the installer directly at any time with:

```bash
./scripts/ensure-latex-workshop-relative-links.py
```

#### Sharing the functionality

The PDF alone contains only a relative source filename, line, and column. It
does not contain a local home-directory path. For another user to retain the
click-to-source behavior:

1. Share the PDF together with its corresponding source file, preserving the
   relative filename encoded in the PDF. The simplest arrangement is to keep
   the PDF and source file in the same directory.
2. The recipient installs VS Code Insiders and LaTeX Workshop.
3. The recipient obtains this generic installer and runs
   `scripts/setup-local-hooks.sh` once from a clone of this repository. If the
   recipient receives only the standalone installer, they can run
   `scripts/ensure-latex-workshop-relative-links.py` directly but must repeat
   that command after relevant extension updates.
4. The recipient reloads the VS Code Insiders window after the installer makes
   a change.

The installer and this documentation are deliberately project-neutral. They do
not contain manuscript names, unrelated project details, personal identifiers,
or local filesystem paths.

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
