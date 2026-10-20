#!/usr/bin/env bash
# Rebuilds the four Gang Beasts 0.0.3 script assemblies with the exact compiler
# invocations Unity 4.3.2 uses (see UnityEditor.Scripting.Compilers.MonoCSharpCompiler
# and UnityScriptCompiler in Unity 4.3.2's UnityEditor.dll).
#
# Usage: tools/build.sh [assembly-name ...]   (default: all four, in dependency order)
set -euo pipefail

HERE="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
UNITY_DATA="$ROOT/UnitySetup-4.3.2/Data"
MONO="$UNITY_DATA/Mono/bin/mono.exe"
PROFILE="$UNITY_DATA/Mono/lib/mono/unity"
GAME_MANAGED="$ROOT/gang_beasts_0_0_3_windows/Gang Beasts_Data/Managed"
UNITYENGINE="$UNITY_DATA/Managed/UnityEngine.dll"
# SRC_ROOT / OUT_DIR let tools build isolated copies (autofix workers) in parallel.
SRC="${SRC_ROOT:-$HERE/src}"
OUT="${OUT_DIR:-$HERE/build/out}"
SIBLINGS="$HERE/build/out"
RSP="$OUT/rsp"
mkdir -p "$OUT" "$RSP"

export MONO_PATH="$(cygpath -w "$PROFILE")"
export MONO_CFG_DIR="$(cygpath -w "$UNITY_DATA/Mono/etc")"

# Standalone Windows player defines for Unity 4.3.2. They only matter for #if blocks.
DEFINES=(UNITY_4_3_2 UNITY_4_3 UNITY_STANDALONE_WIN UNITY_STANDALONE ENABLE_MICROPHONE
  ENABLE_TEXTUREID_MAP ENABLE_AUDIO_FMOD ENABLE_GENERICS ENABLE_DUCK_TYPING ENABLE_TERRAIN
  ENABLE_MOVIES ENABLE_WWW ENABLE_IMAGEEFFECTS ENABLE_WEBCAM ENABLE_NETWORK ENABLE_PHYSICS
  ENABLE_CLOTH ENABLE_2D_PHYSICS ENABLE_SHADOWS ENABLE_AUDIO ENABLE_NAVMESH_CARVING
  ENABLE_SPRITES ENABLE_SINGLE_INSTANCE_BUILD_SETTING ENABLE_PROFILER ENABLE_MONO)

w() { cygpath -w "$1"; }

# A sibling script assembly: our rebuilt copy when present, otherwise the shipped one
# (the shipped and rebuilt assemblies expose the same API once proven).
sib() { if [ -f "$SIBLINGS/$1.dll" ]; then echo "$SIBLINGS/$1.dll"; else echo "$GAME_MANAGED/$1.dll"; fi; }

# Source files for an assembly, in the order Unity would pass them (sorted path order).
sources() { find "$SRC/$1" -type f -name "$2" | LC_ALL=C sort; }

build_csharp() {
  local name="$1"; shift
  local rsp="$RSP/$name.rsp"
  {
    echo "-debug"; echo "-target:library"; echo "-nowarn:0169"
    echo "-out:\"$(w "$OUT/$name.dll")\""
    for r in "$@"; do echo "-r:\"$(w "$r")\""; done
    for d in "${DEFINES[@]}"; do echo "-define:$d"; done
    while IFS= read -r f; do echo "\"$(w "$f")\""; done < <(sources "$name" '*.cs')
    for extra in System.Runtime.Serialization.dll System.Xml.Linq.dll; do
      echo "-r:\"$(w "$PROFILE/$extra")\""
    done
  } > "$rsp"
  "$MONO" "$(w "$PROFILE/smcs.exe")" "@$(w "$rsp")"
}

build_unityscript() {
  local name="$1"; shift
  local rsp="$RSP/$name.rsp"
  {
    echo "-target:library"; echo "-i:UnityEngine"; echo "-i:System.Collections"
    echo "-base:UnityEngine.MonoBehaviour"; echo "-nowarn:BCW0016"; echo "-nowarn:BCW0003"
    echo "-method:Main"; echo "-out:$(w "$OUT/$name.dll")"
    echo "-x-type-inference-rule-attribute:UnityEngineInternal.TypeInferenceRuleAttribute"
    echo "-debug"
    for d in "${DEFINES[@]}"; do echo "-define:$d"; done
    for r in "$@"; do echo "-r:\"$(w "$r")\""; done
    while IFS= read -r f; do echo "\"$(w "$f")\""; done < <(sources "$name" '*.js')
  } > "$rsp"
  "$MONO" "$(w "$PROFILE/us.exe")" "@$(w "$rsp")"
}

targets=("$@")
[ ${#targets[@]} -eq 0 ] && targets=(Assembly-CSharp-firstpass Assembly-UnityScript-firstpass Assembly-CSharp Assembly-UnityScript)

for t in "${targets[@]}"; do
  echo "=== $t"
  case "$t" in
    Assembly-CSharp-firstpass)
      build_csharp "$t" "$UNITYENGINE" ;;
    Assembly-UnityScript-firstpass)
      build_unityscript "$t" "$UNITYENGINE" ;;
    Assembly-CSharp)
      build_csharp "$t" "$UNITYENGINE" "$(sib Assembly-CSharp-firstpass)" \
        "$(sib Assembly-UnityScript-firstpass)" \
        "$GAME_MANAGED/ProBuilderCore.dll" "$GAME_MANAGED/SixBySeven.dll" ;;
    Assembly-UnityScript)
      build_unityscript "$t" "$UNITYENGINE" "$(sib Assembly-CSharp-firstpass)" \
        "$(sib Assembly-UnityScript-firstpass)" \
        "$GAME_MANAGED/ProBuilderCore.dll" "$GAME_MANAGED/SixBySeven.dll" ;;
    *) echo "unknown assembly $t" >&2; exit 2 ;;
  esac
done
