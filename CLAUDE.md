# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A source reconstruction of **Gang Beasts 0.0.3** (Unity 4.3.2f1, Windows). The goal is a *proven* 1:1 rebuild: sources that, compiled with Unity 4.3.2's own compilers, reproduce the shipped script DLLs byte-for-byte except the PE `TimeDateStamp` and module MVID. Git remote: https://github.com/mada-02/Gang-Beasts.git — `src/` is stored byte-exact (`.gitattributes` disables EOL conversion).

- `gang_beasts_0_0_3_windows/` — the shipped game. **Read-only ground truth; never modify.** Work on scratch copies elsewhere. Not in git.
- `UnitySetup-4.3.2/` — (not in git) Unity 4.3.2 editor + its Mono (`Data/Mono/bin/mono.exe`, compilers in `Data/Mono/lib/mono/unity/{smcs,us}.exe`).
- `reconstruction/` — all work: `src/<Assembly>/` (canonical sources), `layout/` (path maps), `tools/`, `build/`, `proof/`, `export/` (AssetRipper output + `ShaderText/`), `GangBeasts/` (assembled Unity project). `build/`, `decompiled/`, `export/`, `tools/bin/` and `GangBeasts/{Library,Temp}` are generated and git-ignored; `GangBeasts/` itself (assets + scripts) is committed. Keep its scripts identical to `src/` (copy edits both ways).
- `init.bat` puts the bundled portable Node/Git on PATH (cmd only).

## Status (keep updated)

Proven byte-identical: Assembly-CSharp-firstpass, Assembly-UnityScript-firstpass, Assembly-UnityScript. **Assembly-CSharp** builds but ~80 methods still differ in IL (paused by the user to ship the Unity project). Get the current list with `ildiff dist` (below).

## Commands (run from `reconstruction/`, Git Bash)

```bash
bash tools/build.sh [Assembly-Name ...]        # Unity-exact compile → build/out/ (default: all four, dependency order)
python -I tools/verify.py <shipped.dll> build/out/<A>.dll   # the byte-level proof (PASS/FAIL)
bash tools/prove_all.sh                        # clean build + verify + ildiff + REA for all four → proof/SUMMARY.txt
                                               #   (rm -rf build/out — never run while autofix is running)
O="../gang_beasts_0_0_3_windows/Gang Beasts_Data/Managed"
tools/bin/ildiff/ildiff.exe diff "$O/<A>.dll" build/out/<A>.dll [-v]  # per-method RAW/SEM/DIFF + layout/attribute report
tools/bin/ildiff/ildiff.exe dist "$O/<A>.dll" build/out/<A>.dll      # per-method distance (0 = equal); sort -n for work list
tools/cmp.sh <A> <TypeSubstring> <Method> [ctx]                     # compact IL diff of one method (the "single test")
python -I tools/assemble_project.py <new-out-dir>                   # build the Unity project (refuses existing dir)
"reconstruction/Open GangBeasts in Unity 4.3.2.bat"                 # open project (see gotchas)
```

The .NET tools (`tools/{ildiff,relayout,autofix,cs2us}`) are rebuilt with `dotnet build -c Release -o ../bin/<name>`; `ildiff` and `autofix` share `tools/ilmodel/IlModel.cs`. REA CLI: `npx -y rea-agents@6.7.0 compare-managed-members <orig> <rebuilt> --format json`.

## How the pipeline fits together

1. **Decompile** (ilspycmd, a separately downloaded tool) with `-lv CSharp3 -ds SparseIntegerSwitch=false` → `decompiled/` (reference only).
2. **Layout**: Unity compiles a script assembly's files in **ordinal full-path order**, and smcs/us.exe emit TypeDefs in file order — so the shipped TypeDef order dictates paths. `layout/<A>.map` lists `path: TypeA TypeB…`; `relayout check` validates order. `layout/gen_csharp_map.py` generates the Assembly-CSharp map (`@Name` overrides the file name; a MonoBehaviour's file must be named after it). Original folder names are unrecoverable; numbered folders are deliberate placeholders.
3. **Compiler flags** in `tools/build.sh` were decompiled from Unity 4.3.2's `UnityEditor.Scripting.Compilers.*`; don't change them. `SRC_ROOT`/`OUT_DIR` env vars let tools build isolated copies.
4. **Matching IL**: C# — `tools/bin/autofix` (Roslyn rewrite search judged by real smcs builds, parallel workers in `build/work/`, Roslyn pre-filter using `build/prefilter-refs` from `retarget_refs.py`). UnityScript `.js` (hand-written, not ported) — `tools/usfix.py` (literal/truthiness/ternary search) and `tools/usidioms.py` (pattern rewrites). Remaining diffs are fixed by hand: read the original IL with `cmp.sh`/`ildiff il`, edit `src/`, rebuild.
5. **Attribute order**: Mono's CustomAttribute `qsort` is unstable, so source order is found by search (`attrsearch.py`, `attrsearch_js.py`) — do this last.
6. **Unity project**: AssetRipper 2.0.0 (downloaded separately; headless `--port 18765`) exports the game into `export/` (with `level10` patched, see gotchas); `assemble_project.py` copies `export/ExportedProject` (minus AssetRipper's scripts), places `src/` at map paths with `.meta` GUIDs taken from AssetRipper's per-class GUIDs, copies `ProBuilderCore.dll`/`SixBySeven.dll` verbatim into `Assets/Plugins` and rewrites references to them as `{fileID: MD4-class-id, guid: dll}`, then runs `fix_controllers.py` (AnimatorControllers in 4.3 layout) and `fix_shaders.py` (real compiled shaders / built-in remaps from `export/ShaderText`).

## Compiler idioms that decide 1:1 (non-obvious)

- mcs/Boo emit different IL for: early `return;` vs wrapping `if`; `if/else` vs ternary; empty `else {}` blocks (kept in original code); `x = x + y` vs `x += y`; named result locals before `return`; `const` locals (get real slots); `switch` with `case N: default:`; explicit `.ToString()` in concatenation; `c ? true : false`; default-valued static initializers (produce an empty `.cctor`).
- UnityScript: literal form is preserved (`2` → `ldc.i4.2; conv.r4`, `2.0` → `ldc.r4`); locals are function-scoped; `for (x in array)` is lowered to an index loop; `if (!obj)` ≠ `obj == null`; a coroutine called as a statement auto-wraps in `StartCoroutine_Auto`; Boo's global name counter (`$Name$48`) shifts if any earlier file differs.
- Third-party code (Unity Standard Assets, poly2tri, Colorful, Marmoset, cInput, wiki JPGEncoder/SmoothFollow) often matches IL exactly when restored to its known original text, comments included.

## Gotchas

- Write files as bytes / `newline='\n'` from Python on Windows — text-mode writes produce CRLF and break the regex tools. Non-ASCII sources need a UTF-8 BOM (`tools/add_bom.py`) for Mono 2.x.
- Bash heredocs containing apostrophes or tab-only blank lines have broken edits; prefer the Write/Edit tools or `tools/rep` with exact text.
- Unity 4.3's Project Wizard crashes on Windows 10/11 when switching projects (`LicenseInfo::~LicenseInfo`); always open with `-projectPath`. Batch mode requires an activated license. Logs: `%LOCALAPPDATA%\Unity\Editor\Editor.log`.
- `level10` embeds a MonoScript whose assembly name is a full display name; AssetRipper only reads it from a scratch copy patched by `tools/patch_monoscript_assembly.py`.
