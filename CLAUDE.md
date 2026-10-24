# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A source reconstruction of **Gang Beasts 0.0.3** (Unity 4.3.2f1, Windows). The goal is a *proven* 1:1 rebuild: sources that, compiled with Unity 4.3.2's own compilers, reproduce the shipped script DLLs byte-for-byte except the PE `TimeDateStamp` and module MVID. Git remote: https://github.com/mada-02/Gang-Beasts.git — `src/` is stored byte-exact (`.gitattributes` disables EOL conversion).

- `gang_beasts_0_0_3_windows/` — the shipped game. **Read-only ground truth; never modify.** Work on scratch copies elsewhere. Not in git.
- `UnitySetup-4.3.2/` — (not in git) Unity 4.3.2 editor + its Mono (`Data/Mono/bin/mono.exe`, compilers in `Data/Mono/lib/mono/unity/{smcs,us}.exe`).
- `reconstruction/` — all work: `src/<Assembly>/` (canonical sources), `layout/` (path maps), `tools/`, `build/`, `proof/`, `export/` (AssetRipper output + `ShaderText/`), `GangBeasts/` (assembled Unity project). `build/`, `decompiled/`, `export/`, `tools/bin/` and `GangBeasts/{Library,Temp}` are generated and git-ignored; `GangBeasts/` itself (assets + scripts) is committed. Keep its scripts identical to `src/` (copy edits both ways) — except for the `additional`/`developer`-branch changes below.

## Status (keep updated)

**All functions match.** Every method in all four script assemblies (Assembly-CSharp-firstpass, Assembly-UnityScript-firstpass, Assembly-UnityScript, Assembly-CSharp) compiles to IL identical to the shipped game, and each rebuilt DLL is byte-identical to the original apart from the PE `TimeDateStamp` and module MVID. `ildiff dist` reports distance 0 for every method. Re-check with `prove_all.sh` / `ildiff dist` (below). This holds on every branch: the `additional` and `developer` dev menus never touch `src/` (`tools/dev/guard.py` checks it on `developer`).

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

## Branches

Check with `git branch --show-current`. Only `main`'s Unity project is identical to `src/`.

- `main` — the pure 1:1 reconstruction.
- `additional` — `main` plus the first sandbox dev menu (`Assets/DevMenu/`, one hook in `SceneManager.Awake`). Kept as it was; superseded by `developer`.
- `developer` — `main` plus the revamped developer layer in `reconstruction/GangBeasts/Assets/Dev/` and its tooling in `reconstruction/tools/dev/` and `reconstruction/dev/`. Described below.

## The `developer` branch

F12 opens the dev menu (IMGUI; tabs AI, Player, Objects, World, Level, Debug, Camera). `src/`, `layout/`, `proof/` and the existing `tools/` are untouched (`tools/dev/guard.py` checks it).

**Game-script hooks** (Unity project copies only; each reviewed hunk is stored in `tools/dev/hooks/*.diff` and `guard.py` fails on any other difference from `src/`):
- `SceneManager.Awake` adds `DevRoot` to the persistent SceneManager object.
- `Player`: `[NonSerialized] public bool devBrain` — `Update` skips the built-in mob AI (`FindClosestTarget`) while a dev brain drives the mob; `TauntInput` stops a mob taunting at a living target (`DevHooks.fixMobTaunt`).
- `HealthAndStamina.TakeDamage` skips `score[player]--` past the P1–P4 scores, which threw for every mob death (`DevHooks.fixScoreIndex`).
Any further hook needs the owner's approval.

**Layout of `Assets/Dev/`:**
- `Core/` — `DevRoot` (level lifecycle: `LevelStarting` → template capture → `BeastRegistry.Sweep` → `LevelReady`), `BeastRegistry` (every beast, Added/Removed/Replaced events, `SafeDestroy` which first releases grab joints on the victim and purges Targeting lists), `DevFields` (which serialized fields are level settings vs live state; a test fails on any unclassified field), `DevReflection`, `DevGround` (reference drop/footing probes), `DevHooks`.
- `Spawning/` — `BeastFactory` (inactive template captured at level load, `Spawn`, `Rebuild` = rebuild a beast from the template with another body and swap it in; hex-packed spawn spots with a clear body volume), `BeastShape`.
- `Generated/` — written by `tools/dev/gen_data.py`, never by hand: `BeastShapes.cs` (Street's 0.0.3 and 0.0.2 pink boss), `HardModeData.cs`, `HitboxMeshes.cs`.
- `AI/` — `DevSpawner` (teams: mob gang, free-for-all, Teams A–D, allies of P1–P4), Smart AI: `AIDirector` (10 Hz: snapshot, `SpatialHash`, perception, `TargetAssigner`: 3 attackers per normal beast (5 per pink boss), the rest queued; `SlotPlanner` arcs ≤155°; sight lines budgeted to 16 per tick and blind to layers 8/9 (Sandbox cubes, Grind teeth)), `AIBrain` (roles Engage/Queue/Regroup/Encircled/Finish/Follow/Search/Patrol, dodges, lunges, carry-and-throw), `AISensors` (allocation-free rays that step past triggers; held to `DevGround`'s answers), `AIDifficulty`.
- `Player/Morph.cs` (human → Pink Boss and back), `Camera/` (freecam: `FreeCamRestore` at execution order −1000 gives SceneCamera and Player.Update the game camera's pose, `FreeCamApply` at +1000 shows the free pose), `World/` (time scale, gravity, infinite health, balls, punch power, props), `UI/DevMenu.cs` (draws only; modules register sections).
- `HardMode/` — 0.0.2 physics and combat: generated data per level/class (physics by body, settings by role, generic values where 0.0.2 had no counterpart), 0.0.2 hitboxes and ignore pairs, and 0.0.2's own `Movement`/`Jump`/`PunchAndGrab`/`CollisionEvent` (`Legacy002/`, decompiled; `guard.py` checks they differ only by class name) plus `HardPlayerPre/Post` (execution order −50/+50) for 0.0.2's Player.Update rules. Everything is restored exactly when switched off. Ground truth: `reconstruction/dev/hardmode/` (`code_diff.md`, `spec.json`/`spec.md`).
- `Tests/` — `DevTestRunner` and the suites (smoke, core, menu, morph, freecam, hardmode, ai_unit, ai, diag); `Baseline/OldBrain.cs` is the additional branch's brain kept verbatim to measure the new AI against.
- `Resources/DevMenu/` — the three loose prefabs (moved from `Assets/GameObject/`, GUIDs unchanged).

**Commands (from `reconstruction/`):**
```bash
python -I tools/dev/guard.py                # src/ untouched, reviewed hooks only, metas, encodings, 0.0.2 ports, generated data
bash tools/dev/compile_dev.sh               # compile the project's scripts with Unity's smcs (no Unity needed)
python -I tools/dev/run_tests.py --build    # batch-build dev/out/player/GangBeastsDev.exe (Unity must be closed)
python -I tools/dev/run_tests.py --suite smoke,core,menu,morph,freecam,hardmode,ai_unit,ai [--filter name] [--seeds 1-3]
bash tools/dev/decompile_002.sh             # 0.0.2 scripts -> decompiled_002/ (needs ../gang_beasts_0_0_2_windows)
python -I tools/dev/fingerprint.py 002 -o dev/out/fp/all002.json; python -I tools/dev/fingerprint.py 003 -o dev/out/fp/all003.json
python -I tools/dev/fingerprint_diff.py dev/out/fp/all002.json dev/out/fp/all003.json -o dev/hardmode/spec.json -m dev/hardmode/spec.md
python -I tools/dev/gen_data.py dev/out/fp/all002.json dev/out/fp/all003.json   # Generated/*.cs
```
New `.cs` files need a `.meta`: `python -I tools/dev/new_meta.py <file or folder> [--order N]` (never on a `.meta`).

**How the tests run (non-obvious):** the player is built without Intro (its move to Menu waits on CameraFade, which advances in OnGUI, and OnGUI never runs headless) and runs `-batchmode -nographics`; each test seeds `Random` and sets `Time.captureFramerate = 100` (one 0.01 s physics step per frame); a test fails on any logged error except the known vanilla ones (`DevTestRunner.vanillaErrors`). PhysX replays a seed exactly only from the same history: reloading a level in-process can change the outcome, so physics outcomes are tested statistically. The menu's drawing itself cannot be tested headless.

**Facts the tests established:** destroying a held beast without care re-anchors the holder's grab joint to the world (breaks at force 150); spawning with level geometry inside the body flings the beast at 55–70 m/s (Gondola); with 0.5 drag a plain fall tops out near 14 m/s, under the 15 m/s damage gate; contacts within 45° of up count as ground unless the beast is Falling, and 0.0.2 never falls, so its landings never hurt.

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
- Unity 4.3.2 batch mode: builds need the editor closed and run with `-nographics` (with the display asleep the editor cannot create its Direct3D window); a new script and an edit that uses it can fail the first compile (it compiles before importing) — `run_tests.py` retries once. A `X.meta.meta` file crashed the editor's auto-refresh.
- `Physics.raycastsHitTriggers` does not exist for 3D physics in Unity 4.3.2 (only Physics2D has it), and this project's raycasts hit triggers.
- Unity 4.3's Project Wizard crashes on Windows 10/11 when switching projects (`LicenseInfo::~LicenseInfo`); always open with `-projectPath`. Batch mode requires an activated license. Logs: `%LOCALAPPDATA%\Unity\Editor\Editor.log`.
- `level10` embeds a MonoScript whose assembly name is a full display name; AssetRipper only reads it from a scratch copy patched by `tools/patch_monoscript_assembly.py`.
