# Gang Beasts 0.0.3: Decompiled into Source

This is a rebuild of the code and the Unity project behind **Gang Beasts 0.0.3**, an early free pre-alpha of Gang Beasts, made in Unity 4.3.2.

The game was taken apart, and its code was rewritten by hand until it matched the original. "Matched" here means something strict: when this code is compiled with the same Unity version, it produces **the same files, byte for byte**, as the ones that shipped with the game. That's checked with tools, so you don't have to take it on trust.

> WARNING: Gang Beasts belongs to Boneloaf. This is an unofficial project for learning and preservation, and it isn't connected to Boneloaf in any way.

## How far along it is

The game's code is split into four parts (Unity calls them *assemblies*):

| Part | Language | Status |
|---|---|---|
| Assembly-CSharp-firstpass | C# | ✅ Exact match |
| Assembly-UnityScript-firstpass | UnityScript (JavaScript) | ✅ Exact match |
| Assembly-UnityScript | UnityScript (JavaScript) | ✅ Exact match |
| Assembly-CSharp | C# | ✅ Exact match |

## Open the game in Unity

You need **Unity 4.3.2** exactly. Newer versions won't open this project properly.

1. Download or clone this repository.
2. Open the folder `reconstruction/GangBeasts` in Unity 4.3.2.
3. The first time, Unity imports every file. This takes a few minutes.
4. Open a level from `Assets/Scenes` (start with `Intro` or `Menu`) and press **Play**.

Some screen effects, like bloom and blur, need Unity **Pro** in this old version. Without Pro, the game still runs; those effects just stay off.

## Build the game

In Unity, go to **File → Build Settings**, pick **PC, Mac & Linux Standalone**, and click **Build**. All the levels are already in the build list, in the right order.

## What's in this repository

```
reconstruction/
  GangBeasts/   the full Unity project (levels, art, sounds and code)
  src/          the rebuilt code, one folder per assembly
  layout/       lists of which file each piece of code goes in
  tools/        the scripts that build the code and check it against the original
  proof/        reports from the checks
```

The code in `GangBeasts/Assets` is a copy of the code in `src/`. If you change one, change the other too.

## Check the code against the original yourself

This part is optional, for anyone who wants to repeat the proof. You need:

- **Windows** with **Git Bash** and **Python 3**.
- **Unity 4.3.2**, in a folder named `UnitySetup-4.3.2` next to `reconstruction/`.
- **The original game files** (Gang Beasts 0.0.3 for Windows), in a folder named `gang_beasts_0_0_3_windows` next to `reconstruction/`. They're used as the reference.

Then, from the `reconstruction` folder in Git Bash:

```bash
bash tools/build.sh        # compile the code the same way Unity 4.3.2 does
bash tools/prove_all.sh    # compile everything from scratch and compare it with the original files
```

`prove_all.sh` writes its results to `proof/SUMMARY.txt`. **PASS** means the file came out the same as the original. The only differences allowed are a timestamp and a random ID, which change every time anything is compiled.

## Good to know

- Don't let Git change line endings in this repository. Even a small change like that would break the exact match. The included `.gitattributes` file already turns it off.
- The original folder names inside the game's code couldn't be recovered, so some folders have numbered names like `01 Prototype`. That's on purpose.
- More technical details about how everything works are in [CLAUDE.md](CLAUDE.md).
