#!/usr/bin/env bash
# Compact IL diff (original vs rebuilt): tools/cmp.sh <Assembly> <TypeFilter> <Method> [context]
HERE="$(cd "$(dirname "$0")/.." && pwd)"
O="$HERE/../gang_beasts_0_0_3_windows/Gang Beasts_Data/Managed/$1.dll"
D="$HERE/tools/bin/ildiff/ildiff.exe"
norm() { python -I -c "
import sys,re
lines=[l.rstrip('\n') for l in sys.stdin]
idx={}
n=0
for l in lines:
    m=re.match(r'\s*IL_([0-9a-f]{4}):',l)
    if m: idx[m.group(1)]=n; n+=1
for l in lines:
    l=re.sub(r'token=.*','',l)
    l=re.sub(r'^\s*IL_[0-9a-f]{4}: ','  ',l)
    l=re.sub(r'IL_([0-9a-f]{4})',lambda m:'L%d'%idx.get(m.group(1),-1),l)
    print(l)
"; }
diff -U${4:-3} <("$D" il "$O" "$2" "$3" | norm) <("$D" il "$HERE/build/out/$1.dll" "$2" "$3" | norm) | tail -n +3
