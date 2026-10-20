"""Rewrites the m_AssemblyName of one MonoScript object inside a Unity 4.x serialized file
(format 9) so asset tools can resolve it, without changing any other object.

    patch_monoscript_assembly.py <in-file> <out-file> <pathID> <old-name> <new-name>

Unity 4.3 wrote level10 of this build with one embedded MonoScript whose m_AssemblyName is
the assembly display name ("Assembly-CSharp, Version=0.0.0.0, ...") rather than
"Assembly-CSharp.dll". The rewritten object is appended at the end of the file and its
object-table entry is repointed; the original bytes are left in place. Only used on a
scratch copy for asset extraction; the shipped files are never modified.
"""
import struct, sys

src, dst, path_id, old, new = sys.argv[1], sys.argv[2], int(sys.argv[3]), sys.argv[4].encode(), sys.argv[5].encode()
data = bytearray(open(src, 'rb').read())
meta_size, file_size, version, data_offset = struct.unpack_from('>IIII', data, 0)
assert version == 9, f'unsupported serialized file version {version}'
big = data[16] != 0
e = '>' if big else '<'
# Object table entry (v9): pathID i32, byteStart u32, byteSize u32, typeID i32, classID i16, isDestroyed i16
entry = None
meta_end = 20 + meta_size
for off in range(20, meta_end - 20):
    pid, start, size, tid, cid, dead = struct.unpack_from(e + 'iIIihh', data, off)
    if pid == path_id and cid == 115 and data_offset + start + size <= len(data) and size < 4096:
        entry = (off, start, size)
        break
assert entry, 'object table entry not found'
off, start, size = entry
obj = bytes(data[data_offset + start:data_offset + start + size])
needle = struct.pack(e + 'I', len(old)) + old
i = obj.index(needle)
pad_old = (4 - len(old) % 4) % 4
pad_new = (4 - len(new) % 4) % 4
new_obj = obj[:i] + struct.pack(e + 'I', len(new)) + new + b'\0' * pad_new + obj[i + 4 + len(old) + pad_old:]
# append, 8-byte aligned
while len(data) % 8:
    data.append(0)
new_start = len(data) - data_offset
data += new_obj
struct.pack_into(e + 'II', data, off + 4, new_start, len(new_obj))
struct.pack_into('>I', data, 4, len(data))
open(dst, 'wb').write(data)
print(f'object {path_id}: {size} -> {len(new_obj)} bytes, moved to {new_start:#x}')
