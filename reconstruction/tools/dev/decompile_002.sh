#!/usr/bin/env bash
# Decompiles the shipped Gang Beasts 0.0.2 script assemblies (read-only input) into
# reconstruction/decompiled_002/<Assembly>/ with the same ilspycmd settings the 0.0.3 work used.
# Reference material for Hard Mode only; the folder is git-ignored.
#
# Usage: tools/dev/decompile_002.sh   (env: GB002 = the 0.0.2 game folder, ILSPY = ilspycmd.dll)
set -euo pipefail

HERE="$(cd "$(dirname "$0")/../.." && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
GB002="${GB002:-$(cd "$ROOT/.." && pwd)/gang_beasts_0_0_2_windows}"
ILSPY="${ILSPY:-$USERPROFILE/.nuget/packages/ilspycmd/11.1.0.9782/tools/net10.0/any/ilspycmd.dll}"
MANAGED="$GB002/Gang Beasts_Data/Managed"
OUT="$HERE/decompiled_002"

for a in Assembly-CSharp Assembly-CSharp-firstpass Assembly-UnityScript Assembly-UnityScript-firstpass; do
  echo "=== $a"
  rm -rf "$OUT/$a"
  mkdir -p "$OUT/$a"
  dotnet "$(cygpath -w "$ILSPY")" -p -o "$(cygpath -w "$OUT/$a")" -lv CSharp3 -ds SparseIntegerSwitch=false \
    -r "$(cygpath -w "$MANAGED")" "$(cygpath -w "$MANAGED/$a.dll")" >/dev/null
  find "$OUT/$a" -name '*.cs' | wc -l
done
