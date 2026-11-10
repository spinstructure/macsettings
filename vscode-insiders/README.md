<!-- settings-sha256:2519c0f4094ad0c4bb2e2565e3657632c9f8f71a55691b49f646cf6269f9c7d9; generator-version:2 -->

# VS Code Insiders Settings

This `settings.json` configures editor readability, suggestions, Git, LaTeX authoring and PDF viewing, autosave, spelling, language tools, and remote SSH connections.

The file uses **JSON with Comments (JSONC)** because it contains `//` comments. Keep those comments when restoring or editing it in VS Code Insiders.

Built-in settings work through VS Code itself or its bundled extensions. Extension-specific settings require the corresponding extensions to be installed and enabled: **Python Environments**, **Lean 4**, **LaTeX Workshop**, **Easy Toggle Settings**, **Code Spell Checker**, and **Remote - SSH**. The selected appearance also requires the **GitHub Theme** extension.

## Restore on macOS

1. Back up any existing User `settings.json`.
2. In Finder, choose **Go → Go to Folder** and enter `~/Library/Application Support/Code - Insiders/User/`.
3. Place the supplied file there as `settings.json`, creating the directory if necessary. Merge with existing settings if they should be retained.
4. Install the extensions listed above.
5. Open VS Code Insiders and run **Preferences: Open User Settings (JSON)** to review the configuration. Restart the application if extension settings require it.

The full standard destination is `~/Library/Application Support/Code - Insiders/User/settings.json`. Workspace and language-specific settings can affect the resulting configuration; see the [VS Code settings documentation](https://code.visualstudio.com/docs/configure/settings).

## Editor behavior

These are built-in VS Code settings.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `editor.minimap.enabled` | `false` | Hides the miniature overview of the file beside the editor. |
| `editor.wordWrap` | `"on"` | Wraps long lines to the editor width without inserting line breaks into the file. |
| `editor.fontSize` | `16` | Sets the editor text size to 16 pixels. |
| `editor.renderValidationDecorations` | `"on"` | Displays diagnostic decorations, such as error and warning underlines, when diagnostics are available. |
| `zenMode.hideLineNumbers` | `false` | Prevents Zen Mode from hiding line numbers. Their actual visibility still depends on the editor’s line-number configuration. |

## Suggestions and language overrides

The global suggestion settings apply wherever supported, subject to language-specific overrides:

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `editor.quickSuggestions` | Object described below | Controls where suggestions appear automatically while typing. |
| `editor.suggestOnTriggerCharacters` | `true` | Allows automatic suggestions after characters designated as triggers by a language’s completion provider. |
| `editor.tabCompletion` | `"on"` | Enables Tab completion for matching completions. |

The `editor.quickSuggestions` object contains three context switches:

| Property | Value | Effect |
| --- | --- | --- |
| `other` | `true` | Enables automatic suggestions in ordinary code or text contexts. |
| `comments` | `false` | Disables automatic quick suggestions inside recognized comments. |
| `strings` | `true` | Enables automatic quick suggestions inside recognized strings. |

Comment and string recognition depends on the active language support. These switches control automatic quick suggestions; available completion content depends on installed language providers.

The top-level `[latex]` and `[tex]` objects are **language-specific override blocks**. Each applies to its corresponding VS Code language identifier, rather than directly matching a filename extension. Both contain:

- `editor.quickSuggestions` with `other: true`, `comments: false`, and `strings: true`, explicitly repeating the global configuration.
- `editor.suggest.snippetsPreventQuickSuggestions: false`, allowing quick suggestions while a snippet is active instead of suppressing them for that reason.

These are built-in editor controls used alongside the LaTeX Workshop completion settings below.

## Appearance and chat

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `workbench.colorTheme` | `"GitHub Dark Default"` | Selects this dark theme from the GitHub Theme extension. The setting itself is built into VS Code. |
| `chat.fontSize` | `16` | Sets normal chat text to 16 pixels. The supplied comments also identify this as controlling the prompt box. |
| `chat.editor.fontSize` | `16` | Sets chat code text to 16 pixels, including code snippets and embedded code or diff editors where the chat interface uses this setting. |

The chat font keys belong to VS Code’s chat configuration. Their application to particular chat surfaces can depend on the interface or extension; the [VS Code chat documentation](https://code.visualstudio.com/docs/chat/chat-overview) documents the distinction between chat text and code-block fonts.

## Accessibility

`accessibility.signals.lineHasInlineSuggestion` is a built-in object setting with `sound: "off"`. It disables the accessibility sound associated with a line containing an inline suggestion. It does not disable inline suggestions themselves.

## Git

These settings belong to VS Code’s bundled Git extension:

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `git.autofetch` | `true` | Enables periodic background fetching so remote-tracking information stays current. Fetching does not itself merge remote changes into the working branch. |
| `git.enableSmartCommit` | `true` | Allows a commit when nothing is staged by using smart commit to include changes automatically, subject to the Git extension’s other controls. |
| `git.confirmSync` | `false` | Removes the confirmation prompt for the Git synchronization action. Synchronization can pull and push changes. |

These meanings follow the [bundled Git extension’s setting descriptions](https://github.com/microsoft/vscode/blob/main/extensions/git/package.nls.json).

## Autosave and LaTeX builds

| Setting | Provider | Configured value | Practical effect |
| --- | --- | --- | --- |
| `files.autoSave` | VS Code | `"afterDelay"` | Automatically saves modified files after an editing delay. |
| `files.autoSaveDelay` | VS Code | `2000` | Sets that delay to 2,000 milliseconds, or two seconds. |
| `latex-workshop.latex.autoBuild.run` | LaTeX Workshop | `"onSave"` | Requests a project build when a LaTeX source file is saved. |

Together, these settings allow autosave to trigger LaTeX builds after typing pauses. Build timing and success still depend on LaTeX Workshop and the available TeX toolchain. The save trigger is documented in [LaTeX Workshop’s build documentation](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#auto-build-latex).

`latex-workshop.message.error.show: false` suppresses LaTeX Workshop error popup notifications. It controls notifications rather than fixing or preventing build errors.

## PDF viewing and refresh

| Setting | Provider | Configured value | Practical effect |
| --- | --- | --- | --- |
| `workbench.editorAssociations` | VS Code | `"*.pdf": "latex-workshop-pdf-hook"` | Associates filenames matching `*.pdf` with LaTeX Workshop’s PDF editor hook. The referenced editor requires LaTeX Workshop. |
| `latex-workshop.view.pdf.viewer` | LaTeX Workshop | `"tab"` | Opens the extension’s PDF viewer in a VS Code editor tab. |
| `latex-workshop.view.pdf.invert` | LaTeX Workshop | `1` | Sets the PDF inversion filter strength to full inversion when invert mode is active. |
| `latex-workshop.view.pdf.invertMode.enabled` | LaTeX Workshop | `"never"` | Disables invert mode at this configuration scope until an applicable override changes it. |
| `latex-workshop.latex.watch.pdf.delay` | LaTeX Workshop | `1000` | Sets the PDF change-stabilization delay to 1,000 milliseconds before the extension treats the changed binary file as ready. This can affect refresh timing. |

Changes to inversion parameters may require reopening the viewer or restarting VS Code. See the [LaTeX Workshop PDF viewer documentation](https://github.com/James-Yu/LaTeX-Workshop/wiki/View).

`latex-workshop.latex.watch.usePolling: false` requests that the extension’s file watcher operate without polling, where supported by the installed version.

**Comment discrepancy:** the comment immediately above `latex-workshop.latex.watch.usePolling` says to use polling, but the configured value is `false`. The value disables polling; the comment does not change that behavior.

### Workspace PDF dark-mode toggle

`easy-toggle-settings.items` is an array supplied by **Easy Toggle Settings**. It contains one object defining a status-bar toggle:

| Object property | Configured value | Purpose |
| --- | --- | --- |
| `property` | `"latex-workshop.view.pdf.invertMode.enabled"` | Identifies the setting to change. |
| `icon` | `"color-mode"` | Selects the status-bar icon. |
| `values` | `["always", "never"]` | Cycles between enabling and disabling PDF invert mode. |
| `disabledValue` | `"never"` | Makes the icon appear disabled or grayed out when inversion is off. |
| `isWorkspace` | `true` | Writes the toggled value at workspace scope instead of changing the User setting. |

The User value remains `"never"` while the toggle can create a workspace override. Other windows opening that same workspace can share its saved override. The toggle requires both Easy Toggle Settings and LaTeX Workshop; its fields are documented by [Easy Toggle Settings](https://github.com/mhagnumdw/vscode-easy-toggle-settings#extension-settings).

## LaTeX completion and file lookup

All settings in this section come from **LaTeX Workshop**.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `latex-workshop.intellisense.package.enabled` | `true` | Adds available completion data for commands and environments from packages used by the project. |
| `latex-workshop.intellisense.package.env.enabled` | `true` | Offers package environments through snippets such as `\envname`. |
| `latex-workshop.intellisense.package.unusual` | `true` | Includes less commonly used package commands and environments. |
| `latex-workshop.intellisense.unimathsymbols.enabled` | `true` | Adds Unicode-math symbol command suggestions. |
| `latex-workshop.intellisense.subsuperscript.enabled` | `true` | Suggests project-used subscripts and superscripts when typing constructs such as `_{` and `^{`. |
| `latex-workshop.intellisense.update.aggressive.enabled` | `true` | Updates completion information after typing pauses, rather than waiting only for saves. |
| `latex-workshop.intellisense.update.delay` | `500` | Sets that parsing delay to 500 milliseconds. |
| `latex-workshop.kpsewhich.bibtex.enabled` | `true` | Enables `kpsewhich` lookup for bibliography files. |
| `latex-workshop.kpsewhich.class.enabled` | `true` | Enables `kpsewhich` lookup for document-class files. |

Package completion depends on available completion data. The lookup settings require an accessible `kpsewhich`, normally provided by a TeX distribution such as TeX Live or MacTeX. See [LaTeX Workshop’s IntelliSense documentation](https://github.com/James-Yu/LaTeX-Workshop/wiki/Intellisense).

## Spelling

All `cSpell.*` settings belong to **Code Spell Checker**.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `cSpell.enabled` | `true` | Enables spell checking. |
| `cSpell.language` | `"en-US"` | Selects US English. |
| `cSpell.diagnosticLevel` | `"Warning"` | Reports spelling diagnostics as warnings. |
| `cSpell.useCustomDecorations` | `false` | Uses VS Code diagnostic rendering for spelling issues, allowing the warning severity to apply. |

These controls are defined in the [Code Spell Checker settings schema](https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/package.json).

### Enabled file types

`cSpell.enabledFileTypes` maps language identifiers to boolean switches. It explicitly enables these five identifiers with `true`:

| Language identifier | Content |
| --- | --- |
| `latex` | LaTeX |
| `tex` | TeX |
| `bibtex` | Bibliography records |
| `markdown` | Markdown |
| `plaintext` | Plain text |

This object enables the listed types; it does not explicitly disable unlisted types.

### Ignored regular expressions

`cSpell.ignoreRegExpList` is an array of patterns whose matched text is excluded from spell checking. The strings below retain their **exact JSONC escaping**:

| JSONC string | Matched text |
| --- | --- |
| `"\\\\[a-zA-Z]+"` | A backslash followed by one or more ASCII letters, covering command names such as `\section`. |
| `"\\$[^$]*\\$"` | Text from one dollar sign to the next, covering simple `$...$` math spans. |
| `"\\\\\\[[\\s\\S]*?\\\\\\]"` | Text enclosed by `\[` and `\]`, including line breaks. |
| `"\\\\\\([\\s\\S]*?\\\\\\)"` | Text enclosed by `\(` and `\)`, including line breaks. |

JSONC string decoding removes one layer of backslash escaping before the regular expression is interpreted. In the last two patterns, `[\s\S]` matches any character, including a newline, and `*?` stops at the first matching closing delimiter.

These patterns are text filters, not a TeX parser. The command pattern does not automatically exclude command arguments. The dollar-sign pattern does not reliably distinguish escaped dollars or `$$...$$` display math.

### Custom dictionary

`cSpell.userWords` is an array of additional accepted words in the User dictionary. It reduces false spelling warnings for technical vocabulary, acronyms, names, and LaTeX-related terms.

The configured entries are:

`ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`, `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, and `wavefunction`.

### Enabled document schemes

`cSpell.enabledSchemes` enables spelling eligibility for each listed URI scheme with `true`:

| Scheme | Document context |
| --- | --- |
| `comment` | Comment editors |
| `file` | Filesystem documents |
| `gist` | Gist-backed documents |
| `repo` | Repository-backed documents |
| `sftp` | SFTP-backed documents |
| `untitled` | Unsaved documents |
| `vscode-notebook-cell` | Notebook cells |
| `vscode-scm` | Source-control input |
| `vscode-userdata` | User-data documents |
| `vscode-vfs` | Virtual filesystem documents |
| `vsls` | Live Share documents |
| `overleaf-workshop` | Overleaf Workshop documents |

Scheme eligibility does not override other checking restrictions or install document providers. Restart VS Code after changing this object, as specified in the [Code Spell Checker schema](https://github.com/streetsidesoftware/vscode-spell-checker/blob/main/package.json).

## Python environments

`python-envs.terminal.autoActivationType: "off"` belongs to **Python Environments**. It disables the extension’s automatic activation of Python environments in terminals. Manual activation remains available.

Restart terminals after changing this setting; see the [Python Environments settings reference](https://github.com/microsoft/vscode-python-environments#settings-reference).

## Lean

`lean4.alwaysAskBeforeInstallingLeanVersions: true` belongs to **Lean 4**. It requests a confirmation prompt before Elan downloads and installs a new Lean version. The extension documents this feature as requiring Elan 4.0.0 or later in its [settings schema](https://github.com/leanprover/vscode-lean4/blob/master/vscode-lean4/package.json).

## Remote SSH

All `remote.SSH.*` settings belong to **Remote - SSH**.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `remote.SSH.showLoginTerminal` | `true` | Shows the SSH login terminal so authentication prompts and connection output are visible. |
| `remote.SSH.useLocalServer` | `false` | Selects terminal-based connection handling instead of the extension’s reusable local-server mode. |
| `remote.SSH.useExecServer` | `false` | Disables the exec-server connection mode that bootstraps through a minimal control server. |
| `remote.SSH.remotePlatform` | Host-to-platform object | Maps the configured host to `"linux"`, identifying its platform for Remote - SSH. The host identifier is omitted here. |
| `remote.SSH.enableDynamicForwarding` | `false` | Disables the extension’s use of SSH dynamic forwarding for its connection. This does not by itself describe or disable every form of port forwarding. |

The connection-mode distinction is documented in [Remote - SSH troubleshooting](https://github.com/microsoft/vscode-remote-release/wiki/Remote-SSH-Troubleshooting). These settings govern connection handling; working SSH access and authentication must still be available.
