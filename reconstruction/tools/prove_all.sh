#!/usr/bin/env bash
# End-to-end proof: clean-build all four script assemblies from src/ with Unity 4.3.2's
# compilers, then for each assembly
#   1. tools/verify.py   byte comparison with the shipped DLL (only TimeDateStamp + MVID may differ)
#   2. ildiff diff       per-method IL / layout / attribute comparison (tokens resolved)
#   3. REA               compare-managed-members (independent managed-member comparison)
# Results go to proof/. Exit status 0 only if every assembly passes step 1.
set -uo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$HERE"
SHIPPED="$HERE/../gang_beasts_0_0_3_windows/Gang Beasts_Data/Managed"
mkdir -p proof
rm -rf build/out
status=0
summary="proof/SUMMARY.txt"
{
  echo "Gang Beasts 0.0.3 script reconstruction proof — $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "Compilers: Unity 4.3.2 (Data/Mono/lib/mono/unity/smcs.exe, us.exe) via tools/build.sh"
  echo
} > "$summary"
for asm in Assembly-CSharp-firstpass Assembly-UnityScript-firstpass Assembly-CSharp Assembly-UnityScript; do
  if ! bash tools/build.sh "$asm" > "proof/build-$asm.log" 2>&1; then
    echo "$asm: BUILD FAILED (see proof/build-$asm.log)" | tee -a "$summary"; status=1; continue
  fi
  v=$(python -I tools/verify.py "$SHIPPED/$asm.dll" "build/out/$asm.dll")
  [[ "$v" == PASS* ]] || status=1
  tools/bin/ildiff/ildiff.exe diff "$SHIPPED/$asm.dll" "build/out/$asm.dll" > "proof/ildiff-$asm.txt"
  il=$(grep '^SUMMARY' "proof/ildiff-$asm.txt")
  sha_o=$(sha256sum "$SHIPPED/$asm.dll" | cut -d' ' -f1); sha_r=$(sha256sum "build/out/$asm.dll" | cut -d' ' -f1)
  rea="skipped"
  if timeout 600 npx -y rea-agents@6.7.0 compare-managed-members "$(cygpath -w "$SHIPPED/$asm.dll")" "$(cygpath -w "build/out/$asm.dll")" --format json > "proof/rea-$asm.json" 2>/dev/null; then
    rea=$(python -I -c "import json,sys; d=json.load(open(sys.argv[1])); n=d['normalized_result']; print(d['evidence_id'], n['summary'])" "proof/rea-$asm.json")
  fi
  {
    echo "== $asm"
    echo "   shipped  sha256 $sha_o"
    echo "   rebuilt  sha256 $sha_r"
    echo "   bytes    $v"
    echo "   ildiff   $il"
    echo "   REA      $rea"
  } | tee -a "$summary"
done
exit $status
