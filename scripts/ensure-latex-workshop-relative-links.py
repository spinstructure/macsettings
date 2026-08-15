#!/usr/bin/env python3
"""Keep the local LaTeX Workshop PDF-relative-source-link patch installed."""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import tempfile
from pathlib import Path


EXTENSION_GLOB = "james-yu.latex-workshop-*"
VIEWER_RELATIVE_PATH = Path("out/src/preview/viewer.js")
LINK_AUTHORITY = "vscode-insiders.invalid"
PATCH_MARKER = "macsettings: latex-workshop relative source links"

HANDLER_ANCHOR = "function handler(websocket, msg) {"
EXTERNAL_LINK_ORIGINAL = """        case 'external_link': {
            const uri = vscode.Uri.parse(data.url);
            if (['http', 'https'].includes(uri.scheme)) {
                void vscode.env.openExternal(uri);
            }
"""
EXTERNAL_LINK_PATCHED = f"""        case 'external_link': {{
            const uri = vscode.Uri.parse(data.url);
            // {PATCH_MARKER}
            if (uri.scheme === 'https' && uri.authority === '{LINK_AUTHORITY}') {{
                void openSourceLink(uri, websocket);
            }}
            else if (['http', 'https'].includes(uri.scheme)) {{
                void vscode.env.openExternal(uri);
            }}
"""
SOURCE_LINK_HELPER = f"""// {PATCH_MARKER}: begin
async function openSourceLink(uri, websocket) {{
    const match = /^(.*):(\\d+):(\\d+)$/.exec(uri.path);
    if (!match) {{
        return;
    }}
    const [, encodedPath, lineText, columnText] = match;
    const relativePath = encodedPath.replace(/^\\/+/, '');
    if (!relativePath || relativePath.split('/').includes('..')) {{
        return;
    }}
    const client = Array.from(manager.getClients() ?? []).find(candidate => candidate.websocket === websocket);
    const pdfUri = client ? vscode.Uri.parse(client.pdfFileUri, true) : undefined;
    const workspaceUri = vscode.workspace.workspaceFolders?.[0]?.uri;
    const baseUri = pdfUri
        ? pdfUri.with({{ path: path.posix.dirname(pdfUri.path) }})
        : workspaceUri;
    if (!baseUri) {{
        return;
    }}
    const sourceUri = vscode.Uri.joinPath(baseUri, relativePath);
    const document = await vscode.workspace.openTextDocument(sourceUri);
    const line = Math.max(0, Number.parseInt(lineText, 10) - 1);
    const column = Math.max(0, Number.parseInt(columnText, 10) - 1);
    const position = new vscode.Position(line, column);
    const existingEditor = vscode.window.visibleTextEditors.find(editor => editor.document.uri.toString() === document.uri.toString());
    const editor = await vscode.window.showTextDocument(document, {{
        viewColumn: existingEditor?.viewColumn,
        preview: false,
        selection: new vscode.Range(position, position)
    }});
    editor.revealRange(new vscode.Range(position, position), vscode.TextEditorRevealType.InCenterIfOutsideViewport);
}}
// {PATCH_MARKER}: end
"""


class PatchError(RuntimeError):
    pass


def default_extensions_root() -> Path:
    override = os.environ.get("VSCODE_INSIDERS_EXTENSIONS_DIR")
    if override:
        return Path(override).expanduser()
    return Path.home() / ".vscode-insiders" / "extensions"


def patch_viewer_text(source: str) -> tuple[str, bool]:
    has_helper = "async function openSourceLink(uri, websocket)" in source
    has_handler = f"uri.authority === '{LINK_AUTHORITY}'" in source

    if has_helper and has_handler:
        return source, False
    if has_helper != has_handler:
        raise PatchError("a partial relative-source-link patch is present")
    if source.count(HANDLER_ANCHOR) != 1:
        raise PatchError("the LaTeX Workshop handler layout is unfamiliar")
    if source.count(EXTERNAL_LINK_ORIGINAL) != 1:
        raise PatchError("the LaTeX Workshop external-link layout is unfamiliar")

    patched = source.replace(HANDLER_ANCHOR, SOURCE_LINK_HELPER + HANDLER_ANCHOR, 1)
    patched = patched.replace(EXTERNAL_LINK_ORIGINAL, EXTERNAL_LINK_PATCHED, 1)
    return patched, True


def validate_javascript(path: Path) -> None:
    node = shutil.which("node")
    if node is None:
        return
    result = subprocess.run([node, "--check", str(path)], capture_output=True, text=True)
    if result.returncode:
        details = result.stderr.strip() or result.stdout.strip()
        raise PatchError(f"JavaScript validation failed: {details}")


def install_patch(viewer_path: Path, check_only: bool) -> bool:
    source = viewer_path.read_text(encoding="utf-8")
    patched, changed = patch_viewer_text(source)
    if not changed:
        backup_path = viewer_path.with_name(viewer_path.name + ".macsettings-backup")
        legacy_backup = viewer_path.with_name(viewer_path.name + ".codex-backup")
        if not check_only and not backup_path.exists() and legacy_backup.exists():
            shutil.copy2(legacy_backup, backup_path)
            print(f"Adopted existing LaTeX Workshop backup: {backup_path.name}")
        print(f"LaTeX Workshop patch is present: {viewer_path.parents[3].name}")
        return False
    if check_only:
        raise PatchError(f"patch is missing: {viewer_path}")

    backup_path = viewer_path.with_name(viewer_path.name + ".macsettings-backup")
    if not backup_path.exists():
        shutil.copy2(viewer_path, backup_path)

    temporary_name = ""
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=viewer_path.parent,
            prefix=".viewer.macsettings.",
            suffix=".js",
            delete=False,
        ) as temporary:
            temporary.write(patched)
            temporary_name = temporary.name
        temporary_path = Path(temporary_name)
        temporary_path.chmod(viewer_path.stat().st_mode)
        validate_javascript(temporary_path)
        os.replace(temporary_path, viewer_path)
    finally:
        if temporary_name:
            Path(temporary_name).unlink(missing_ok=True)

    print(f"Installed LaTeX Workshop patch: {viewer_path.parents[3].name}")
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify without installing")
    parser.add_argument("--extensions-dir", type=Path, default=default_extensions_root())
    args = parser.parse_args()

    roots = sorted(path for path in args.extensions_dir.glob(EXTENSION_GLOB) if path.is_dir())
    viewer_paths = [root / VIEWER_RELATIVE_PATH for root in roots]
    viewer_paths = [path for path in viewer_paths if path.is_file()]
    if not viewer_paths:
        print(f"Skipped LaTeX Workshop patch: no installed extension found under {args.extensions_dir}")
        return 0

    changed = False
    try:
        for viewer_path in viewer_paths:
            changed = install_patch(viewer_path, args.check) or changed
    except (OSError, PatchError) as error:
        print(f"ERROR: {error}", file=os.sys.stderr)
        return 1

    if changed:
        print("Reload the VS Code Insiders window before using relative TeX-line PDF links.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
