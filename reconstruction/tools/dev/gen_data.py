"""Generates Assets/Dev/Generated/*.cs from beast fingerprints, so no shape or Hard Mode number is typed
by hand.

  python -I tools/dev/gen_data.py dev/out/fp/all002.json dev/out/fp/all003.json   (writes the files)
  python -I tools/dev/gen_data.py ... --check                                   (exit 1 if they would change)

BeastShapes.cs: Street's pink boss in each version, as the differences from that version's Street mobs
(the majority value where mobs disagree): root scale, bone local positions and scales, chest colliders,
part masses and drags, and the boss's own stats.
HitboxMeshes.cs: 0.0.2's convex hitbox meshes, read from the shipped 0.0.2 build (Street's beasts).
HardModeData.cs: from dev/hardmode/spec.json, per level and beast class: the 0.0.2 and 0.0.3 value of every
rigidbody and joint field (physics) and every script setting (stats) that differs; the hitbox on each part
(mesh, smooth sphere collisions, physic material); and 0.0.2's collision-ignore pairs (decompiled
Player.Awake). Bone positions and scales come with the boss shape; anchors Unity derives from the pose
(m_ConnectedAnchor) and 0.0.3-only parts (hand proxies) are left out.
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RECON = os.path.normpath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(RECON, "GangBeasts", "Assets", "Dev", "Generated")
sys.path.insert(0, HERE)
import fingerprint as fpr  # noqa: E402
import fingerprint_diff as fd  # noqa: E402

SPEC = os.path.join(RECON, "dev", "hardmode", "spec.json")
DECOMPILED_PLAYER = os.path.join(RECON, "decompiled_002", "Assembly-CSharp", "Player.cs")
PHYSICS = re.compile(r"^parts\.(?P<path>[^.]+)\.(?P<key>rigidbody\.m_(Mass|Drag|AngularDrag)|joint\.m_(Angular[XYZ]Motion|[XYZ]Motion|Anchor|"
                     r"(LinearLimit|LowAngularXLimit|HighAngularXLimit|AngularYLimit|AngularZLimit)\.(limit|bounciness|spring|damper)))$")
STATS = {"scripts.Player.force": "Player.force", "scripts.Movement.movementSpeed": "Movement.movementSpeed",
         "scripts.Movement.animationSpeed": "Movement.animationSpeed", "scripts.Jump.jumpStrength": "Jump.jumpStrength",
         "scripts.Jump.fallTime": "Jump.fallTime", "scripts.PunchAndGrab.liftForce": "PunchAndGrab.liftForce",
         "scripts.HealthAndStamina.health": "HealthAndStamina.health",
         "scripts.HealthAndStamina.healthRegenerationSpeed": "HealthAndStamina.healthRegenerationSpeed",
         "scripts.HealthAndStamina.maxStunTime": "HealthAndStamina.maxStunTime",
         "scripts.HealthAndStamina.stunThreshold": "HealthAndStamina.stunThreshold", "scripts.HealthAndStamina.canDie": "HealthAndStamina.canDie"}


def street(fps):
    return [l for l in fps if l["level"] == "Street"][0]


def majority(beasts):
    """key -> the value most beasts share (ties: the first beast's)."""
    flats = [fd.flatten({k: v for k, v in b.items() if k != "class"}, "", {}) for b in beasts]
    keys = set()
    for f in flats:
        keys.update(f)
    out = {}
    for key in keys:
        values = [f[key] for f in flats if key in f]
        best, best_count = values[0], 0
        for v in values:
            count = sum(1 for w in values if fd.same(v, w))
            if count > best_count:
                best, best_count = v, count
        out[key] = best
    return out


def f(x):
    """C# float literal that round-trips the 32-bit value."""
    if x == float("inf"):
        return "float.PositiveInfinity"
    text = repr(float(x))
    if "e" in text or "E" in text:
        mant, exp = text.lower().split("e")
        return "%se%sf" % (mant, exp)
    return text + "f"


def v3(v):
    return "new Vector3(%s, %s, %s)" % (f(v[0]), f(v[1]), f(v[2]))


def boss_shape(fp, version):
    level = street(fp)
    boss = [b for b in level["beasts"] if b["class"] == "boss"][0]
    mobs = [b for b in level["beasts"] if b["class"] == "mob" and b["active"]]
    normal = majority(mobs)
    shaped = fd.flatten({k: v for k, v in boss.items() if k != "class"}, "", {})
    bones, colliders, bodies = [], [], []
    for path, part in sorted(boss["parts"].items()):
        if path in ("", "agent"):
            continue
        prefix = "parts." + path + "."
        if not fd.same(normal.get(prefix + "pos"), part["pos"]) or not fd.same(normal.get(prefix + "scale"), part["scale"]):
            bones.append((path, part["pos"], part["scale"]))
        if not fd.same(normal.get(prefix + "colliders"), fd.canonical(part["colliders"])):
            colliders.append((path, part["colliders"]))
        rb = part.get("rigidbody")
        if rb:
            mass = rb["m_Mass"] if not fd.same(normal.get(prefix + "rigidbody.m_Mass"), rb["m_Mass"]) else None
            drag = rb["m_Drag"] if not fd.same(normal.get(prefix + "rigidbody.m_Drag"), rb["m_Drag"]) else None
            if mass is not None or drag is not None:
                bodies.append((path, mass, drag))
    stats = {}
    for key in ("HealthAndStamina.health", "HealthAndStamina.stunThreshold", "HealthAndStamina.healthRegenerationSpeed",
                "Movement.movementSpeed", "Movement.animationSpeed", "Player.force", "Jump.jumpStrength"):
        k = "scripts." + key
        if k in shaped and not fd.same(normal.get(k), shaped[k]):
            stats[key] = shaped[k]
    return {"version": version, "scale": boss["scale"][0], "bones": bones, "colliders": colliders, "bodies": bodies, "stats": stats}


def emit_shape(name, shape):
    lines = []
    lines.append("\t// Street's pink boss in %s, against that version's Street mobs." % shape["version"])
    lines.append("\tpublic static readonly BeastShape %s = new BeastShape(" % name)
    lines.append("\t\t%s," % f(shape["scale"]))
    lines.append("\t\tnew BeastShape.Bone[] {")
    for path, pos, scale in shape["bones"]:
        lines.append("\t\t\tnew BeastShape.Bone(\"%s\", %s, %s)," % (path, v3(pos), v3(scale)))
    lines.append("\t\t},")
    lines.append("\t\tnew BeastShape.Capsule[] {")
    for path, cols in shape["colliders"]:
        for c in cols:
            if c["type"] != "CapsuleCollider":
                raise SystemExit("boss %s: non-capsule collider change on %s not supported" % (shape["version"], path))
            lines.append("\t\t\tnew BeastShape.Capsule(\"%s\", %s, %s, %d, %s)," % (path, f(c["m_Radius"]), f(c["m_Height"]), c["m_Direction"], v3(c["m_Center"])))
    lines.append("\t\t},")
    lines.append("\t\tnew BeastShape.Body[] {")
    for path, mass, drag in shape["bodies"]:
        lines.append("\t\t\tnew BeastShape.Body(\"%s\", %s, %s)," % (path, f(mass) if mass is not None else "-1f", f(drag) if drag is not None else "-1f"))
    lines.append("\t\t},")
    s = shape["stats"]
    def stat(key):
        return f(s[key]) if key in s else "-1f"
    lines.append("\t\t%s, %s, %s, %s);" % (stat("HealthAndStamina.health"), stat("HealthAndStamina.stunThreshold"),
                                          stat("Movement.movementSpeed"), stat("Movement.animationSpeed")))
    return lines


def beast_shapes(fp2, fp3):
    lines = ["// GENERATED by tools/dev/gen_data.py from the 0.0.2 and 0.0.3 fingerprints. Do not edit.",
             "using UnityEngine;", "", "public static class BeastShapes", "{"]
    lines += emit_shape("Boss003", boss_shape(fp3, "0.0.3"))
    lines.append("")
    lines += emit_shape("Boss002", boss_shape(fp2, "0.0.2"))
    lines.append("}")
    return "\n".join(lines) + "\n"


def hitbox_meshes():
    meshes = fpr.hitbox_meshes_002("Street")
    names = sorted(meshes)
    lines = ["// GENERATED by tools/dev/gen_data.py from the shipped 0.0.2 build (Street's beasts). Do not edit.",
             "// 0.0.2's convex hitbox meshes: positions in the part's own space and triangle indices.",
             "public static class HitboxMeshes", "{", "\tpublic static readonly string[] names =", "\t{"]
    lines.append("\t\t" + ", ".join('"%s"' % n for n in names))
    lines += ["\t};", "", "\tpublic static readonly float[][] vertices =", "\t{"]
    for n in names:
        lines.append("\t\tnew float[] { " + ", ".join(f(x) for v in meshes[n]["vertices"] for x in v) + " },")
    lines += ["\t};", "", "\tpublic static readonly int[][] triangles =", "\t{"]
    for n in names:
        lines.append("\t\tnew int[] { " + ", ".join(str(i) for i in meshes[n]["triangles"]) + " },")
    lines += ["\t};", "}"]
    return "\n".join(lines) + "\n"


def hitboxes(fp2):
    """part path -> (mesh, smooth, convex, material name) on 0.0.2 beasts; must be the same everywhere."""
    found = {}
    for level in fp2:
        for b in level["beasts"]:
            for path, part in b["parts"].items():
                for c in part["colliders"]:
                    if c["type"] != "MeshCollider":
                        continue
                    m = c.get("m_Material")
                    entry = (c["m_Mesh"], bool(c["m_SmoothSphereCollisions"]), bool(c["m_Convex"]), m["m_Name"] if m else None)
                    if path in found and found[path] != entry:
                        raise SystemExit("0.0.2 hitbox on %s differs between beasts: %s vs %s" % (path, found[path], entry))
                    found[path] = entry
    return found


def ignore_pairs():
    with open(DECOMPILED_PLAYER, encoding="utf-8") as fh:
        text = fh.read()
    return re.findall(r'Physics\.IgnoreCollision\(part\["(\w+)"\]\.collider, part\["(\w+)"\]\.collider\)', text)


def class_fields(diffs):
    physics, stats = [], []
    for key, v in sorted(diffs.items()):
        m = PHYSICS.match(key)
        if m and "proxy" not in m.group("path") and "Fingers" not in m.group("path"):
            field = m.group("key").replace("rigidbody.", "rb.").replace("joint.", "j.")
            a, b = v["002"], v["003"]
            if isinstance(a, list):
                for axis, x, y in zip("xyz", a, b):
                    physics.append((m.group("path"), field + "." + axis, x, y))
            else:
                physics.append((m.group("path"), field, a, b))
        elif key in STATS and v["002"] != "<missing>" and v["003"] != "<missing>":
            stats.append((STATS[key], v["002"], v["003"]))
    return physics, stats


def num(v):
    return f(1.0 if v is True else 0.0 if v is False else v)


FIELD_CLASS = """	// Part path ("" for a script setting), field, 0.0.2 value, 0.0.3 value (joint motions: 0 locked,
	// 1 limited, 2 free; flags: 1 true, 0 false).
	public class Field
	{
		public readonly string path;

		public readonly string key;

		public readonly float v002;

		public readonly float v003;

		public Field(string path, string key, float v002, float v003)
		{
			this.path = path;
			this.key = key;
			this.v002 = v002;
			this.v003 = v003;
		}
	}

	public class ClassData
	{
		public readonly string level;

		public readonly string cls;

		// No 0.0.2 counterpart (Subway): only the values that are the same in every 0.0.2 level.
		public readonly bool generic;

		public readonly Field[] physics;

		public readonly Field[] stats;

		public ClassData(string level, string cls, bool generic, Field[] physics, Field[] stats)
		{
			this.level = level;
			this.cls = cls;
			this.generic = generic;
			this.physics = physics;
			this.stats = stats;
		}
	}
"""


def hard_mode_data(fp2, fp3):
    with open(SPEC, encoding="utf-8") as fh:
        spec = json.load(fh)
    active = {(l["level"], b["class"]) for l in fp3 for b in l["beasts"] if b["active"]}
    boxes = hitboxes(fp2)
    pairs = ignore_pairs()
    if len(pairs) != 9:
        raise SystemExit("expected 9 IgnoreCollision pairs in 0.0.2's Player.Awake, found %d" % len(pairs))
    lines = ["// GENERATED by tools/dev/gen_data.py from dev/hardmode/spec.json, the 0.0.2 build and its decompiled",
             "// Player.Awake. Do not edit.", "public static class HardModeData", "{", FIELD_CLASS]
    lines.append("\t// Part path, hitbox mesh (HitboxMeshes), smooth sphere collisions, physic material (null: none).")
    lines.append("\tpublic static readonly string[,] hitboxes =\n\t{")
    for path in sorted(boxes):
        mesh, smooth, convex, mat = boxes[path]
        if not convex:
            raise SystemExit("0.0.2 hitbox on %s is not convex" % path)
        lines.append('\t\t{ "%s", "%s", "%s", %s },' % (path, mesh, "true" if smooth else "false", '"%s"' % mat if mat else "null"))
    lines.append("\t};\n")
    lines.append("\t// 0.0.2's Player.Awake ignores collisions between these parts.")
    lines.append("\tpublic static readonly string[,] ignorePairs =\n\t{")
    for a, b in pairs:
        lines.append('\t\t{ "%s", "%s" },' % (a, b))
    lines.append("\t};\n")
    entries = []
    normal = {}
    for level, classes in sorted(spec["levels"].items()):
        for cls, entry in sorted(classes.items()):
            physics, stats = class_fields(entry["diffs"])
            entries.append((level, cls, entry["source"] == "generic", physics, stats))
            if cls in ("human", "mob") and (level, cls) in active:
                normal.setdefault(level, []).append({(x[0], x[1]): x[2] for x in physics})
    # Humans and mobs share one rig: their physics deltas must agree within a level (classes in play only:
    # Gondola's switched-off mobs are leftover 0.0.2-style beasts in both versions).
    for level, lists in normal.items():
        if len(lists) == 2 and lists[0] != lists[1]:
            raise SystemExit("%s: human and mob physics deltas differ" % level)
    # Per class, the values every 0.0.2 level shares (level "*"): for a class a level does not have in
    # 0.0.2 (AI spawned in Ring, say). Only 0.0.2 targets: the beast's own values are saved for restore.
    for cls in ("human", "mob", "boss"):
        generic = spec["generic"].get(cls)
        if generic is None:
            continue
        diffs = {k: {"002": v, "003": v} for k, v in generic.items()}
        physics, stats = class_fields(diffs)
        entries.append(("*", cls, True, physics, stats))
    lines.append("\tpublic static readonly ClassData[] classes =\n\t{")
    for level, cls, generic, physics, stats in entries:
        lines.append('\t\tnew ClassData("%s", "%s", %s, new Field[] {' % (level, cls, "true" if generic else "false"))
        for path, key, a, b in physics:
            lines.append('\t\t\tnew Field("%s", "%s", %s, %s),' % (path, key, num(a), num(b)))
        lines.append("\t\t}, new Field[] {")
        for key, a, b in stats:
            lines.append('\t\t\tnew Field("", "%s", %s, %s),' % (key, num(a), num(b)))
        lines.append("\t\t}),")
    lines.append("\t};")
    lines.append("}")
    return "\n".join(lines) + "\n"


def main(argv):
    check = "--check" in argv
    argv = [a for a in argv if a != "--check"]
    with open(argv[0], encoding="utf-8") as fh:
        fp2 = json.load(fh)
    with open(argv[1], encoding="utf-8") as fh:
        fp3 = json.load(fh)
    files = {"BeastShapes.cs": beast_shapes(fp2, fp3), "HitboxMeshes.cs": hitbox_meshes(), "HardModeData.cs": hard_mode_data(fp2, fp3)}
    changed = False
    for name, text in files.items():
        path = os.path.join(OUT, name)
        old = None
        if os.path.exists(path):
            with open(path, encoding="utf-8", newline="") as fh:
                old = fh.read()
        if old != text:
            changed = True
            if check:
                print("would change", name)
            else:
                os.makedirs(OUT, exist_ok=True)
                with open(path, "w", encoding="utf-8", newline="\n") as fh:
                    fh.write(text)
                print("wrote", name)
    if check and changed:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
