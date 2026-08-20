<!-- settings-sha256:498a7d948ce5d5f16728f7b76d6fd53fdc483bd1d780f00c6e86035b6cf13357; generator-version:2 -->

# VS Code Insiders Settings

## Overview

This configuration emphasizes comfortable editing, automatic LaTeX builds, integrated PDF viewing, spelling support for technical writing, Git convenience, and visible Remote SSH authentication.

The file is **JSON with Comments (JSONC)** rather than strict JSON: it contains `//` comments, and VS Code settings files support this syntax. Extension-specific settings have an effect only when their corresponding extensions are installed and enabled.

## Editor behavior

- `editor.minimap.enabled`: Set to `false`, hiding the source-code minimap.
- `editor.wordWrap`: Set to `"on"`, wrapping long lines to fit the editor viewport.
- `editor.fontSize`: Set to `16`, using a 16-pixel editor font.
- `editor.renderValidationDecorations`: Set to `"on"`, allowing validation diagnostics such as errors and warnings to be rendered in the editor.
- `editor.suggestOnTriggerCharacters`: Set to `true`, allowing completion suggestions to appear when a language-specific trigger character is typed.
- `editor.tabCompletion`: Set to `"on"`, allowing the Tab key to accept suitable completion proposals.
- `zenMode.hideLineNumbers`: Set to `false`, keeping line numbers visible in Zen Mode.

### Quick suggestions

The built-in `editor.quickSuggestions` object controls where automatic completion suggestions may appear:

- `other: true` enables suggestions in ordinary code or document content.
- `comments: false` disables automatic suggestions inside comments.
- `strings: true` enables suggestions inside strings.

This is particularly useful for LaTeX-related completions because some LaTeX content may be classified as string-like text.

## Language-specific LaTeX and TeX overrides

The `[latex]` and `[tex]` objects are language-specific VS Code overrides. Both contain the same configuration so that it applies to files recognized under either language identifier.

Within each override:

- `editor.quickSuggestions` enables suggestions in `other` content and `strings`, while disabling them in `comments`.
- `editor.suggest.snippetsPreventQuickSuggestions`: Set to `false`, so the availability of snippets does not suppress quick suggestions.

These overrides reinforce the global completion behavior specifically for LaTeX and TeX documents.

## Chat appearance

These are built-in VS Code chat-interface settings:

- `chat.fontSize`: Set to `16`, controlling the font size of ordinary chat text and the prompt input.
- `chat.editor.fontSize`: Set to `16`, controlling the font size used in chat code snippets, embedded editors, and diffs.

## Workbench appearance

- `workbench.colorTheme`: Set to `"GitHub Dark Default"`, selecting that installed color theme. The theme must be available in the current VS Code Insiders installation, whether built in or supplied by an extension.

## Git

These built-in Git settings affect repositories opened in VS Code:

- `git.autofetch`: Set to `true`, allowing VS Code to fetch remote repository updates automatically.
- `git.enableSmartCommit`: Set to `true`, allowing a commit action to stage all changes automatically when there are changes to commit but nothing is staged.
- `git.confirmSync`: Set to `false`, suppressing the confirmation prompt before synchronizing commits with a remote.

The last two settings reduce confirmation steps, so commit and synchronization actions should be reviewed before invoking them.

## Autosave

- `files.autoSave`: Set to `"afterDelay"`, saving modified files automatically after a period without editing.
- `files.autoSaveDelay`: Set to `2000`, making that delay 2,000 milliseconds, or two seconds.

Because LaTeX Workshop is configured to build on save, an autosave can also trigger a LaTeX build.

## LaTeX Workshop

All `latex-workshop.*` settings are provided by the **LaTeX Workshop** extension and require that extension to be installed.

### Automatic builds

- `latex-workshop.latex.autoBuild.run`: Set to `"onSave"`, requesting a LaTeX build whenever a relevant source file is saved. This includes saves caused by the configured two-second autosave behavior.

### PDF viewing and file association

- `latex-workshop.view.pdf.viewer`: Set to `"tab"`, opening LaTeX Workshop’s PDF viewer in a VS Code editor tab.
- `workbench.editorAssociations`: Associates the filename pattern `"*.pdf"` with `"latex-workshop-pdf-hook"`. The key is a glob matching PDF filenames, and the value is LaTeX Workshop’s contributed PDF editor identifier. This routes PDFs through the extension’s PDF-opening hook when the extension is available.
- `latex-workshop.latex.watch.pdf.delay`: Set to `1000`, giving the PDF watcher a 1,000-millisecond delay before refreshing. This can help when a rebuilt PDF is correct but the open viewer does not immediately update.

### PDF inversion and dark mode

- `latex-workshop.view.pdf.invert`: Set to `1`, configuring the extension’s PDF color-inversion amount.
- `latex-workshop.view.pdf.invertMode.enabled`: Set to `"never"`, leaving PDF inversion disabled at the global user-settings level until another configuration scope overrides it.

The toggle described below can write a workspace-specific value of `"always"` or `"never"` without changing the global preference for every VS Code Insiders window.

### Error notifications

- `latex-workshop.message.error.show`: Set to `false`, suppressing LaTeX Workshop’s error popup notifications. Build problems may still be available through the extension’s other diagnostic or output interfaces.

### IntelliSense

These settings configure LaTeX Workshop’s completion and IntelliSense features:

- `latex-workshop.intellisense.package.enabled`: Set to `true`, enabling package-related IntelliSense.
- `latex-workshop.intellisense.package.env.enabled`: Set to `true`, enabling environment suggestions associated with packages.
- `latex-workshop.intellisense.package.unusual`: Set to `true`, allowing the extension to include package information it classifies as unusual.
- `latex-workshop.intellisense.unimathsymbols.enabled`: Set to `true`, enabling completion information based on Unicode mathematical symbols.
- `latex-workshop.intellisense.subsuperscript.enabled`: Set to `true`, enabling IntelliSense support related to subscripts and superscripts.
- `latex-workshop.intellisense.update.aggressive.enabled`: Set to `true`, enabling the extension’s more aggressive IntelliSense update behavior.
- `latex-workshop.intellisense.update.delay`: Set to `500`, using a 500-millisecond delay for IntelliSense updates.

### TeX file discovery

- `latex-workshop.kpsewhich.bibtex.enabled`: Set to `true`, allowing LaTeX Workshop to use `kpsewhich` when resolving BibTeX-related files.
- `latex-workshop.kpsewhich.class.enabled`: Set to `true`, allowing it to use `kpsewhich` when resolving document class files such as `.cls` files.

These options are useful with TeX distributions such as TeX Live or MacTeX when dependencies are installed outside the current project directory.

## PDF dark-mode toggle

`easy-toggle-settings.items` is an extension-provided array and requires an extension that contributes the `easy-toggle-settings.*` configuration.

The array contains one toggle definition:

- `property`: Targets `latex-workshop.view.pdf.invertMode.enabled`.
- `icon`: Uses the `"color-mode"` icon identifier for the status-bar control.
- `values`: Cycles between `"always"` and `"never"`.
- `disabledValue`: Treats `"never"` as the disabled state.
- `isWorkspace`: Set to `true`, storing the selected value at workspace scope rather than changing the user setting for every window.

In practice, the status-bar control toggles LaTeX Workshop PDF inversion for the current workspace while the global user-level value remains `"never"`.

## Lean 4

- `lean4.alwaysAskBeforeInstallingLeanVersions`: Set to `true`, requesting confirmation before the Lean 4 extension installs Lean versions.

This is an extension-provided setting and requires the corresponding Lean 4 extension.

## Spelling

All `cSpell.*` settings are provided by the **Code Spell Checker / cSpell** extension and require that extension to be installed.

### General spelling behavior

- `cSpell.enabled`: Set to `true`, enabling spell checking.
- `cSpell.language`: Set to `"en-US"`, selecting US English.
- `cSpell.diagnosticLevel`: Set to `"Warning"`, reporting spelling diagnostics at warning severity.
- `cSpell.useCustomDecorations`: Set to `false`, disabling cSpell’s custom decoration mechanism in favor of its ordinary diagnostic presentation.

### Enabled file types

`cSpell.enabledFileTypes` is a mapping of VS Code language identifiers to enabled states. Spell checking is explicitly enabled for:

- `latex`
- `tex`
- `bibtex`
- `markdown`
- `plaintext`

Every listed identifier is mapped to `true`.

### Ignored regular expressions

`cSpell.ignoreRegExpList` is an array of regular-expression strings. Backslashes are doubled because the patterns are stored as JSONC strings.

- `\\\\[a-zA-Z]+` ignores a backslash followed by one or more ASCII letters, covering LaTeX command names such as a typical `\command`.
- `\\$[^$]*\\$` ignores content delimited by a pair of single dollar signs, covering simple inline-math regions that do not contain another dollar sign.
- `\\\\\\[[\\s\\S]*?\\\\\\]` ignores content between LaTeX display-math delimiters `\[` and `\]`. The `[\s\S]` construction matches any character, including newlines, and `*?` makes the match non-greedy.
- `\\\\\\([\\s\\S]*?\\\\\\)` ignores content between LaTeX inline-math delimiters `\(` and `\)`, including multiline content.

These patterns reduce spelling diagnostics for LaTeX commands and mathematical expressions. They are deliberately pattern-based and do not constitute a complete LaTeX parser.

### Custom dictionary

`cSpell.userWords` is an array of accepted terms that should not be reported as misspellings. It contains technical vocabulary, proper names, abbreviations, package names, and project-oriented terminology:

`ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`, `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, and `wavefunction`.

Capitalization is preserved in the configuration.

### Enabled URI schemes

`cSpell.enabledSchemes` maps URI schemes to `true`, allowing cSpell to operate on resources opened through those schemes:

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

Some schemes correspond to ordinary local or unsaved resources, while others are contributed by VS Code features or extensions. Enabling a scheme does not install or configure the service that provides it.

## Remote SSH

All `remote.SSH.*` settings are provided by the **Remote - SSH** extension and require that extension to be installed.

- `remote.SSH.showLoginTerminal`: Set to `true`, showing the SSH login terminal so that authentication prompts and connection messages remain visible. This property appears twice in the source file with the same value. The duplicate does not express a second distinct option and can be removed during cleanup without changing the intended configuration.
- `remote.SSH.useLocalServer`: Set to `false`, disabling the extension’s local-server connection mode.
- `remote.SSH.useExecServer`: Set to `false`, disabling its exec-server connection mode.
- `remote.SSH.remotePlatform`: Maps the configured SSH host to `"linux"`, telling Remote SSH to treat that destination as a Linux system. This nested object can contain additional host-to-platform mappings if more destinations need explicit platform identification.
- `remote.SSH.enableDynamicForwarding`: Set to `false`, disabling the extension’s dynamic-forwarding option for these Remote SSH connections.

The exact connection consequences of the server-mode and forwarding options can depend on the installed Remote - SSH version and the SSH environment.

## Restoring the settings on macOS

1. Quit VS Code Insiders or close all windows that might write user settings.
2. Back up any existing settings file.
3. Place the file at:

   `~/Library/Application Support/Code - Insiders/User/settings.json`

4. Reopen VS Code Insiders.
5. Install the extensions needed for the `latex-workshop.*`, `easy-toggle-settings.*`, `lean4.*`, `cSpell.*`, and `remote.SSH.*` settings. Ensure the `"GitHub Dark Default"` theme is also available.

Keep the `.json` filename even though the file uses JSONC syntax; `settings.json` is the standard VS Code Insiders user-settings filename.
