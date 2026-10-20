// relayout: rearranges decompiled C# so smcs reproduces the original metadata layout.
//
//   relayout genmap <original.dll>                         default layout map on stdout
//   relayout check  <original.dll> <map>                   verify the map's sorted file order
//   relayout apply  <original.dll> <srcdir> <map> <outdir> write regrouped, reordered sources
//   relayout fixup  <srcdir>                               rewrite systematic decompiler idioms in place
//
// Layout map lines:  <path under Assets/>: <TopLevelType> [<TopLevelType> ...]
// Unity 4.3.2 hands script files to the compiler in ordinal path order, smcs emits
// TypeDefs in file order, then each type's fields/methods in declaration order.
// (REVERSE_ATTRS=1 reverses attribute lists; Mono's unstable CustomAttribute sort makes
// that only a heuristic, so it is off by default.)
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.PortableExecutable;
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

static class Program
{
    static int Main(string[] args)
    {
        if (args[0] == "fixup") return Fixup.Run(args[1]);
        var meta = new Meta(args[1]);
        switch (args[0])
        {
            case "genmap":
                foreach (var t in meta.TopLevel) Console.WriteLine($"{t.Replace('.', '/').Replace('`', '_')}.cs: {t}");
                return 0;
            case "check": return Check(meta, Map.Load(args[2])) ? 0 : 1;
            case "apply":
                var map = Map.Load(args[3]);
                if (!Check(meta, map)) return 1;
                return Apply(meta, args[2], map, args[4]);
        }
        return 2;
    }

    static bool Check(Meta meta, List<(string Path, List<string> Types)> map)
    {
        var sorted = map.OrderBy(e => "Assets/" + e.Path, StringComparer.Ordinal).SelectMany(e => e.Types).ToList();
        var dupPaths = map.GroupBy(e => e.Path).Where(g => g.Count() > 1).Select(g => g.Key).ToList();
        foreach (var d in dupPaths) Console.Error.WriteLine($"duplicate path {d}");
        if (sorted.SequenceEqual(meta.TopLevel) && dupPaths.Count == 0) return true;
        for (int i = 0; i < Math.Max(sorted.Count, meta.TopLevel.Count); i++)
            if (i >= sorted.Count || i >= meta.TopLevel.Count || sorted[i] != meta.TopLevel[i])
            {
                Console.Error.WriteLine($"layout order mismatch at #{i}: map gives {(i < sorted.Count ? sorted[i] : "-")}, metadata has {(i < meta.TopLevel.Count ? meta.TopLevel[i] : "-")}");
                break;
            }
        return false;
    }

    static int Apply(Meta meta, string srcDir, List<(string Path, List<string> Types)> map, string outDir)
    {
        // Index every top-level type declaration in the decompiled tree.
        var decls = new Dictionary<string, (BaseTypeDeclarationSyntax Decl, CompilationUnitSyntax Unit)>();
        var delegates = new Dictionary<string, (DelegateDeclarationSyntax Decl, CompilationUnitSyntax Unit)>();
        foreach (var file in Directory.EnumerateFiles(srcDir, "*.cs", SearchOption.AllDirectories))
        {
            var unit = (CompilationUnitSyntax)CSharpSyntaxTree.ParseText(File.ReadAllText(file), new CSharpParseOptions(LanguageVersion.CSharp3)).GetRoot();
            foreach (var m in unit.DescendantNodes().OfType<MemberDeclarationSyntax>())
            {
                if (m.Parent is TypeDeclarationSyntax) continue;
                string ns = m.Ancestors().OfType<BaseNamespaceDeclarationSyntax>().FirstOrDefault()?.Name.ToString() ?? "";
                string Full(string name, int arity) => (ns.Length > 0 ? ns + "." : "") + name + (arity > 0 ? "`" + arity : "");
                if (m is BaseTypeDeclarationSyntax bt)
                    decls[Full(bt.Identifier.Text, (bt as TypeDeclarationSyntax)?.TypeParameterList?.Parameters.Count ?? 0)] = (bt, unit);
                else if (m is DelegateDeclarationSyntax dd)
                    delegates[Full(dd.Identifier.Text, dd.TypeParameterList?.Parameters.Count ?? 0)] = (dd, unit);
            }
        }
        int problems = 0;
        foreach (var (path, types) in map)
        {
            var usings = new SortedSet<string>(StringComparer.Ordinal);
            var body = new StringBuilder();
            string? currentNs = null;
            foreach (var t in types)
            {
                MemberDeclarationSyntax decl; CompilationUnitSyntax unit;
                if (decls.TryGetValue(t, out var d)) { decl = Reorder(meta, t, d.Decl, ref problems); unit = d.Unit; }
                else if (delegates.TryGetValue(t, out var dg)) { decl = ReverseAttributes(dg.Decl); unit = dg.Unit; }
                else { Console.Error.WriteLine($"no declaration for {t}"); problems++; continue; }
                foreach (var u in unit.Usings) usings.Add(u.ToString().Trim());
                string ns = t.Contains('.') ? t[..t.LastIndexOf('.')] : "";
                if (ns != currentNs)
                {
                    if (!string.IsNullOrEmpty(currentNs)) body.Append("}\n");
                    if (ns.Length > 0) body.Append($"namespace {ns}\n{{\n");
                    currentNs = ns;
                }
                var text = decl.ToFullString().Trim('\r', '\n').Replace("\r\n", "\n");
                if (ns.Length > 0) text = string.Join("\n", text.Split('\n').Select(l => l.Length > 0 ? "\t" + l : l));
                body.Append(text).Append("\n\n");
            }
            if (!string.IsNullOrEmpty(currentNs)) body.Append("}\n");
            var outPath = Path.Combine(outDir, path);
            Directory.CreateDirectory(Path.GetDirectoryName(outPath)!);
            var header = string.Join("\n", usings) + (usings.Count > 0 ? "\n\n" : "");
            var content = header + body.ToString().TrimEnd('\n') + "\n";
            var bytes = Encoding.UTF8.GetBytes(content);
            if (bytes.Any(b => b > 0x7f)) bytes = Encoding.UTF8.GetPreamble().Concat(bytes).ToArray();
            File.WriteAllBytes(outPath, bytes);
        }
        Console.Error.WriteLine($"relayout: {map.Count} files written, {problems} problem(s)");
        return problems == 0 ? 0 : 1;
    }

    // Multiple attributes on one target are written to metadata in reverse source order,
    // so the source order is the reverse of the (decompiler-preserved) metadata order.
    static readonly bool ReverseAttrs = Environment.GetEnvironmentVariable("REVERSE_ATTRS") == "1";
    static T ReverseAttributes<T>(T node) where T : MemberDeclarationSyntax
    {
        if (!ReverseAttrs) return node;
        var lists = node.AttributeLists;
        var attrs = lists.SelectMany(l => l.Attributes).ToList();
        if (attrs.Count < 2) return node;
        var trivia = lists[0].GetLeadingTrivia();
        var indent = lists.Last().GetLeadingTrivia().Where(t => t.IsKind(SyntaxKind.WhitespaceTrivia)).ToList();
        attrs.Reverse();
        var newLists = attrs.Select((a, i) =>
        {
            var l = SyntaxFactory.AttributeList(SyntaxFactory.SingletonSeparatedList(a.WithoutTrivia()))
                .WithTrailingTrivia(SyntaxFactory.EndOfLine("\n"));
            return i == 0 ? l.WithLeadingTrivia(trivia) : l.WithLeadingTrivia(indent);
        });
        return (T)node.WithAttributeLists(SyntaxFactory.List(newLists));
    }

    static MemberDeclarationSyntax Reorder(Meta meta, string fullName, BaseTypeDeclarationSyntax decl, ref int problems)
    {
        decl = ReverseAttributes(decl);
        if (decl is not TypeDeclarationSyntax td) return decl;
        if (!meta.Types.TryGetValue(fullName, out var info)) { Console.Error.WriteLine($"metadata has no type {fullName}"); problems++; return decl; }

        var members = td.Members.ToList();
        var fieldOrder = info.Fields;   // field names in FieldDef order
        var methodOrder = info.Methods; // (name, param type simple names) in MethodDef order
        var keyed = new List<(MemberDeclarationSyntax Node, int Field, int Method, int Nested)>();
        foreach (var raw in members)
        {
            var m = raw is TypeDeclarationSyntax nested ? (MemberDeclarationSyntax)Reorder(meta, fullName + "/" + NestedName(nested), nested, ref problems) : ReverseMemberAttributes(raw);
            int f = -1, me = -1, n = -1;
            switch (m)
            {
                case BaseTypeDeclarationSyntax bt:
                    n = info.Nested.IndexOf(NestedName(bt)); break;
                case DelegateDeclarationSyntax dd:
                    n = info.Nested.IndexOf(dd.Identifier.Text); break;
                case FieldDeclarationSyntax fd:
                    f = fieldOrder.IndexOf(fd.Declaration.Variables[0].Identifier.Text); break;
                case EventFieldDeclarationSyntax ef:
                    f = fieldOrder.IndexOf(ef.Declaration.Variables[0].Identifier.Text);
                    me = FindMethod(methodOrder, "add_" + ef.Declaration.Variables[0].Identifier.Text, null); break;
                case PropertyDeclarationSyntax pd:
                {
                    var name = pd.ExplicitInterfaceSpecifier != null ? pd.ExplicitInterfaceSpecifier.Name + "." + pd.Identifier.Text : pd.Identifier.Text;
                    var first = pd.AccessorList?.Accessors.FirstOrDefault();
                    me = FindAccessor(methodOrder, name, pd.AccessorList);
                    bool auto = pd.AccessorList != null && pd.AccessorList.Accessors.All(a => a.Body == null);
                    if (auto) f = fieldOrder.IndexOf($"<{pd.Identifier.Text}>k__BackingField");
                    break;
                }
                case IndexerDeclarationSyntax ix:
                    me = FindAccessor(methodOrder, "Item", ix.AccessorList); break;
                case EventDeclarationSyntax ed:
                    me = FindMethod(methodOrder, "add_" + ed.Identifier.Text, null); break;
                case ConstructorDeclarationSyntax cd:
                    me = FindMethod(methodOrder, cd.Modifiers.Any(SyntaxKind.StaticKeyword) ? ".cctor" : ".ctor", cd.ParameterList); break;
                case DestructorDeclarationSyntax:
                    me = FindMethod(methodOrder, "Finalize", null); break;
                case MethodDeclarationSyntax md:
                {
                    var name = md.ExplicitInterfaceSpecifier != null ? md.ExplicitInterfaceSpecifier.Name + "." + md.Identifier.Text : md.Identifier.Text;
                    me = FindMethod(methodOrder, name, md.ParameterList, md.TypeParameterList?.Parameters.Count ?? 0); break;
                }
                case OperatorDeclarationSyntax op:
                    me = FindMethod(methodOrder, OperatorName(op), op.ParameterList); break;
                case ConversionOperatorDeclarationSyntax co:
                    me = FindMethod(methodOrder, co.ImplicitOrExplicitKeyword.IsKind(SyntaxKind.ImplicitKeyword) ? "op_Implicit" : "op_Explicit", co.ParameterList); break;
            }
            if (f < 0 && me < 0 && n < 0 && m is not EnumMemberDeclarationSyntax)
            { Console.Error.WriteLine($"  unplaced member in {fullName}: {m.ToString().Split('\n')[0].Trim()}"); problems++; }
            keyed.Add((m, f, me, n));
        }
        if (td is not TypeDeclarationSyntax || decl is EnumDeclarationSyntax) return decl;

        // Nested types first (their position does not affect tokens), then a merge of the
        // field sequence and the method sequence that respects members carrying both.
        var nestedTypes = keyed.Where(k => k.Nested >= 0).OrderBy(k => k.Nested).Select(k => k.Node).ToList();
        var rest = keyed.Where(k => k.Nested < 0).ToList();
        var byField = rest.Where(k => k.Field >= 0).OrderBy(k => k.Field).ToList();
        var byMethod = rest.Where(k => k.Method >= 0 && k.Field < 0).OrderBy(k => k.Method).ToList();
        var ordered = new List<MemberDeclarationSyntax>(nestedTypes);
        int mi = 0;
        foreach (var fk in byField)
        {
            if (fk.Method >= 0)
                while (mi < byMethod.Count && byMethod[mi].Method < fk.Method) ordered.Add(byMethod[mi++].Node);
            ordered.Add(fk.Node);
        }
        while (mi < byMethod.Count) ordered.Add(byMethod[mi++].Node);
        ordered.AddRange(rest.Where(k => k.Field < 0 && k.Method < 0).Select(k => k.Node));
        return td.WithMembers(SyntaxFactory.List(ordered));
    }

    static MemberDeclarationSyntax ReverseMemberAttributes(MemberDeclarationSyntax m) => ReverseAttributes(m);

    static string NestedName(BaseTypeDeclarationSyntax t) =>
        t.Identifier.Text + ((t as TypeDeclarationSyntax)?.TypeParameterList is { } tp ? "`" + tp.Parameters.Count : "");

    static string OperatorName(OperatorDeclarationSyntax op)
    {
        int n = op.ParameterList.Parameters.Count;
        return op.OperatorToken.Kind() switch
        {
            SyntaxKind.PlusToken => n == 1 ? "op_UnaryPlus" : "op_Addition",
            SyntaxKind.MinusToken => n == 1 ? "op_UnaryNegation" : "op_Subtraction",
            SyntaxKind.AsteriskToken => "op_Multiply", SyntaxKind.SlashToken => "op_Division",
            SyntaxKind.PercentToken => "op_Modulus", SyntaxKind.EqualsEqualsToken => "op_Equality",
            SyntaxKind.ExclamationEqualsToken => "op_Inequality", SyntaxKind.LessThanToken => "op_LessThan",
            SyntaxKind.GreaterThanToken => "op_GreaterThan", SyntaxKind.LessThanEqualsToken => "op_LessThanOrEqual",
            SyntaxKind.GreaterThanEqualsToken => "op_GreaterThanOrEqual", SyntaxKind.ExclamationToken => "op_LogicalNot",
            SyntaxKind.TildeToken => "op_OnesComplement", SyntaxKind.TrueKeyword => "op_True", SyntaxKind.FalseKeyword => "op_False",
            SyntaxKind.AmpersandToken => "op_BitwiseAnd", SyntaxKind.BarToken => "op_BitwiseOr", SyntaxKind.CaretToken => "op_ExclusiveOr",
            SyntaxKind.LessThanLessThanToken => "op_LeftShift", SyntaxKind.GreaterThanGreaterThanToken => "op_RightShift",
            SyntaxKind.PlusPlusToken => "op_Increment", SyntaxKind.MinusMinusToken => "op_Decrement",
            _ => "op_?",
        };
    }

    static int FindAccessor(List<(string Name, List<string> Params, int Arity)> order, string prop, AccessorListSyntax? list)
    {
        var idx = new List<int>();
        foreach (var a in list?.Accessors ?? default)
        {
            string prefix = a.Keyword.IsKind(SyntaxKind.GetKeyword) ? "get_" : "set_";
            int dot = prop.LastIndexOf('.');
            string name = dot >= 0 ? prop[..(dot + 1)] + prefix + prop[(dot + 1)..] : prefix + prop;
            int i = order.FindIndex(o => NameMatches(o.Name, name));
            if (i >= 0) idx.Add(i);
        }
        return idx.Count == 0 ? -1 : idx.Min();
    }

    static int FindMethod(List<(string Name, List<string> Params, int Arity)> order, string name, BaseParameterListSyntax? ps, int arity = 0)
    {
        var cands = Enumerable.Range(0, order.Count).Where(i => order[i].Arity == arity && NameMatches(order[i].Name, name)).ToList();
        if (ps != null) cands = cands.Where(i => order[i].Params.Count == ps.Parameters.Count).ToList();
        if (cands.Count <= 1 || ps == null) return cands.Count == 0 ? -1 : cands[0];
        var syn = ps.Parameters.Select(p => Simple(p.Type?.ToString() ?? "")).ToList();
        var exact = cands.Where(i => order[i].Params.SequenceEqual(syn)).ToList();
        return exact.Count >= 1 ? exact[0] : cands[0];
    }

    // Explicit interface implementations are named "<full interface name>.<member>" in metadata
    // (e.g. "System.Collections.Generic.IEnumerable<Poly2Tri.Point2D>.GetEnumerator").
    static bool NameMatches(string meta, string syntax)
    {
        if (meta == syntax) return true;
        int sd = syntax.LastIndexOf('.');
        if (sd < 0) return false;
        string member = syntax[(sd + 1)..], iface = Simple(syntax[..sd]);
        if (!meta.EndsWith("." + member)) return false;
        return Simple(meta[..^(member.Length + 1)]) == iface;
    }

    // Reduces a type to a comparable simple form: last name segment, no generic args, arrays kept.
    public static string Simple(string t)
    {
        t = t.Replace(" ", "").Replace("ref", "").Replace("out", "").Replace("params", "");
        string suffix = "";
        while (t.EndsWith("]")) { int k = t.LastIndexOf('['); suffix = t[k..] + suffix; t = t[..k]; }
        if (t.EndsWith("&")) t = t[..^1];
        int lt = t.IndexOf('<'); if (lt >= 0) t = t[..lt];
        int dot = t.LastIndexOf('.'); if (dot >= 0) t = t[(dot + 1)..];
        t = t switch
        {
            "int" => "Int32", "uint" => "UInt32", "float" => "Single", "double" => "Double", "bool" => "Boolean", "string" => "String",
            "object" => "Object", "long" => "Int64", "ulong" => "UInt64", "short" => "Int16", "ushort" => "UInt16", "byte" => "Byte",
            "sbyte" => "SByte", "char" => "Char", "void" => "Void", "decimal" => "Decimal", _ => t,
        };
        return t + suffix;
    }
}

static class Map
{
    public static List<(string Path, List<string> Types)> Load(string file) =>
        File.ReadAllLines(file).Select(l => l.Trim()).Where(l => l.Length > 0 && !l.StartsWith("#"))
            .Select(l => { int c = l.LastIndexOf(".cs:", StringComparison.Ordinal) + 3; return (l[..c].Trim(), l[(c + 1)..].Split(' ', StringSplitOptions.RemoveEmptyEntries).ToList()); })
            .ToList();
}

sealed class TypeMeta
{
    public List<string> Fields = new();
    public List<(string Name, List<string> Params, int Arity)> Methods = new();
    public List<string> Nested = new();
}

sealed class Meta : ISignatureTypeProvider<string, object?>
{
    public readonly List<string> TopLevel = new();
    public readonly Dictionary<string, TypeMeta> Types = new();
    readonly MetadataReader md;

    public Meta(string path)
    {
        var pe = new PEReader(File.OpenRead(path));
        md = pe.GetMetadataReader();
        foreach (var th in md.TypeDefinitions)
        {
            var td = md.GetTypeDefinition(th);
            var name = FullName(th);
            if (name == "<Module>") continue;
            if (!td.IsNested && !md.GetString(td.Name).StartsWith("<")) TopLevel.Add(name);
            var tm = new TypeMeta();
            foreach (var fh in td.GetFields()) tm.Fields.Add(md.GetString(md.GetFieldDefinition(fh).Name));
            foreach (var mh in td.GetMethods())
            {
                var m = md.GetMethodDefinition(mh);
                var sig = m.DecodeSignature(this, null);
                tm.Methods.Add((md.GetString(m.Name), sig.ParameterTypes.Select(Program.Simple).ToList(), m.GetGenericParameters().Count));
            }
            foreach (var nh in td.GetNestedTypes()) tm.Nested.Add(md.GetString(md.GetTypeDefinition(nh).Name));
            Types[name] = tm;
        }
    }

    string FullName(TypeDefinitionHandle h)
    {
        var t = md.GetTypeDefinition(h);
        if (t.IsNested) return FullName(t.GetDeclaringType()) + "/" + md.GetString(t.Name);
        var ns = md.GetString(t.Namespace);
        return (ns.Length > 0 ? ns + "." : "") + md.GetString(t.Name);
    }

    public string GetArrayType(string e, ArrayShape s) => e + "[" + new string(',', s.Rank - 1) + "]";
    public string GetByReferenceType(string e) => e + "&";
    public string GetFunctionPointerType(MethodSignature<string> s) => "fnptr";
    public string GetGenericInstantiation(string g, System.Collections.Immutable.ImmutableArray<string> a) => g;
    public string GetGenericMethodParameter(object? c, int i) => "!!" + i;
    public string GetGenericTypeParameter(object? c, int i) => "!" + i;
    public string GetModifiedType(string m, string u, bool r) => u;
    public string GetPinnedType(string e) => e;
    public string GetPointerType(string e) => e + "*";
    public string GetPrimitiveType(PrimitiveTypeCode t) => t.ToString();
    public string GetSZArrayType(string e) => e + "[]";
    public string GetTypeFromDefinition(MetadataReader r, TypeDefinitionHandle h, byte k) => md.GetString(md.GetTypeDefinition(h).Name).Split('`')[0];
    public string GetTypeFromReference(MetadataReader r, TypeReferenceHandle h, byte k) => md.GetString(md.GetTypeReference(h).Name).Split('`')[0];
    public string GetTypeFromSpecification(MetadataReader r, object? c, TypeSpecificationHandle h, byte k) => md.GetTypeSpecification(h).DecodeSignature(this, null);
}

// Systematic decompiler idioms whose source form compiles differently under smcs.
static class Fixup
{
    public static int Run(string dir)
    {
        int changed = 0;
        foreach (var file in Directory.EnumerateFiles(dir, "*.cs", SearchOption.AllDirectories))
        {
            var bytes = File.ReadAllBytes(file);
            bool bom = bytes.Length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF;
            var text = Encoding.UTF8.GetString(bytes, bom ? 3 : 0, bytes.Length - (bom ? 3 : 0));
            var root = CSharpSyntaxTree.ParseText(text, new CSharpParseOptions(LanguageVersion.CSharp3)).GetRoot();
            var newRoot = new Rewriter().Visit(root);
            if (newRoot.ToFullString() == text) continue;
            var outBytes = Encoding.UTF8.GetBytes(newRoot.ToFullString());
            File.WriteAllBytes(file, bom ? Encoding.UTF8.GetPreamble().Concat(outBytes).ToArray() : outBytes);
            changed++;
        }
        Console.Error.WriteLine($"fixup: {changed} file(s) changed");
        return 0;
    }

    sealed class Rewriter : CSharpSyntaxRewriter
    {
        public override SyntaxNode? VisitBinaryExpression(BinaryExpressionSyntax node)
        {
            var n = (BinaryExpressionSyntax)base.VisitBinaryExpression(node)!;
            // ILSpy prints IL `neg` as `0f - x` / `0.0 - x`; the source was unary minus.
            if (n.IsKind(SyntaxKind.SubtractExpression) && n.Left is LiteralExpressionSyntax lit &&
                (lit.Token.Text == "0f" || lit.Token.Text == "0.0" || lit.Token.Text == "0.0f"))
            {
                ExpressionSyntax operand = n.Right is BinaryExpressionSyntax or ConditionalExpressionSyntax or CastExpressionSyntax
                    ? SyntaxFactory.ParenthesizedExpression(n.Right.WithoutTrivia()) : n.Right.WithoutTrivia();
                return SyntaxFactory.PrefixUnaryExpression(SyntaxKind.UnaryMinusExpression, operand).WithTriviaFrom(n);
            }
            return n;
        }
    }
}
