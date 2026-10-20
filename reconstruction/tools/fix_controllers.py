"""Rewrites AssetRipper-reconstructed AnimatorControllers into Unity 4.3's editor layout.

    fix_controllers.py <project-dir>

AssetRipper 2.0 emits, for this 4.3.2 build, a controller whose Base Layer StateMachine has
no states (m_States: []) and m_MotionSetCount 0, with m_DefaultState pointing at a separate
.state asset whose m_ParentStateMachine is null. Unity 4.3 builds a runtime controller from
that and crashes in mecanim::animation::EvaluateAvatarSM on the first frame of play mode.
Unity 4.3 itself stores a controller's states and state machines as sub-assets of the
.controller file; this script embeds each referenced State there (keeping its motions,
speed, etc.), lists it in m_States, parents it, sets m_MotionSetCount to 1 and removes the
now-unreferenced standalone .state file.
"""
import pathlib, re, sys

proj = pathlib.Path(sys.argv[1])
assets = proj / 'Assets'
states = {}
for meta in assets.rglob('*.state.meta'):
    guid = re.search(r'^guid: ([0-9a-f]{32})', meta.read_text(encoding='utf-8'), re.M).group(1)
    states[guid] = meta.with_suffix('')

used = set()
for ctrl in assets.rglob('*.controller'):
    text = ctrl.read_text(encoding='utf-8')
    m = re.search(r'm_DefaultState: \{fileID: 110200000, guid: ([0-9a-f]{32}), type: 2\}', text)
    if not m or m.group(1) not in states:
        continue
    state_file = states[m.group(1)]
    state_doc = state_file.read_text(encoding='utf-8').split('--- !u!1102 &110200000\n', 1)[1]
    sm_id = re.search(r'^--- !u!1107 &(\d+)', text, re.M).group(1)
    state_doc = re.sub(r'm_ParentStateMachine: \{fileID: 0\}', f'm_ParentStateMachine: {{fileID: {sm_id}}}', state_doc)
    state_doc = re.sub(r'm_ObjectHideFlags: \d+', 'm_ObjectHideFlags: 3', state_doc, count=1)
    text = text.replace(m.group(0), 'm_DefaultState: {fileID: 110200000}')
    text = re.sub(r'(\n  m_States:) \[\]', r'\1\n  - {fileID: 110200000}', text, count=1)
    text = re.sub(r'm_MotionSetCount: 0', 'm_MotionSetCount: 1', text, count=1)
    # StateMachine is a hidden sub-asset in editor-authored 4.3 controllers
    text = re.sub(r'(--- !u!1107 &\d+\nStateMachine:\n  serializedVersion: 2\n  m_ObjectHideFlags:) \d+', r'\1 3', text)
    text = text.rstrip('\n') + '\n--- !u!1102 &110200000\n' + state_doc.rstrip('\n') + '\n'
    ctrl.write_text(text, encoding='utf-8', newline='\n')
    used.add(state_file)
    print(f'fixed {ctrl.relative_to(proj)} (embedded {state_file.name})')

for s in used:
    still = any(s.name in p.read_text(encoding='utf-8', errors='ignore') for p in assets.rglob('*') if p.suffix in ('.unity', '.prefab', '.controller'))
    guid = re.search(r'^guid: ([0-9a-f]{32})', (s.parent / (s.name + '.meta')).read_text(encoding='utf-8'), re.M).group(1)
    refs = [p for p in assets.rglob('*') if p.suffix in ('.unity', '.prefab', '.controller', '.asset') and guid in p.read_text(encoding='utf-8', errors='ignore')]
    if not refs:
        s.unlink()
        (s.parent / (s.name + '.meta')).unlink()
        print(f'removed {s.relative_to(proj)}')
