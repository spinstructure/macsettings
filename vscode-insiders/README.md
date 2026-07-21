<!-- settings-sha256:ebbba322a1e229c5f51f39cd967a81adae2aacff0ea741d0baee6b5e0bdd4ea4; generator-version:2 -->

# VS Code Insiders Settings

This README documents the supplied VS Code Insiders user configuration. The `settings.json` file uses **JSON with Comments (JSONC)**, allowing `//` comments alongside normal JSON syntax.

Settings beginning with `editor.`, `chat.`, `zenMode.`, `workbench.`, `git.`, and `files.` are built into VS Code Insiders. Settings for LaTeX Workshop, Code Spell Checker, Lean 4, and Easy Toggle Settings require their corresponding extensions to be installed. The selected color theme must also be available.

## Editor Behavior

- `editor.minimap.enabled`: Set to `false`, hiding the code minimap normally displayed beside the editor scrollbar.

- `editor.wordWrap`: Set to `"on"`, wrapping long lines at the editor viewport instead of requiring horizontal scrolling.

- `editor.fontSize`: Set to `16`, using a 16-pixel font size in text editors.

- `editor.renderValidationDecorations`: Set to `"on"`, allowing validation diagnostics such as errors and warnings to be rendered in the editor.

### Suggestions and Completion

- `editor.quickSuggestions`: Controls where automatic completion suggestions may appear:

  - `"other": true` enables suggestions in ordinary code or text.
  - `"comments": false` disables automatic suggestions inside comments.
  - `"strings": true` enables suggestions inside strings.

- `editor.suggestOnTriggerCharacters`: Set to `true`, allowing language services and extensions to open suggestions after recognized trigger characters.

- `editor.tabCompletion`: Set to `"on"`, allowing Tab to insert an available completion when appropriate.

## Language-Specific LaTeX Overrides

VS Code language-specific settings use keys of the form `[language-id]`. These settings apply only while editing files recognized as the named language.

Both `[latex]` and `[tex]` contain the same configuration so that completion behavior remains consistent for files assigned either language identifier.

### `[latex]`

- `editor.quickSuggestions` enables automatic suggestions in ordinary text and strings while disabling them in comments:

  - `"other": true`
  - `"comments": false`
  - `"strings": true`

- `editor.suggest.snippetsPreventQuickSuggestions`: Set to `false`, allowing quick suggestions to remain available when snippets are involved instead of letting snippet behavior suppress them.

### `[tex]`

- `editor.quickSuggestions` uses the same values as the `[latex]` override:

  - `"other": true`
  - `"comments": false`
  - `"strings": true`

- `editor.suggest.snippetsPreventQuickSuggestions`: Set to `false`, allowing quick suggestions while snippets are active.

## Chat Appearance

These are built-in VS Code Insiders chat settings.

- `chat.fontSize`: Set to `16`, controlling the font size of normal chat text and the chat prompt input.

- `chat.editor.fontSize`: Set to `16`, controlling the font size of editor-like content within chat, including code snippets and diffs.

## Zen Mode

- `zenMode.hideLineNumbers`: Set to `false`, keeping editor line numbers visible when Zen Mode is active.

## Appearance

- `workbench.colorTheme`: Set to `"GitHub Dark Default"`, selecting that theme for the VS Code Insiders interface. The theme must be installed or otherwise available for VS Code to apply it.

## Git

These settings configure VS Code’s built-in Git integration.

- `git.autofetch`: Set to `true`, periodically fetching remote repository information in the background.

- `git.enableSmartCommit`: Set to `true`, enabling VS Code’s smart-commit workflow, including committing staged or otherwise eligible changes without requiring the user to stage files through the Source Control interface first in applicable situations.

- `git.confirmSync`: Set to `false`, suppressing the confirmation prompt that would otherwise appear before synchronizing local commits with a remote repository. Synchronization can fetch, pull, or push as required by the repository state.

## Lean 4

This extension-provided setting requires the Lean 4 extension.

- `lean4.alwaysAskBeforeInstallingLeanVersions`: Set to `true`, instructing the extension to ask before installing Lean versions rather than installing them without confirmation.

## LaTeX Workshop

All `latex-workshop.*` settings require the LaTeX Workshop extension.

### Automatic Building

- `latex-workshop.latex.autoBuild.run`: Set to `"onSave"`, triggering a LaTeX build whenever a LaTeX source file is saved. Because delayed autosave is enabled elsewhere in this configuration, an autosave can also trigger a build.

### PDF Viewing

- `latex-workshop.view.pdf.viewer`: Set to `"tab"`, opening LaTeX Workshop’s PDF viewer in a VS Code editor tab.

- `latex-workshop.view.pdf.invert`: Set to `1`, configuring the PDF viewer’s inversion level used when its invert mode is active.

- `latex-workshop.view.pdf.invertMode.enabled`: Set to `"never"` at the user-settings level, so PDF inversion is not globally enabled. The Easy Toggle Settings item described below can create a workspace-specific value of `"always"` or `"never"`.

- `latex-workshop.latex.watch.pdf.delay`: Set to `1000`, adding a 1,000-millisecond delay before the PDF watcher refreshes the viewer after detecting an updated PDF. This can give a build process time to finish writing the file before it is reloaded.

### PDF File Association

`workbench.editorAssociations` is a built-in VS Code setting, but the configured target is provided by LaTeX Workshop:

- `"*.pdf": "latex-workshop-pdf-hook"` associates files matching the `*.pdf` glob with LaTeX Workshop’s PDF editor hook.

The `*.pdf` pattern matches filenames ending in `.pdf`. Opening such a file therefore routes it to the LaTeX Workshop PDF integration when the extension is installed.

### Error Notifications

- `latex-workshop.message.error.show`: Set to `false`, disabling LaTeX Workshop’s error popup notifications. This does not by itself remove diagnostics or build logs exposed through other parts of the extension.

### IntelliSense and Autocomplete

- `latex-workshop.intellisense.package.enabled`: Set to `true`, enabling package-based LaTeX completion data.

- `latex-workshop.intellisense.package.env.enabled`: Set to `true`, enabling environment-related completion data derived from packages.

- `latex-workshop.intellisense.package.unusual`: Set to `true`, allowing IntelliSense support for packages that LaTeX Workshop classifies as unusual.

- `latex-workshop.intellisense.unimathsymbols.enabled`: Set to `true`, enabling completion support based on Unicode mathematical symbol information.

- `latex-workshop.intellisense.subsuperscript.enabled`: Set to `true`, enabling the extension’s subscript and superscript IntelliSense behavior.

- `latex-workshop.intellisense.update.aggressive.enabled`: Set to `true`, enabling more aggressive updating of IntelliSense information as documents change.

- `latex-workshop.intellisense.update.delay`: Set to `500`, applying a 500-millisecond delay to IntelliSense updates.

### TeX File Resolution

These settings enable use of `kpsewhich`, when available through the installed TeX distribution, to locate TeX-related files.

- `latex-workshop.kpsewhich.bibtex.enabled`: Set to `true`, allowing LaTeX Workshop to use `kpsewhich` when resolving bibliography-related files such as `.bib` files.

- `latex-workshop.kpsewhich.class.enabled`: Set to `true`, allowing LaTeX Workshop to use `kpsewhich` when resolving document class files such as `.cls` files.

## PDF Dark-Mode Toggle

The `easy-toggle-settings.items` setting is provided by the Easy Toggle Settings extension.

It contains an array with one toggle definition:

- `property`: Set to `"latex-workshop.view.pdf.invertMode.enabled"`, identifying the LaTeX Workshop setting that the toggle changes.

- `icon`: Set to `"color-mode"`, selecting the icon used for the toggle’s status-bar item.

- `values`: Set to the array `["always", "never"]`, defining the values through which the toggle switches:

  - `"always"` enables PDF invert mode.
  - `"never"` disables PDF invert mode.

- `disabledValue`: Set to `"never"`, identifying `"never"` as the disabled state.

- `isWorkspace`: Set to `true`, making the toggle write the selected value at workspace scope. This allows different workspaces to use different PDF inversion states without changing the user-wide value for every VS Code Insiders window.

The user-wide `latex-workshop.view.pdf.invertMode.enabled` value remains `"never"` unless a more specific workspace setting overrides it.

## Autosave

These are built-in VS Code file settings.

- `files.autoSave`: Set to `"afterDelay"`, automatically saving modified files after the user stops making changes for the configured delay.

- `files.autoSaveDelay`: Set to `2000`, making the autosave delay 2,000 milliseconds, or two seconds.

For LaTeX files, each autosave can activate the `"onSave"` LaTeX Workshop build configuration.

## Spell Checking

All `cSpell.*` settings require the Code Spell Checker extension.

### General Configuration

- `cSpell.enabled`: Set to `true`, enabling spell checking.

- `cSpell.language`: Set to `"en-US"`, selecting US English as the spell-checking language.

- `cSpell.diagnosticLevel`: Set to `"Warning"`, reporting spelling diagnostics at warning severity.

- `cSpell.useCustomDecorations`: Set to `false`, disabling Code Spell Checker’s custom decoration mechanism. Spelling issues can still be represented through the diagnostic mechanism configured by the extension.

### Enabled File Types

`cSpell.enabledFileTypes` is an object that explicitly enables spell checking for these language identifiers:

- `"latex": true`
- `"tex": true`
- `"bibtex": true`
- `"markdown": true`
- `"plaintext": true`

This covers LaTeX and TeX documents, BibTeX databases, Markdown files, and plain-text files.

### Ignored Regular Expressions

`cSpell.ignoreRegExpList` is an array of regular-expression strings. Because `settings.json` is JSONC, backslashes used by the regular expressions must themselves be escaped in the JSON strings.

The configured patterns are:

- `\\\\[a-zA-Z]+` in JSONC represents a regular expression that matches a literal backslash followed by one or more ASCII letters. This ignores command names such as LaTeX control sequences.

- `\\$[^$]*\\$` matches text enclosed by single dollar signs, provided there is no intervening dollar sign. It is intended to ignore dollar-delimited inline mathematics.

- `\\\\\\[[\\s\\S]*?\\\\\\]` matches content delimited by LaTeX’s `\[` and `\]` display-math markers. The `[\s\S]*?` portion matches any characters, including line breaks, as little as necessary before the closing delimiter.

- `\\\\\\([\\s\\S]*?\\\\\\)` matches content delimited by LaTeX’s `\(` and `\)` inline-math markers. It likewise allows the delimited content to span lines.

Together, these patterns reduce spelling warnings for LaTeX commands and several common forms of mathematical content.

### Custom Dictionary

`cSpell.userWords` is an array of terms accepted by Code Spell Checker. It contains project-neutral technical vocabulary, names, abbreviations, package names, and specialized terms:

`ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`, `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, and `wavefunction`.

These entries prevent the listed spellings from being reported as unknown words. Capitalization is preserved as written in the configuration.

### Enabled URI Schemes

`cSpell.enabledSchemes` is an object that enables spell checking for resources opened through the following URI schemes:

- `"comment": true`
- `"file": true`
- `"gist": true`
- `"repo": true`
- `"sftp": true`
- `"untitled": true`
- `"vscode-notebook-cell": true`
- `"vscode-scm": true`
- `"vscode-userdata": true`
- `"vscode-vfs": true`
- `"vsls": true`
- `"overleaf-workshop": true`

These entries allow Code Spell Checker to operate not only on ordinary local files, but also on supported virtual documents, untitled editors, notebook cells, source-control resources, remote or shared resources, and documents exposed through compatible extensions. A scheme is useful only when VS Code or an installed extension supplies resources using that scheme.

## Required Extensions and Components

The configuration references settings or contributions associated with:

- LaTeX Workshop for `latex-workshop.*`, the `latex-workshop-pdf-hook` editor association, LaTeX building, IntelliSense, and PDF viewing.
- Code Spell Checker for `cSpell.*`.
- Lean 4 for `lean4.*`.
- Easy Toggle Settings for `easy-toggle-settings.*`.
- A theme provider containing `"GitHub Dark Default"`.
- A TeX distribution that provides `kpsewhich` if the configured TeX file-resolution features are to be used.

Extension-specific settings have no intended effect unless their corresponding extensions are installed and active.

## Restoring the Configuration on macOS

VS Code Insiders stores user settings at:

`~/Library/Application Support/Code - Insiders/User/settings.json`

To restore this configuration:

1. Quit VS Code Insiders or close all windows that may be editing user settings.
2. Create the `User` directory if it does not already exist.
3. Back up any existing `settings.json` file.
4. Save the supplied JSONC configuration as `settings.json` at the path above.
5. Reopen VS Code Insiders.
6. Install the referenced extensions and ensure the selected theme and any required TeX tooling are available.

The file must retain valid JSONC syntax: property names and string values remain double-quoted, entries are comma-separated, and `//` comments are permitted.
