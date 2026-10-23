"""Static guard tests for the developer branch (no Unity needed).

  python -I tools/dev/guard.py                 run every check, exit 1 on any failure
  python -I tools/dev/guard.py --record-hooks  rewrite tools/dev/hooks/*.diff from the current hook edits

Checks:
  protected   reconstruction/src, layout, proof and the pre-existing tools are identical to main
              (committed, staged, unstaged and untracked).
  hooks       every game script in the Unity project equals its src/ copy, except the hooked files,
              whose diff against src/ must equal the reviewed patch in tools/dev/hooks/.
  metas       every file and folder under Assets/Dev has a .meta, no .meta is orphaned, and every
              GUID in the project is unique.
  encoding    files under Assets/Dev and tools/dev use LF only; non-ASCII .cs files carry a UTF-8 BOM
              (Mono 2.x needs it).
  classnames  every MonoBehaviour under Assets/Dev lives in a file named after it.
"""
import difflib
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RECON = os.path.normpath(os.path.join(HERE, "..", ".."))
REPO = os.path.dirname(RECON)
ASSETS = os.path.join(RECON, "GangBeasts", "Assets")
SRC = os.path.join(RECON, "src")
DEV = os.path.join(ASSETS, "Dev")
TOOLS_DEV = HERE
HOOKS = os.path.join(HERE, "hooks")

failures = []


def fail(check, message):
    failures.append((check, message))


def git(*args):
    return subprocess.run(["git", "-C", REPO] + list(args), capture_output=True, text=True, check=True).stdout


def read_bytes(path):
    with open(path, "rb") as f:
        return f.read()


def check_protected():
    paths = ["reconstruction/src", "reconstruction/layout", "reconstruction/proof", "reconstruction/tools",
             ":(exclude)reconstruction/tools/dev"]
    changed = git("diff", "--name-status", "main", "--", *paths).strip()
    if changed:
        fail("protected", "differs from main:\n" + changed)
    untracked = git("status", "--porcelain", "--untracked-files=all", "--", *paths).strip()
    if untracked:
        fail("protected", "uncommitted or untracked:\n" + untracked)


def src_pairs():
    """(relative path, src file, project file) for every script in src/."""
    for assembly in sorted(os.listdir(SRC)):
        root = os.path.join(SRC, assembly)
        for dirpath, _, files in os.walk(root):
            for name in files:
                if name.endswith((".cs", ".js")):
                    path = os.path.join(dirpath, name)
                    rel = os.path.relpath(path, root).replace(os.sep, "/")
                    yield rel, path, os.path.join(ASSETS, rel)


def hook_diff(rel, src_path, project_path):
    a = read_bytes(src_path).decode("utf-8-sig").splitlines(True)
    b = read_bytes(project_path).decode("utf-8-sig").splitlines(True)
    return "".join(difflib.unified_diff(a, b, "src/" + rel, "project/" + rel, n=2))


def hook_file(rel):
    return os.path.join(HOOKS, os.path.basename(rel) + ".diff")


def check_hooks(record):
    expected = set()
    if os.path.isdir(HOOKS):
        expected = {name for name in os.listdir(HOOKS) if name.endswith(".diff")}
    seen = set()
    for rel, src_path, project_path in src_pairs():
        if not os.path.isfile(project_path):
            fail("hooks", "missing from the project: " + rel)
            continue
        if read_bytes(src_path) == read_bytes(project_path):
            continue
        name = os.path.basename(hook_file(rel))
        seen.add(name)
        diff = hook_diff(rel, src_path, project_path)
        if record:
            os.makedirs(HOOKS, exist_ok=True)
            with open(hook_file(rel), "w", encoding="utf-8", newline="\n") as f:
                f.write(diff)
            print("recorded", rel)
            continue
        if name not in expected:
            fail("hooks", "unreviewed edit to a game script: " + rel)
            continue
        with open(hook_file(rel), encoding="utf-8", newline="") as f:
            reviewed = f.read()
        if diff != reviewed:
            fail("hooks", "hook edit differs from the reviewed patch: " + rel)
    if record:
        for name in expected - seen:
            os.remove(os.path.join(HOOKS, name))
            print("removed stale", name)
        return
    for name in sorted(expected - seen):
        fail("hooks", "reviewed hook no longer present (re-record?): " + name)


GUID = re.compile(rb"^guid: ([0-9a-f]{32})\s*$", re.M)


def check_metas():
    if os.path.isdir(DEV):
        if not os.path.isfile(DEV + ".meta"):
            fail("metas", "missing Dev.meta")
        for dirpath, dirs, files in os.walk(DEV):
            names = set(files) | set(dirs)
            for name in sorted(names):
                path = os.path.join(dirpath, name)
                if name.endswith(".meta"):
                    if name[:-5] not in names:
                        fail("metas", "orphaned meta: " + os.path.relpath(path, ASSETS))
                elif name + ".meta" not in names:
                    fail("metas", "missing meta: " + os.path.relpath(path, ASSETS))
    owners = {}
    for dirpath, _, files in os.walk(ASSETS):
        for name in files:
            if not name.endswith(".meta"):
                continue
            path = os.path.join(dirpath, name)
            match = GUID.search(read_bytes(path))
            if not match:
                fail("metas", "no guid in " + os.path.relpath(path, ASSETS))
                continue
            guid = match.group(1)
            if guid in owners:
                fail("metas", "duplicate guid %s: %s and %s" % (guid.decode(), owners[guid], os.path.relpath(path, ASSETS)))
            owners[guid] = os.path.relpath(path, ASSETS)


TEXT = (".cs", ".js", ".py", ".sh", ".md", ".txt", ".json", ".diff", ".meta", ".csproj")


def check_encoding():
    for root in (DEV, TOOLS_DEV):
        if not os.path.isdir(root):
            continue
        for dirpath, dirs, files in os.walk(root):
            dirs[:] = [d for d in dirs if d not in ("bin", "obj", "__pycache__")]
            for name in files:
                if not name.endswith(TEXT):
                    continue
                path = os.path.join(dirpath, name)
                data = read_bytes(path)
                rel = os.path.relpath(path, RECON)
                if b"\r" in data:
                    fail("encoding", "CR in " + rel)
                body = data[3:] if data.startswith(b"\xef\xbb\xbf") else data
                try:
                    body.decode("ascii")
                except UnicodeDecodeError:
                    if name.endswith(".cs") and not data.startswith(b"\xef\xbb\xbf"):
                        fail("encoding", "non-ASCII .cs without UTF-8 BOM: " + rel)


BEHAVIOUR = re.compile(r"^\s*(?:public\s+|internal\s+)?(?:sealed\s+)?class\s+(\w+)\s*:\s*MonoBehaviour\b", re.M)


def check_classnames():
    if not os.path.isdir(DEV):
        return
    for dirpath, _, files in os.walk(DEV):
        for name in files:
            if not name.endswith(".cs"):
                continue
            path = os.path.join(dirpath, name)
            text = read_bytes(path).decode("utf-8-sig")
            for cls in BEHAVIOUR.findall(text):
                if cls != name[:-3]:
                    fail("classnames", "MonoBehaviour %s in %s" % (cls, os.path.relpath(path, ASSETS)))


def main():
    record = "--record-hooks" in sys.argv[1:]
    checks = [("protected", check_protected), ("hooks", lambda: check_hooks(record)), ("metas", check_metas),
              ("encoding", check_encoding), ("classnames", check_classnames)]
    for name, check in checks:
        before = len(failures)
        check()
        status = "PASS" if len(failures) == before else "FAIL"
        print("%-11s %s" % (name, status))
    for check, message in failures:
        print("  [%s] %s" % (check, message))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
