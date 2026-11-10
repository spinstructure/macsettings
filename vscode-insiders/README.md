<!-- settings-sha256:2519c0f4094ad0c4bb2e2565e3657632c9f8f71a55691b49f646cf6269f9c7d9; shortcuts-sha256:106457608c3bf8d3690977ac6868542639a08511e8c7bc9a1599338b0db98e59; generator-version:3 -->

# VS Code Insiders Settings

This configuration combines editor preferences, LaTeX completion and PDF viewing, delayed autosave, spelling checks, Git integration, and remote development settings. The supplied `keybindings.json` contains one conditional save-and-build shortcut.

`settings.json` is **JSON with Comments (JSONC)**: its `//` comments are valid in VS Code settings files.

## Extensions and configuration scope

Extension-specific settings require the corresponding extensions to be installed and enabled:

| Settings or feature | Required extension |
| --- | --- |
| `python-envs.*` | Python Environments |
| `latex-workshop.*` and the PDF editor association | LaTeX Workshop |
| `easy-toggle-settings.*` | Easy Toggle Settings |
| `cSpell.*` | Code Spell Checker |
| `lean4.*` | Lean 4 |
| `remote.SSH.*` | Remote - SSH |
| `GitHub Dark Default` theme | GitHub Theme |

The editor, workbench, chat appearance, autosave, Zen Mode, and accessibility settings are built into VS Code. The `git.*` settings belong to its bundled Git extension.

These are User settings. Supported workspace, workspace-folder, remote, and language-specific settings can affect the resulting configuration. Language-specific editor settings take precedence over general editor settings; workspace language settings can override the corresponding User language settings. See [User and workspace settings](https://code.visualstudio.com/docs/configure/settings#language-specific-editor-settings).

## Editor behavior

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `editor.minimap.enabled` | `false` | Hides the miniature document overview beside the editor. |
| `editor.wordWrap` | `"on"` | Visually wraps long lines at the editor width without inserting newline characters into the file. |
| `editor.fontSize` | `16` | Sets the editor font size to 16 pixels. |
| `editor.renderValidationDecorations` | `"on"` | Displays diagnostic decorations, such as error and warning underlines, when diagnostic providers report issues. |
| `editor.suggestOnTriggerCharacters` | `true` | Allows completion providers to open suggestions when their trigger characters are typed. |
| `editor.tabCompletion` | `"on"` | Enables inserting matching completions with Tab when applicable. Other Tab behavior still depends on the editor context. |

### Automatic suggestions

The global `editor.quickSuggestions` object controls suggestions while typing:

| Member | Value | Effect |
| --- | --- | --- |
| `other` | `true` | Enables automatic suggestions in ordinary text or code contexts. |
| `comments` | `false` | Disables ordinary automatic quick suggestions in contexts classified as comments. |
| `strings` | `true` | Enables automatic suggestions in contexts classified as strings. |

Classification depends on the active language support. Disabling comment quick suggestions does not itself disable manually requested completion or every provider-triggered suggestion.

Although the nearby comment discusses LaTeX, this top-level object applies generally, subject to language-specific settings.

### LaTeX and TeX overrides

The `[latex]` and `[tex]` objects are separate language-specific overrides using VS Code language IDs.

Both contain:

| Nested setting | Configured value | Effect |
| --- | --- | --- |
| `editor.quickSuggestions` | `other: true`, `comments: false`, `strings: true` | Explicitly applies the same suggestion policy within that language. |
| `editor.suggest.snippetsPreventQuickSuggestions` | `false` | Allows quick suggestions while a snippet session is active. |

These blocks apply to editors identified as `latex` and `tex`, respectively. They do not automatically cover other language IDs, including `latex-expl3` and `doctex`.

## Appearance, chat, and accessibility

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `workbench.colorTheme` | `"GitHub Dark Default"` | Selects this dark theme from the GitHub Theme extension. |
| `chat.fontSize` | `16` | Sets normal chat text and prompt-box text to the configured 16-pixel size where supported by the chat interface. |
| `chat.editor.fontSize` | `16` | Sets the font size for embedded chat code editors, including code snippets and diffs. |
| `zenMode.hideLineNumbers` | `false` | Prevents entering Zen Mode from hiding otherwise visible line numbers. |
| `accessibility.signals.lineHasInlineSuggestion` | `{ "sound": "off" }` | Turns off the sound associated with a line having an inline suggestion. It does not disable the suggestion itself. |

The accessibility object configures only its `sound` member.

## Git

These settings control the bundled Git integration:

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `git.autofetch` | `true` | Automatically fetches from the repository’s default remote, keeping remote-tracking information current without merging changes into the working branch. |
| `git.enableSmartCommit` | `true` | Enables committing without first staging changes when no changes are staged. The exact eligible changes can depend on other Git configuration. |
| `git.confirmSync` | `false` | Removes the confirmation specifically associated with synchronizing repositories. Other Git prompts can still appear. |

These behaviors are described in the [bundled Git extension’s setting definitions](https://github.com/microsoft/vscode/blob/main/extensions/git/package.nls.json). Smart Commit still requires a commit action; enabling it does not create commits automatically.

## Autosave and LaTeX builds

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `files.autoSave` | `"afterDelay"` | Automatically saves modified files after an idle delay. |
| `files.autoSaveDelay` | `2000` | Sets that delay to 2,000 milliseconds, approximately two seconds after editing stops. |
| `latex-workshop.latex.autoBuild.run` | `"onSave"` | Requests automatic LaTeX builds on qualifying document saves. |
| `latex-workshop.message.error.show` | `false` | Suppresses LaTeX Workshop error popup notifications. Compilation can still fail, and diagnostic or log information can remain available. |

LaTeX Workshop documents `"onSave"` as building when a `.tex` file is saved. Autosave can produce those save events, so this configuration can build after the two-second autosave delay as well as after an explicit save. Project detection and the extension’s build eligibility rules still apply. See [LaTeX Workshop: Auto build LaTeX](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#auto-build-latex).

The supplied files do not select a compiler or build recipe. Building requires a usable TeX toolchain and the extension’s applicable project configuration.

## LaTeX completion and file lookup

All settings in this section are provided by LaTeX Workshop.

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `latex-workshop.intellisense.package.enabled` | `true` | Enables completion data for commands and environments from included packages. |
| `latex-workshop.intellisense.package.env.enabled` | `true` | Makes package environments available through environment-name snippets such as `\envname`; requires package completion to be enabled. |
| `latex-workshop.intellisense.package.unusual` | `true` | Includes less commonly used package commands and environments. |
| `latex-workshop.intellisense.unimathsymbols.enabled` | `true` | Includes unimath symbol suggestions when typing `\`. |
| `latex-workshop.intellisense.subsuperscript.enabled` | `true` | Suggests subscripts and superscripts used in the project after `_{` or `^{`. |
| `latex-workshop.intellisense.update.aggressive.enabled` | `true` | Updates completion information during editing after an idle period. |
| `latex-workshop.intellisense.update.delay` | `500` | Sets that idle period to 500 milliseconds. This controls completion updates, not autosave or compilation. |
| `latex-workshop.kpsewhich.bibtex.enabled` | `true` | Uses `kpsewhich` to locate bibliography files for IntelliSense. |
| `latex-workshop.kpsewhich.class.enabled` | `true` | Uses `kpsewhich` to locate class files for IntelliSense parsing. |

See the extension’s [IntelliSense documentation](https://github.com/James-Yu/LaTeX-Workshop/wiki/Intellisense). The `kpsewhich` options require that executable to be available, typically through TeX Live or MacTeX; they do not install missing TeX packages.

## PDF viewing and file watching

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `workbench.editorAssociations` | `"*.pdf": "latex-workshop-pdf-hook"` | Associates filenames matching the `*.pdf` glob with LaTeX Workshop’s PDF editor hook. This is a built-in VS Code association targeting an extension-provided editor. |
| `latex-workshop.view.pdf.viewer` | `"tab"` | Uses LaTeX Workshop’s internal PDF viewer in an editor tab. |
| `latex-workshop.view.pdf.invert` | `1` | Sets the CSS inversion level to full inversion when inversion is enabled. |
| `latex-workshop.view.pdf.invertMode.enabled` | `"never"` | Disables the inversion filter at User scope, even with the dark workbench theme selected. |
| `latex-workshop.latex.watch.usePolling` | `false` | In extension versions supporting this key, disables optional polling-based file watching. |
| `latex-workshop.latex.watch.pdf.delay` | `1000` | Gives PDF changes a 1,000-millisecond stabilization delay before the watcher treats the binary file as fully changed. |

**Comment/value mismatch:** the comment above `latex-workshop.latex.watch.usePolling` says to use polling, but the supplied value is `false`. The configured value governs behavior. If an installed extension version reports this key as unknown, it has no supported effect in that version.

The PDF watcher delay concerns file-change stabilization; it is not a build delay or autosave interval. Viewer changes may require reopening the PDF tab. See [LaTeX Workshop: PDF viewing](https://github.com/James-Yu/LaTeX-Workshop/wiki/View).

### Workspace PDF inversion toggle

`easy-toggle-settings.items` is an array containing one status-bar toggle definition:

| Member | Configured value | Effect |
| --- | --- | --- |
| `property` | `"latex-workshop.view.pdf.invertMode.enabled"` | Identifies the setting the button changes. |
| `icon` | `"color-mode"` | Uses the `color-mode` status-bar icon. |
| `values` | `["always", "never"]` | Cycles between enabling inversion and disabling it. |
| `disabledValue` | `"never"` | Displays the icon as disabled or grayed when inversion is off; the button remains a toggle. |
| `isWorkspace` | `true` | Writes the selected value at workspace scope rather than changing the User setting. |

Thus the User baseline remains `"never"`, while an individual workspace can retain `"always"` or `"never"`. Other windows using the same workspace can share its saved override.

The button requires both Easy Toggle Settings and LaTeX Workshop. Its configuration does not add another custom keyboard shortcut. See [Easy Toggle Settings documentation](https://marketplace.visualstudio.com/items?itemName=mhagnumdw.easy-toggle-settings).

## Spelling

All `cSpell.*` settings belong to Code Spell Checker.

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `cSpell.enabled` | `true` | Enables spell checking, subject to document eligibility and other applicable configuration. |
| `cSpell.language` | `"en-US"` | Selects US English spelling dictionaries. |
| `cSpell.diagnosticLevel` | `"Warning"` | Reports ordinary spelling diagnostics at warning severity. |
| `cSpell.useCustomDecorations` | `false` | Uses VS Code’s diagnostic rendering instead of the extension’s custom decorations. |

With custom decorations disabled, `"Warning"` controls the normal diagnostic presentation. The supplied `editor.renderValidationDecorations: "on"` allows diagnostic underlines to appear. See [Code Spell Checker appearance settings](https://streetsidesoftware.com/vscode-spell-checker/docs/configuration/appearance#cspellusecustomdecorations).

### Enabled file types

`cSpell.enabledFileTypes` explicitly enables these language IDs:

| Member | Value | Document type |
| --- | --- | --- |
| `latex` | `true` | LaTeX |
| `tex` | `true` | TeX |
| `bibtex` | `true` | BibTeX |
| `markdown` | `true` | Markdown |
| `plaintext` | `true` | Plain text |

These are language IDs, not filename globs. The object does not explicitly disable unlisted types; their eligibility depends on the extension’s remaining configuration.

### Ignored text patterns

`cSpell.ignoreRegExpList` is an array of four regular-expression strings. JSON escaping is decoded before each expression is interpreted.

| Exact JSON string | Effect |
| --- | --- |
| `"\\\\[a-zA-Z]+"` | Matches a literal backslash followed by one or more ASCII letters, excluding command names such as `\section` from spelling checks. Command arguments are not excluded by this expression alone. |
| `"\\$[^$]*\\$"` | Matches a dollar sign, any number of non-dollar characters, and another dollar sign. It broadly excludes dollar-delimited inline mathematics. |
| `"\\\\\\[[\\s\\S]*?\\\\\\]"` | Matches text between literal `\[` and `\]` delimiters, including line breaks. |
| `"\\\\\\([\\s\\S]*?\\\\\\)"` | Matches text between literal `\(` and `\)` delimiters, including line breaks. |

In the last two expressions, `[\s\S]` matches any character and `*?` takes the shortest matching span through a closing delimiter.

These expressions operate on text rather than parsing TeX. In particular, `[^$]*` can include newlines, and escaped dollars, `$$` delimiters, or missing closing delimiters can produce unintended matches. Text inside a matched span is excluded from spelling checks, including prose embedded in mathematics.

### Custom dictionary

`cSpell.userWords` adds accepted vocabulary to the normal dictionaries. Its entries are words to recognize, not regular expressions or replacements.

The complete supplied list is:

- `ABJM`, `backrefs`, `basepoint`, `Bianchi`, `bosonic`, `bosonization`, `brane`, `branes`
- `cohomology`, `compactifications`, `Darboux`, `diagonalizable`, `diffeomorphism`, `eigenmodes`, `equivariant`, `exponentials`
- `factorization`, `fermionic`, `fieldstrength`, `groupoids`, `holomorphic`, `homeomorphism`, `homomorphism`
- `jheppub`, `monoid`, `monoidal`, `natbib`, `nondynamical`, `orbifold`, `Rham`
- `spacetimes`, `spinor`, `spinors`, `sublattice`, `SUGRA`, `supergravity`, `superinvariant`, `superpotentials`
- `symplectic`, `topological`, `torsionfree`, `wavefunction`

### Enabled document schemes

`cSpell.enabledSchemes` permits spell checking for documents using the listed URI schemes. Every supplied member is `true`:

| Scheme | Intended document source |
| --- | --- |
| `comment` | Comment editors. |
| `file` | Ordinary filesystem documents. |
| `gist` | Documents exposed through a Gist provider. |
| `repo` | Documents exposed through a repository provider. |
| `sftp` | Documents exposed through an SFTP provider. |
| `untitled` | New, unsaved documents. |
| `vscode-notebook-cell` | Individual notebook cells. |
| `vscode-scm` | Source Control input documents, including commit messages. |
| `vscode-userdata` | VS Code user-data documents, including supported snippet documents. |
| `vscode-vfs` | Documents exposed through a virtual filesystem provider. |
| `vsls` | Live Share documents. |
| `overleaf-workshop` | Documents exposed through Overleaf Workshop. |

Allowing a scheme does not install its provider, establish a connection, or guarantee that every document passes other spelling filters. Unlisted schemes are not explicitly disabled by this object. Scheme changes require a VS Code restart according to the extension’s [file-type and scheme documentation](https://streetsidesoftware.com/vscode-spell-checker/docs/configuration/files-folders-and-workspaces).

## Python environments and Lean

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `python-envs.terminal.autoActivationType` | `"off"` | Disables terminal environment auto-activation performed by Python Environments. Shell startup scripts can still activate environments independently. |
| `lean4.alwaysAskBeforeInstallingLeanVersions` | `true` | Requests confirmation whenever Elan is about to download and install a new Lean version. |

See the official [Python environments documentation](https://code.visualstudio.com/docs/python/environments). The Lean option requires Elan 4.0.0 or later, according to the [Lean 4 extension’s setting definition](https://github.com/leanprover/vscode-lean4/blob/master/vscode-lean4/package.json).

## Remote SSH

These settings are provided by Remote - SSH:

| Setting | Configured value | Purpose and practical effect |
| --- | --- | --- |
| `remote.SSH.showLoginTerminal` | `true` | Shows the SSH login terminal so authentication prompts and connection output are visible. |
| `remote.SSH.useLocalServer` | `false` | Selects terminal connection mode rather than the reusable local-server connection mode. |
| `remote.SSH.useExecServer` | `false` | Disables the minimal exec-server bootstrap mode. |
| `remote.SSH.remotePlatform` | One host mapping to `"linux"` | Records Linux as the platform for the configured host. The host identifier is omitted from this documentation. |
| `remote.SSH.enableDynamicForwarding` | `false` | Disables the extension’s use of SSH dynamic port forwarding. |

`remote.SSH.remotePlatform` is a host-to-platform dictionary, not a command or connection credential. It does not configure authentication.

The local-server and exec-server options select different connection mechanisms; they do not disable the remote VS Code Server required for normal remote development. See Microsoft’s [Remote SSH troubleshooting documentation](https://github.com/microsoft/vscode-remote-release/wiki/Remote-SSH-troubleshooting).

## Keyboard shortcuts

The supplied `keybindings.json` contains exactly one custom rule.

### Command+S: conditional save, then build

| Field | Supplied configuration |
| --- | --- |
| `key` | `"cmd+s"` — Command+S on macOS. |
| `command` | `"runCommands"` — VS Code’s built-in command sequencer. |
| `args` | An object containing a `commands` array with two command IDs in execution order. |

When the rule matches, its `args.commands` array runs:

1. `workbench.action.files.save` — invokes VS Code’s built-in Save command.
2. `latex-workshop.build` — invokes LaTeX Workshop’s project build command.

The commands run sequentially, with Save first. Neither array entry supplies individual command arguments, and the binding does not name a particular recipe. LaTeX Workshop and a working build toolchain are required for the second command. `runCommands` itself requires no macro extension. See [VS Code: Running multiple commands](https://code.visualstudio.com/docs/configure/keybindings#running-multiple-commands).

### Conditions

The complete `when` clause is:

`editorTextFocus && editorLangId =~ /^(latex|latex-expl3|doctex)$/ && config.latex-workshop.latex.autoBuild.run == 'never'`

All three conditions must hold:

1. **`editorTextFocus`** requires focus in an editor’s text area. Focus in the terminal, Explorer, or PDF viewer does not satisfy this condition.
2. **`editorLangId =~ /^(latex|latex-expl3|doctex)$/`** requires the active editor’s language ID to be exactly `latex`, `latex-expl3`, or `doctex`. `=~` is the regular-expression match operator; `^` and `$` anchor the whole value, parentheses group the alternatives, and `|` means “or.” The expression is case-sensitive. It excludes `tex`, despite the separate `[tex]` completion settings.
3. **`config.latex-workshop.latex.autoBuild.run == 'never'`** requires the configuration context value to equal the string `"never"`.

These operators and context keys are explained in [VS Code: When clause contexts](https://code.visualstudio.com/api/references/when-clause-contexts).

### Activity with the supplied settings

**This custom rule is inactive with the supplied configuration**, because `latex-workshop.latex.autoBuild.run` is `"onSave"`, not `"never"`.

| Situation | Result |
| --- | --- |
| Supplied `"onSave"` configuration | The custom sequence does not match. Other applicable Command+S bindings, normally Save, remain available. Qualifying saves can trigger automatic LaTeX builds. |
| Configuration context changed to `"never"`, matching language, text editor focused | Command+S invokes Save followed by an explicit LaTeX Workshop build. |
| Nonmatching language or focus outside editor text | This custom rule does not match, regardless of the build setting. |

A workspace override to `"never"` can activate the rule when its other conditions hold. The supplied `[latex]` and `[tex]` blocks affect completion only.

There is a scope caveat: VS Code’s `config.*` context lookup uses configuration without a document resource or language override, as shown in its [context-key implementation](https://github.com/microsoft/vscode/blob/main/src/vs/platform/contextkey/browser/contextKeyService.ts). Folder-specific values in a multi-root workspace can therefore differ from the value tested by this shortcut. LaTeX Workshop currently declares this build setting as resource-scoped rather than language-overridable in its [configuration manifest](https://github.com/James-Yu/LaTeX-Workshop/blob/master/package.json); placing it inside a language block is not a supported way to switch build mode. Inspect resolved settings and shortcut behavior when adding overrides.

### Explicit saves versus autosave

Autosave does **not** simulate Command+S and does not execute this keybinding’s `runCommands` sequence.

With the supplied `"onSave"` setting, a qualifying autosave can trigger LaTeX Workshop’s automatic build mechanism. An explicit save can do the same when it produces a qualifying save event.

When the applicable build mode and the shortcut’s configuration context both read `"never"`, autosave still saves files but does not trigger LaTeX Workshop’s automatic builds. A matching Command+S press instead requests the explicit save-and-build sequence. This conditional design avoids adding a second explicit build while the supplied `"onSave"` mode is active. See [LaTeX Workshop’s automatic build conditions](https://github.com/James-Yu/LaTeX-Workshop/wiki/Compile#auto-build-latex).

## Restore on macOS

1. Back up existing configuration files before replacing or merging them.
2. In Finder, choose **Go → Go to Folder…** and open `~/Library/Application Support/Code - Insiders/User/`.
3. Place the supplied settings in `settings.json` and the supplied shortcut array in `keybindings.json`. Preserve the JSONC comments in `settings.json`.
4. Install the corresponding extensions listed above and provide a TeX toolchain for LaTeX builds.
5. In VS Code Insiders, use **Preferences: Open User Settings (JSON)** to inspect settings and **Preferences: Open Keyboard Shortcuts (JSON)** to inspect shortcuts.

For a non-default profile, use those commands to open the active profile’s files, whose locations can differ from the standard User directory. Review existing workspace overrides, particularly the PDF inversion override written by the status-bar toggle, because copying User settings does not remove them.
