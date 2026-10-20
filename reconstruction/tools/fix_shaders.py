"""Replaces AssetRipper's placeholder shaders with the build's real shaders.

    fix_shaders.py <project-dir>

AssetRipper 2.0 cannot decompile this build's shader programs, so it writes
"//DummyShaderTextExporter" surface shaders that only sample _MainTex (breaking every
image effect, Marmoset IBL material, glow, transparency, ...). But a Unity 4.3 player
stores each shader's complete *compiled ShaderLab* text (properties, passes and the
opengl/d3d9/d3d11 programs) in Shader.m_Script, and the Unity 4.3 editor imports that text
as a normal .shader. export/ShaderText holds that text for every shader in the build
(dumped from the AssetRipper session; see index.json).

For each placeholder in the project (matched by its `Shader "Name"` line):
  * a Unity built-in shader (name in Unity 4.3.2's Data/Resources/unity_builtin_extra) is
    removed and every reference to it is pointed at the built-in, the way the original
    project referenced it: {fileID: <id>, guid: 0000000000000000f000000000000000, type: 0};
  * any other shader gets the build's original compiled text.
"""
import json, pathlib, re, struct, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
proj = pathlib.Path(sys.argv[1]).resolve()
assets = proj / 'Assets'
BUILTIN_GUID = '0000000000000000f000000000000000'


def builtin_shader_ids():
    d = (ROOT.parent / 'UnitySetup-4.3.2' / 'Data' / 'Resources' / 'unity_builtin_extra').read_bytes()
    ms, fs, ver, do = struct.unpack_from('>IIII', d, 0)
    e = '>' if d[16] else '<'
    ids = {}
    for off in range(20, 20 + ms - 20):
        pid, start, size, tid, cid, dead = struct.unpack_from(e + 'iIIihh', d, off)
        if cid == 48 and dead == 0 and 0 < size < 5_000_000 and do + start + size <= len(d) and 0 < pid < 1_000_000:
            m = re.search(rb'Shader\s+"([^"]+)"', d[do + start:do + start + size])
            if m:
                ids.setdefault(m.group(1).decode(), pid)
    return ids


def shader_name(text):
    m = re.match(r'\s*Shader\s+"([^"]+)"', text)
    return m.group(1) if m else None


builtins = builtin_shader_ids()
originals = {}
for entry in json.loads((ROOT / 'export' / 'ShaderText' / 'index.json').read_text(encoding='utf-8')):
    originals.setdefault(entry['shader'], []).append(ROOT / 'export' / 'ShaderText' / entry['file'])

remap = {}
replaced = removed = 0
unmatched = []
for sh in sorted(assets.rglob('*.shader')):
    text = sh.read_text(encoding='utf-8', errors='replace')
    if '//DummyShaderTextExporter' not in text:
        continue
    name = shader_name(text)
    meta = sh.parent / (sh.name + '.meta')
    guid = re.search(r'^guid: ([0-9a-f]{32})', meta.read_text(encoding='utf-8'), re.M).group(1)
    if name in builtins:
        remap[guid] = builtins[name]
        sh.unlink(); meta.unlink(); removed += 1
        print(f'built-in  {name:55} -> fileID {builtins[name]}')
        continue
    cands = originals.get(name, [])
    if not cands:
        unmatched.append(name); continue
    # identical duplicates are common; otherwise prefer the one with the same Properties block
    props = re.search(r'Properties \{(.*?)\n\}', text, re.S)
    best = cands[0]
    for c in cands:
        ct = c.read_text(encoding='utf-8')
        if props and props.group(1) in ct:
            best = c; break
    sh.write_text(best.read_text(encoding='utf-8'), encoding='utf-8', newline='\n')
    replaced += 1
    print(f'original  {name:55} <- {best.name}')

pat = re.compile(r'\{fileID: 4800000, guid: ([0-9a-f]{32}), type: 3\}')
touched = 0
for p in assets.rglob('*'):
    if p.suffix not in ('.mat', '.unity', '.prefab', '.asset') or not p.is_file():
        continue
    t = p.read_text(encoding='utf-8', errors='surrogateescape')
    n = pat.sub(lambda m: '{fileID: %d, guid: %s, type: 0}' % (remap[m.group(1)], BUILTIN_GUID) if m.group(1) in remap else m.group(0), t)
    if n != t:
        p.write_text(n, encoding='utf-8', errors='surrogateescape', newline='\n'); touched += 1
print(f'{replaced} shaders restored from the build, {removed} remapped to built-ins ({touched} files updated); unmatched: {unmatched}')
