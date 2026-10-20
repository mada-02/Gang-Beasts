using System.Collections.Immutable;
using System.Reflection;
using System.Reflection.Emit;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.PortableExecutable;
using System.Text;

public sealed class TypeInfo
{
    public int Token; public string FullName = ""; public string Attributes = ""; public string BaseType = "";
    public List<string> Interfaces = new(); public List<string> Fields = new(); public List<string> MethodKeys = new();
    public List<string> Properties = new(); public List<string> CustomAttributes = new();
}

public sealed class Method
{
    public string Key = "", TypeName = "", Name = ""; public int Token, Rva;
    public byte[] RawIL = Array.Empty<byte>(); public string RawLocals = ""; public string RawEH = "";
    public string Header = ""; public List<string> Normalized = new();
    // Normalized IL with branch targets expressed as instruction indices instead of offsets.
    public List<string> Indexed()
    {
        var idx = new Dictionary<string, int>();
        int n = 0;
        foreach (var l in Normalized) if (l.StartsWith("IL_")) idx[l[..7]] = n++;
        return Normalized.Select(l =>
        {
            var t = l.StartsWith("IL_") ? l[9..] : l;
            return System.Text.RegularExpressions.Regex.Replace(t, "IL_[0-9a-f]{4}", m => "L" + (idx.TryGetValue(m.Value, out var k) ? k : -1));
        }).ToList();
    }
    public bool RawEquals(Method o) => RawIL.AsSpan().SequenceEqual(o.RawIL) && RawLocals == o.RawLocals && RawEH == o.RawEH && Header == o.Header;
}

public sealed class Assembly
{
    readonly MetadataReader md; readonly PEReader pe;
    public readonly Dictionary<string, Method> Methods = new();
    public readonly List<TypeInfo> TypeOrder = new();
    public int UserStringHeapSize, MemberRefCount, TypeRefCount;
    static readonly Dictionary<short, OpCode> OpCodesByValue = typeof(OpCodes).GetFields(BindingFlags.Public | BindingFlags.Static)
        .Select(f => (OpCode)f.GetValue(null)!).ToDictionary(o => o.Value);
    readonly NameProvider names;

    public Assembly(string path)
    {
        pe = new PEReader(File.OpenRead(path));
        md = pe.GetMetadataReader();
        names = new NameProvider(md);
        UserStringHeapSize = md.GetHeapSize(HeapIndex.UserString);
        MemberRefCount = md.GetTableRowCount(TableIndex.MemberRef);
        TypeRefCount = md.GetTableRowCount(TableIndex.TypeRef);
        foreach (var th in md.TypeDefinitions)
        {
            var td = md.GetTypeDefinition(th);
            var ti = new TypeInfo
            {
                Token = MetadataTokens.GetToken(th), FullName = names.TypeDefName(th), Attributes = td.Attributes.ToString(),
                BaseType = td.BaseType.IsNil ? "-" : names.TypeName(td.BaseType),
            };
            foreach (var ih in td.GetInterfaceImplementations()) ti.Interfaces.Add(names.TypeName(md.GetInterfaceImplementation(ih).Interface));
            foreach (var fh in td.GetFields())
            {
                var f = md.GetFieldDefinition(fh);
                var c = f.GetDefaultValue();
                string constant = c.IsNil ? "" : " = " + Convert.ToHexString(md.GetBlobBytes(md.GetConstant(c).Value));
                string rvaData = (f.Attributes & FieldAttributes.HasFieldRVA) != 0 ? $" rvadata={FieldRvaHash(f)}" : "";
                ti.Fields.Add($"{f.Attributes} {f.DecodeSignature(names, null)} {md.GetString(f.Name)}{constant}{rvaData}{Attrs(f.GetCustomAttributes())}");
            }
            foreach (var ph in td.GetProperties())
            {
                var p = md.GetPropertyDefinition(ph);
                var acc = p.GetAccessors();
                ti.Properties.Add($"{md.GetString(p.Name)} get={(acc.Getter.IsNil ? "-" : md.GetString(md.GetMethodDefinition(acc.Getter).Name))} set={(acc.Setter.IsNil ? "-" : md.GetString(md.GetMethodDefinition(acc.Setter).Name))}{Attrs(p.GetCustomAttributes())}");
            }
            foreach (var eh in td.GetEvents()) ti.Properties.Add("event " + md.GetString(md.GetEventDefinition(eh).Name));
            ti.CustomAttributes.AddRange(AttrList(td.GetCustomAttributes()));
            foreach (var mh in td.GetMethods())
            {
                var m = ReadMethod(mh, ti.FullName);
                ti.MethodKeys.Add(m.Key);
                Methods[m.Key] = m;
            }
            TypeOrder.Add(ti);
        }
    }

    string FieldRvaHash(FieldDefinition f)
    {
        int rva = f.GetRelativeVirtualAddress();
        var data = pe.GetSectionData(rva).GetContent(0, 64);
        return Convert.ToHexString(System.Security.Cryptography.SHA256.HashData(data.ToArray()))[..12];
    }

    string Attrs(CustomAttributeHandleCollection c) { var l = AttrList(c); return l.Count == 0 ? "" : " [" + string.Join(", ", l) + "]"; }
    List<string> AttrList(CustomAttributeHandleCollection c) => c.Select(h =>
    {
        var ca = md.GetCustomAttribute(h);
        return names.MemberName(ca.Constructor) + "(" + Convert.ToHexString(md.GetBlobBytes(ca.Value)) + ")";
    }).ToList();

    Method ReadMethod(MethodDefinitionHandle mh, string typeName)
    {
        var def = md.GetMethodDefinition(mh);
        var sig = def.DecodeSignature(names, null);
        string gen = def.GetGenericParameters().Count > 0 ? "`" + def.GetGenericParameters().Count : "";
        var m = new Method
        {
            TypeName = typeName, Name = md.GetString(def.Name), Token = MetadataTokens.GetToken(mh), Rva = def.RelativeVirtualAddress,
        };
        m.Key = $"{typeName}::{m.Name}{gen}({string.Join(", ", sig.ParameterTypes)}) : {sig.ReturnType}";
        var paramNames = def.GetParameters().Select(p => md.GetParameter(p)).Select(p => $"{p.SequenceNumber}:{md.GetString(p.Name)}:{p.Attributes}").ToList();
        m.Header = $"{def.Attributes} {def.ImplAttributes} params[{string.Join(",", paramNames)}]{Attrs(def.GetCustomAttributes())}";
        if (def.RelativeVirtualAddress == 0) return m;
        var body = pe.GetMethodBody(def.RelativeVirtualAddress);
        m.RawIL = body.GetILBytes() ?? Array.Empty<byte>();
        m.RawLocals = body.LocalSignature.IsNil ? "" : Convert.ToHexString(md.GetBlobBytes(md.GetStandaloneSignature(body.LocalSignature).Signature)) + "@" + MetadataTokens.GetToken(body.LocalSignature);
        m.RawEH = string.Join(";", body.ExceptionRegions.Select(r => $"{r.Kind}:{r.TryOffset}+{r.TryLength}/{r.HandlerOffset}+{r.HandlerLength}/{(r.CatchType.IsNil ? 0 : MetadataTokens.GetToken(r.CatchType))}/{r.FilterOffset}"));
        m.Header += $" maxstack={body.MaxStack} initlocals={body.LocalVariablesInitialized}";
        if (!body.LocalSignature.IsNil)
        {
            var locals = md.GetStandaloneSignature(body.LocalSignature).DecodeLocalSignature(names, null);
            m.Normalized.Add(".locals (" + string.Join(", ", locals) + ")");
        }
        foreach (var r in body.ExceptionRegions)
            m.Normalized.Add($".try {r.TryOffset}+{r.TryLength} {r.Kind} {r.HandlerOffset}+{r.HandlerLength} {(r.CatchType.IsNil ? "" : names.TypeName(r.CatchType))}");
        m.Normalized.AddRange(Decode(m.RawIL));
        return m;
    }

    List<string> Decode(byte[] il)
    {
        var lines = new List<string>();
        int i = 0;
        while (i < il.Length)
        {
            int start = i;
            short v = il[i++];
            if (v == 0xFE) v = unchecked((short)(0xFE00 | il[i++]));
            var op = OpCodesByValue[v];
            string operand = "";
            switch (op.OperandType)
            {
                case OperandType.InlineNone: break;
                case OperandType.ShortInlineBrTarget: operand = "IL_" + (i + 1 + (sbyte)il[i]).ToString("x4"); i += 1; break;
                case OperandType.InlineBrTarget: operand = "IL_" + (i + 4 + BitConverter.ToInt32(il, i)).ToString("x4"); i += 4; break;
                case OperandType.ShortInlineI: operand = ((sbyte)il[i]).ToString(); i += 1; break;
                case OperandType.ShortInlineVar: operand = il[i].ToString(); i += 1; break;
                case OperandType.InlineVar: operand = BitConverter.ToUInt16(il, i).ToString(); i += 2; break;
                case OperandType.InlineI: operand = BitConverter.ToInt32(il, i).ToString(); i += 4; break;
                case OperandType.InlineI8: operand = BitConverter.ToInt64(il, i).ToString(); i += 8; break;
                case OperandType.ShortInlineR: operand = BitConverter.ToSingle(il, i).ToString("R"); i += 4; break;
                case OperandType.InlineR: operand = BitConverter.ToDouble(il, i).ToString("R"); i += 8; break;
                case OperandType.InlineSwitch:
                    int n = BitConverter.ToInt32(il, i); i += 4;
                    int baseOff = i + 4 * n;
                    var targets = new List<string>();
                    for (int k = 0; k < n; k++) { targets.Add("IL_" + (baseOff + BitConverter.ToInt32(il, i)).ToString("x4")); i += 4; }
                    operand = "(" + string.Join(",", targets) + ")"; break;
                case OperandType.InlineString:
                    operand = "\"" + md.GetUserString(MetadataTokens.UserStringHandle(BitConverter.ToInt32(il, i) & 0xFFFFFF)).Replace("\n", "\\n") + "\""; i += 4; break;
                case OperandType.InlineSig:
                    operand = "sig:" + Convert.ToHexString(md.GetBlobBytes(md.GetStandaloneSignature(MetadataTokens.StandaloneSignatureHandle(BitConverter.ToInt32(il, i) & 0xFFFFFF)).Signature)); i += 4; break;
                default: // tokens: method, field, type, tok
                    var h = MetadataTokens.EntityHandle(BitConverter.ToInt32(il, i)); i += 4;
                    operand = names.AnyName(h); break;
            }
            lines.Add($"IL_{start:x4}: {op.Name} {operand}".TrimEnd());
        }
        return lines;
    }
}

public sealed class NameProvider : ISignatureTypeProvider<string, object?>
{
    readonly MetadataReader md;
    public NameProvider(MetadataReader md) { this.md = md; }
    public string GetArrayType(string e, ArrayShape s) => e + "[" + new string(',', s.Rank - 1) + "]";
    public string GetByReferenceType(string e) => e + "&";
    public string GetFunctionPointerType(MethodSignature<string> s) => "fnptr";
    public string GetGenericInstantiation(string g, ImmutableArray<string> a) => g + "<" + string.Join(",", a) + ">";
    public string GetGenericMethodParameter(object? c, int i) => "!!" + i;
    public string GetGenericTypeParameter(object? c, int i) => "!" + i;
    public string GetModifiedType(string m, string u, bool r) => u + (r ? " modreq(" : " modopt(") + m + ")";
    public string GetPinnedType(string e) => e + " pinned";
    public string GetPointerType(string e) => e + "*";
    public string GetPrimitiveType(PrimitiveTypeCode t) => t.ToString();
    public string GetSZArrayType(string e) => e + "[]";
    public string GetTypeFromDefinition(MetadataReader r, TypeDefinitionHandle h, byte k) => TypeDefName(h);
    public string GetTypeFromReference(MetadataReader r, TypeReferenceHandle h, byte k) => TypeRefName(h);
    public string GetTypeFromSpecification(MetadataReader r, object? c, TypeSpecificationHandle h, byte k) => md.GetTypeSpecification(h).DecodeSignature(this, null);

    public string TypeDefName(TypeDefinitionHandle h)
    {
        var t = md.GetTypeDefinition(h);
        var name = md.GetString(t.Name);
        if (t.IsNested) return TypeDefName(t.GetDeclaringType()) + "/" + name;
        var ns = md.GetString(t.Namespace);
        return ns.Length > 0 ? ns + "." + name : name;
    }
    public string TypeRefName(TypeReferenceHandle h)
    {
        var t = md.GetTypeReference(h);
        var name = md.GetString(t.Name);
        if (t.ResolutionScope.Kind == HandleKind.TypeReference) return TypeRefName((TypeReferenceHandle)t.ResolutionScope) + "/" + name;
        var ns = md.GetString(t.Namespace);
        return ns.Length > 0 ? ns + "." + name : name;
    }
    public string TypeName(EntityHandle h) => h.Kind switch
    {
        HandleKind.TypeDefinition => TypeDefName((TypeDefinitionHandle)h),
        HandleKind.TypeReference => TypeRefName((TypeReferenceHandle)h),
        HandleKind.TypeSpecification => md.GetTypeSpecification((TypeSpecificationHandle)h).DecodeSignature(this, null),
        _ => h.Kind.ToString(),
    };
    public string MemberName(EntityHandle h)
    {
        switch (h.Kind)
        {
            case HandleKind.MethodDefinition:
            {
                var d = md.GetMethodDefinition((MethodDefinitionHandle)h);
                var s = d.DecodeSignature(this, null);
                return $"{s.ReturnType} {TypeDefName(d.GetDeclaringType())}::{md.GetString(d.Name)}({string.Join(",", s.ParameterTypes)})";
            }
            case HandleKind.MemberReference:
            {
                var r = md.GetMemberReference((MemberReferenceHandle)h);
                string parent = r.Parent.Kind switch
                {
                    HandleKind.MethodDefinition => MemberName(r.Parent),
                    HandleKind.ModuleReference => "module",
                    _ => TypeName(r.Parent),
                };
                if (r.GetKind() == MemberReferenceKind.Method)
                {
                    var s = r.DecodeMethodSignature(this, null);
                    return $"{s.ReturnType} {parent}::{md.GetString(r.Name)}({string.Join(",", s.ParameterTypes)})";
                }
                return $"{r.DecodeFieldSignature(this, null)} {parent}::{md.GetString(r.Name)}";
            }
            case HandleKind.MethodSpecification:
            {
                var s = md.GetMethodSpecification((MethodSpecificationHandle)h);
                return MemberName(s.Method) + "<" + string.Join(",", s.DecodeSignature(this, null)) + ">";
            }
            case HandleKind.FieldDefinition:
            {
                var f = md.GetFieldDefinition((FieldDefinitionHandle)h);
                return $"{f.DecodeSignature(this, null)} {TypeDefName(f.GetDeclaringType())}::{md.GetString(f.Name)}";
            }
        }
        return h.Kind.ToString();
    }
    public string AnyName(EntityHandle h) => h.Kind is HandleKind.TypeDefinition or HandleKind.TypeReference or HandleKind.TypeSpecification ? TypeName(h) : MemberName(h);
}
