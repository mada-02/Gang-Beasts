"""Ensure every source file that contains non-ASCII bytes starts with a UTF-8 BOM
(Mono 2.x smcs/us.exe otherwise read sources in the system code page)."""
import sys, pathlib
for root in sys.argv[1:]:
    for p in pathlib.Path(root).rglob('*'):
        if p.suffix not in ('.cs', '.js') or not p.is_file():
            continue
        b = p.read_bytes()
        if not b.startswith(b'\xef\xbb\xbf') and any(c > 0x7f for c in b):
            p.write_bytes(b'\xef\xbb\xbf' + b)
            print('BOM added:', p)
