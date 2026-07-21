# VS Code Insiders Settings

This README is generated from `vscode-insiders/settings.json`.

The backed-up settings file corresponds to the macOS VS Code Insiders user settings file:

```text
~/Library/Application Support/Code - Insiders/User/settings.json
```

Regenerate this README with Codex:

```bash
./scripts/update-vscode-insiders-readme.sh
```

The main `backup.sh` script runs this generator automatically after copying and
sanitizing `settings.json`. The generator skips the Codex call when the settings
hash has not changed.

## Summary

`settings.json` currently contains **44 top-level setting(s)**.

## Settings by category

### Autosave / files

| Setting | Current value summary | Notes |
|---|---|---|
| `files.autoSave` | `afterDelay` | Controls autosave behavior. |
| `files.autoSaveDelay` | `2000` | Sets autosave delay in milliseconds. |

### Easy Toggle Settings

| Setting | Current value summary | Notes |
|---|---|---|
| `easy-toggle-settings.items` | 1 item(s) |  |

### Editor behavior

| Setting | Current value summary | Notes |
|---|---|---|
| `editor.fontSize` | `16` | Sets the editor font size. |
| `editor.minimap.enabled` | `false` | Controls whether the editor minimap is shown. |
| `editor.quickSuggestions` | 3 nested setting(s) | Controls automatic quick suggestions. |
| `editor.renderValidationDecorations` | `on` | Controls validation decorations in the editor. |
| `editor.suggestOnTriggerCharacters` | `true` | Controls suggestions triggered by typed characters. |
| `editor.tabCompletion` | `on` | Controls tab completion behavior. |
| `editor.wordWrap` | `on` | Controls editor word wrapping. |
| `zenMode.hideLineNumbers` | `false` | Controls whether line numbers are hidden in Zen Mode. |

### File associations

| Setting | Current value summary | Notes |
|---|---|---|
| `workbench.editorAssociations` | 1 nested setting(s) | Controls file-to-editor associations. |

### Git

| Setting | Current value summary | Notes |
|---|---|---|
| `git.autofetch` | `true` | Controls automatic Git fetching. |
| `git.confirmSync` | `false` | Controls confirmation prompts before Git sync. |
| `git.enableSmartCommit` | `true` | Allows committing all changes when no files are staged. |

### LaTeX Workshop

| Setting | Current value summary | Notes |
|---|---|---|
| `latex-workshop.intellisense.package.enabled` | `true` |  |
| `latex-workshop.intellisense.package.env.enabled` | `true` |  |
| `latex-workshop.intellisense.package.unusual` | `true` |  |
| `latex-workshop.intellisense.subsuperscript.enabled` | `true` |  |
| `latex-workshop.intellisense.unimathsymbols.enabled` | `true` |  |
| `latex-workshop.intellisense.update.aggressive.enabled` | `true` |  |
| `latex-workshop.intellisense.update.delay` | `500` |  |
| `latex-workshop.kpsewhich.bibtex.enabled` | `true` |  |
| `latex-workshop.kpsewhich.class.enabled` | `true` |  |
| `latex-workshop.latex.autoBuild.run` | `onSave` | Controls when LaTeX Workshop auto-builds documents. |
| `latex-workshop.latex.watch.pdf.delay` | `1000` | Sets the PDF watcher delay. |
| `latex-workshop.message.error.show` | `false` | Controls LaTeX Workshop error popup messages. |
| `latex-workshop.view.pdf.invert` | `1` | Controls PDF inversion intensity. |
| `latex-workshop.view.pdf.invertMode.enabled` | `never` | Controls when PDF invert mode is enabled. |
| `latex-workshop.view.pdf.viewer` | `tab` | Controls the LaTeX Workshop PDF viewer type. |

### Language-specific overrides

| Setting | Current value summary | Notes |
|---|---|---|
| `[latex]` | 2 nested setting(s) |  |
| `[tex]` | 2 nested setting(s) |  |

### Lean

| Setting | Current value summary | Notes |
|---|---|---|
| `lean4.alwaysAskBeforeInstallingLeanVersions` | `true` | Controls whether Lean version installs require confirmation. |

### Other settings

| Setting | Current value summary | Notes |
|---|---|---|
| `chat.editor.fontSize` | `16` |  |
| `chat.fontSize` | `16` |  |

### Spell checking

| Setting | Current value summary | Notes |
|---|---|---|
| `cSpell.diagnosticLevel` | `Warning` | Sets spell-checking diagnostic severity. |
| `cSpell.enabled` | `true` | Enables or disables cSpell. |
| `cSpell.enabledFileTypes` | 5 nested setting(s) |  |
| `cSpell.enabledSchemes` | 12 nested setting(s) |  |
| `cSpell.ignoreRegExpList` | 4 item(s) | Stores regular expressions ignored by spell checking. |
| `cSpell.language` | `en-US` | Sets the spell-checking language. |
| `cSpell.useCustomDecorations` | `false` |  |
| `cSpell.userWords` | 42 item(s) | Stores custom words accepted by the spell checker. |

### Theme / appearance

| Setting | Current value summary | Notes |
|---|---|---|
| `workbench.colorTheme` | `GitHub Dark Default` | Sets the active color theme. |

## Related files

```text
vscode-insiders/settings.json
vscode-insiders/keybindings.json
vscode-insiders/extensions.txt
vscode-insiders/snippets/
```

## Manual restore

From the root of this repository:

```bash
VSCODE_USER="$HOME/Library/Application Support/Code - Insiders/User"
mkdir -p "$VSCODE_USER"
cp vscode-insiders/settings.json "$VSCODE_USER/settings.json"

if [ -f vscode-insiders/keybindings.json ]; then
  cp vscode-insiders/keybindings.json "$VSCODE_USER/keybindings.json"
fi

if [ -d vscode-insiders/snippets ]; then
  rm -rf "$VSCODE_USER/snippets"
  cp -R vscode-insiders/snippets "$VSCODE_USER/snippets"
fi
```

Then restart VS Code Insiders.

## Extension restore

If `extensions.txt` is present, reinstall the listed extensions with:

```bash
while IFS= read -r extension; do
  code-insiders --install-extension "$extension"
done < vscode-insiders/extensions.txt
```

## Privacy notes

Before committing changes, check that `settings.json`, snippets, and extension lists do not contain:

```text
tokens
API keys
private URLs
account identifiers
machine-specific secrets
absolute paths you do not want public
```

The main backup script performs sanitization and optional secret scanning, but this repository is public, so unusual changes should still be reviewed.
