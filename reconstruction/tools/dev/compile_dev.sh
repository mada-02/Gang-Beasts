#!/usr/bin/env bash
# Compiles the Unity project's Assembly-CSharp (game scripts + Assets/Dev) and Assembly-CSharp-Editor
# with Unity 4.3.2's own smcs and the flags tools/build.sh uses, without opening Unity. A fast check
# that the developer-branch code builds; Unity itself still does the real import.
#
# Usage: tools/dev/compile_dev.sh            (output in dev/out/compile/)
set -euo pipefail

HERE="$(cd "$(dirname "$0")/../.." && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
UNITY_DATA="${UNITY_DATA:-$(cd "$ROOT/.." && pwd)/UnitySetup-4.3.2/Data}"
MONO="$UNITY_DATA/Mono/bin/mono.exe"
PROFILE="$UNITY_DATA/Mono/lib/mono/unity"
ASSETS="$HERE/GangBeasts/Assets"
LIB="$HERE/GangBeasts/Library/ScriptAssemblies"
OUT="$HERE/dev/out/compile"
mkdir -p "$OUT"

export MONO_PATH="$(cygpath -w "$PROFILE")"
export MONO_CFG_DIR="$(cygpath -w "$UNITY_DATA/Mono/etc")"

DEFINES=(UNITY_4_3_2 UNITY_4_3 UNITY_STANDALONE_WIN UNITY_STANDALONE ENABLE_MICROPHONE
  ENABLE_TEXTUREID_MAP ENABLE_AUDIO_FMOD ENABLE_GENERICS ENABLE_DUCK_TYPING ENABLE_TERRAIN
  ENABLE_MOVIES ENABLE_WWW ENABLE_IMAGEEFFECTS ENABLE_WEBCAM ENABLE_NETWORK ENABLE_PHYSICS
  ENABLE_CLOTH ENABLE_2D_PHYSICS ENABLE_SHADOWS ENABLE_AUDIO ENABLE_NAVMESH_CARVING
  ENABLE_SPRITES ENABLE_SINGLE_INSTANCE_BUILD_SETTING ENABLE_PROFILER ENABLE_MONO)

w() { cygpath -w "$1"; }

# Unity's split: Plugins/, Standard Assets/ and Pro Standard Assets/ go to the firstpass assemblies,
# any folder named Editor to the editor assemblies, everything else to Assembly-CSharp.
runtime_sources() {
  find "$ASSETS" -type f -name '*.cs' \
    -not -path "$ASSETS/Plugins/*" -not -path "$ASSETS/Standard Assets/*" -not -path "$ASSETS/Pro Standard Assets/*" \
    -not -path '*/Editor/*' | LC_ALL=C sort
}
editor_sources() {
  find "$ASSETS" -type f -name '*.cs' -path '*/Editor/*' \
    -not -path "$ASSETS/Plugins/*" -not -path "$ASSETS/Standard Assets/*" -not -path "$ASSETS/Pro Standard Assets/*" | LC_ALL=C sort
}

compile() {
  local name="$1" list="$2"; shift 2
  local rsp="$OUT/$name.rsp"
  {
    echo "-debug"; echo "-target:library"; echo "-nowarn:0169"
    echo "-out:\"$(w "$OUT/$name.dll")\""
    for r in "$@"; do echo "-r:\"$(w "$r")\""; done
    for d in "${DEFINES[@]}"; do echo "-define:$d"; done
    while IFS= read -r f; do echo "\"$(w "$f")\""; done < "$list"
    for extra in System.Runtime.Serialization.dll System.Xml.Linq.dll; do
      echo "-r:\"$(w "$PROFILE/$extra")\""
    done
  } > "$rsp"
  echo "=== $name ($(wc -l < "$list") files)"
  "$MONO" "$(w "$PROFILE/smcs.exe")" "@$(w "$rsp")"
}

runtime_sources > "$OUT/runtime.txt"
compile Assembly-CSharp "$OUT/runtime.txt" "$UNITY_DATA/Managed/UnityEngine.dll" \
  "$LIB/Assembly-CSharp-firstpass.dll" "$LIB/Assembly-UnityScript-firstpass.dll" \
  "$ASSETS/Plugins/ProBuilderCore.dll" "$ASSETS/Plugins/SixBySeven.dll"

editor_sources > "$OUT/editor.txt"
if [ -s "$OUT/editor.txt" ]; then
  compile Assembly-CSharp-Editor "$OUT/editor.txt" "$UNITY_DATA/Managed/UnityEngine.dll" \
    "$UNITY_DATA/Managed/UnityEditor.dll" "$OUT/Assembly-CSharp.dll" \
    "$LIB/Assembly-CSharp-firstpass.dll" "$LIB/Assembly-UnityScript-firstpass.dll" \
    "$ASSETS/Plugins/ProBuilderCore.dll" "$ASSETS/Plugins/SixBySeven.dll"
fi
echo "OK"
