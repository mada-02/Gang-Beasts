"""Writes Unity 4.3 .meta files (fresh GUIDs) for new files and folders that lack one.

  python -I tools/dev/new_meta.py <path> [<path> ...] [--order N]

A folder argument covers everything inside it. --order sets MonoImporter.executionOrder for the
.cs files named on this command line (not for those found inside folders). Existing metas are
never touched.
"""
import os
import sys
import uuid

SCRIPT = ("fileFormatVersion: 2\nguid: {guid}\nMonoImporter:\n  serializedVersion: 2\n  defaultReferences: []\n"
          "  executionOrder: {order}\n  icon: {{instanceID: 0}}\n  userData: \n")
FOLDER = "fileFormatVersion: 2\nguid: {guid}\nfolderAsset: yes\nDefaultImporter:\n  userData: \n"
OTHER = "fileFormatVersion: 2\nguid: {guid}\nDefaultImporter:\n  userData: \n"


def write_meta(path, order=0):
    meta = path + ".meta"
    if os.path.exists(meta) or path.endswith(".meta"):
        return
    if os.path.isdir(path):
        text = FOLDER
    elif path.endswith((".cs", ".js")):
        text = SCRIPT
    else:
        text = OTHER
    with open(meta, "w", encoding="ascii", newline="\n") as f:
        f.write(text.format(guid=uuid.uuid4().hex, order=order))
    print("meta", os.path.relpath(meta))


def main(args):
    order = 0
    if "--order" in args:
        i = args.index("--order")
        order = int(args[i + 1])
        del args[i:i + 2]
    for arg in args:
        path = os.path.abspath(arg)
        # A meta for a meta (X.meta.meta) made Unity 4.3's auto-refresh crash the editor.
        if path.endswith(".meta"):
            sys.exit("refusing to make a meta for a meta: " + arg)
        # Every enclosing folder up to Assets needs a meta too.
        parent = os.path.dirname(path)
        chain = []
        while os.path.basename(parent) != "Assets" and os.path.dirname(parent) != parent:
            chain.append(parent)
            parent = os.path.dirname(parent)
        for folder in reversed(chain):
            write_meta(folder)
        write_meta(path, order)
        if os.path.isdir(path):
            for dirpath, dirs, files in os.walk(path):
                for name in sorted(dirs) + sorted(files):
                    if not name.endswith(".meta"):
                        write_meta(os.path.join(dirpath, name))


if __name__ == "__main__":
    main(sys.argv[1:])
