<!-- settings-sha256:b074728c19a000ddea41755bda110f1f3da52c0eb17e5ee87dca6a1f145d0fd9; generator-version:2 -->

# VS Code Insiders Settings

This configuration defines editor behavior, appearance, Git integration, LaTeX authoring and PDF viewing, autosave, spell checking, Lean support, and Remote SSH behavior for VS Code Insiders.

The file is **JSON with Comments (JSONC)** rather than strict JSON. VS Code accepts JSONC in `settings.json`, allowing the included `//` comments and trailing commas where supported.

Extension-specific settings have an effect only when their corresponding extensions are installed. This configuration references LaTeX Workshop, Code Spell Checker, Easy Toggle Settings, Lean 4, Remote - SSH, and a GitHub color theme.

## Editor appearance and behavior

- `editor.minimap.enabled`: Set to `false`, hiding the editor minimap.

- `editor.wordWrap`: Set to `"on"`, wrapping long lines at the editor viewport rather than requiring horizontal scrolling.

- `editor.fontSize`: Set to `16`, making the main editor font 16 pixels high.

- `editor.renderValidationDecorations`: Set to `"on"`, enabling diagnostic decorations such as error and warning indicators in the editor.

- `zenMode.hideLineNumbers`: Set to `false`, keeping line numbers visible when Zen Mode is active.

## Chat appearance

These are built-in chat interface settings in VS Code Insiders:

- `chat.fontSize`: Set to `16`, controlling the font size of regular chat text and the prompt input.

- `chat.editor.fontSize`: Set to `16`, controlling the editor font used for code snippets, patches, and diffs shown in chat.

## Suggestions and tab completion

The global suggestion settings apply unless a language-specific override changes them.

### Quick suggestions

`editor.quickSuggestions` configures automatic suggestions by text context:

- `"other": true` enables suggestions in ordinary source text.
- `"comments": false` disables automatic suggestions inside comments.
- `"strings": true` enables suggestions inside quoted strings.

This is particularly useful for markup-oriented languages, where meaningful completion targets can appear inside string-like syntax.

### Trigger characters

`editor.suggestOnTriggerCharacters` is `true`, allowing IntelliSense to open automatically when a language provider recognizes a trigger character.

### Tab completion

`editor.tabCompletion` is `"on"`, allowing the Tab key to insert an eligible completion when one is available.

## LaTeX and TeX language overrides

The `[latex]` and `[tex]` objects are language-specific override blocks. They apply only when the active editor is recognized as `latex` or `tex`, respectively.

Both overrides set:

- `editor.quickSuggestions.other` to `true`.
- `editor.quickSuggestions.comments` to `false`.
- `editor.quickSuggestions.strings` to `true`.
- `editor.suggest.snippetsPreventQuickSuggestions` to `false`.

Setting `editor.suggest.snippetsPreventQuickSuggestions` to `false` allows quick suggestions to continue appearing when snippet-related editor state would otherwise suppress them. Together, these overrides favor automatic completion in LaTeX and TeX documents while leaving automatic suggestions inside comments disabled.

The `[latex]` and `[tex]` blocks are separate because VS Code and installed extensions may assign either language identifier to TeX-family files.

## PDF file association

`workbench.editorAssociations` maps filename patterns to editors:

- `"*.pdf": "latex-workshop-pdf-hook"` associates every PDF file with LaTeX Workshop’s PDF editor hook.

This causes PDFs opened in VS Code to be routed through LaTeX Workshop rather than the ordinary default editor association. It requires the LaTeX Workshop extension.

## Git

These are built-in VS Code Git settings:

- `git.autofetch`: Set to `true`, periodically fetching updates from configured Git remotes.

- `git.enableSmartCommit`: Set to `true`, permitting a commit operation to include all current changes when there are changes but nothing has been staged.

- `git.confirmSync`: Set to `false`, suppressing the confirmation prompt before synchronizing commits with a remote. A sync operation may pull and push according to VS Code’s Git workflow.

## Appearance

`workbench.colorTheme` is set to `"GitHub Dark Default"`, selecting the GitHub Dark Default workbench theme.

The named theme must be available in the VS Code Insiders installation. If it is supplied by an extension, that theme extension must be installed and enabled.

## Lean 4

`lean4.alwaysAskBeforeInstallingLeanVersions` is set to `true`.

This is an extension-provided Lean 4 setting. It makes the extension ask for confirmation before installing Lean versions instead of installing them without that prompt. It requires the Lean 4 extension.

## LaTeX Workshop

All settings beginning with `latex-workshop.` are provided by the LaTeX Workshop extension and require that extension to be installed.

### Automatic builds

`latex-workshop.latex.autoBuild.run` is set to `"onSave"`, causing LaTeX Workshop to start its configured build process whenever a relevant LaTeX file is saved.

Because autosave is also enabled, pausing after an edit can trigger this sequence:

1. VS Code automatically saves the file after the configured delay.
2. LaTeX Workshop observes the save.
3. LaTeX Workshop starts a LaTeX build.

### PDF viewer

`latex-workshop.view.pdf.viewer` is set to `"tab"`, opening LaTeX Workshop’s internal PDF viewer in a VS Code editor tab.

### PDF inversion and dark mode

Two settings control the configured PDF inversion behavior:

- `latex-workshop.view.pdf.invert` is set to `1`, configuring LaTeX Workshop’s PDF inversion value.

- `latex-workshop.view.pdf.invertMode.enabled` is set to `"never"`, leaving inversion disabled at the global user-settings level.

A workspace-scoped toggle can switch `latex-workshop.view.pdf.invertMode.enabled` between `"always"` and `"never"` without changing the global setting for every VS Code Insiders window.

### File and PDF watching

`latex-workshop.latex.watch.usePolling` is `true`, making LaTeX Workshop poll for relevant file changes instead of relying exclusively on filesystem-change events. Polling can be more reliable on filesystems or workflows where change notifications are occasionally missed, although it may perform periodic filesystem checks.

`latex-workshop.latex.watch.pdf.delay` is `1000`, giving the PDF watcher a 1,000-millisecond delay before reacting to a rebuilt PDF. This can help avoid refreshing the internal viewer before a PDF update is ready.

### Error notifications

`latex-workshop.message.error.show` is `false`, disabling LaTeX Workshop’s error popup notifications. This does not by itself disable builds, diagnostics, logs, or other places where build errors may be reported.

### IntelliSense

The following settings configure LaTeX Workshop completion and IntelliSense:

- `latex-workshop.intellisense.package.enabled`: `true` enables package-related IntelliSense.

- `latex-workshop.intellisense.package.env.enabled`: `true` enables environment completions associated with packages.

- `latex-workshop.intellisense.package.unusual`: `true` includes package information that LaTeX Workshop categorizes as unusual.

- `latex-workshop.intellisense.unimathsymbols.enabled`: `true` enables completion support based on Unicode mathematical symbols.

- `latex-workshop.intellisense.subsuperscript.enabled`: `true` enables IntelliSense support related to subscript and superscript input.

- `latex-workshop.intellisense.update.aggressive.enabled`: `true` enables the extension’s aggressive IntelliSense update behavior.

- `latex-workshop.intellisense.update.delay`: `500` sets a 500-millisecond delay for relevant IntelliSense updates.

### TeX file lookup

These settings enable LaTeX Workshop to use `kpsewhich`, when available, to locate files known to the installed TeX distribution:

- `latex-workshop.kpsewhich.bibtex.enabled`: `true` enables lookup support for bibliography-related files such as `.bib` files.

- `latex-workshop.kpsewhich.class.enabled`: `true` enables lookup support for document class files such as `.cls` files.

These lookups depend on a TeX distribution, such as TeX Live or MacTeX, providing a usable `kpsewhich` command.

## PDF dark-mode toggle

`easy-toggle-settings.items` is an array supplied to the Easy Toggle Settings extension. Each array element describes a status-bar toggle. This configuration contains one toggle object.

The object has the following fields:

- `property`: Set to `"latex-workshop.view.pdf.invertMode.enabled"`, identifying the setting that the toggle changes.

- `icon`: Set to `"color-mode"`, selecting the icon used for the toggle’s status-bar presentation.

- `values`: The array `["always", "never"]` defines the values through which the setting toggles.

- `disabledValue`: Set to `"never"`, identifying `"never"` as the disabled state.

- `isWorkspace`: Set to `true`, storing the toggled value as a workspace setting rather than changing the global user setting.

As a result, the button switches LaTeX Workshop PDF inversion on or off for the current workspace. Different workspaces can retain different toggle states. This configuration requires both Easy Toggle Settings and LaTeX Workshop.

## Autosave

These are built-in VS Code file settings:

- `files.autoSave`: Set to `"afterDelay"`, automatically saving a modified file after editing pauses.

- `files.autoSaveDelay`: Set to `2000`, making the autosave delay 2,000 milliseconds, or two seconds.

Autosave can trigger other save-based actions, including the configured LaTeX Workshop `"onSave"` build.

## Spell checking

All settings beginning with `cSpell.` are provided by the Code Spell Checker extension and require that extension to be installed.

### General behavior

- `cSpell.enabled`: `true` enables spell checking.

- `cSpell.language`: `"en-US"` selects American English.

- `cSpell.diagnosticLevel`: `"Warning"` reports spelling findings at warning severity.

- `cSpell.useCustomDecorations`: `false` disables the extension’s custom decoration style, leaving spelling findings to be represented through its diagnostic reporting behavior.

### Enabled file types

`cSpell.enabledFileTypes` is an object keyed by VS Code language identifier. Each configured value is `true`, enabling spell checking for:

- `latex`
- `tex`
- `bibtex`
- `markdown`
- `plaintext`

Other language identifiers are not changed by this object.

### Ignored regular expressions

`cSpell.ignoreRegExpList` is an array of regular-expression strings. Text matching these patterns is excluded from spell checking.

Because the file is JSONC, backslashes inside each string are escaped. The effective patterns are intended to ignore common LaTeX commands and mathematical regions:

- `\\\\[a-zA-Z]+` matches a backslash followed by one or more ASCII letters, covering commands such as `\section` or `\alpha`. It targets the command token rather than documenting every possible command argument.

- `\\$[^$]*\\$` matches text between a pair of dollar signs, covering simple inline math such as `$x+y$`.

- `\\\\\\[[\\s\\S]*?\\\\\\]` matches content delimited by `\[` and `\]`. The `[\s\S]` construction includes whitespace and non-whitespace characters, so the match can span lines; `*?` makes the repetition non-greedy.

- `\\\\\\([\\s\\S]*?\\\\\\)` similarly matches content delimited by `\(` and `\)`, including multiline content.

These expressions reduce false-positive spelling warnings in LaTeX control sequences and math. They are textual regular expressions rather than a complete LaTeX parser, so their behavior follows the matched delimiters and character patterns.

### Custom dictionary

`cSpell.userWords` is an array of terms accepted as correctly spelled. It contains:

`ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`, `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, and `wavefunction`.

The dictionary prevents these exact configured terms from being reported as misspellings. It is useful for specialized mathematical, physical, and LaTeX-related vocabulary not necessarily present in the standard `en-US` dictionary.

### Enabled URI schemes

`cSpell.enabledSchemes` controls the URI schemes in which Code Spell Checker is allowed to operate. Every listed scheme is enabled with `true`:

- `comment`
- `file`
- `gist`
- `repo`
- `sftp`
- `untitled`
- `vscode-notebook-cell`
- `vscode-scm`
- `vscode-userdata`
- `vscode-vfs`
- `vsls`
- `overleaf-workshop`

These entries allow spell checking in ordinary local files as well as supported virtual, remote, notebook, source-control, collaboration, and extension-provided documents. A scheme has a practical effect only when VS Code or an installed extension exposes documents under that scheme.

## Remote SSH

All settings beginning with `remote.SSH.` are provided by the Remote - SSH extension and require that extension to be installed.

- `remote.SSH.showLoginTerminal`: Set to `true`, showing the SSH login terminal during connection setup. This makes interactive prompts and connection output visible.

- `remote.SSH.useLocalServer`: Set to `false`, disabling the extension’s local-server connection mode.

- `remote.SSH.useExecServer`: Set to `false`, disabling the extension’s exec-server mode.

- `remote.SSH.remotePlatform`: Maps `"tiger3.princeton.edu"` to `"linux"`. This tells Remote - SSH to treat that host as a Linux remote, avoiding or reducing platform detection ambiguity for that host.

- `remote.SSH.enableDynamicForwarding`: Set to `false`, disabling the extension’s dynamic forwarding option for Remote SSH connections.

The exact connection path used by Remote - SSH can depend on the installed extension version, SSH configuration, and remote environment.

## Required extensions and components

The built-in editor, Git, autosave, chat, Zen Mode, appearance-selection, and language-override settings are handled by VS Code Insiders itself.

The extension-specific portions require the corresponding components:

- LaTeX Workshop for `latex-workshop.*` and the `latex-workshop-pdf-hook` PDF association.
- Code Spell Checker for `cSpell.*`.
- Easy Toggle Settings for `easy-toggle-settings.items`.
- Lean 4 for `lean4.*`.
- Remote - SSH for `remote.SSH.*`.
- A theme provider containing `"GitHub Dark Default"` if that theme is not already available in the installation.
- A TeX distribution exposing `kpsewhich` for the enabled TeX file-lookup features.

## Restoring the settings on macOS

VS Code Insiders stores user settings at:

`~/Library/Application Support/Code - Insiders/User/settings.json`

To restore this configuration:

1. Quit VS Code Insiders or close all windows that may modify user settings.
2. Create a backup of any existing `settings.json`.
3. Place the JSONC settings file at the path above, creating the `User` directory if necessary.
4. Reopen VS Code Insiders.
5. Install and enable the referenced extensions for extension-specific settings.
6. Open the Settings editor or run **Preferences: Open User Settings (JSON)** to review the restored configuration.

If an existing settings file contains options that should be retained, merge the top-level properties into it instead of replacing the entire file. Each top-level setting name should appear only once in the final JSONC object.
