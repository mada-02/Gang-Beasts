"""Searches source orders of `@script` class attributes in UnityScript files so that Mono's
unstable CustomAttribute sort reproduces the shipped attribute order.

    attrsearch_js.py <Assembly>

Greedy: for each type whose attribute order differs, try every permutation of the
@script lines of its file; keep the first one that lowers the number of mismatching types."""
import itertools, pathlib, subprocess, sys

asm = sys.argv[1]
root = pathlib.Path(__file__).resolve().parent.parent
orig = root.parent / 'gang_beasts_0_0_3_windows' / 'Gang Beasts_Data' / 'Managed' / f'{asm}.dll'
ildiff = str(root / 'tools' / 'bin' / 'ildiff' / 'ildiff.exe')
files = {}
for line in open(root / 'layout' / f'{asm}.map', encoding='utf-8'):
    line = line.strip()
    if line and not line.startswith('#'):
        path, types = line.rsplit('.js:', 1)
        for t in types.split():
            files[t] = root / 'src' / asm / (path + '.js')


def status():
    r = subprocess.run(['bash', 'tools/build.sh', asm], cwd=root, capture_output=True, text=True)
    if r.returncode:
        sys.exit(r.stdout[-2000:])
    out = subprocess.run([ildiff, 'diff', str(orig), str(root / 'build' / 'out' / f'{asm}.dll')], capture_output=True, text=True).stdout
    return [l.split()[1] for l in out.splitlines() if l.startswith('ATTRIBUTES')]


bad = status()
print('start:', len(bad), bad, flush=True)
progress = True
while bad and progress:
    progress = False
    for t in list(bad):
        p = files[t]
        text = p.read_text(encoding='utf-8')
        lines = text.split('\n')
        idx = [i for i, l in enumerate(lines) if l.startswith('@script ')]
        if len(idx) < 2:
            continue
        original = [lines[i] for i in idx]
        for perm in itertools.permutations(original):
            if list(perm) == original:
                continue
            for i, a in zip(idx, perm):
                lines[i] = a
            p.write_text('\n'.join(lines), encoding='utf-8', newline='\n')
            now = status()
            if len(now) < len(bad):
                print(f'  {t}: {len(bad)} -> {len(now)}', flush=True)
                bad = now
                progress = True
                break
        else:
            for i, a in zip(idx, original):
                lines[i] = a
            p.write_text('\n'.join(lines), encoding='utf-8', newline='\n')
        if progress:
            break
status()
print('final:', len(bad), bad)
