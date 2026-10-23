"""Beast physics fingerprints for Gang Beasts 0.0.2 (shipped binary levels) and 0.0.3 (project YAML scenes).

  python -I tools/dev/fingerprint.py 002 [Level ...] [-o out.json]
  python -I tools/dev/fingerprint.py 003 [Level ...] [-o out.json]

Both produce the same JSON schema: per level, the global physics settings and every beast (a GameObject
with a Player script): its root, its script fields that matter for physics and combat, and per body part
(path under the root) the transform, layer, tag, rigidbody, colliders (with physic material and mesh
names) and configurable joint (with the connected part).

The 0.0.2 files carry no type trees, so each class is read with its Unity 4.3 binary layout (field order
from the 0.0.3 YAML). Every object read must consume exactly its byte size, or the tool stops: a wrong
layout cannot slip through. 0.0.2 script layouts come from the decompiled 0.0.2 classes.
"""
import json
import os
import re
import struct
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RECON = os.path.normpath(os.path.join(HERE, "..", ".."))
REPO = os.path.dirname(RECON)
GB002 = os.environ.get("GB002", os.path.join(os.path.dirname(REPO), "gang_beasts_0_0_2_windows", "Gang Beasts_Data"))
ASSETS = os.path.join(RECON, "GangBeasts", "Assets")
SETTINGS = os.path.join(RECON, "GangBeasts", "ProjectSettings")

# Script fields kept in the fingerprint, by class, with the name used in the JSON (0.0.2's Health
# names map onto 0.0.3's HealthAndStamina).
SCRIPT_FIELDS = {
    "Player": ["player", "gangName", "actorColor", "force", "mob"],
    "Movement": ["movementSpeed", "animationSpeed"],
    "Jump": ["jumpStrength", "fallTime", "airSpeed"],
    "PunchAndGrab": ["liftForce", "useStamina"],
    "Health": ["health", "regenerationSpeed", "maxStunTime", "stunThreshold", "canDie"],
    "HealthAndStamina": ["health", "healthRegenerationSpeed", "maxStunTime", "stunThreshold", "canDie"],
    "Targeting": ["fov"],
}
SCRIPT_ALIASES = {"Health": "HealthAndStamina", "regenerationSpeed": "healthRegenerationSpeed"}

BUILTIN_TAGS = {0: "Untagged", 1: "Respawn", 2: "Finish", 3: "EditorOnly", 5: "MainCamera", 6: "Player", 7: "GameController"}


class LayoutError(Exception):
    pass


# --------------------------------------------------------------------------------------------- 0.0.2

class Reader:
    def __init__(self, data):
        self.d = data
        self.p = 0

    def u8(self):
        v = self.d[self.p]
        self.p += 1
        return v

    def bool(self):
        return bool(self.u8())

    def i16(self):
        v, = struct.unpack_from("<h", self.d, self.p)
        self.p += 2
        return v

    def u16(self):
        v, = struct.unpack_from("<H", self.d, self.p)
        self.p += 2
        return v

    def i32(self):
        v, = struct.unpack_from("<i", self.d, self.p)
        self.p += 4
        return v

    def u32(self):
        v, = struct.unpack_from("<I", self.d, self.p)
        self.p += 4
        return v

    def f32(self):
        v, = struct.unpack_from("<f", self.d, self.p)
        self.p += 4
        return v

    def align(self):
        self.p = (self.p + 3) & ~3

    def string(self):
        n = self.i32()
        if n < 0 or self.p + n > len(self.d):
            raise LayoutError("bad string length %d at %d" % (n, self.p))
        s = self.d[self.p:self.p + n].decode("utf-8", "replace")
        self.p += n
        self.align()
        return s

    def vec3(self):
        return [self.f32(), self.f32(), self.f32()]

    def quat(self):
        return [self.f32(), self.f32(), self.f32(), self.f32()]

    def pptr(self):
        return (self.i32(), self.i32())

    def pptr_array(self):
        return [self.pptr() for _ in range(self.count())]

    def count(self):
        n = self.i32()
        if n < 0 or n > 1000000:
            raise LayoutError("bad array count %d at %d" % (n, self.p))
        return n

    def done(self, what):
        if self.p != len(self.d):
            raise LayoutError("%s: read %d of %d bytes" % (what, self.p, len(self.d)))


class SerializedFile:
    """A Unity 4.x (format 9) serialized file without type trees."""

    cache = {}

    def __init__(self, path):
        self.path = path
        self.name = os.path.basename(path)
        with open(path, "rb") as f:
            d = f.read()
        meta_size, file_size, version, data_offset = struct.unpack_from(">IIII", d, 0)
        if version != 9 or d[16] != 0:
            raise LayoutError("%s: format %d, endian %d not supported" % (path, version, d[16]))
        p = d.index(b"\0", 20) + 1  # unity version
        p += 4  # platform
        types, = struct.unpack_from("<i", d, p)
        if types != 0:
            raise LayoutError("%s has type trees; this reader expects none" % path)
        p += 8  # type count + an unused int
        count, = struct.unpack_from("<i", d, p)
        p += 4
        self.objects = {}
        for _ in range(count):
            path_id, start, size, type_id, class_id, destroyed = struct.unpack_from("<iIIihh", d, p)
            p += 20
            self.objects[path_id] = (class_id, data_offset + start, size)
        externals, = struct.unpack_from("<i", d, p)
        p += 4
        self.externals = []
        for _ in range(externals):
            p = d.index(b"\0", p) + 1 + 16 + 4
            end = d.index(b"\0", p)
            self.externals.append(d[p:end].decode())
            p = end + 1
        self.data = d

    @classmethod
    def open(cls, path):
        path = os.path.normcase(os.path.abspath(path))
        if path not in cls.cache:
            cls.cache[path] = SerializedFile(path)
        return cls.cache[path]

    def reader(self, path_id):
        class_id, start, size = self.objects[path_id]
        return Reader(self.data[start:start + size])

    def of_class(self, class_id):
        return [pid for pid, (cid, _, _) in self.objects.items() if cid == class_id]

    def resolve(self, pptr):
        """(file, path id) a PPtr points at, or None for a null reference."""
        file_id, path_id = pptr
        if path_id == 0:
            return None
        if file_id == 0:
            return self, path_id
        name = self.externals[file_id - 1]
        if name.startswith("library/"):
            name = os.path.join("Resources", name[len("library/"):])
        target = SerializedFile.open(os.path.join(os.path.dirname(self.path), name))
        return target, path_id


def read_gameobject(r):
    components = []
    for _ in range(r.count()):
        class_id = r.i32()
        components.append((class_id, r.pptr()))
    layer = r.u32()
    name = r.string()
    tag = r.u16()
    active = r.bool()  # the last field: no padding after it
    r.done("GameObject")
    return {"components": components, "layer": layer, "name": name, "tag": tag, "active": active}


def read_transform(r):
    t = {"go": r.pptr(), "rot": r.quat(), "pos": r.vec3(), "scale": r.vec3()}
    t["children"] = r.pptr_array()
    t["father"] = r.pptr()
    r.done("Transform")
    return t


def read_rigidbody(r):
    r.pptr()
    rb = {"m_Mass": r.f32(), "m_Drag": r.f32(), "m_AngularDrag": r.f32(), "m_UseGravity": r.bool(),
          "m_IsKinematic": r.bool(), "m_Interpolate": r.u8()}
    r.align()
    rb["m_Constraints"] = r.i32()
    rb["m_CollisionDetection"] = r.i32()
    r.done("Rigidbody")
    return rb


def read_limit(r):
    return {"limit": r.f32(), "bounciness": r.f32(), "spring": r.f32(), "damper": r.f32()}


def read_drive(r):
    return {"mode": r.i32(), "positionSpring": r.f32(), "positionDamper": r.f32(), "maximumForce": r.f32()}


def read_joint(r):
    r.pptr()
    j = {"m_ConnectedBody": r.pptr(), "m_Anchor": r.vec3(), "m_Axis": r.vec3(), "m_AutoConfigureConnectedAnchor": r.bool()}
    r.align()
    j["m_ConnectedAnchor"] = r.vec3()
    j["m_SecondaryAxis"] = r.vec3()
    for k in ("m_XMotion", "m_YMotion", "m_ZMotion", "m_AngularXMotion", "m_AngularYMotion", "m_AngularZMotion"):
        j[k] = r.i32()
    for k in ("m_LinearLimit", "m_LowAngularXLimit", "m_HighAngularXLimit", "m_AngularYLimit", "m_AngularZLimit"):
        j[k] = read_limit(r)
    j["m_TargetPosition"] = r.vec3()
    j["m_TargetVelocity"] = r.vec3()
    for k in ("m_XDrive", "m_YDrive", "m_ZDrive"):
        j[k] = read_drive(r)
    j["m_TargetRotation"] = r.quat()
    j["m_TargetAngularVelocity"] = r.vec3()
    j["m_RotationDriveMode"] = r.i32()
    for k in ("m_AngularXDrive", "m_AngularYZDrive", "m_SlerpDrive"):
        j[k] = read_drive(r)
    j["m_ProjectionMode"] = r.i32()
    j["m_ProjectionDistance"] = r.f32()
    j["m_ProjectionAngle"] = r.f32()
    j["m_ConfiguredInWorldSpace"] = r.bool()
    j["m_SwapBodies"] = r.bool()
    r.align()
    j["m_BreakForce"] = r.f32()
    j["m_BreakTorque"] = r.f32()
    r.done("ConfigurableJoint")
    return j


def read_collider(r, class_id):
    r.pptr()
    c = {"m_Material": r.pptr(), "m_IsTrigger": r.bool(), "m_Enabled": r.bool()}
    r.align()
    if class_id == 135:
        c["type"] = "SphereCollider"
        c["m_Radius"] = r.f32()
        c["m_Center"] = r.vec3()
    elif class_id == 136:
        c["type"] = "CapsuleCollider"
        c["m_Radius"] = r.f32()
        c["m_Height"] = r.f32()
        c["m_Direction"] = r.i32()
        c["m_Center"] = r.vec3()
    elif class_id == 65:
        c["type"] = "BoxCollider"
        c["m_Size"] = r.vec3()
        c["m_Center"] = r.vec3()
    elif class_id == 64:
        c["type"] = "MeshCollider"
        c["m_SmoothSphereCollisions"] = r.bool()
        c["m_Convex"] = r.bool()
        r.align()
        c["m_Mesh"] = r.pptr()
    r.done(c["type"])
    return c


def read_physic_material(r):
    m = {"m_Name": r.string(), "dynamicFriction": r.f32(), "staticFriction": r.f32(), "bounciness": r.f32(),
         "frictionCombine": r.i32(), "bounceCombine": r.i32(), "frictionDirection2": r.vec3(),
         "dynamicFriction2": r.f32(), "staticFriction2": r.f32()}
    r.done("PhysicMaterial")
    return m


def read_monoscript(r):
    r.string()  # m_Name (empty in builds)
    r.i32()  # execution order
    r.u32()  # properties hash
    name = r.string()
    r.string()  # namespace
    r.string()  # assembly
    r.bool()  # m_IsEditorScript, the last field: no padding after it
    r.done("MonoScript")
    return name


# Serialized fields of the 0.0.2 scripts, in declaration order (decompiled_002/Assembly-CSharp).
LAYOUT_002 = {
    "Player": [("player", "i32"), ("gangName", "str"), ("actorColor", "color"), ("direction", "vec3"),
               ("jumpReset", "f32"), ("canJump", "bool"), ("leftHandTimer", "f32"), ("leftGrab", "bool"),
               ("leftPunch", "bool"), ("leftLift", "bool"), ("leftInputDown", "bool"), ("rightHandTimer", "f32"),
               ("rightGrab", "bool"), ("rightPunch", "bool"), ("rightLift", "bool"), ("rightInputDown", "bool"),
               ("taunt", "bool"), ("force", "f32"), ("applyedForce", "f32"), ("punchRetriggerDelay", "f32"),
               ("mob", "bool"), ("agent", "pptr"), ("target", "pptr"), ("targetInRange", "bool"), ("state", "i32")],
    "Movement": [("movementSpeed", "f32"), ("animationSpeed", "f32"), ("leftLimbPosition", "i32"), ("rightLimbPosition", "i32")],
    "Jump": [("jumpStrength", "f32"), ("currentJumpStrength", "f32"), ("jumpTimer", "f32"), ("fallTime", "f32")],
    "PunchAndGrab": [("liftForce", "f32")],
    "Health": [("health", "f32"), ("regenerationSpeed", "f32"), ("maxStunTime", "f32"), ("stunThreshold", "f32"),
               ("canDie", "bool"), ("dead", "bool"), ("runOnce", "bool"), ("hurtSound", "pptr[]"), ("stunSound", "pptr[]"),
               ("stunRetriggerDelay", "f32"), ("deathSound", "pptr[]"), ("punchSound", "pptr[]"), ("blink", "pptr")],
    "Targeting": [("targetsInSphere", "pptr[]"), ("punchTarget", "pptr"), ("grabTarget", "pptr"), ("fov", "f32")],
    "CollisionEvent": [("stepSound", "pptr[]"), ("punchSound", "pptr[]")],
}


def read_field(r, kind):
    if kind == "i32":
        return r.i32()
    if kind == "f32":
        return r.f32()
    if kind == "bool":
        v = r.bool()
        r.align()  # script bools are 4-byte aligned (checked: every object's size must match)
        return v
    if kind == "str":
        return r.string()
    if kind == "color":
        return r.quat()
    if kind == "vec3":
        return r.vec3()
    if kind == "pptr":
        return r.pptr()
    if kind == "pptr[]":
        return r.pptr_array()
    raise ValueError(kind)


def read_monobehaviour(sf, r):
    r.pptr()  # game object
    enabled = r.bool()
    r.align()
    script = r.pptr()
    r.string()  # m_Name
    target = sf.resolve(script)
    cls = None
    if target is not None:
        tf, tid = target
        cls = read_monoscript(tf.reader(tid))
    fields = None
    if cls in LAYOUT_002:
        fields = {}
        for name, kind in LAYOUT_002[cls]:
            fields[name] = read_field(r, kind)
        r.done("MonoBehaviour " + cls)
    return {"class": cls, "enabled": enabled, "fields": fields}


def tags_002():
    sf = SerializedFile.open(os.path.join(GB002, "mainData"))
    pid = sf.of_class(78)[0]
    r = sf.reader(pid)
    tags = [r.string() for _ in range(r.count())]
    return tags


def levels_002():
    sf = SerializedFile.open(os.path.join(GB002, "mainData"))
    r = sf.reader(sf.of_class(141)[0])
    return [r.string() for _ in range(r.count())]


def globals_002():
    sf = SerializedFile.open(os.path.join(GB002, "mainData"))
    r = sf.reader(sf.of_class(55)[0])
    g = {"m_Gravity": r.vec3(), "m_DefaultMaterial": r.pptr(), "m_BounceThreshold": r.f32(), "m_SleepVelocity": r.f32(),
         "m_SleepAngularVelocity": r.f32(), "m_MaxAngularVelocity": r.f32(), "m_MinPenetrationForPenalty": r.f32(),
         "m_SolverIterationCount": r.i32(), "m_RaycastsHitTriggers": r.bool()}
    r.align()
    g["m_LayerCollisionMatrix"] = "".join("%08x" % r.u32() for _ in range(r.count()))
    r.done("PhysicsManager")
    del g["m_DefaultMaterial"]
    t = sf.reader(sf.of_class(5)[0])
    g["Fixed Timestep"] = t.f32()
    g["Maximum Allowed Timestep"] = t.f32()
    g["m_TimeScale"] = t.f32()
    t.done("TimeManager")
    return g


def fingerprint_002(level_name):
    names = levels_002()
    scene_index = names.index("Assets/Scenes/%s.unity" % level_name)
    # mainData holds scene 0 (Intro); scene n lives in level(n-1).
    sf = SerializedFile.open(os.path.join(GB002, "level%d" % (scene_index - 1)))
    tags = tags_002()

    def tag_name(t):
        return BUILTIN_TAGS.get(t, tags[t - 20000] if t >= 20000 else str(t))

    gos = {pid: read_gameobject(sf.reader(pid)) for pid in sf.of_class(1)}
    transforms = {pid: read_transform(sf.reader(pid)) for pid in sf.of_class(4)}
    beasts = []
    for go_pid, go in gos.items():
        scripts = [read_monobehaviour(sf, sf.reader(ptr[1])) for cid, ptr in go["components"] if cid == 114]
        if not any(s["class"] == "Player" for s in scripts):
            continue
        beasts.append(beast_002(sf, gos, transforms, go_pid, tag_name))
    return {"version": "0.0.2", "level": level_name, "source": sf.name, "globals": globals_002(),
            "beasts": sorted(beasts, key=lambda b: (b["class"], b["root_position"]))}


def beast_002(sf, gos, transforms, root_go, tag_name):
    def transform_of(go_pid):
        for cid, ptr in gos[go_pid]["components"]:
            if cid == 4:
                return ptr[1]
    rigid_owner = {}
    paths = {}
    root_t = transform_of(root_go)
    stack = [(root_t, "")]
    while stack:
        t_pid, path = stack.pop()
        paths[t_pid] = path
        for child in transforms[t_pid]["children"]:
            child_go = transforms[child[1]]["go"][1]
            name = gos[child_go]["name"]
            stack.append((child[1], (path + "/" if path else "") + name))
    parts = {}
    scripts = {}
    for t_pid, path in paths.items():
        go_pid = transforms[t_pid]["go"][1]
        go = gos[go_pid]
        t = transforms[t_pid]
        part = {"active": go["active"], "layer": go["layer"], "tag": tag_name(go["tag"]), "pos": t["pos"], "rot": t["rot"],
                "scale": t["scale"], "colliders": []}
        for cid, ptr in go["components"]:
            r = sf.reader(ptr[1])
            if cid == 54:
                part["rigidbody"] = read_rigidbody(r)
                rigid_owner[ptr[1]] = path
            elif cid == 153:
                part["joint"] = read_joint(r)
            elif cid in (64, 65, 135, 136):
                c = read_collider(r, cid)
                c["m_Material"] = material_002(sf, c["m_Material"])
                if cid == 64:
                    c["m_Mesh"] = mesh_name_002(sf, c["m_Mesh"])
                part["colliders"].append(c)
            elif cid == 114:
                mb = read_monobehaviour(sf, r)
                if path == "" and mb["fields"] is not None:
                    scripts[mb["class"]] = mb["fields"]
                part.setdefault("scripts", []).append(mb["class"])
        parts[path] = part
    for part in parts.values():
        if "joint" in part:
            body = part["joint"]["m_ConnectedBody"]
            part["joint"]["m_ConnectedBody"] = connected_name(body, rigid_owner)
    return finish_beast(parts, scripts, "0.0.2")


def connected_name(pptr, owners):
    if pptr[1] == 0:
        return None
    if pptr[0] != 0:
        return "<external>"
    return owners.get(pptr[1], "<outside beast>")


def material_002(sf, pptr):
    target = sf.resolve(pptr)
    if target is None:
        return None
    f, pid = target
    return read_physic_material(f.reader(pid))


def mesh_name_002(sf, pptr):
    target = sf.resolve(pptr)
    if target is None:
        return None
    f, pid = target
    return f.reader(pid).string()


# --------------------------------------------------------------------------------------------- 0.0.3

DOC = re.compile(r"^--- !u!(\d+) &(\d+)")


def scalar(text):
    text = text.strip()
    if text == "":
        return None
    if text[0] in "'\"" and text[-1] == text[0]:
        return text[1:-1]
    if text.startswith("{"):
        return flow_map(text)
    if text == "[]":
        return []
    for conv in (int, float):
        try:
            return conv(text)
        except ValueError:
            pass
    if text in ("Infinity", "-Infinity", "NaN"):
        return float(text.lower().replace("infinity", "inf"))
    return text


def flow_map(text):
    body = text.strip()[1:-1].strip()
    result = {}
    if not body:
        return result
    for item in body.split(", "):
        key, _, value = item.partition(":")
        result[key.strip()] = scalar(value)
    return result


def indent_of(line):
    return len(line) - len(line.lstrip(" "))


def parse_block(lines, i, indent):
    """Mapping or sequence whose items start at this indent."""
    if lines[i].lstrip().startswith("- "):
        return parse_sequence(lines, i, indent)
    return parse_mapping(lines, i, indent)


def parse_mapping(lines, i, indent):
    result = {}
    while i < len(lines) and indent_of(lines[i]) == indent and not lines[i].lstrip().startswith("- "):
        key, _, rest = lines[i].strip().partition(":")
        i += 1
        if rest.strip() == "" and i < len(lines):
            nxt = indent_of(lines[i])
            if nxt > indent or (nxt == indent and lines[i].lstrip().startswith("- ")):
                value, i = parse_block(lines, i, nxt)
                result[key] = value
                continue
        result[key] = scalar(rest)
    return result, i


def parse_sequence(lines, i, indent):
    items = []
    while i < len(lines) and indent_of(lines[i]) == indent and lines[i].lstrip().startswith("- "):
        text = lines[i].strip()[2:]
        i += 1
        if text.startswith("{") or ":" not in text:
            items.append(scalar(text))
            continue
        key, _, rest = text.partition(":")
        item = {key.strip(): scalar(rest)}
        if i < len(lines) and indent_of(lines[i]) == indent + 2:
            more, i = parse_mapping(lines, i, indent + 2)
            item.update(more)
        items.append(item)
    return items, i


def load_yaml_scene(path, wanted):
    docs = {}
    with open(path, encoding="utf-8") as f:
        lines = f.read().split("\n")
    i = 0
    while i < len(lines):
        m = DOC.match(lines[i])
        if not m:
            i += 1
            continue
        cid, fid = int(m.group(1)), int(m.group(2))
        j = i + 1
        while j < len(lines) and not lines[j].startswith("--- "):
            j += 1
        if cid in wanted:
            body = [l for l in lines[i + 2:j] if l.strip()]
            value, _ = parse_mapping(body, 0, 2) if body else ({}, 0)
            docs[fid] = (cid, value)
        i = j
    return docs


GUID_RE = re.compile(r"^guid: ([0-9a-f]{32})", re.M)
_guids = None


def guid_index():
    """guid -> asset path for scripts, physic materials and meshes."""
    global _guids
    if _guids is None:
        _guids = {}
        for dirpath, _, files in os.walk(ASSETS):
            for name in files:
                if name.endswith(".meta"):
                    with open(os.path.join(dirpath, name), encoding="utf-8", errors="replace") as f:
                        m = GUID_RE.search(f.read())
                    if m:
                        _guids[m.group(1)] = os.path.join(dirpath, name[:-5])
    return _guids


def material_003(ref):
    if not ref or not ref.get("guid"):
        return None
    path = guid_index().get(ref["guid"])
    if path is None or not path.endswith(".physicMaterial"):
        return {"m_Name": "<unresolved %s>" % ref["guid"]}
    docs = load_yaml_scene(path, {134})
    return next(iter(docs.values()))[1]


def mesh_name_003(ref):
    if not ref or ref.get("fileID", 0) == 0:
        return None
    path = guid_index().get(ref.get("guid", ""))
    if path is None:
        return "<builtin %s>" % ref.get("fileID")
    return os.path.splitext(os.path.basename(path))[0]


def globals_003():
    def doc(name, cid):
        return next(iter(load_yaml_scene(os.path.join(SETTINGS, name), {cid}).values()))[1]
    p = doc("DynamicsManager.asset", 55)
    t = doc("TimeManager.asset", 5)
    g = {k: p[k] for k in ("m_BounceThreshold", "m_SleepVelocity", "m_SleepAngularVelocity", "m_MaxAngularVelocity",
                           "m_MinPenetrationForPenalty", "m_SolverIterationCount")}
    g["m_Gravity"] = [p["m_Gravity"]["x"], p["m_Gravity"]["y"], p["m_Gravity"]["z"]]
    g["m_RaycastsHitTriggers"] = bool(p["m_RaycastsHitTriggers"])
    # YAML stores the matrix as little-endian bytes in hex; the binary as uint32 words.
    raw = bytes.fromhex(str(p["m_LayerCollisionMatrix"]))
    g["m_LayerCollisionMatrix"] = "".join("%08x" % struct.unpack_from("<I", raw, k)[0] for k in range(0, len(raw), 4))
    g["Fixed Timestep"] = t["Fixed Timestep"]
    g["Maximum Allowed Timestep"] = t["Maximum Allowed Timestep"]
    g["m_TimeScale"] = t["m_TimeScale"]
    return g


def vec(v):
    return [v["x"], v["y"], v["z"]]


def quat(v):
    return [v["x"], v["y"], v["z"], v["w"]]


def fingerprint_003(level_name):
    path = os.path.join(ASSETS, "Scenes", level_name + ".unity")
    docs = load_yaml_scene(path, {1, 4, 54, 64, 65, 114, 135, 136, 153})
    scripts_by_guid = {g: os.path.splitext(os.path.basename(p))[0] for g, p in guid_index().items() if p.endswith((".cs", ".js"))}
    beasts = []
    for fid, (cid, go) in docs.items():
        if cid != 1:
            continue
        classes = []
        for comp in go.get("m_Component", []):
            (ccid, ref), = comp.items()
            if int(ccid) == 114 and ref["fileID"] in docs:
                classes.append(scripts_by_guid.get(docs[ref["fileID"]][1]["m_Script"].get("guid")))
        if "Player" in classes:
            beasts.append(beast_003(docs, fid, scripts_by_guid))
    return {"version": "0.0.3", "level": level_name, "source": os.path.basename(path), "globals": globals_003(),
            "beasts": sorted(beasts, key=lambda b: (b["class"], b["root_position"]))}


def beast_003(docs, root_go, scripts_by_guid):
    def comps(go_fid):
        return [(int(k), ref["fileID"]) for c in docs[go_fid][1].get("m_Component", []) for k, ref in c.items()]

    def transform_of(go_fid):
        for cid, fid in comps(go_fid):
            if cid == 4:
                return fid
    paths = {}
    stack = [(transform_of(root_go), "")]
    while stack:
        t_fid, path = stack.pop()
        paths[t_fid] = path
        for child in docs[t_fid][1].get("m_Children") or []:
            child_go = docs[child["fileID"]][1]["m_GameObject"]["fileID"]
            stack.append((child["fileID"], (path + "/" if path else "") + docs[child_go][1]["m_Name"]))
    parts = {}
    scripts = {}
    rigid_owner = {}
    for t_fid, path in paths.items():
        t = docs[t_fid][1]
        go_fid = t["m_GameObject"]["fileID"]
        go = docs[go_fid][1]
        part = {"active": bool(go["m_IsActive"]), "layer": go["m_Layer"], "tag": go["m_TagString"], "pos": vec(t["m_LocalPosition"]),
                "rot": quat(t["m_LocalRotation"]), "scale": vec(t["m_LocalScale"]), "colliders": []}
        for cid, fid in comps(go_fid):
            if fid not in docs:
                continue
            d = docs[fid][1]
            if cid == 54:
                part["rigidbody"] = {k: d[k] for k in ("m_Mass", "m_Drag", "m_AngularDrag", "m_UseGravity", "m_IsKinematic",
                                                     "m_Interpolate", "m_Constraints", "m_CollisionDetection")}
                for k in ("m_UseGravity", "m_IsKinematic"):
                    part["rigidbody"][k] = bool(part["rigidbody"][k])
                rigid_owner[fid] = path
            elif cid == 153:
                part["joint"] = joint_003(d)
            elif cid in (64, 65, 135, 136):
                part["colliders"].append(collider_003(cid, d))
            elif cid == 114:
                cls = scripts_by_guid.get(d["m_Script"].get("guid"))
                if path == "" and cls in SCRIPT_FIELDS:
                    scripts[cls] = d
                part.setdefault("scripts", []).append(cls)
        parts[path] = part
    for part in parts.values():
        if "joint" in part:
            ref = part["joint"]["m_ConnectedBody"]
            part["joint"]["m_ConnectedBody"] = connected_name((0, ref["fileID"]), rigid_owner)
    return finish_beast(parts, scripts, "0.0.3")


def joint_003(d):
    j = {}
    for k, v in d.items():
        if k in ("m_ObjectHideFlags", "m_PrefabParentObject", "m_PrefabInternal", "m_GameObject"):
            continue
        if isinstance(v, dict) and set(v) >= {"x", "y", "z"}:
            v = quat(v) if "w" in v else vec(v)
        elif isinstance(v, dict) and "serializedVersion" in v:
            v = {kk: vv for kk, vv in v.items() if kk != "serializedVersion"}
        j[k] = v
    j["m_AutoConfigureConnectedAnchor"] = bool(j["m_AutoConfigureConnectedAnchor"])
    j["m_ConfiguredInWorldSpace"] = bool(j["m_ConfiguredInWorldSpace"])
    j["m_SwapBodies"] = bool(j["m_SwapBodies"])
    return j


def collider_003(cid, d):
    c = {"type": {135: "SphereCollider", 136: "CapsuleCollider", 65: "BoxCollider", 64: "MeshCollider"}[cid],
         "m_Material": material_003(d.get("m_Material")), "m_IsTrigger": bool(d["m_IsTrigger"]), "m_Enabled": bool(d["m_Enabled"])}
    for k in ("m_Radius", "m_Height", "m_Direction"):
        if k in d:
            c[k] = d[k]
    for k in ("m_Center", "m_Size"):
        if k in d:
            c[k] = vec(d[k])
    if cid == 64:
        c["m_SmoothSphereCollisions"] = bool(d["m_SmoothSphereCollisions"])
        c["m_Convex"] = bool(d["m_Convex"])
        c["m_Mesh"] = mesh_name_003(d.get("m_Mesh"))
    return c


# --------------------------------------------------------------------------------------------- common

def finish_beast(parts, scripts, version):
    kept = {}
    for cls, fields in scripts.items():
        wanted = SCRIPT_FIELDS.get(cls)
        if not wanted:
            continue
        name = SCRIPT_ALIASES.get(cls, cls)
        out = {}
        for f in wanted:
            if f in fields:
                v = fields[f]
                if isinstance(v, dict) and set(v) == {"r", "g", "b", "a"}:
                    v = [v["r"], v["g"], v["b"], v["a"]]
                if f in ("mob", "canDie", "useStamina"):
                    v = bool(v)
                out[SCRIPT_ALIASES.get(f, f)] = v
        kept[name] = out
    root = parts[""]
    player = kept.get("Player", {})
    boss = root["scale"][0] > 1.1
    kind = "human" if not player.get("mob") else ("boss" if boss else "mob")
    # Material values are inlined; drop collider material entries' editor-only keys.
    for part in parts.values():
        for c in part["colliders"]:
            m = c.get("m_Material")
            if isinstance(m, dict):
                c["m_Material"] = {k: (vec(v) if isinstance(v, dict) else v) for k, v in m.items()
                                   if k not in ("m_ObjectHideFlags", "m_PrefabParentObject", "m_PrefabInternal")}
    return {"class": kind, "active": root["active"], "root_position": [round(x, 3) for x in root["pos"]], "scale": root["scale"],
            "scripts": kept, "parts": parts}


def main(argv):
    if not argv or argv[0] not in ("002", "003"):
        sys.exit(__doc__)
    version = argv[0]
    out = None
    if "-o" in argv:
        i = argv.index("-o")
        out = argv[i + 1]
        del argv[i:i + 2]
    levels = argv[1:]
    if not levels:
        if version == "002":
            levels = [os.path.splitext(os.path.basename(p))[0] for p in levels_002()[1:]]
        else:
            levels = sorted(os.path.splitext(n)[0] for n in os.listdir(os.path.join(ASSETS, "Scenes")) if n.endswith(".unity"))
    result = []
    for level in levels:
        fp = fingerprint_002(level) if version == "002" else fingerprint_003(level)
        counts = {}
        for b in fp["beasts"]:
            counts[b["class"]] = counts.get(b["class"], 0) + 1
        print("%s %-12s beasts %s" % (version, level, counts), file=sys.stderr)
        result.append(fp)
    text = json.dumps(result, indent=1, sort_keys=True)
    if out:
        with open(out, "w", encoding="utf-8", newline="\n") as f:
            f.write(text + "\n")
    else:
        print(text)


if __name__ == "__main__":
    main(sys.argv[1:])
