"""usfix: compiler-judged search for UnityScript source details.

    usfix.py <Assembly-Name> [max-passes]

UnityScript (us.exe/Boo) keeps literal forms in IL (`2` -> ldc.i4.2; conv.r4, `2.0`
-> ldc.r4 2) and compiles implicit truthiness (`if (!x)`) differently from explicit
null tests, details ILSpy's C# loses. For each method whose IL (tokens resolved)
differs from the original, usfix tries single-token rewrites inside that function's
body, compiles the candidates with Unity 4.3.2's us.exe (tools/build.sh, isolated
worker trees, in parallel), and keeps rewrites that bring that method's IL strictly
closer to the original. Independent improvements to one body are combined and the
combination is verified by a further compile.
"""
import os, re, subprocess, sys, pathlib, concurrent.futures as cf

ROOT = pathlib.Path(__file__).resolve().parent.parent
ASM = sys.argv[1]
PASSES = int(sys.argv[2]) if len(sys.argv) > 2 else 12
ORIG = ROOT.parent / 'gang_beasts_0_0_3_windows' / 'Gang Beasts_Data' / 'Managed' / f'{ASM}.dll'
ILDIFF = ROOT / 'tools' / 'bin' / 'ildiff' / 'ildiff.exe'
SRC = ROOT / 'src' / ASM
WORKERS = max(1, (os.cpu_count() or 4) - 2)
MAP = {}
for line in open(ROOT / 'layout' / f'{ASM}.map', encoding='utf-8'):
    line = line.strip()
    if not line or line.startswith('#'):
        continue
    path, types = line.rsplit('.js:', 1)
    MAP[path + '.js'] = types.split()


def read(p):
    raw = p.read_bytes()
    bom = raw.startswith(b'\xef\xbb\xbf')
    return raw[3 if bom else 0:].decode('utf-8'), bom


def write(p, text, bom):
    data = (b'\xef\xbb\xbf' if bom else b'') + text.encode('utf-8')
    p.parent.mkdir(parents=True, exist_ok=True)
    if not p.exists() or p.read_bytes() != data:
        p.write_bytes(data)


def measure(src_root=None, out_dir=None):
    env = dict(os.environ)
    if src_root:
        env['SRC_ROOT'] = str(src_root)
    if out_dir:
        env['OUT_DIR'] = str(out_dir)
    r = subprocess.run(['bash', 'tools/build.sh', ASM], cwd=ROOT, env=env, capture_output=True, text=True)
    out = pathlib.Path(out_dir or ROOT / 'build' / 'out') / f'{ASM}.dll'
    if r.returncode != 0 or re.search(r': (BCE|UCE)\d', r.stdout) or not out.exists():
        return None
    d = subprocess.run([str(ILDIFF), 'dist', str(ORIG), str(out)], capture_output=True, text=True).stdout
    res = {}
    for l in d.splitlines():
        n, k = l.split('\t', 1)
        res[k] = int(n)
    return res


FUNC = re.compile(r'^[ \t]*(?:(?:private|static|protected|public|final|override|virtual|internal)\s+)*function\s+(?:(get|set)\s+)?(\w+)\s*\(([^)]*)\)', re.M)


def bodies(text):
    """Yields (name, nparams, start, end) for every function body (start..end inclusive of braces)."""
    for m in FUNC.finditer(text):
        i = text.index('{', m.end())
        depth, j, in_str = 0, i, None
        while j < len(text):
            c = text[j]
            if in_str:
                if c == '\\':
                    j += 1
                elif c == in_str:
                    in_str = None
            elif c in '"\'':
                in_str = c
            elif c == '/' and text.startswith('//', j):
                j = text.index('\n', j)
                continue
            elif c == '{':
                depth += 1
            elif c == '}':
                depth -= 1
                if depth == 0:
                    break
            j += 1
        name = m.group(2)
        if m.group(1):
            name = m.group(1) + '_' + name
        params = [p for p in m.group(3).split(',') if p.strip()]
        yield name, len(params), i, j + 1


def site_for(key, index):
    t, rest = key.split('::', 1)
    name = rest[:rest.index('(')]
    params = rest[rest.index('(') + 1:rest.rindex(') : ')]
    nparams = 0 if not params.strip() else params.count(',') + 1 - params.count('<') * 0
    top = t.split('/')[0]
    leaf = t.split('/')[-1] if '/' in t else None
    if leaf and leaf.startswith('$'):
        # Boo generator types: "$Name$NN" (and its nested "$" enumerator) belong to Name.
        name = t.split('/')[1].split('$')[1]
        nparams = None
    cands = [s for s in index if top in s['types'] and s['name'] == name and (nparams is None or s['n'] == nparams)]
    return cands[0] if len(cands) == 1 else None


LIT_FLOAT = re.compile(r'(?<![\w.])(\d+)\.0(?![\d\w])')
LIT_INT = re.compile(r'(?<![\w.])(\d+)(?![\d.\w])')
NULLCMP = re.compile(r'([A-Za-z_][\w.]*(?:\[[^\]]*\])?) (==|!=) null\b')


def negate(cond):
    c = cond.strip()
    if c.startswith('(') and matching(c, 0) == len(c) - 1:
        inner = c[1:-1].strip()
    else:
        inner = c
    if inner.startswith('!') and (inner[1:].lstrip()[0] == '(' and matching(inner, inner.index('(')) == len(inner) - 1 or re.fullmatch(r'![\w.\[\]()]+', inner)):
        return inner[1:].strip()
    for a, b in ((' != ', ' == '), (' == ', ' != ')):
        if top_level(inner, a) and not top_level(inner, ' && ') and not top_level(inner, ' || '):
            return inner.replace(a, b, 1)
    return '!(' + inner + ')'


def matching(t, i):
    depth = 0
    for j in range(i, len(t)):
        if t[j] == '(':
            depth += 1
        elif t[j] == ')':
            depth -= 1
            if depth == 0:
                return j
    return -1


def top_level(t, op):
    depth = 0
    for j in range(len(t)):
        if t[j] == '(':
            depth += 1
        elif t[j] == ')':
            depth -= 1
        elif depth == 0 and t.startswith(op, j):
            return True
    return False


def ternaries(body):
    """Yields (start, end, flipped) for parenthesized ternaries "(c ? a : b)"."""
    for q in [m.start() for m in re.finditer(r' \? ', body)]:
        depth, s = 0, None
        for j in range(q, -1, -1):
            if body[j] == ')':
                depth += 1
            elif body[j] == '(':
                if depth == 0:
                    s = j
                    break
                depth -= 1
        if s is None:
            continue
        e = matching(body, s)
        seg = body[s + 1:e]
        qq = q - s - 1
        depth, c = 0, None
        for j in range(qq + 3, len(seg)):
            if seg[j] in '([':
                depth += 1
            elif seg[j] in ')]':
                depth -= 1
            elif depth == 0 and seg.startswith(' : ', j):
                c = j
                break
        if c is None:
            continue
        # Inside an argument list the ternary is bounded by top-level commas.
        lo = 0
        depth = 0
        for j in range(qq):
            if seg[j] in '([':
                depth += 1
            elif seg[j] in ')]':
                depth -= 1
            elif depth == 0 and seg[j] == ',':
                lo = j + 1
        hi = len(seg)
        depth = 0
        for j in range(c + 3, len(seg)):
            if seg[j] in '([':
                depth += 1
            elif seg[j] in ')]':
                depth -= 1
            elif depth == 0 and seg[j] == ',':
                hi = j
                break
        cond, a, b = seg[lo:qq], seg[qq + 3:c], seg[c + 3:hi]
        lead = len(cond) - len(cond.lstrip())
        if lo == 0 and hi == len(seg):
            yield s, e + 1, '(' + negate(cond) + ' ? ' + b + ' : ' + a + ')'
        else:
            yield s + 1 + lo + lead, s + 1 + hi, negate(cond) + ' ? ' + b.rstrip() + ' : ' + a


def candidates(body):
    out = []
    for s, e, t in ternaries(body):
        out.append((s, e, t, 'ternary flip'))
    for m in LIT_FLOAT.finditer(body):
        out.append((m.start(), m.end(), m.group(1), 'float->int literal'))
    for m in LIT_INT.finditer(body):
        out.append((m.start(), m.end(), m.group(1) + '.0', 'int->float literal'))
    for m in NULLCMP.finditer(body):
        expr, op = m.group(1), m.group(2)
        out.append((m.start(), m.end(), ('!' + expr) if op == '==' else expr, 'implicit truthiness'))
    return out


def apply(files, edits):
    """edits: {path: [(abs_start, abs_end, text)]} -> {path: new text}"""
    res = {}
    for p, (text, bom) in files.items():
        es = sorted(edits.get(p, []), reverse=True)
        for s, e, t in es:
            text = text[:s] + t + text[e:]
        res[p] = (text, bom)
    return res


def run_batch(w, files, batch):
    work = ROOT / 'build' / 'work' / f'us{w}'
    src = work / 'src' / ASM
    for p, (text, bom) in apply(files, batch).items():
        write(src / p.relative_to(SRC), text, bom)
    return measure(work / 'src', work / 'out')


def main():
    dist = measure()
    if dist is None:
        sys.exit('baseline build failed')
    print('baseline:', sum(1 for v in dist.values() if v), 'differing methods', flush=True)
    for npass in range(1, PASSES + 1):
        files = {p: read(p) for p in SRC.rglob('*.js')}
        index = []
        for p, (text, _) in files.items():
            rel = p.relative_to(SRC).as_posix()
            types = MAP.get(rel, [])
            for name, n, s, e in bodies(text):
                index.append({'path': p, 'types': types, 'name': name, 'n': n, 's': s, 'e': e})
        sites = {}
        for k, v in dist.items():
            if not v:
                continue
            st = site_for(k, index)
            if st is None:
                continue
            sid = (st['path'], st['s'])
            sites.setdefault(sid, {'site': st, 'keys': []})['keys'].append(k)
        cands = {}
        for sid, x in sites.items():
            st = x['site']
            body = files[st['path']][0][st['s']:st['e']]
            cands[sid] = [(st['path'], st['s'] + a, st['s'] + b, t, why) for a, b, t, why in candidates(body)]
        maxk = max((len(c) for c in cands.values()), default=0)
        print(f'pass {npass}: {len(sites)} bodies, {sum(len(c) for c in cands.values())} candidates (max {maxk})', flush=True)
        if not maxk:
            break
        jobs = []
        for k in range(maxk):
            batch = {}
            owners = []
            for sid, cl in cands.items():
                if k < len(cl):
                    p, s, e, t, why = cl[k]
                    batch.setdefault(p, []).append((s, e, t))
                    owners.append((sid, cl[k]))
            jobs.append((batch, owners))
        improvements = {}
        # Each worker owns one isolated tree and pulls jobs until the queue is empty.
        results = []
        queue = list(jobs)
        def worker(w):
            out = []
            while True:
                try:
                    b, o = queue.pop()
                except IndexError:
                    return out
                d = run_batch(w, files, b)
                if d is None and len(o) > 1:
                    # A candidate broke the build: bisect the batch so the others still get judged.
                    half = len(o) // 2
                    for part in (o[:half], o[half:]):
                        pb = {}
                        for sid, c in part:
                            pb.setdefault(c[0], []).append((c[1], c[2], c[3]))
                        queue.append((pb, part))
                    continue
                out.append((d, o))
        with cf.ThreadPoolExecutor(WORKERS) as ex:
            for r in ex.map(worker, range(WORKERS)):
                results.extend(r)
        for d, owners in results:
            if d is None:
                continue
            for sid, c in owners:
                keys = sites[sid]['keys']
                before = sum(dist[k] for k in keys)
                now = sum(d.get(k, 1000) for k in keys)
                if now < before:
                    improvements.setdefault(sid, []).append((before - now, c))
        if not improvements:
            break
        # Combine all improving, non-overlapping single edits per body; fall back to the best one.
        chosen = {}
        for sid, imps in improvements.items():
            imps.sort(key=lambda x: -x[0])
            taken = []
            for gain, c in imps:
                if all(c[2] <= t[1] or c[1] >= t[2] for t in taken):
                    taken.append(c)
            chosen[sid] = (taken, imps[0][1])
        edits = {}
        for sid, (taken, _) in chosen.items():
            for p, s, e, t, why in taken:
                edits.setdefault(p, []).append((s, e, t))
        new_files = apply(files, edits)
        for p, (text, bom) in new_files.items():
            write(p, text, bom)
        after = measure()
        if after is None or any(sum(after.get(k, 1000) for k in sites[sid]['keys']) >= sum(dist[k] for k in sites[sid]['keys']) for sid in chosen):
            # Some combination interfered: keep only the best single edit per body.
            edits = {}
            for sid, (_, best) in chosen.items():
                p, s, e, t, why = best
                edits.setdefault(p, []).append((s, e, t))
            for p, (text, bom) in apply(files, edits).items():
                write(p, text, bom)
            after = measure()
            if after is None:
                for p, (text, bom) in files.items():
                    write(p, text, bom)
                sys.exit('accepted edits do not build; reverted pass')
        for sid in chosen:
            ks = sites[sid]['keys']
            print(f"    + {ks[0]}  {sum(dist[k] for k in ks)} -> {sum(after.get(k, 1000) for k in ks)}", flush=True)
        dist = after
        print(f'pass {npass}: now', sum(1 for v in dist.values() if v), 'differing methods', flush=True)
    for k, v in sorted(dist.items()):
        if v:
            print(f'  remaining d={v:<4} {k}')


if __name__ == '__main__':
    main()
