"""Rewrites ILSpy renderings of UnityScript idioms back into UnityScript source form.

    usidioms.py <dir>...

* for-in over arrays: Boo lowers `for (var x : T in expr) body` to an index loop over a
  hoisted array (with `x` uses rewritten to `array[i]`, but `x` still declared), which
  ILSpy shows as
      var i : int = 0;
      var arr : T[] = expr;
      for (var length : int = arr.Length; i < length; i++) { ... arr[i] ... }
* `!a == null` (a cs2us precedence slip for !RuntimeServices.EqualityOperator(a, null)) -> `a != null`
* `Extensions.get_length((x as System.Array))` -> `x.length` (UnityScript array length)
* `UnityScript.Lang.Array((x as IEnumerable))` -> `new Array(x)`
"""
import re, sys, pathlib

FOR = re.compile(
    r'^(?P<ind>\t*)var (?P<i>\w+) : int = 0;\n'
    r'(?P=ind)var (?P<arr>\w+) : (?P<T>[\w.]+)\[\] = (?P<expr>[^\n]+);\n'
    r'(?P=ind)for \(var (?P<len>\w+) : int = (?P=arr)\.Length; (?P=i) < (?P=len); (?P=i)\+\+\) \{\n', re.M)


def item_name(t, used):
    base = {'GameObject': 'obj', 'Transform': 't', 'Mesh': 'm', 'Material': 'mat', 'Renderer': 'r'}.get(t.split('.')[-1], 'item')
    name, n = base, 2
    while name in used:
        name, n = f'{base}{n}', n + 1
    return name


RESULT = re.compile(r'^(?P<ind>\t*)var result : (?P<T>[\w.]+);\n', re.M)


def returns(s):
    """Boo compiles each `return x;` as a branch to one shared ret; ILSpy renders that as a
    `result` local assigned on every path (an int for boolean functions). Restore returns."""
    out, pos = [], 0
    for m in RESULT.finditer(s):
        ind = m.group('ind')
        # function body end: first line "<ind[:-1]>}" after the declaration
        end = re.compile('^' + ind[:-1] + r'\}\n', re.M).search(s, m.end())
        body = s[m.end():end.start()]
        last = re.search(r'\n?' + ind + r'return (result != 0|\(?result(?: as [\w.]+)?\)?);\n$', body)
        if not last:
            continue
        boolean = m.group('T') == 'int' and last.group(1) == 'result != 0'
        inner = body[:last.start()] + '\n'
        def conv(mm):
            v = mm.group('v').strip()
            if boolean and v in ('0', '1'):
                v = 'false' if v == '0' else 'true'
            return f"{mm.group('i')}return {v};"
        inner2 = re.sub(r'(?P<i>\t*)result = (?P<v>[^;\n]+);', conv, inner)
        if re.search(r'\bresult\b', inner2):
            continue  # some other use of result: leave it for manual work
        out.append(s[pos:m.start()] + inner2.rstrip('\n') + '\n')
        pos = end.start()
    out.append(s[pos:])
    return ''.join(out)


LOGIC = re.compile(
    r'^(?P<ind>\t*)var (?P<f>\w+) : boolean = (?P<a>[^;\n]+);\n'
    r'(?P=ind)if \((?P<neg>!?)(?P=f)\) \{\n(?P=ind)\t(?P=f) = (?P<b>[^;\n]+);\n(?P=ind)\}\n', re.M)
COPY = r'^(?P<ind>\t*)var (?P<y>\w+) : boolean = {f};\n'


def logic(s):
    """Boo evaluates `a || b` / `a && b` as a value (dup/brtrue/pop); ILSpy expands it to
    `var f = a; if (!f) f = b;` (|| ) or `if (f) f = b;` (&&), often followed by a copy."""
    while True:
        m = LOGIC.search(s)
        if not m:
            return s
        op = '||' if m.group('neg') else '&&'
        expr = f"{m.group('a')} {op} {m.group('b')}"
        rest = s[m.end():]
        c = re.match(COPY.format(f=re.escape(m.group('f'))), rest, re.M)
        f_used_after = lambda tail: re.search(r'\b' + re.escape(m.group('f')) + r'\b', tail)
        asg = re.match(r'(?P<ind>\t*)(?P<t>[\w.\[\]]+) = ' + re.escape(m.group('f')) + r';\n', rest)
        if asg and asg.group('t') != m.group('f') and not f_used_after(rest[asg.end():]):
            s = s[:m.start()] + f"{m.group('ind')}{asg.group('t')} = {expr};\n" + rest[asg.end():]
        elif c and not re.search(r'\b' + re.escape(m.group('f')) + r'\b', rest[c.end():]):
            s = s[:m.start()] + f"{m.group('ind')}var {c.group('y')} : boolean = ({expr});\n" + rest[c.end():]
        else:
            s = s[:m.start()] + f"{m.group('ind')}var {m.group('f')} : boolean = ({expr});\n" + rest


VALCOPY = re.compile(r'^(?P<ind>\t*)var (?P<f>\w+) : boolean = \((?P<e>[^;\n]+)\);\n(?P=ind)(?P<t>[\w.\[\]]+) = (?P=f);\n', re.M)


def collapse(s):
    """`var f : boolean = (a && b); target = f;` (f otherwise unused) -> `target = a && b;`"""
    pos = 0
    while True:
        m = VALCOPY.search(s, pos)
        if not m:
            return s
        if m.group('t') != m.group('f') and not re.search(r'\b' + re.escape(m.group('f')) + r'\b', s[m.end():]):
            s = s[:m.start()] + f"{m.group('ind')}{m.group('t')} = {m.group('e')};\n" + s[m.end():]
        else:
            pos = m.end()


def rewrite(s):
    s = returns(s)
    s = logic(s)
    s = collapse(s)
    while True:
        m = FOR.search(s)
        if not m:
            break
        ind = m.group('ind')
        # find the loop body end: the line "<ind>}" closing the for
        close = re.compile('^' + ind + r'\}\n', re.M).search(s, m.end())
        body = s[m.end():close.start()]
        arr, i = m.group('arr'), m.group('i')
        used = set(re.findall(r'\b\w+\b', s))
        name = item_name(m.group('T'), used)
        body2 = re.sub(r'\b' + re.escape(arr) + r'\[' + re.escape(i) + r'\]', name, body)
        if re.search(r'\b' + re.escape(arr) + r'\b', body2) or re.search(r'\b' + re.escape(i) + r'\b', body2):
            # the body uses the index or array directly: not a plain for-in
            s = s[:m.start()] + s[m.start():m.end()].replace('var ' + i + ' : int = 0;', 'var ' + i + ' : int = 0; ', 1) + s[m.end():]
            break
        head = f"{ind}for (var {name} : {m.group('T')} in {m.group('expr')}) {{\n"
        s = s[:m.start()] + head + body2 + s[close.start():]
    s = re.sub(r'!([A-Za-z_][\w.\[\]]*) == null', r'\1 != null', s)
    s = re.sub(r'Extensions\.get_length\(\(([^()]+) as System\.Array\)\)', r'\1.length', s)
    s = re.sub(r'UnityScript\.Lang\.Array\(\(([^()]+) as IEnumerable\)\)', r'new Array(\1)', s)
    return s


for root in sys.argv[1:]:
    for p in pathlib.Path(root).rglob('*.js'):
        raw = p.read_bytes(); bom = raw.startswith(b'\xef\xbb\xbf')
        s = raw[3 if bom else 0:].decode('utf-8')
        t = rewrite(s)
        if t != s:
            p.write_bytes((b'\xef\xbb\xbf' if bom else b'') + t.encode('utf-8'))
            print('rewrote', p)
