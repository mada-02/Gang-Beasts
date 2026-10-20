"""Remove trailing whitespace and collapse blank-line runs in source files (no IL effect)."""
import sys, pathlib, re
for root in sys.argv[1:]:
    for p in pathlib.Path(root).rglob('*'):
        if p.suffix not in ('.cs', '.js') or not p.is_file():
            continue
        raw = p.read_bytes(); bom = raw.startswith(b'\xef\xbb\xbf')
        s = raw[3 if bom else 0:].decode('utf-8')
        t = re.sub(r'[ \t]+\n', '\n', s)
        t = re.sub(r'\n{3,}', '\n\n', t)
        # a blank line directly after an opening brace or before a closing brace is never wanted
        t = re.sub(r'\{\n\n', '{\n', t)
        t = re.sub(r'\n\n(\t*\})', r'\n\1', t)
        if t != s:
            p.write_bytes((b'\xef\xbb\xbf' if bom else b'') + t.encode('utf-8'))
