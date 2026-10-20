"""unguard.py FILE GUARD_CONDITION NEW_CONDITION

Rewrites the first `if (GUARD_CONDITION) {\n<ind>\treturn;\n<ind>}` in FILE so that the
rest of the enclosing block runs inside `if (NEW_CONDITION) { ... }` instead (the shape
Boo/mcs emit as a single forward branch rather than an early return). Only applied where
the original IL shows that shape."""
import re, sys

path, guard, newcond = sys.argv[1], sys.argv[2], sys.argv[3]
raw = open(path, 'rb').read()
bom = raw.startswith(b'\xef\xbb\xbf')
s = raw[3 if bom else 0:].decode('utf-8')
m = re.search(r'^(\t*)if \(' + re.escape(guard) + r'\) \{\n\1\treturn;\n\1\}\n', s, re.M)
if not m:
    sys.exit('guard not found')
ind = m.group(1)
close = re.compile('^' + ind[:-1] + r'\}\n', re.M).search(s, m.end())
rest = s[m.end():close.start()].rstrip('\n')
rest = '\n'.join(('\t' + l if l.strip() else l) for l in rest.split('\n'))
s = s[:m.start()] + f'{ind}if ({newcond}) {{\n{rest}\n{ind}}}\n' + s[close.start():]
open(path, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + s.encode('utf-8'))
