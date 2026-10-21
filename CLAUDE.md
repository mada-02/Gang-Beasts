# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A source reconstruction of **Gang Beasts 0.0.3** (Unity 4.3.2f1, Windows). The goal is a *proven* 1:1 rebuild: sources that, compiled with Unity 4.3.2's own compilers, reproduce the shipped script DLLs byte-for-byte except the PE `TimeDateStamp` and module MVID. Git remote: https://github.com/mada-02/Gang-Beasts.git — `src/` is stored byte-exact (`.gitattributes` disables EOL conversion).

- `gang_beasts_0_0_3_windows/` — the shipped game. **Read-only ground truth; never modify.** Work on scratch copies elsewhere. Not in git.
- `UnitySetup-4.3.2/` — (not in git) Unity 4.3.2 editor + its Mono (`Data/Mono/bin/mono.exe`, compilers in `Data/Mono/lib/mono/unity/{smcs,us}.exe`).
- `reconstruction/` — all work: `src/<Assembly>/` (canonical sources), `layout/` (path maps), `tools/`, `build/`, `proof/`, `export/` (AssetRipper output + `ShaderText/`), `GangBeasts/` (assembled Unity project). `build/`, `decompiled/`, `export/`, `tools/bin/` and `GangBeasts/{Library,Temp}` are generated and git-ignored; `GangBeasts/` itself (assets + scripts) is committed. Keep its scripts identical to `src/` (copy edits both ways) — except for the `additional`-branch changes below.

## Status (keep updated)

**All functions match.** Every method in all four script assemblies (Assembly-CSharp-firstpass, Assembly-UnityScript-firstpass, Assembly-UnityScript, Assembly-CSharp) compiles to IL identical to the shipped game, and each rebuilt DLL is byte-identical to the original apart from the PE `TimeDateStamp` and module MVID. `ildiff dist` reports distance 0 for every method. Re-check with `prove_all.sh` / `ildiff dist` (below). This holds on both branches: the `additional` branch's dev menu never touches `src/`.

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
"../UnitySetup-4.3.2/Unity.exe" -projectPath "$(cygpath -w GangBeasts)"   # open project (see gotchas)
```

The .NET tools (`tools/{ildiff,relayout,autofix,cs2us}`) are rebuilt with `dotnet build -c Release -o ../bin/<name>`; `ildiff` and `autofix` share `tools/ilmodel/IlModel.cs`. REA CLI: `npx -y rea-agents@6.7.0 compare-managed-members <orig> <rebuilt> --format json`.

## Branches and the F12 dev menu (`additional` branch only)

This CLAUDE.md is the same on both branches. **The dev menu exists only on `additional`**; if you're on `main`, none of the files below are present. Check with `git branch --show-current`.

- `main` — the pure 1:1 reconstruction. The Unity project's scripts are identical to `src/`.
- `additional` — `main` plus a sandbox dev menu.

The `additional` branch adds a sandbox dev menu **only to the Unity project** (`reconstruction/GangBeasts/Assets`); `src/`, `layout/`, `tools/` and `proof/` are untouched, so the byte-exact proof still applies to `src/`. Branch-only differences:

- `Assets/DevMenu/DevMenu.cs` — IMGUI window toggled with **F12** (`toggleKey`). Tabs:
  - **AI**: spawns copies of a level beast as mobs (`Player.mob = true`, `player = 4` so it never takes a P1–P4 slot) driven by the game's own NavMesh chase/punch AI. Type *Normal* or *Pink Boss*; team *Mob gang*, *Free-for-all* or *Ally P1* (joins P1's `gangName`); count, random colours, spawn at screen centre / near P1.
  - **Objects**: physics primitives (size/mass), prefabs from `Resources/DevMenu`, and copies of loose physics objects in the current level.
  - **Settings**: time scale (also pushed into `AudioTimeScale.timeScale` via reflection), gravity, punch power, volume, infinite health for human players, show balance balls, FPS.
  - **Level**: restart, main menu, load any level (`SceneManager.levelList`, fallback list), remove spawned AI/objects.
- `Assets/DevMenu/DevMenuPunch.cs` — added to every beast's hands; when power > 1 and the hand is tagged `Body Part (Harmful)`, adds knockback + damage (same formula as `CollisionEvent.DamageCheck`, scaled). Replaces an earlier slider on `Player.force`, which controls balance/muscle strength, not punches.
- `Assets/DevMenu/DevMenuFollow.cs` — for *Ally P1* AI: keeps the NavMesh agent following the leader when it has no target within 10 m (mob AI only sets a destination while it has a target), using the same leash as `Player.FindClosestTarget`.
- `Assets/Scripts/28 Gang Beasts/Player/SceneManager.cs` — the one edit to a reconstructed script: `Awake` adds `DevMenu` to the persistent SceneManager object. This file intentionally differs from `src/Assembly-CSharp`; don't copy it back to `src/`.
- The three loose prefabs (`Glass Sheet`, `Sign`, `Window Glass (3m)`) moved from `Assets/GameObject/` to `Assets/DevMenu/Resources/DevMenu/` with GUIDs unchanged, so `Resources.LoadAll("DevMenu")` finds them.
- `assemble_project.py` knows nothing of the dev menu; regenerating the project drops it — re-apply these files afterwards.

How it works (non-obvious):
- `Player.Awake` re-parents every rigidbody part to the root, so a live beast can't be cloned directly. ~0.5 s after each level load, `CaptureTemplate` copies a beast (preferring a level mob) **while inactive**, restores the original part hierarchy (`partPaths`), strips `healthBar`/`staminaBar`, and records the level's starting health; spawns instantiate that template.
- *Pink Boss* reproduces Street's boss: same mesh scaled 1.2918×, reshaped chest/head/arm bones and chest capsule colliders (`ApplyBossShape`, applied to the inactive copy), health 200, stun threshold 20, movement speed 30, animation speed 0.4.
- Beasts balance on an invisible `ball` part under the hips (why they hover); *Show balance balls* toggles its renderer.

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
