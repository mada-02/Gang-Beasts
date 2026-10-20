# Gang Beasts 0.0.3 — proven source reconstruction

Source for the four script assemblies of Gang Beasts 0.0.3 (Unity 4.3.2f1, Windows). When these sources are compiled with Unity 4.3.2's own compilers and flags, the result must match the shipped DLLs byte for byte. Only the PE `TimeDateStamp` and the module MVID may differ.

| Assembly | Status |
|---|---|
| Assembly-CSharp-firstpass | byte-identical (proven) |
| Assembly-UnityScript-firstpass | byte-identical (proven) |
| Assembly-UnityScript | byte-identical (proven) |
| Assembly-CSharp | builds; ~80 methods still differ in IL |

The UnityScript assemblies are real `.js` compiled with `us.exe`, not C# ports.

## Not included

The game, the Unity editor and any assets taken from the game are not in this repository. To build, place these next to `reconstruction/`:

- `gang_beasts_0_0_3_windows/`: your copy of the game.
- `UnitySetup-4.3.2/`: Unity 4.3.2 (its Mono and compilers are used directly).

## Usage (Git Bash, from `reconstruction/`)

```bash
bash tools/build.sh                         # Unity-exact compile → build/out/
bash tools/prove_all.sh                     # clean build + byte proof + IL diff → proof/SUMMARY.txt
python -I tools/assemble_project.py <dir>   # Unity 4.3.2 project (needs an AssetRipper export in export/)
```

`.gitattributes` turns off line-ending conversion so the sources stay byte-exact. See [CLAUDE.md](CLAUDE.md) for the pipeline, the tools and the compiler idioms that decide a 1:1 match.
