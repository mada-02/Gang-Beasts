"""Writes copies of assemblies whose framework AssemblyRefs are retargeted to the
Unity 4.3 "unity" profile identity (2.0.5.0, token 7cec85d7bea7798e).

    retarget_refs.py <out-dir> <dll>...

Only used to let Roslyn (the autofix pre-filter) bind code the way smcs does; smcs
unifies 2.0.0.0 / 3.5.0.0 / 2.0.5.0 framework references itself. The real builds
never see these copies. Patches are in place (same-length version fields and 8-byte
public-key-token blobs)."""
import os, struct, sys

FRAMEWORK = {'mscorlib', 'System', 'System.Core', 'System.Xml', 'Mono.Security', 'System.Xml.Linq', 'System.Runtime.Serialization'}
UNITY_TOKEN = bytes.fromhex('7cec85d7bea7798e')


def rva_to_off(sections, rva):
    for va, vs, raw, rs in sections:
        if va <= rva < va + max(vs, rs):
            return raw + rva - va
    raise ValueError(rva)


def patch(data):
    data = bytearray(data)
    pe = struct.unpack_from('<I', data, 0x3C)[0]
    coff = pe + 4
    nsect, = struct.unpack_from('<H', data, coff + 2)
    optsz, = struct.unpack_from('<H', data, coff + 16)
    opt = coff + 20
    magic, = struct.unpack_from('<H', data, opt)
    dd = opt + (96 if magic == 0x10B else 112)
    cli_rva, = struct.unpack_from('<I', data, dd + 14 * 8)
    sections = []
    for i in range(nsect):
        s = opt + optsz + 40 * i
        vs, va, rs, raw = struct.unpack_from('<IIII', data, s + 8)
        sections.append((va, vs, raw, rs))
    cli = rva_to_off(sections, cli_rva)
    md = rva_to_off(sections, struct.unpack_from('<I', data, cli + 8)[0])
    vlen, = struct.unpack_from('<I', data, md + 12)
    p = md + 16 + vlen
    n, = struct.unpack_from('<H', data, p + 2)
    p += 4
    streams = {}
    for _ in range(n):
        off, size = struct.unpack_from('<II', data, p)
        e = data.index(b'\0', p + 8)
        streams[data[p + 8:e].decode()] = md + off
        p = (e + 4) & ~3
    t = streams['#~']
    hs = data[t + 6]
    si, gi, bi = (4 if hs & 1 else 2), (4 if hs & 2 else 2), (4 if hs & 4 else 2)
    valid, = struct.unpack_from('<Q', data, t + 8)
    rows = {}
    q = t + 24
    for i in range(64):
        if valid >> i & 1:
            rows[i] = struct.unpack_from('<I', data, q)[0]
            q += 4

    def idx(table):
        return 4 if rows.get(table, 0) > 0xFFFF else 2

    def coded(tables, bits):
        return 4 if max(rows.get(x, 0) for x in tables) >= (1 << (16 - bits)) else 2

    # Row sizes for tables 0..0x23 (enough to reach AssemblyRef = 0x23).
    tdor = coded([2, 1, 0x1B], 2); rs_ = coded([0, 0x1A, 0x23, 1], 2); mrp = coded([2, 1, 0x1A, 6, 0x1B], 3)
    hc = coded([4, 8, 0x17], 2); hca = coded([6, 4, 1, 2, 8, 9, 0x0A, 0, 0x0E, 0x17, 0x14, 0x11, 0x1A, 0x1B, 0x20, 0x23, 0x26, 0x27, 0x28, 0x2A, 0x2C, 0x2B], 5)
    cat = coded([6, 0x0A, 0x0A, 0x0A, 0x0A], 3); hfm = coded([4, 8], 1); hds = coded([2, 6, 0x20], 2)
    hs_ = coded([0x14, 0x17], 1); ms = coded([6, 0x0A], 1); mf = coded([4, 6], 1)
    size = {
        0x00: 2 + si + gi * 3, 0x01: rs_ + si * 2, 0x02: 4 + si * 2 + tdor + idx(4) + idx(6), 0x03: idx(4),
        0x04: 2 + si + bi, 0x05: idx(6), 0x06: 4 + 2 + 2 + si + bi + idx(8), 0x07: idx(8), 0x08: 2 + 2 + si,
        0x09: idx(2) + tdor, 0x0A: mrp + si + bi, 0x0B: 2 + hc + bi, 0x0C: hca + cat + bi, 0x0D: hfm + bi,
        0x0E: 2 + hds + bi, 0x0F: 2 + 4 + idx(2), 0x10: 4 + idx(4), 0x11: bi, 0x12: idx(2) + idx(0x14),
        0x13: idx(0x14), 0x14: 2 + si + tdor, 0x15: idx(2) + idx(0x17), 0x16: idx(0x17), 0x17: 2 + si + bi,
        0x18: 2 + idx(6) + hs_, 0x19: idx(2) + ms * 2, 0x1A: si, 0x1B: bi, 0x1C: 2 + mf + si + idx(0x1A),
        0x1D: 4 + idx(4), 0x1E: 4 + 4, 0x1F: 4, 0x20: 4 + 8 + 4 + bi + si * 2, 0x21: 4, 0x22: 4 * 3 + 4,
    }
    off = q
    for i in range(0x23):
        off += rows.get(i, 0) * size[i]
    blob = streams['#Blob']; strings = streams['#Strings']
    rowsize = 8 + 4 + bi + si * 2 + bi
    changed = []
    for r in range(rows.get(0x23, 0)):
        row = off + r * rowsize
        pk = int.from_bytes(data[row + 12:row + 12 + bi], 'little')
        name_i = int.from_bytes(data[row + 12 + bi:row + 12 + bi + si], 'little')
        name = data[strings + name_i:data.index(b'\0', strings + name_i)].decode()
        if name not in FRAMEWORK:
            continue
        struct.pack_into('<HHHH', data, row, 2, 0, 5, 0)
        b = blob + pk
        if data[b] == 8:
            data[b + 1:b + 9] = UNITY_TOKEN
        changed.append(name)
    return bytes(data), changed


if __name__ == '__main__':
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for f in sys.argv[2:]:
        d, ch = patch(open(f, 'rb').read())
        open(os.path.join(out, os.path.basename(f)), 'wb').write(d)
        print(os.path.basename(f), 'retargeted:', ch)
