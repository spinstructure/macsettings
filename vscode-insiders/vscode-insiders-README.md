# VS Code Insiders `settings.json`

This file documents the purpose of the `settings.json` file in this folder.

The backed-up file is:

```text
vscode-insiders/settings.json
```

It corresponds to the VS Code Insiders user settings file on macOS:

```text
~/Library/Application Support/Code - Insiders/User/settings.json
```

This is for **Visual Studio Code Insiders**, not the stable Visual Studio Code app.

## Overview

The current `settings.json` configures VS Code Insiders for a LaTeX-heavy workflow, with additional settings for Git, Lean, PDF viewing, autosave, and spell checking.

The major groups of settings are:

```text
Editor behavior
Zen Mode behavior
LaTeX / TeX editing
PDF viewing through LaTeX Workshop
PDF dark/invert mode toggle
Git behavior
Theme
Lean version handling
LaTeX Workshop build/viewer/IntelliSense behavior
Autosave
cSpell spell checking
```

## Editor behavior

These settings control general editor behavior:

```jsonc
"editor.minimap.enabled": false
"editor.wordWrap": "on"
"editor.fontSize": 16
"editor.renderValidationDecorations": "on"
```

They disable the minimap, enable word wrapping, set a larger editor font size, and keep validation decorations visible.

## Zen Mode

```jsonc
"zenMode.hideLineNumbers": false
```

This keeps line numbers visible when entering Zen Mode.

## Suggestions and tab completion

The settings enable automatic suggestions and tab completion:

```jsonc
"editor.quickSuggestions": {
  "other": true,
  "comments": false,
  "strings": true
}

"editor.suggestOnTriggerCharacters": true
"editor.tabCompletion": "on"
```

This makes suggestions appear automatically in ordinary code/text and strings, while disabling suggestions in comments.

## LaTeX and TeX-specific suggestions

The `[latex]` and `[tex]` sections override editor behavior specifically for LaTeX and TeX files:

```jsonc
"[latex]": {
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": true
  },
  "editor.suggest.snippetsPreventQuickSuggestions": false
}

"[tex]": {
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": true
  },
  "editor.suggest.snippetsPreventQuickSuggestions": false
}
```

These settings are intended to keep autocomplete/snippet suggestions responsive while editing LaTeX documents.

## PDF association

```jsonc
"workbench.editorAssociations": {
  "*.pdf": "latex-workshop-pdf-hook"
}
```

This opens PDF files using the LaTeX Workshop PDF viewer hook rather than the default PDF viewer.

## Git settings

```jsonc
"git.autofetch": true
"git.enableSmartCommit": true
"git.confirmSync": false
```

These settings enable automatic fetching, allow smart commits, and avoid confirmation prompts when syncing.

## Theme

```jsonc
"workbench.colorTheme": "GitHub Dark Default"
```

This sets the VS Code Insiders color theme.

## Lean

```jsonc
"lean4.alwaysAskBeforeInstallingLeanVersions": true
```

This makes Lean version installation explicit rather than automatic.

## LaTeX Workshop build behavior

```jsonc
"latex-workshop.latex.autoBuild.run": "onSave"
```

This builds LaTeX whenever a file is saved.

Because autosave is also enabled, this means LaTeX can be rebuilt shortly after editing pauses.

## LaTeX Workshop PDF viewer

```jsonc
"latex-workshop.view.pdf.viewer": "tab"
```

This uses LaTeX Workshop's internal PDF viewer inside a VS Code tab.

## LaTeX Workshop PDF dark/invert mode

```jsonc
"latex-workshop.view.pdf.invert": 1
"latex-workshop.view.pdf.invertMode.enabled": "always"
```

These settings configure LaTeX Workshop's PDF color inversion/dark-mode behavior.

There is also an Easy Toggle Settings button:

```jsonc
"easy-toggle-settings.items": [
  {
    "property": "latex-workshop.view.pdf.invertMode.enabled",
    "icon": "color-mode",
    "values": ["always", "never"],
    "disabledValue": "never"
  }
]
```

This adds a status-bar toggle for switching the PDF invert mode between:

```text
always
never
```

## PDF watcher delay

```jsonc
"latex-workshop.latex.watch.pdf.delay": 1000
```

This gives the PDF watcher more time before refreshing the viewer. It can help when the PDF rebuilds correctly but the viewer tab does not update immediately.

## LaTeX Workshop notifications

```jsonc
"latex-workshop.message.error.show": false
```

This suppresses LaTeX Workshop error popup notifications.

## LaTeX Workshop IntelliSense

The following settings improve LaTeX Workshop autocomplete and package/environment suggestions:

```jsonc
"latex-workshop.intellisense.package.enabled": true
"latex-workshop.intellisense.package.env.enabled": true
"latex-workshop.intellisense.package.unusual": true
"latex-workshop.intellisense.unimathsymbols.enabled": true
"latex-workshop.intellisense.subsuperscript.enabled": true
"latex-workshop.intellisense.update.aggressive.enabled": true
"latex-workshop.intellisense.update.delay": 500
```

These are intended to make LaTeX suggestions more complete and more responsive.

## TeX Live / MacTeX lookup

```jsonc
"latex-workshop.kpsewhich.bibtex.enabled": true
"latex-workshop.kpsewhich.class.enabled": true
```

These enable `kpsewhich` lookup for BibTeX and class files. This is useful when resolving files installed through TeX Live or MacTeX.

## Autosave

```jsonc
"files.autoSave": "afterDelay"
"files.autoSaveDelay": 2000
```

Files are autosaved after a 2 second delay.

Since LaTeX Workshop builds on save, this can also trigger LaTeX rebuilds after autosave.

## cSpell spell checking

Spell checking is enabled:

```jsonc
"cSpell.enabled": true
"cSpell.language": "en-US"
"cSpell.diagnosticLevel": "Warning"
"cSpell.useCustomDecorations": false
```

The enabled file types include LaTeX, TeX, BibTeX, Markdown, and plaintext:

```jsonc
"cSpell.enabledFileTypes": {
  "latex": true,
  "tex": true,
  "bibtex": true,
  "markdown": true,
  "plaintext": true
}
```

## cSpell LaTeX ignore patterns

The `cSpell.ignoreRegExpList` ignores common LaTeX constructs such as commands and math expressions.

This helps avoid false spelling warnings inside expressions like:

```text
\command
$...$
\[...\]
\(...\)
```

## cSpell custom words

The `cSpell.userWords` list contains technical words that should not be flagged as spelling errors.

Examples include terms from physics, mathematics, and geometry/topology, such as:

```text
bosonization
cohomology
diffeomorphism
equivariant
fermionic
holomorphic
monoidal
orbifold
spinor
supergravity
symplectic
topological
```

## cSpell schemes

The `cSpell.enabledSchemes` section enables spell checking in several VS Code URI schemes, including ordinary files, untitled buffers, notebooks, source-control views, and Overleaf-related virtual files.

## Restore instructions

To restore this file manually on macOS:

```bash
VSCODE_USER="$HOME/Library/Application Support/Code - Insiders/User"

mkdir -p "$VSCODE_USER"
cp vscode-insiders/settings.json "$VSCODE_USER/settings.json"
```

Then restart VS Code Insiders.

## Privacy notes

Before committing changes to `settings.json`, check that it does not contain:

```text
API keys
tokens
private URLs
account identifiers
machine-specific secrets
absolute paths you do not want public
```

The repository backup script performs sanitization and optional secret scanning, but this file should still be treated as public.
