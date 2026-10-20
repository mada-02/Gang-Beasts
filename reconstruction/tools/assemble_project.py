"""Assembles the reconstructed Unity 4.3.2 project.

    assemble_project.py <out-dir>

Inputs
  export/ExportedProject   AssetRipper 2.0.0 export of the shipped build (scenes, prefabs,
                           assets, settings; its decompiled scripts are discarded)
  src/<Assembly>/...       the proven script sources, at their layout-map paths
  layout/<Assembly>.map    path -> declared types
  ../gang_beasts_0_0_3_windows/.../Managed/{ProBuilderCore,SixBySeven}.dll
                           shipped third-party plugin assemblies, copied verbatim

Script identity: a scene/prefab references a script as {fileID: 11500000, guid: G}. Each
reconstructed source file receives the GUID AssetRipper assigned to the MonoBehaviour /
ScriptableObject class it is named after, so every reference resolves to the proven
source. Classes that live in the plugin DLLs are referenced the way Unity references
classes inside assemblies: {fileID: FileID(namespace, name), guid: <dll guid>}.
"""
import hashlib, json, pathlib, re, shutil, struct, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
EXPORT = ROOT / 'export' / 'ExportedProject'
MANAGED = ROOT.parent / 'gang_beasts_0_0_3_windows' / 'Gang Beasts_Data' / 'Managed'
OUT = pathlib.Path(sys.argv[1]).resolve()
ASSEMBLIES = ['Assembly-CSharp-firstpass', 'Assembly-UnityScript-firstpass', 'Assembly-CSharp', 'Assembly-UnityScript']
PLUGINS = ['ProBuilderCore', 'SixBySeven']


# ---- Unity FileID for a class inside an assembly: MD4("s\0\0\0" + namespace + name)[0:4] ----
def md4(data):
    def f(x, y, z): return (x & y) | (~x & z)
    def g(x, y, z): return (x & y) | (x & z) | (y & z)
    def h(x, y, z): return x ^ y ^ z
    def rol(v, s): return ((v << s) | (v >> (32 - s))) & 0xffffffff
    msg = bytearray(data)
    ml = (8 * len(data)) & 0xffffffffffffffff
    msg.append(0x80)
    while len(msg) % 64 != 56:
        msg.append(0)
    msg += struct.pack('<Q', ml)
    a, b, c, d = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
    for off in range(0, len(msg), 64):
        X = list(struct.unpack('<16I', msg[off:off + 64]))
        aa, bb, cc, dd = a, b, c, d
        for i in range(16):
            k = i
            s = [3, 7, 11, 19][i % 4]
            if i % 4 == 0: a = rol((a + f(b, c, d) + X[k]) & 0xffffffff, s)
            elif i % 4 == 1: d = rol((d + f(a, b, c) + X[k]) & 0xffffffff, s)
            elif i % 4 == 2: c = rol((c + f(d, a, b) + X[k]) & 0xffffffff, s)
            else: b = rol((b + f(c, d, a) + X[k]) & 0xffffffff, s)
        for i in range(16):
            k = (i % 4) * 4 + i // 4
            s = [3, 5, 9, 13][i % 4]
            if i % 4 == 0: a = rol((a + g(b, c, d) + X[k] + 0x5a827999) & 0xffffffff, s)
            elif i % 4 == 1: d = rol((d + g(a, b, c) + X[k] + 0x5a827999) & 0xffffffff, s)
            elif i % 4 == 2: c = rol((c + g(d, a, b) + X[k] + 0x5a827999) & 0xffffffff, s)
            else: b = rol((b + g(c, d, a) + X[k] + 0x5a827999) & 0xffffffff, s)
        order = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]
        for i in range(16):
            k = order[i]
            s = [3, 9, 11, 15][i % 4]
            if i % 4 == 0: a = rol((a + h(b, c, d) + X[k] + 0x6ed9eba1) & 0xffffffff, s)
            elif i % 4 == 1: d = rol((d + h(a, b, c) + X[k] + 0x6ed9eba1) & 0xffffffff, s)
            elif i % 4 == 2: c = rol((c + h(d, a, b) + X[k] + 0x6ed9eba1) & 0xffffffff, s)
            else: b = rol((b + h(c, d, a) + X[k] + 0x6ed9eba1) & 0xffffffff, s)
        a, b, c, d = (a + aa) & 0xffffffff, (b + bb) & 0xffffffff, (c + cc) & 0xffffffff, (d + dd) & 0xffffffff
    return struct.pack('<4I', a, b, c, d)


assert md4(b'abc').hex() == 'a448017aaf21d8525fc10ae87aa6729d'


def file_id(namespace, name):
    return struct.unpack('<i', md4(b's\0\0\0' + (namespace + name).encode('utf-8'))[:4])[0]


def meta_guid(meta_path):
    m = re.search(r'^guid: ([0-9a-f]{32})', meta_path.read_text(encoding='utf-8'), re.M)
    return m.group(1) if m else None


def stable_guid(text):
    return hashlib.md5(('gang-beasts-0.0.3/' + text).encode('utf-8')).hexdigest()


def script_meta(guid):
    return ('fileFormatVersion: 2\nguid: ' + guid + '\nMonoImporter:\n  serializedVersion: 2\n'
            '  defaultReferences: []\n  executionOrder: 0\n  icon: {instanceID: 0}\n  userData: \n')


def dll_meta(guid):
    return 'fileFormatVersion: 2\nguid: ' + guid + '\nMonoAssemblyImporter:\n  serializedVersion: 1\n  iconMap: {}\n  executionOrder: {}\n  userData: \n'


def declared_classes(path):
    """(namespace, class) pairs declared at the top level of an exported C# file."""
    text = path.read_text(encoding='utf-8', errors='replace')
    ns = re.search(r'^namespace ([\w.]+)', text, re.M)
    names = re.findall(r'^\s*(?:public |internal |sealed |abstract |static |partial )*(?:class|struct) (\w+)', text, re.M)
    return [(ns.group(1) if ns else '', n) for n in names[:1]]


def main():
    if OUT.exists():
        sys.exit(f'{OUT} exists; refusing to overwrite')
    # 1. AssetRipper's script GUIDs, keyed by (assembly, namespace, class).
    ar_scripts = {}
    for meta in list((EXPORT / 'Assets' / 'Scripts').rglob('*.cs.meta')) + list((EXPORT / 'Assets' / 'Plugins').rglob('*.cs.meta')):
        src = meta.with_suffix('')
        rel = src.relative_to(EXPORT / 'Assets').parts
        asm = rel[1]
        for ns, cls in declared_classes(src):
            ar_scripts[(asm, ns, cls)] = meta_guid(meta)

    # 2. Copy every exported asset except AssetRipper's script trees.
    skip = {EXPORT / 'Assets' / 'Scripts', EXPORT / 'Assets' / 'Plugins'}
    def ignore(d, names):
        return [n for n in names if pathlib.Path(d, n) in skip]
    shutil.copytree(EXPORT, OUT, ignore=ignore)

    # 3. Reconstructed sources with GUIDs matched by class.
    report = {'scripts': [], 'plugin_classes': []}
    used = {}
    for asm in ASSEMBLIES:
        for line in open(ROOT / 'layout' / f'{asm}.map', encoding='utf-8'):
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            ext = '.js' if asm.startswith('Assembly-UnityScript') else '.cs'
            path, types = line.rsplit(ext + ':', 1)
            path += ext
            src = ROOT / 'src' / asm / path
            dst = OUT / 'Assets' / path
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)
            stem = pathlib.Path(path).stem
            guid = None
            for t in types.split():
                ns, _, cls = t.rpartition('.')
                cls = cls.split('`')[0]
                if cls == stem and (asm, ns, cls) in ar_scripts:
                    guid = ar_scripts[(asm, ns, cls)]
            origin = 'assetripper-class-guid' if guid else 'stable-path-guid'
            guid = guid or stable_guid(path)
            assert guid not in used, f'duplicate guid {guid} for {path} and {used[guid]}'
            used[guid] = path
            (dst.parent / (dst.name + '.meta')).write_text(script_meta(guid), encoding='utf-8', newline='\n')
            report['scripts'].append({'assembly': asm, 'path': 'Assets/' + path, 'guid': guid, 'guid_origin': origin})

    # 4. Plugin DLLs, verbatim, and remapping of references to their classes.
    remap = {}
    for plugin in PLUGINS:
        dst = OUT / 'Assets' / 'Plugins' / f'{plugin}.dll'
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(MANAGED / f'{plugin}.dll', dst)
        dguid = stable_guid('Assets/Plugins/' + plugin + '.dll')
        (dst.parent / (dst.name + '.meta')).write_text(dll_meta(dguid), encoding='utf-8', newline='\n')
        for (asm, ns, cls), g in ar_scripts.items():
            if asm == plugin:
                remap[g] = (file_id(ns, cls), dguid)
                report['plugin_classes'].append({'plugin': plugin, 'class': (ns + '.' if ns else '') + cls, 'fileID': file_id(ns, cls), 'guid': dguid})
    pat = re.compile(r'\{fileID: 11500000, guid: ([0-9a-f]{32}), type: 3\}')
    rewritten = 0
    for p in OUT.joinpath('Assets').rglob('*'):
        if p.suffix not in ('.unity', '.prefab', '.asset', '.mat', '.controller', '.anim') or not p.is_file():
            continue
        t = p.read_text(encoding='utf-8', errors='surrogateescape')
        def sub(m):
            g = m.group(1)
            if g in remap:
                fid, dg = remap[g]
                return '{fileID: %d, guid: %s, type: 3}' % (fid, dg)
            return m.group(0)
        n = pat.sub(sub, t)
        if n != t:
            p.write_text(n, encoding='utf-8', errors='surrogateescape', newline='\n')
            rewritten += 1
    # 4b. AnimatorControllers as Unity 4.3 expects them (states embedded; see fix_controllers.py).
    subprocess.run([sys.executable, '-I', str(ROOT / 'tools' / 'fix_controllers.py'), str(OUT)], check=True)
    # Real shaders instead of AssetRipper placeholders (see fix_shaders.py).
    subprocess.run([sys.executable, '-I', str(ROOT / 'tools' / 'fix_shaders.py'), str(OUT)], check=True)

    # 5. Every script reference must resolve.
    known = set(used) | {dg for _, dg in remap.values()}
    unresolved = {}
    for p in OUT.joinpath('Assets').rglob('*'):
        if p.suffix not in ('.unity', '.prefab', '.asset') or not p.is_file():
            continue
        for g in re.findall(r'm_Script: \{fileID: -?\d+, guid: ([0-9a-f]{32}), type: 3\}', p.read_text(encoding='utf-8', errors='replace')):
            if g not in known:
                unresolved.setdefault(g, set()).add(str(p.relative_to(OUT)))
    report['files_with_plugin_references_rewritten'] = rewritten
    report['unresolved_script_references'] = {g: sorted(v) for g, v in unresolved.items()}
    (OUT / 'RECONSTRUCTION-SCRIPTS.json').write_text(json.dumps(report, indent=1), encoding='utf-8')
    print(f"scripts: {len(report['scripts'])}, plugin classes: {len(report['plugin_classes'])}, "
          f"files rewritten: {rewritten}, unresolved references: {len(unresolved)}")


if __name__ == '__main__':
    main()
