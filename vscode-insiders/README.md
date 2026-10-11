<!-- settings-sha256:611bbcd1453f218d831bae6e727d03d554a61c8d91c2dcd69fea1095dc6d433a; generator-version:2 -->

# VS Code Insiders Settings

## Overview

This configuration tailors VS Code Insiders for writing LaTeX, viewing PDFs, working with Git and Remote SSH, and editing prose with spell checking. It also adjusts general editor appearance, completion behavior, autosave, chat text sizing, and Zen Mode.

The file is **JSON with Comments (JSONC)** rather than strict JSON because it contains `//` comments. VS Code supports JSONC in `settings.json`.

Settings supplied by extensions take effect only when the corresponding extensions are installed. This configuration includes settings associated with LaTeX Workshop, Code Spell Checker, Lean 4, Remote - SSH, and a settings-toggle extension.

## Editor behavior and appearance

### Minimap

`editor.minimap.enabled` is set to `false`, hiding the code minimap normally displayed beside the editor scrollbar. This leaves more horizontal space for the document.

### Word wrapping

`editor.wordWrap` is set to `"on"`, so long lines wrap at the editor viewport instead of requiring horizontal scrolling. Wrapping changes only the on-screen presentation; it does not insert line breaks into the file.

### Editor font size

`editor.fontSize` is set to `16`, making text in standard editor tabs use a 16-pixel font size.

### Validation decorations

`editor.renderValidationDecorations` is set to `"on"`, allowing validation diagnostics such as errors and warnings to be displayed in the editor.

### Color theme

`workbench.colorTheme` selects `"GitHub Dark Default"` as the workbench theme. The theme must be installed and available for VS Code Insiders to apply it; it is commonly provided by the GitHub Theme extension.

## Chat appearance

`chat.fontSize` is set to `16`. It controls the font size of ordinary chat text and the chat prompt input.

`chat.editor.fontSize` is also set to `16`. It controls editor-style content embedded in chat, including code snippets and diffs.

These are built-in VS Code chat settings where the corresponding chat interface is available.

## Zen Mode

`zenMode.hideLineNumbers` is set to `false`, preserving editor line numbers when Zen Mode is active instead of hiding them.

## Suggestions and completion

### General quick suggestions

`editor.quickSuggestions` configures when automatic suggestions may appear:

- `"other": true` enables quick suggestions in ordinary code or document content.
- `"comments": false` disables automatic quick suggestions in comments.
- `"strings": true` enables them inside strings and string-like regions.

How a language extension classifies text as ordinary content, a comment, or a string can affect which rule applies.

`editor.suggestOnTriggerCharacters` is `true`, allowing completion providers to open suggestions when a language-specific trigger character is typed.

`editor.tabCompletion` is `"on"`, allowing the Tab key to accept or insert suitable completions when one is available.

### LaTeX language override

The `[latex]` object applies only to editors whose language identifier is `latex`.

Its `editor.quickSuggestions` object repeats the general configuration:

- Suggestions are enabled for `"other"`.
- Suggestions are disabled for `"comments"`.
- Suggestions are enabled for `"strings"`.

`editor.suggest.snippetsPreventQuickSuggestions` is `false`, allowing quick suggestions to continue appearing even when a snippet could otherwise suppress them.

### TeX language override

The `[tex]` object applies the same override to editors whose language identifier is `tex`:

- `editor.quickSuggestions.other` is `true`.
- `editor.quickSuggestions.comments` is `false`.
- `editor.quickSuggestions.strings` is `true`.
- `editor.suggest.snippetsPreventQuickSuggestions` is `false`.

Providing both `[latex]` and `[tex]` covers extensions or files that use either language identifier.

## PDF file association

`workbench.editorAssociations` maps the filename pattern `"*.pdf"` to `"latex-workshop-pdf-hook"`.

This causes PDF files to open through LaTeX Workshop’s PDF editor integration rather than through another registered PDF editor. This association requires the LaTeX Workshop extension.

## Git

These are built-in VS Code Git settings.

`git.autofetch` is `true`, allowing VS Code to fetch updated remote Git references automatically.

`git.enableSmartCommit` is `true`, enabling the Source Control interface to commit all current changes when a commit is requested without explicitly staged changes.

`git.confirmSync` is `false`, suppressing the confirmation prompt normally associated with running Git synchronization from VS Code. A sync can exchange commits with the configured remote, so the action proceeds without that extra confirmation.

## Lean 4

`lean4.alwaysAskBeforeInstallingLeanVersions` is `true`. The Lean 4 extension will ask before installing a Lean version rather than proceeding without confirmation.

This is an extension-provided setting and requires the Lean 4 extension.

## LaTeX Workshop

All `latex-workshop.*` settings are provided by the LaTeX Workshop extension and have no effect unless that extension is installed.

### Automatic builds

`latex-workshop.latex.autoBuild.run` is `"onSave"`, instructing LaTeX Workshop to start its configured LaTeX build process whenever a relevant document is saved.

Because `files.autoSave` is enabled elsewhere in this configuration, an automatic save can also trigger an automatic LaTeX build.

### PDF viewer

`latex-workshop.view.pdf.viewer` is `"tab"`, selecting LaTeX Workshop’s internal PDF viewer in a VS Code editor tab.

### PDF inversion and dark mode

`latex-workshop.view.pdf.invert` is `1`. This configures the inversion amount used by LaTeX Workshop’s PDF display when its inversion mode is active.

`latex-workshop.view.pdf.invertMode.enabled` is `"never"`, so PDF inversion is globally disabled by this configuration until another setting scope—such as a workspace override—changes it.

### Workspace PDF dark-mode toggle

`easy-toggle-settings.items` is an array of toggle definitions supplied by the extension that implements Easy Toggle Settings. The configured array contains one toggle:

- `"property"` is `"latex-workshop.view.pdf.invertMode.enabled"`, identifying the setting to change.
- `"icon"` is `"color-mode"`, selecting the icon used for the toggle where the extension displays it.
- `"values"` is the two-element array `["always", "never"]`, defining the values through which the toggle switches.
- `"disabledValue"` is `"never"`, identifying `"never"` as the disabled state.
- `"isWorkspace"` is `true`, directing the toggle to write its change at workspace scope.

The practical result is a workspace-specific control for switching LaTeX Workshop PDF inversion between `"always"` and `"never"`. Using workspace scope prevents the toggle from changing the user-level behavior of every VS Code Insiders window.

This configuration requires both LaTeX Workshop and the extension that provides `easy-toggle-settings.items`.

### File watching and PDF refresh

`latex-workshop.latex.watch.usePolling` is `false`, so polling is not enabled for LaTeX Workshop’s file watcher. The accompanying source comment discusses polling as a possible reliability aid, but the configured value explicitly leaves it disabled.

`latex-workshop.latex.watch.pdf.delay` is `1000`, configuring a 1,000-millisecond delay for the PDF watcher before it refreshes the viewer. This can provide time for a rebuilt PDF to finish being written before it is reloaded.

### Error notifications

`latex-workshop.message.error.show` is `false`, disabling LaTeX Workshop’s error popup notifications. This affects popup presentation; errors may still be available through other extension or VS Code interfaces.

### IntelliSense

The following settings configure LaTeX Workshop’s completion and IntelliSense features:

- `latex-workshop.intellisense.package.enabled` is `true`, enabling package-related IntelliSense.
- `latex-workshop.intellisense.package.env.enabled` is `true`, enabling package-provided environment information in IntelliSense.
- `latex-workshop.intellisense.package.unusual` is `true`, allowing package IntelliSense to include packages the extension classifies as unusual.
- `latex-workshop.intellisense.unimathsymbols.enabled` is `true`, enabling completion support based on Unicode mathematical symbols.
- `latex-workshop.intellisense.subsuperscript.enabled` is `true`, enabling IntelliSense support related to LaTeX subscript and superscript input.
- `latex-workshop.intellisense.update.aggressive.enabled` is `true`, enabling the extension’s more aggressive IntelliSense update behavior.
- `latex-workshop.intellisense.update.delay` is `500`, setting the IntelliSense update delay to 500 milliseconds.

### TeX file lookup

`latex-workshop.kpsewhich.bibtex.enabled` is `true`, allowing LaTeX Workshop to use `kpsewhich` when resolving BibTeX-related files available through the installed TeX distribution.

`latex-workshop.kpsewhich.class.enabled` is `true`, allowing `kpsewhich` lookup for LaTeX class files such as `.cls` files.

These lookups depend on a TeX distribution, such as TeX Live or MacTeX, providing `kpsewhich` and making it available to the extension.

## Autosave

These are built-in VS Code file settings.

`files.autoSave` is `"afterDelay"`, enabling automatic saving after editing activity stops for the configured delay.

`files.autoSaveDelay` is `2000`, setting that delay to 2,000 milliseconds, or two seconds.

Autosaves are normal save events for settings and extensions that react to saves. In particular, they can trigger the configured LaTeX Workshop `"onSave"` build behavior.

## Spell checking

All `cSpell.*` settings are provided by the Code Spell Checker extension and require that extension to be installed.

### General behavior

`cSpell.enabled` is `true`, enabling spell checking.

`cSpell.language` is `"en-US"`, selecting the US English dictionary and spelling conventions.

`cSpell.diagnosticLevel` is `"Warning"`, reporting detected spelling issues as warning-level diagnostics.

`cSpell.useCustomDecorations` is `false`, disabling the extension’s custom decoration mechanism. Spelling diagnostics can instead use the configured diagnostic presentation.

### Enabled file types

`cSpell.enabledFileTypes` is an object that explicitly enables spell checking for these language identifiers:

- `"latex": true`
- `"tex": true`
- `"bibtex": true`
- `"markdown": true`
- `"plaintext": true`

This covers LaTeX and TeX sources, BibTeX databases, Markdown documents, and plain-text files.

### Ignored regular expressions

`cSpell.ignoreRegExpList` contains regular-expression strings for text that should be excluded from spell checking. Because these expressions are stored inside JSON strings, backslashes are escaped for JSONC as well as for the regular-expression syntax.

- `\\\\[a-zA-Z]+` matches a backslash followed by one or more ASCII letters. It is intended to ignore LaTeX command names such as `\section` or `\alpha`.
- `\\$[^$]*\\$` matches a dollar sign, any number of non-dollar characters, and another dollar sign. It ignores single-dollar inline mathematical material that does not itself contain a dollar sign.
- `\\\\\\[[\\s\\S]*?\\\\\\]` matches content delimited by `\[` and `\]`, including content spanning lines. The non-greedy `*?` limits each match to the next closing delimiter.
- `\\\\\\([\\s\\S]*?\\\\\\)` matches content delimited by `\(` and `\)`, including multiline content.

In the last two expressions, `[\s\S]` is used to match both whitespace and non-whitespace characters, effectively allowing any character including newlines.

These patterns reduce spelling diagnostics for LaTeX commands and common mathematical regions. They do not describe every possible TeX construct.

### Custom dictionary

`cSpell.userWords` is an array of words accepted by the spell checker. Entries preserve specialized terminology, names, abbreviations, package names, and chosen compound spellings:

`ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`, `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, and `wavefunction`.

These entries suppress spelling warnings for exact words recognized through the custom dictionary. Case handling is determined by Code Spell Checker’s dictionary rules.

### Enabled URI schemes

`cSpell.enabledSchemes` controls which document URI schemes Code Spell Checker may process. Every listed scheme is enabled:

- `"comment": true` enables documents using the `comment` scheme.
- `"file": true` enables ordinary files.
- `"gist": true` enables documents exposed through the `gist` scheme.
- `"repo": true` enables documents exposed through the `repo` scheme.
- `"sftp": true` enables documents exposed through an SFTP scheme.
- `"untitled": true` enables new, unsaved editors.
- `"vscode-notebook-cell": true` enables notebook cells.
- `"vscode-scm": true` enables documents exposed through VS Code source-control interfaces.
- `"vscode-userdata": true` enables documents stored through VS Code’s user-data scheme.
- `"vscode-vfs": true` enables documents exposed through VS Code’s virtual filesystem scheme.
- `"vsls": true` enables documents associated with the Visual Studio Live Share scheme.
- `"overleaf-workshop": true` enables documents exposed through the Overleaf Workshop scheme.

Some schemes are created by optional extensions or particular VS Code features. Enabling a scheme permits spell checking when such documents exist; it does not install or activate the feature that provides the scheme.

## Remote SSH

The `remote.SSH.*` settings are provided by Microsoft’s Remote - SSH extension and require that extension.

`remote.SSH.showLoginTerminal` is `true`, showing the SSH login terminal during connection. This makes interactive prompts and connection output visible.

`remote.SSH.useLocalServer` is `false`, disabling the Remote - SSH local-server connection mode.

`remote.SSH.useExecServer` is `false`, disabling the extension’s exec-server mode.

`remote.SSH.remotePlatform` is a host-to-platform mapping. The entry `"tiger3.princeton.edu": "linux"` tells Remote - SSH to treat that named remote host as Linux when choosing and operating its remote components.

`remote.SSH.enableDynamicForwarding` is `false`, disabling the extension’s dynamic SSH forwarding option.

## Extension requirements

The built-in editor, workbench, Git, autosave, chat, and Zen Mode settings are handled by VS Code Insiders itself. The following portions require corresponding extensions or features:

- `latex-workshop.*` and the `"latex-workshop-pdf-hook"` association require LaTeX Workshop.
- `cSpell.*` requires Code Spell Checker.
- `lean4.*` requires the Lean 4 extension.
- `remote.SSH.*` requires Remote - SSH.
- `easy-toggle-settings.*` requires the extension that provides Easy Toggle Settings.
- `"GitHub Dark Default"` must be supplied by an installed and enabled theme.
- URI schemes such as `overleaf-workshop`, `gist`, `sftp`, and `vsls` are useful only when a feature or extension provides documents under those schemes.

Language-specific behavior also depends on an installed extension assigning the relevant `latex`, `tex`, or `bibtex` language identifier.

## Restoring the configuration on macOS

The VS Code Insiders user settings file is located at:

`~/Library/Application Support/Code - Insiders/User/settings.json`

To restore this configuration:

1. Quit VS Code Insiders or close all windows that might overwrite user settings.
2. Create the `User` directory if it does not already exist.
3. Place the supplied JSONC content in `settings.json` at the path above.
4. Reopen VS Code Insiders.
5. Install and enable the extensions required by the extension-specific settings.

If a `settings.json` file already exists, back it up or merge the supplied properties into it instead of replacing settings that should be retained. Since settings objects cannot contain duplicate keys reliably, each top-level setting should appear only once after a merge.
