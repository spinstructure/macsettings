<!-- settings-sha256:b23fbc61cb4ad1b7e9b34298e56a7494c284b79d1c285ee33b563cac860eb15a; generator-version:2 -->

# VS Code Insiders Settings

This configuration covers editor behavior, Git, LaTeX authoring and PDF viewing, autosave, spell checking, Python environment activation, Lean installation prompts, and Remote SSH connections.

`settings.json` uses **JSON with Comments (JSONC)** because it contains `//` comments. Preserve it as JSONC when editing; strict JSON parsers do not accept these comments.

Built-in settings are identified below. Extension-specific settings require the corresponding extensions to be installed. Workspace settings and language-specific overrides can affect the configuration that applies to a particular file.

## Restore on macOS

1. In VS Code Insiders, run **Preferences: Open User Settings (JSON)** from the Command Palette.
2. Back up any existing settings before replacing or merging them.
3. Place the supplied file at the standard macOS VS Code Insiders User settings location:

   `~/Library/Application Support/Code - Insiders/User/settings.json`

4. Install the extensions needed by the configuration: Python Environments, GitHub Theme, Lean 4, LaTeX Workshop, Easy Toggle Settings, Code Spell Checker, and Remote - SSH.

The path above applies to the standard User configuration. If using a separate profile or custom user-data location, use the settings file opened by the Command Palette command.

## Editor behavior and completion

These settings are built into VS Code.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `editor.minimap.enabled` | `false` | Hides the editor minimap. |
| `editor.wordWrap` | `"on"` | Wraps displayed lines to the editor width without inserting line breaks into the file. |
| `editor.fontSize` | `16` | Sets editor text size to 16 pixels. |
| `editor.renderValidationDecorations` | `"on"` | Enables visual decorations for diagnostics, such as error and warning underlines. Diagnostic providers still determine which issues are reported. |
| `editor.suggestOnTriggerCharacters` | `true` | Allows completion suggestions to appear when a language provider recognizes a trigger character. |
| `editor.tabCompletion` | `"on"` | Enables Tab-based completion when a matching completion is available. |

### Automatic suggestions

The global `editor.quickSuggestions` object configures automatic suggestions by text context:

| Nested property | Value | Practical effect |
| --- | --- | --- |
| `other` | `true` | Enables automatic suggestions in ordinary code or text contexts. |
| `comments` | `false` | Disables automatic quick suggestions in text recognized as comments. |
| `strings` | `true` | Enables automatic suggestions in text recognized as strings. |

These global settings apply beyond LaTeX. Context classification and available suggestions depend on the language support installed.

### Language-specific overrides

The `[latex]` and `[tex]` objects each contain the same overrides:

| Setting inside each override | Configured value | Practical effect |
| --- | --- | --- |
| `editor.quickSuggestions` | `other: true`, `comments: false`, `strings: true` | Explicitly applies the same automatic-suggestion policy to that language identifier. |
| `editor.suggest.snippetsPreventQuickSuggestions` | `false` | Allows quick suggestions while a snippet session is active. |

These blocks target language identifiers, rather than filename extensions directly. Their effect depends on the language mode assigned to the document.

## Appearance, chat, and Zen Mode

| Setting | Configured value | Provider and practical effect |
| --- | --- | --- |
| `workbench.colorTheme` | `"GitHub Dark Default"` | Built-in theme selection setting. Selects the named theme supplied by the GitHub Theme extension. |
| `chat.fontSize` | `16` | Built-in chat setting. Sets normal chat text and prompt-box text to 16 pixels. |
| `chat.editor.fontSize` | `16` | Built-in chat setting. Sets text in chat code editors, including snippets and diffs, to 16 pixels. |
| `zenMode.hideLineNumbers` | `false` | Built-in setting. Prevents Zen Mode from hiding line numbers; it does not independently enable line numbers if another setting disables them. |

## Git

These settings belong to VS Code’s built-in Git integration.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `git.autofetch` | `true` | Enables automatic fetching of remote repository information. Fetching updates remote-tracking information without merging it into the current branch. |
| `git.enableSmartCommit` | `true` | Allows committing all changes when no changes are staged. Review the changes before invoking a commit. |
| `git.confirmSync` | `false` | Suppresses the confirmation prompt for Git synchronization. It does not itself initiate synchronization. |

## Python and Lean

| Setting | Configured value | Provider and practical effect |
| --- | --- | --- |
| `python-envs.terminal.autoActivationType` | `"off"` | Python Environments extension. Disables its automatic environment activation in terminals. |
| `lean4.alwaysAskBeforeInstallingLeanVersions` | `true` | Lean 4 extension. Requests confirmation before the extension installs Lean versions. |

## Autosave and LaTeX builds

| Setting | Configured value | Provider and practical effect |
| --- | --- | --- |
| `files.autoSave` | `"afterDelay"` | Built-in setting. Enables saving modified files after a delay. |
| `files.autoSaveDelay` | `2000` | Built-in setting. Sets the autosave delay to 2,000 milliseconds, or two seconds after editing stops. |
| `latex-workshop.latex.autoBuild.run` | `"onSave"` | LaTeX Workshop. Enables automatic builds on save events handled by the extension, including applicable autosaves. |

Together, these settings can trigger a LaTeX build after a two-second pause in editing. Actual compilation still requires a working TeX installation and a build configuration that succeeds for the document.

## PDF opening, viewing, and refresh

The `workbench.editorAssociations` object is built into VS Code. Its entry maps the filename pattern `*.pdf` to the editor identifier `"latex-workshop-pdf-hook"`, directing PDF opening through LaTeX Workshop’s PDF handling.

The remaining settings in this section are provided by LaTeX Workshop.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `latex-workshop.view.pdf.viewer` | `"tab"` | Uses the internal PDF viewer in a VS Code tab. |
| `latex-workshop.view.pdf.invert` | `1` | Sets the PDF inversion amount to `1` for use when inversion mode is active. |
| `latex-workshop.view.pdf.invertMode.enabled` | `"never"` | Disables PDF inversion at the scope where this file is installed, unless overridden at a more specific scope. |
| `latex-workshop.latex.watch.usePolling` | `false` | Disables polling for LaTeX Workshop’s file watcher. |
| `latex-workshop.latex.watch.pdf.delay` | `1000` | Sets the PDF watcher delay to 1,000 milliseconds, allowing time before the extension processes a PDF change and refreshes the viewer. |
| `latex-workshop.message.error.show` | `false` | Suppresses LaTeX Workshop error popup notifications. It does not prevent compilation errors or resolve them. |

**Comment/value discrepancy:** the comment above `latex-workshop.latex.watch.usePolling` says to use polling, but the configured value is `false`. The effective configuration disables polling; the comment should be corrected if that is the intended behavior.

### PDF inversion toggle

The Easy Toggle Settings extension supplies `easy-toggle-settings.items`. This array contains one status-bar toggle:

| Field | Configured value | Meaning |
| --- | --- | --- |
| `property` | `"latex-workshop.view.pdf.invertMode.enabled"` | Identifies the setting controlled by the button. |
| `icon` | `"color-mode"` | Selects the icon displayed for the toggle. |
| `values` | `["always", "never"]` | Defines the two values the button cycles between. |
| `disabledValue` | `"never"` | Identifies `"never"` as the toggle’s disabled state. |
| `isWorkspace` | `true` | Writes the changed value at workspace scope. |

The button therefore switches PDF inversion on and off for the current workspace. Its workspace setting can override the User-level `"never"` value. Other windows using that same workspace may also pick up the workspace setting.

Both Easy Toggle Settings and LaTeX Workshop are needed for this control to have its intended effect.

## LaTeX IntelliSense and file lookup

These settings are provided by LaTeX Workshop.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `latex-workshop.intellisense.package.enabled` | `true` | Enables package-aware completion support. |
| `latex-workshop.intellisense.package.env.enabled` | `true` | Enables package-provided environment completions. |
| `latex-workshop.intellisense.package.unusual` | `true` | Enables inclusion of package completion information classified by the extension as unusual. |
| `latex-workshop.intellisense.unimathsymbols.enabled` | `true` | Enables Unicode mathematics symbol completion support. |
| `latex-workshop.intellisense.subsuperscript.enabled` | `true` | Enables the extension’s subscript and superscript completion support. |
| `latex-workshop.intellisense.update.aggressive.enabled` | `true` | Enables the extension’s more aggressive IntelliSense update behavior while editing. |
| `latex-workshop.intellisense.update.delay` | `500` | Sets the IntelliSense update delay to 500 milliseconds. |
| `latex-workshop.kpsewhich.bibtex.enabled` | `true` | Enables use of `kpsewhich` to help locate bibliography files. |
| `latex-workshop.kpsewhich.class.enabled` | `true` | Enables use of `kpsewhich` to help locate LaTeX class files. |

Available completions depend on the extension’s supported packages and its analysis of the document. The lookup settings require an accessible `kpsewhich` executable, typically supplied by a TeX distribution such as TeX Live or MacTeX.

## Spell checking

All `cSpell.*` settings are provided by the Code Spell Checker extension.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `cSpell.enabled` | `true` | Enables spell checking for eligible documents. |
| `cSpell.language` | `"en-US"` | Selects US English spelling dictionaries. |
| `cSpell.diagnosticLevel` | `"Warning"` | Reports spelling issues with warning severity. |
| `cSpell.useCustomDecorations` | `false` | Disables the extension’s custom spelling decorations. Standard diagnostic rendering remains subject to VS Code’s diagnostic settings. |

### Enabled file types

The `cSpell.enabledFileTypes` object explicitly enables these language identifiers:

| Language identifier | Value | Document type |
| --- | --- | --- |
| `latex` | `true` | LaTeX |
| `tex` | `true` | TeX |
| `bibtex` | `true` | BibTeX bibliographies |
| `markdown` | `true` | Markdown |
| `plaintext` | `true` | Plain text |

This object enables the listed types; it does not explicitly disable every unlisted type. Spell checking also depends on the document’s URI scheme and any applicable overrides.

### Ignored regular expressions

The `cSpell.ignoreRegExpList` array excludes matching text from spell checking. The entries below show the **exact JSONC string values**, including their escape characters:

| Configured string | Matching text excluded from checking |
| --- | --- |
| `"\\\\[a-zA-Z]+"` | A literal backslash followed by one or more ASCII letters, such as `\section` or `\alpha`. Command arguments are not included by this expression. |
| `"\\$[^$]*\\$"` | Text between a pair of dollar signs, with no dollar sign inside the match. This is intended to cover simple `$...$` mathematics. |
| `"\\\\\\[[\\s\\S]*?\\\\\\]"` | Text from `\[` to the next `\]`, including line breaks. |
| `"\\\\\\([\\s\\S]*?\\\\\\)"` | Text from `\(` to the next `\)`, including line breaks. |

JSON escaping and regular-expression escaping both contribute to the repeated backslashes. In the last two expressions, `[\s\S]` matches any character, including a newline, and `*?` makes the match stop at the earliest closing delimiter.

These expressions are text-matching rules, not a TeX parser. They do not reliably distinguish escaped dollar signs or `$$...$$` display mathematics, and they do not explicitly cover named mathematical environments.

### Custom accepted words

The `cSpell.userWords` array adds the following 42 entries to the accepted spelling vocabulary:

- `ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`
- `brane`, `branes`, `cohomology`, `compactifications`, `Darboux`, `diagonalizable`
- `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`, `factorization`, `fermionic`
- `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`, `jheppub`
- `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`
- `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`
- `superinvariant`, `superpotentials`, `symplectic`, `topological`, `torsionfree`, `wavefunction`

This is an inline custom vocabulary. It accepts these terms for spell checking; it does not define them or configure editor completions.

### Enabled document schemes

The `cSpell.enabledSchemes` object enables spell checking for documents with each of the following URI schemes:

| Scheme | Value | Document context |
| --- | --- | --- |
| `comment` | `true` | Documents exposed through a comment URI provider |
| `file` | `true` | Filesystem documents |
| `gist` | `true` | Documents exposed through a Gist provider |
| `repo` | `true` | Documents exposed through a repository provider |
| `sftp` | `true` | Documents exposed through an SFTP provider |
| `untitled` | `true` | Unsaved documents |
| `vscode-notebook-cell` | `true` | Notebook cell documents |
| `vscode-scm` | `true` | Documents exposed by source-control features |
| `vscode-userdata` | `true` | VS Code user-data documents |
| `vscode-vfs` | `true` | Documents exposed through that virtual-filesystem scheme |
| `vsls` | `true` | Live Share documents |
| `overleaf-workshop` | `true` | Documents exposed by Overleaf Workshop |

Scheme names describe document URI types, not filename extensions. Enabling a scheme does not install its provider, connect to a service, or override all other spell-checking eligibility rules.

## Remote SSH

These settings are provided by the Remote - SSH extension.

| Setting | Configured value | Practical effect |
| --- | --- | --- |
| `remote.SSH.showLoginTerminal` | `true` | Shows the SSH login terminal, making login output and interactive authentication prompts visible. |
| `remote.SSH.useLocalServer` | `false` | Disables the extension’s local-server connection mode. |
| `remote.SSH.useExecServer` | `false` | Disables the extension’s exec-server connection mode. |
| `remote.SSH.remotePlatform` | One host mapped to `"linux"` | Explicitly identifies the configured remote host as Linux. The host identifier is omitted here to avoid reproducing environment-specific information. |
| `remote.SSH.enableDynamicForwarding` | `false` | Disables the extension’s use of SSH dynamic forwarding. This does not necessarily disable other forwarding mechanisms. |

The `remote.SSH.remotePlatform` object uses host identifiers as keys and operating-system identifiers as values. Review its host mapping before restoring this configuration in another environment.

The connection details associated with local-server and exec-server modes can vary with the installed Remote - SSH version. This configuration explicitly disables both modes; it does not define an SSH hostname, account, or authentication method for initiating a connection.

## Configuration review points

- Autosave uses a two-second delay, and LaTeX Workshop builds on applicable save events.
- PDF inversion starts disabled at User scope; the status-bar toggle can enable it for a workspace.
- File-watcher polling is disabled, despite the adjacent comment saying otherwise.
- The PDF watcher delay is one second, and the IntelliSense update delay is half a second.
- LaTeX error popups are suppressed, so build output and diagnostics remain useful places to inspect failures.
- Spell checking includes an explicit technical vocabulary and regex exclusions whose coverage is intentionally limited.
- Git smart commit is enabled, and synchronization confirmation is disabled.
- The Remote SSH platform mapping is environment-specific and should be reviewed during restoration.
