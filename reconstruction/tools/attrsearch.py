"""Greedy search over source attribute order so Mono's (unstable) CustomAttribute sort
reproduces the shipped attribute order. Usage: attrsearch.py <Assembly>"""
import subprocess, sys, re, pathlib
asm = sys.argv[1]
root = pathlib.Path(__file__).resolve().parent.parent
orig = root.parent / 'gang_beasts_0_0_3_windows' / 'Gang Beasts_Data' / 'Managed' / f'{asm}.dll'
ildiff = root / 'tools' / 'bin' / 'ildiff' / 'ildiff.exe'

def status():
    r = subprocess.run(['bash', 'tools/build.sh', asm], cwd=root, capture_output=True, text=True)
    if r.returncode: sys.exit('build failed:\n' + r.stdout[-3000:])
    out = subprocess.run([str(ildiff), 'diff', str(orig), str(root / 'build' / 'out' / f'{asm}.dll')], capture_output=True, text=True).stdout
    return [l.split()[1] for l in out.splitlines() if l.startswith('ATTRIBUTES')], out

def find_decl(type_name):
    simple = type_name.split('.')[-1].split('/')[-1]
    pat = re.compile(r'^(\t*)(?:public |internal |private |protected |sealed |abstract |static |partial )*(?:class|struct|interface|enum) ' + re.escape(simple) + r'\b', re.M)
    for p in (root / 'src' / asm).rglob('*.cs'):
        raw = p.read_bytes(); bom = raw.startswith(b'\xef\xbb\xbf'); s = raw[3 if bom else 0:].decode()
        m = pat.search(s)
        if m: return p, bom, s, m
    return None

def toggle(type_name):
    p, bom, s, m = find_decl(type_name)
    lines = s[:m.start()].split('\n')
    attrs = []
    while lines and len(lines) >= 2 and lines[-2].strip().startswith('['):
        attrs.insert(0, lines.pop(-2))
    if len(attrs) < 2: return False
    # rotate: try the next permutation in a fixed cycle
    attrs = attrs[1:] + attrs[:1]
    lines[-1:-1] = attrs
    s = '\n'.join(lines) + s[m.start():]
    p.write_bytes((b'\xef\xbb\xbf' if bom else b'') + s.encode())
    return True

bad, _ = status()
print('start:', len(bad), bad)
improved = True
while bad and improved:
    improved = False
    for t in list(bad):
        n_attrs = None
        for attempt in range(5):
            if not toggle(t): break
            now, _ = status()
            if len(now) < len(bad):
                print(f'  {t}: {len(bad)} -> {len(now)}'); bad = now; improved = True; break
        else:
            pass
        if improved: break
print('final:', len(bad), bad)
