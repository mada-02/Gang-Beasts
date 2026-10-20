"""rep.py FILE  -- reads replacement pairs from stdin separated by lines '@@@' (old) / '===' (new) / '@@@' ...
Format:  <<<\nOLD\n===\nNEW\n>>>  repeated. Each OLD must occur exactly once."""
import sys
p = sys.argv[1]
raw = open(p, 'rb').read()
bom = raw.startswith(b'\xef\xbb\xbf')
s = raw[3:].decode('utf-8') if bom else raw.decode('utf-8')
spec = sys.stdin.read()
blocks = spec.split('<<<\n')[1:]
for b in blocks:
    old, rest = b.split('\n===\n', 1)
    new = rest.rsplit('\n>>>', 1)[0]
    n = s.count(old)
    if n != 1:
        sys.exit(f'{p}: expected 1 occurrence, found {n}:\n{old}')
    s = s.replace(old, new)
open(p, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + s.encode('utf-8'))
