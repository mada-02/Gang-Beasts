"""Turns 0.0.2 and 0.0.3 fingerprints (fingerprint.py) into the Hard Mode spec.

  python -I tools/dev/fingerprint_diff.py dev/out/fp/all002.json dev/out/fp/all003.json \
      -o dev/hardmode/spec.json -m dev/hardmode/spec.md

For each level in both versions and each beast class (human, mob, boss), active beasts only:
  - every field is reduced to the class's consensus value (a field whose beasts disagree is reported);
  - every field whose 0.0.2 consensus differs from 0.0.3's goes into the spec;
  - "generic" values are 0.0.2 consensus values that are the same in every 0.0.2 level with that class.
    Levels new in 0.0.3 (Subway) only get those.
"""
import json
import re
import sys

# Identity and placement, not physics: where the beast stands, its NavMesh "agent" carrot, and the
# kinematic flag of the 16 parts Player.Awake turns non-kinematic anyway (the ball spring keeps its own).
IGNORED = re.compile(r"^(root_position|active|scale_root|scripts\.Player\.(player|gangName|actorColor)"
                     r"|parts\.\.(pos|rot)|parts\.agent(\..*)?"
                     r"|parts\.hips(/[^.]*)?\.rigidbody\.m_IsKinematic)$")
TOLERANCE = 1e-5


def flatten(value, prefix, out):
    if isinstance(value, dict):
        for k, v in value.items():
            flatten(v, prefix + "." + k if prefix else k, out)
    elif isinstance(value, list) and value and isinstance(value[0], dict):
        out[prefix] = canonical(value)
    else:
        out[prefix] = value
    return out


def canonical(value):
    """Order-free, rounding-stable text for lists of dicts (colliders)."""
    def norm(v):
        if isinstance(v, float):
            return float("%.6g" % v)
        if isinstance(v, dict):
            return {k: norm(x) for k, x in v.items()}
        if isinstance(v, list):
            return [norm(x) for x in v]
        return v
    return json.dumps(sorted((norm(v) for v in value), key=lambda d: json.dumps(d, sort_keys=True)), sort_keys=True)


def same(a, b):
    if a == b:  # also equal infinities, whose difference is NaN
        return True
    if isinstance(a, bool) or isinstance(b, bool):
        return a == b
    if isinstance(a, (int, float)) and isinstance(b, (int, float)):
        return abs(a - b) <= TOLERANCE * max(1.0, abs(a), abs(b))
    if isinstance(a, list) and isinstance(b, list):
        return len(a) == len(b) and all(same(x, y) for x, y in zip(a, b))
    return a == b


def consensus(beasts):
    """key -> value when every beast agrees, plus key -> [values] where they do not."""
    flats = [flatten({k: v for k, v in b.items() if k != "class"}, "", {}) for b in beasts]
    keys = set()
    for f in flats:
        keys.update(f)
    agreed, varies = {}, {}
    for key in sorted(keys):
        if IGNORED.match(key):
            continue
        values = [f.get(key, "<missing>") for f in flats]
        if all(same(values[0], v) for v in values[1:]):
            agreed[key] = values[0]
        else:
            distinct = []
            for v in values:
                if not any(same(v, d) for d in distinct):
                    distinct.append(v)
            varies[key] = distinct
    return agreed, varies


def groups(fingerprints):
    """(level, class) -> beasts. Active beasts only, unless a class has none active in the level (Subway's
    and Gondola's mobs start switched off): inactive leftovers would pollute a class that is in play."""
    out = {}
    for level in fingerprints:
        by_class = {}
        for b in level["beasts"]:
            by_class.setdefault(b["class"], []).append(b)
        for cls, beasts in by_class.items():
            active = [b for b in beasts if b["active"]]
            out[(level["level"], cls)] = active or beasts
    return out


def pattern(key):
    """Collapse per-part keys so a report line covers every part with the same change."""
    return re.sub(r"^parts\.[^.]*(\.|$)", r"parts.*\1", key)


def main(argv):
    out_json = argv[argv.index("-o") + 1] if "-o" in argv else None
    out_md = argv[argv.index("-m") + 1] if "-m" in argv else None
    with open(argv[0], encoding="utf-8") as f:
        fp2 = json.load(f)
    with open(argv[1], encoding="utf-8") as f:
        fp3 = json.load(f)
    g2, g3 = groups(fp2), groups(fp3)
    levels2 = {l["level"] for l in fp2}
    spec = {"levels": {}, "generic": {}, "varies": {}, "globals": {}}
    cons2 = {}
    for key, beasts in sorted(g2.items()):
        agreed, varies = consensus(beasts)
        cons2[key] = agreed
        if varies:
            spec["varies"]["0.0.2 %s %s" % key] = varies
    cons3 = {}
    for key, beasts in sorted(g3.items()):
        agreed, varies = consensus(beasts)
        cons3[key] = agreed
        if varies:
            spec["varies"]["0.0.3 %s %s" % key] = varies
    # Generic 0.0.2 values per class: the same in every 0.0.2 level that has the class.
    for cls in ("human", "mob", "boss"):
        per_level = [cons2[k] for k in cons2 if k[1] == cls]
        if not per_level:
            continue
        generic = {}
        for field, value in per_level[0].items():
            if all(field in c and same(value, c[field]) for c in per_level[1:]):
                generic[field] = value
        spec["generic"][cls] = generic
    for (level, cls), c3 in sorted(cons3.items()):
        if level in levels2 and (level, cls) in cons2:
            source, c2 = "level", cons2[(level, cls)]
        else:
            source, c2 = "generic", spec["generic"].get(cls, {})
        diffs = {}
        for field in sorted(set(c2) | set(c3)):
            a, b = c2.get(field, "<missing>"), c3.get(field, "<missing>")
            if source == "generic" and field not in c2:
                continue
            if not same(a, b):
                diffs[field] = {"002": a, "003": b}
        spec["levels"].setdefault(level, {})[cls] = {"source": source, "diffs": diffs}
    gl2, gl3 = fp2[0]["globals"], fp3[0]["globals"]
    for field in sorted(set(gl2) | set(gl3)):
        if not same(gl2.get(field), gl3.get(field)):
            spec["globals"][field] = {"002": gl2.get(field), "003": gl3.get(field)}
    if out_json:
        with open(out_json, "w", encoding="utf-8", newline="\n") as f:
            json.dump(spec, f, indent=1, sort_keys=True)
            f.write("\n")
    report = render(spec)
    if out_md:
        with open(out_md, "w", encoding="utf-8", newline="\n") as f:
            f.write(report)
    else:
        print(report)


def short(v):
    if isinstance(v, str) and v.startswith("["):
        return "(%d colliders)" % len(json.loads(v))
    if isinstance(v, float):
        return "%.6g" % v
    if isinstance(v, list):
        return "[" + ", ".join(short(x) for x in v) + "]"
    return str(v)


def render(spec):
    lines = ["# Hard Mode spec: 0.0.2 vs 0.0.3 beast data", "",
             "Generated by `tools/dev/fingerprint_diff.py` from `fingerprint.py` output; do not edit.", ""]
    lines.append("## Global physics settings")
    lines.append("")
    if spec["globals"]:
        for k, v in spec["globals"].items():
            lines.append("- `%s`: 0.0.2 %s, 0.0.3 %s" % (k, short(v["002"]), short(v["003"])))
    else:
        lines.append("Identical (gravity, solver iterations, sleep thresholds, max angular velocity, layer matrix, timestep).")
    lines.append("")
    for level, classes in sorted(spec["levels"].items()):
        lines.append("## %s" % level)
        lines.append("")
        for cls, entry in sorted(classes.items()):
            diffs = entry["diffs"]
            lines.append("### %s (%s values, %d fields differ)" % (cls, "0.0.2 " + level if entry["source"] == "level" else "generic 0.0.2", len(diffs)))
            lines.append("")
            collapsed = {}
            for field, v in diffs.items():
                key = (pattern(field), short(v["002"]), short(v["003"]))
                collapsed.setdefault(key, []).append(field.split(".")[1] if field.startswith("parts.") else "")
            for (pat, a, b), parts in sorted(collapsed.items()):
                where = ""
                if pat.startswith("parts.*"):
                    where = " on " + (", ".join(p or "(root)" for p in parts) if len(parts) <= 4 else "%d parts" % len(parts))
                lines.append("- `%s`%s: 0.0.2 %s, 0.0.3 %s" % (pat, where, a, b))
            lines.append("")
    if spec["varies"]:
        lines.append("## Fields that differ between beasts of one class (not in the spec)")
        lines.append("")
        for group, fields in sorted(spec["varies"].items()):
            lines.append("- %s: %s" % (group, ", ".join("`%s`" % f for f in sorted(fields))))
        lines.append("")
    return "\n".join(lines)


if __name__ == "__main__":
    main(sys.argv[1:])
