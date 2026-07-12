#!/usr/bin/env python3
from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Any


REPO = Path(__file__).resolve().parents[1]
SETTINGS = REPO / "vscode-insiders" / "settings.json"
README = REPO / "vscode-insiders" / "README.md"


CATEGORY_RULES = [
    ("Editor behavior", re.compile(r"^(editor\.|zenMode\.)")),
    ("Language-specific overrides", re.compile(r"^\[.*\]$")),
    ("File associations", re.compile(r"^workbench\.editorAssociations$")),
    ("Theme / appearance", re.compile(r"^workbench\.")),
    ("Git", re.compile(r"^git\.")),
    ("Lean", re.compile(r"^lean4\.")),
    ("LaTeX Workshop", re.compile(r"^latex-workshop\.")),
    ("Easy Toggle Settings", re.compile(r"^easy-toggle-settings\.")),
    ("Autosave / files", re.compile(r"^files\.")),
    ("Spell checking", re.compile(r"^cSpell\.")),
]


def strip_jsonc_comments(text: str) -> str:
    """Remove // and /* */ comments from JSONC while preserving quoted strings."""
    out: list[str] = []
    i = 0
    in_string = False
    quote = ""
    escape = False

    while i < len(text):
        c = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""

        if in_string:
            out.append(c)
            if escape:
                escape = False
            elif c == "\\":
                escape = True
            elif c == quote:
                in_string = False
            i += 1
            continue

        if c in {"'", '"'}:
            in_string = True
            quote = c
            out.append(c)
            i += 1
            continue

        if c == "/" and nxt == "/":
            while i < len(text) and text[i] != "\n":
                i += 1
            out.append("\n")
            continue

        if c == "/" and nxt == "*":
            i += 2
            while i + 1 < len(text) and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue

        out.append(c)
        i += 1

    return "".join(out)


def load_settings() -> dict[str, Any]:
    if not SETTINGS.exists():
        raise SystemExit(f"Missing {SETTINGS}")

    text = SETTINGS.read_text(encoding="utf-8")
    text = strip_jsonc_comments(text)
    text = re.sub(r",(\s*[}\]])", r"\1", text)

    data = json.loads(text)
    if not isinstance(data, dict):
        raise SystemExit(f"{SETTINGS} did not parse as a JSON object")

    return data


def classify_key(key: str) -> str:
    for category, pattern in CATEGORY_RULES:
        if pattern.search(key):
            return category
    return "Other settings"


def summarize_value(value: Any) -> str:
    if isinstance(value, bool):
        return "`true`" if value else "`false`"

    if isinstance(value, (int, float)):
        return f"`{value}`"

    if isinstance(value, str):
        display = value if len(value) <= 80 else value[:77] + "..."
        return f"`{display}`"

    if isinstance(value, list):
        return f"{len(value)} item(s)"

    if isinstance(value, dict):
        return f"{len(value)} nested setting(s)"

    if value is None:
        return "`null`"

    return "`<value>`"


def setting_description(key: str) -> str:
    descriptions = {
        "editor.minimap.enabled": "Controls whether the editor minimap is shown.",
        "editor.wordWrap": "Controls editor word wrapping.",
        "editor.fontSize": "Sets the editor font size.",
        "editor.renderValidationDecorations": "Controls validation decorations in the editor.",
        "zenMode.hideLineNumbers": "Controls whether line numbers are hidden in Zen Mode.",
        "editor.quickSuggestions": "Controls automatic quick suggestions.",
        "editor.suggestOnTriggerCharacters": "Controls suggestions triggered by typed characters.",
        "editor.tabCompletion": "Controls tab completion behavior.",
        "workbench.editorAssociations": "Controls file-to-editor associations.",
        "git.autofetch": "Controls automatic Git fetching.",
        "git.enableSmartCommit": "Allows committing all changes when no files are staged.",
        "git.confirmSync": "Controls confirmation prompts before Git sync.",
        "workbench.colorTheme": "Sets the active color theme.",
        "lean4.alwaysAskBeforeInstallingLeanVersions": "Controls whether Lean version installs require confirmation.",
        "latex-workshop.latex.autoBuild.run": "Controls when LaTeX Workshop auto-builds documents.",
        "latex-workshop.view.pdf.viewer": "Controls the LaTeX Workshop PDF viewer type.",
        "latex-workshop.view.pdf.invert": "Controls PDF inversion intensity.",
        "latex-workshop.view.pdf.invertMode.enabled": "Controls when PDF invert mode is enabled.",
        "latex-workshop.latex.watch.pdf.delay": "Sets the PDF watcher delay.",
        "latex-workshop.message.error.show": "Controls LaTeX Workshop error popup messages.",
        "files.autoSave": "Controls autosave behavior.",
        "files.autoSaveDelay": "Sets autosave delay in milliseconds.",
        "cSpell.enabled": "Enables or disables cSpell.",
        "cSpell.language": "Sets the spell-checking language.",
        "cSpell.diagnosticLevel": "Sets spell-checking diagnostic severity.",
        "cSpell.userWords": "Stores custom words accepted by the spell checker.",
        "cSpell.ignoreRegExpList": "Stores regular expressions ignored by spell checking.",
    }
    return descriptions.get(key, "")


def write_readme(settings: dict[str, Any]) -> None:
    categories: dict[str, list[tuple[str, Any]]] = {}

    for key in sorted(settings):
        category = classify_key(key)
        categories.setdefault(category, []).append((key, settings[key]))

    lines: list[str] = []

    lines.append("# VS Code Insiders settings")
    lines.append("")
    lines.append("This README is generated from `vscode-insiders/settings.json`.")
    lines.append("")
    lines.append("The backed-up settings file corresponds to the macOS VS Code Insiders user settings file:")
    lines.append("")
    lines.append("```text")
    lines.append("~/Library/Application Support/Code - Insiders/User/settings.json")
    lines.append("```")
    lines.append("")
    lines.append("Regenerate this README with:")
    lines.append("")
    lines.append("```bash")
    lines.append("python3 scripts/update-vscode-insiders-readme.py")
    lines.append("```")
    lines.append("")
    lines.append("The main `backup.sh` script runs this generator automatically after copying `settings.json`.")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(f"`settings.json` currently contains **{len(settings)} top-level setting(s)**.")
    lines.append("")
    lines.append("## Settings by category")
    lines.append("")

    for category in sorted(categories):
        lines.append(f"### {category}")
        lines.append("")
        lines.append("| Setting | Current value summary | Notes |")
        lines.append("|---|---|---|")

        for key, value in categories[category]:
            safe_key = key.replace("|", "\\|")
            notes = setting_description(key).replace("|", "\\|")
            lines.append(f"| `{safe_key}` | {summarize_value(value)} | {notes} |")

        lines.append("")

    lines.append("## Related files")
    lines.append("")
    lines.append("```text")
    lines.append("vscode-insiders/settings.json")
    lines.append("vscode-insiders/keybindings.json")
    lines.append("vscode-insiders/extensions.txt")
    lines.append("vscode-insiders/snippets/")
    lines.append("```")
    lines.append("")
    lines.append("## Manual restore")
    lines.append("")
    lines.append("From the root of this repository:")
    lines.append("")
    lines.append("```bash")
    lines.append('VSCODE_USER="$HOME/Library/Application Support/Code - Insiders/User"')
    lines.append('mkdir -p "$VSCODE_USER"')
    lines.append('cp vscode-insiders/settings.json "$VSCODE_USER/settings.json"')
    lines.append("")
    lines.append("if [ -f vscode-insiders/keybindings.json ]; then")
    lines.append('  cp vscode-insiders/keybindings.json "$VSCODE_USER/keybindings.json"')
    lines.append("fi")
    lines.append("")
    lines.append("if [ -d vscode-insiders/snippets ]; then")
    lines.append('  rm -rf "$VSCODE_USER/snippets"')
    lines.append('  cp -R vscode-insiders/snippets "$VSCODE_USER/snippets"')
    lines.append("fi")
    lines.append("```")
    lines.append("")
    lines.append("Then restart VS Code Insiders.")
    lines.append("")
    lines.append("## Extension restore")
    lines.append("")
    lines.append("If `extensions.txt` is present, reinstall the listed extensions with:")
    lines.append("")
    lines.append("```bash")
    lines.append("while IFS= read -r extension; do")
    lines.append('  code-insiders --install-extension "$extension"')
    lines.append("done < vscode-insiders/extensions.txt")
    lines.append("```")
    lines.append("")
    lines.append("## Privacy notes")
    lines.append("")
    lines.append("Before committing changes, check that `settings.json`, snippets, and extension lists do not contain:")
    lines.append("")
    lines.append("```text")
    lines.append("tokens")
    lines.append("API keys")
    lines.append("private URLs")
    lines.append("account identifiers")
    lines.append("machine-specific secrets")
    lines.append("absolute paths you do not want public")
    lines.append("```")
    lines.append("")
    lines.append("The main backup script performs sanitization and optional secret scanning, but this repository is public, so unusual changes should still be reviewed.")
    lines.append("")

    README.write_text("\n".join(lines), encoding="utf-8", newline="\n")


def main() -> None:
    settings = load_settings()
    write_readme(settings)
    print(f"Wrote {README}")


if __name__ == "__main__":
    main()
