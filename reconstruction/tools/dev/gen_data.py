"""Generates Assets/Dev/Generated/*.cs from beast fingerprints, so no shape or Hard Mode number is typed
by hand.

  python -I tools/dev/gen_data.py dev/out/fp/all002.json dev/out/fp/all003.json   (writes the files)
  python -I tools/dev/gen_data.py ... --check                                   (exit 1 if they would change)

BeastShapes.cs: Street's pink boss in each version, as the differences from that version's Street mobs
(the majority value where mobs disagree): root scale, bone local positions and scales, chest colliders,
part masses and drags, and the boss's own stats.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RECON = os.path.normpath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(RECON, "GangBeasts", "Assets", "Dev", "Generated")
sys.path.insert(0, HERE)
import fingerprint_diff as fd  # noqa: E402


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


def main(argv):
    check = "--check" in argv
    argv = [a for a in argv if a != "--check"]
    with open(argv[0], encoding="utf-8") as fh:
        fp2 = json.load(fh)
    with open(argv[1], encoding="utf-8") as fh:
        fp3 = json.load(fh)
    files = {"BeastShapes.cs": beast_shapes(fp2, fp3)}
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
