"""Byte-level proof that a rebuilt assembly equals the shipped one.

Usage: verify.py <original.dll> <rebuilt.dll>

Passes only if both files have the same length and every differing byte lies inside
one of the two fields every compile regenerates:
  * the COFF header TimeDateStamp (4 bytes), and
  * the module MVID (the 16-byte GUID referenced by the Module table's Mvid column).
Exit status 0 = proven identical modulo those fields.
"""
import struct, sys


def rva_to_offset(sections, rva):
    for va, vsize, raw, rawsize in sections:
        if va <= rva < va + max(vsize, rawsize):
            return raw + (rva - va)
    raise ValueError(f'RVA {rva:#x} not in any section')


def regenerated_fields(data):
    pe = struct.unpack_from('<I', data, 0x3C)[0]
    assert data[pe:pe + 4] == b'PE\0\0', 'not a PE file'
    coff = pe + 4
    nsect = struct.unpack_from('<H', data, coff + 2)[0]
    opt_size = struct.unpack_from('<H', data, coff + 16)[0]
    timestamp = (coff + 4, 4)
    opt = coff + 20
    magic = struct.unpack_from('<H', data, opt)[0]
    dd = opt + (96 if magic == 0x10B else 112)
    cli_rva = struct.unpack_from('<I', data, dd + 14 * 8)[0]
    sec = opt + opt_size
    sections = []
    for i in range(nsect):
        s = sec + 40 * i
        vsize, va, rawsize, raw = struct.unpack_from('<IIII', data, s + 8)
        sections.append((va, vsize, raw, rawsize))
    cli = rva_to_offset(sections, cli_rva)
    md_rva = struct.unpack_from('<I', data, cli + 8)[0]
    md = rva_to_offset(sections, md_rva)
    assert data[md:md + 4] == b'BSJB'
    ver_len = struct.unpack_from('<I', data, md + 12)[0]
    p = md + 16 + ver_len
    nstreams = struct.unpack_from('<H', data, p + 2)[0]
    p += 4
    streams = {}
    for _ in range(nstreams):
        off, size = struct.unpack_from('<II', data, p)
        name_end = data.index(b'\0', p + 8)
        name = data[p + 8:name_end].decode()
        streams[name] = (md + off, size)
        p = (name_end + 4) & ~3
    tables_off = streams['#~'][0]
    heap_sizes = data[tables_off + 6]
    string_idx = 4 if heap_sizes & 1 else 2
    guid_idx = 4 if heap_sizes & 2 else 2
    valid = struct.unpack_from('<Q', data, tables_off + 8)[0]
    # Module is table 0, first row directly after the row-count array.
    nrows_tables = bin(valid).count('1')
    module_row = tables_off + 24 + 4 * nrows_tables
    mvid_index_off = module_row + 2 + string_idx  # Generation(2) + Name(string)
    mvid_index = int.from_bytes(data[mvid_index_off:mvid_index_off + guid_idx], 'little')
    guid_heap = streams['#GUID'][0]
    mvid = (guid_heap + 16 * (mvid_index - 1), 16)
    return {'TimeDateStamp': timestamp, 'MVID': mvid}


def main(a_path, b_path):
    a = open(a_path, 'rb').read()
    b = open(b_path, 'rb').read()
    if len(a) != len(b):
        print(f'FAIL size differs: {len(a)} vs {len(b)}')
        return 1
    fields = regenerated_fields(a)
    assert fields == regenerated_fields(b), 'field locations differ'
    allowed = set()
    for start, size in fields.values():
        allowed.update(range(start, start + size))
    diffs = [i for i in range(len(a)) if a[i] != b[i]]
    outside = [i for i in diffs if i not in allowed]
    if outside:
        print(f'FAIL {len(outside)} differing byte(s) outside regenerated fields, first at {outside[0]:#x}')
        return 1
    in_fields = {n: sum(1 for i in diffs if s <= i < s + z) for n, (s, z) in fields.items()}
    print(f'PASS {len(a)} bytes identical except regenerated fields {in_fields}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1], sys.argv[2]))
