// autofix: compiler-judged search for the source form of decompiled C# methods.
//
//   autofix <reconstruction-root> <Assembly-Name> [max-passes]
//
// For every method whose IL (tokens resolved) differs from the original, autofix
// proposes single-site rewrites of control-flow idioms that ILSpy normalizes away
// (guard returns, else-flattening, ternary/if orientation, loop continues), compiles
// them with Unity 4.3.2's smcs via tools/build.sh, and keeps a rewrite only when that
// method's IL moves strictly closer to the original. Candidates for different methods
// are evaluated in the same compile; a failing compile is bisected.
using System.Diagnostics;
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

sealed class Edit
{
    public string File = "", NewText = "", Rule = ""; public int Start, Length;
    public List<string> Related = new();
}

sealed class SourceFile
{
    public string Path = "", Text = ""; public bool Bom; public SyntaxNode Root = null!;
    public static SourceFile Load(string path)
    {
        var bytes = System.IO.File.ReadAllBytes(path);
        bool bom = bytes.Length >= 3 && bytes[0] == 0xEF && bytes[1] == 0xBB && bytes[2] == 0xBF;
        var text = Encoding.UTF8.GetString(bytes, bom ? 3 : 0, bytes.Length - (bom ? 3 : 0));
        return new SourceFile { Path = path, Text = text, Bom = bom, Root = CSharpSyntaxTree.ParseText(text, new CSharpParseOptions(LanguageVersion.CSharp3)).GetRoot() };
    }
    public void Write(string text)
    {
        var b = Encoding.UTF8.GetBytes(text);
        System.IO.File.WriteAllBytes(Path, Bom ? Encoding.UTF8.GetPreamble().Concat(b).ToArray() : b);
    }
}

sealed class Site
{
    public SourceFile File = null!; public BlockSyntax Body = null!;
    public bool ReturnsVoid; public string Key = ""; public List<string> Related = new();
    public TypeSyntax? ReturnType;
}

static class Locator
{
    public sealed record Entry(string TypeName, string Name, List<string> Params, int Arity, SourceFile File, BlockSyntax? Body, bool Void, TypeSyntax? Ret = null);

    public static List<Entry> Index(IEnumerable<SourceFile> files)
    {
        var list = new List<Entry>();
        foreach (var f in files)
            foreach (var td in f.Root.DescendantNodes().OfType<TypeDeclarationSyntax>())
            {
                string tn = TypeName(td);
                foreach (var m in td.Members)
                {
                    switch (m)
                    {
                        case MethodDeclarationSyntax md:
                            list.Add(new(tn, (md.ExplicitInterfaceSpecifier != null ? md.ExplicitInterfaceSpecifier.Name + "." : "") + md.Identifier.Text,
                                Params(md.ParameterList), md.TypeParameterList?.Parameters.Count ?? 0, f, md.Body, md.ReturnType.ToString() == "void", md.ReturnType));
                            break;
                        case OperatorDeclarationSyntax od:
                            list.Add(new(tn, OpName(od), Params(od.ParameterList), 0, f, od.Body, false, od.ReturnType));
                            break;
                        case ConversionOperatorDeclarationSyntax co:
                            list.Add(new(tn, co.ImplicitOrExplicitKeyword.IsKind(SyntaxKind.ImplicitKeyword) ? "op_Implicit" : "op_Explicit",
                                Params(co.ParameterList), 0, f, co.Body, false, co.Type));
                            break;
                        case ConstructorDeclarationSyntax cd:
                            list.Add(new(tn, cd.Modifiers.Any(SyntaxKind.StaticKeyword) ? ".cctor" : ".ctor", Params(cd.ParameterList), 0, f, cd.Body, true));
                            break;
                        case BasePropertyDeclarationSyntax pd when pd.AccessorList != null:
                            string pname = pd switch
                            {
                                PropertyDeclarationSyntax p => (p.ExplicitInterfaceSpecifier != null ? p.ExplicitInterfaceSpecifier.Name + "." : "") + p.Identifier.Text,
                                IndexerDeclarationSyntax => "Item",
                                EventDeclarationSyntax e => e.Identifier.Text,
                                _ => "?"
                            };
                            foreach (var a in pd.AccessorList.Accessors)
                            {
                                string prefix = a.Keyword.Text switch { "get" => "get_", "set" => "set_", "add" => "add_", "remove" => "remove_", _ => "" };
                                int dot = pname.LastIndexOf('.');
                                string full = dot >= 0 ? pname[..(dot + 1)] + prefix + pname[(dot + 1)..] : prefix + pname;
                                var ps = pd is IndexerDeclarationSyntax ix ? Params(ix.ParameterList) : new List<string>();
                                if (prefix != "get_") ps.Add(Simple(pd.Type.ToString()));
                                list.Add(new(tn, full, ps, 0, f, a.Body, prefix != "get_", prefix == "get_" ? pd.Type : null));
                            }
                            break;
                    }
                }
            }
        return list;
    }

    static string OpName(OperatorDeclarationSyntax op)
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

    static List<string> Params(BaseParameterListSyntax ps) => ps.Parameters.Select(p => Simple(p.Type?.ToString() ?? "")).ToList();

    static string TypeName(BaseTypeDeclarationSyntax t)
    {
        string name = t.Identifier.Text + ((t as TypeDeclarationSyntax)?.TypeParameterList is { } tp ? "`" + tp.Parameters.Count : "");
        if (t.Parent is BaseTypeDeclarationSyntax outer) return TypeName(outer) + "/" + name;
        var ns = t.Ancestors().OfType<BaseNamespaceDeclarationSyntax>().FirstOrDefault()?.Name.ToString();
        return string.IsNullOrEmpty(ns) ? name : ns + "." + name;
    }

    // Metadata key: "<Type>::<Name>[`n](<param full types>) : <ret>"
    public static Site? Find(List<Entry> index, string key)
    {
        int sep = key.IndexOf("::", StringComparison.Ordinal);
        string type = key[..sep];
        string rest = key[(sep + 2)..];
        int open = rest.IndexOf('(');
        string name = rest[..open];
        int arity = 0;
        int bt = name.LastIndexOf('`');
        if (bt > 0 && int.TryParse(name[(bt + 1)..], out arity)) name = name[..bt];
        string paramText = rest[(open + 1)..rest.LastIndexOf(") : ", StringComparison.Ordinal)];
        var ps = SplitParams(paramText).Select(Simple).ToList();
        var related = new List<string>();

        // Compiler-generated members map back to the user method that produced them.
        int slash = type.LastIndexOf('/');
        string leaf = slash >= 0 ? type[(slash + 1)..] : type;
        if (leaf.StartsWith("<") && leaf.Contains(">c__"))
        {
            string user = leaf[1..leaf.IndexOf('>')];
            type = type[..slash];
            var e = index.Where(x => x.TypeName == type && x.Name == user).ToList();
            return e.Count == 1 && e[0].Body != null ? Make(e[0], key) : null;
        }
        if (name.StartsWith("<") && name.Contains(">m__"))
        {
            string user = name[1..name.IndexOf('>')];
            var e = index.Where(x => x.TypeName == type && x.Name == user).ToList();
            return e.Count == 1 && e[0].Body != null ? Make(e[0], key) : null;
        }
        var cands = index.Where(x => x.TypeName == type && x.Arity == arity && NameMatches(name, x.Name) && x.Params.Count == ps.Count).ToList();
        if (cands.Count > 1) cands = cands.Where(x => x.Params.SequenceEqual(ps)).ToList();
        return cands.Count == 1 && cands[0].Body != null ? Make(cands[0], key) : null;
    }

    static Site Make(Entry e, string key) => new() { File = e.File, Body = e.Body!, ReturnsVoid = e.Void, Key = key, ReturnType = e.Void ? null : e.Ret };

    static bool NameMatches(string meta, string syntax)
    {
        if (meta == syntax) return true;
        int sd = syntax.LastIndexOf('.');
        if (sd < 0) return false;
        string member = syntax[(sd + 1)..], iface = Simple(syntax[..sd]);
        return meta.EndsWith("." + member) && Simple(meta[..^(member.Length + 1)]) == iface;
    }

    static List<string> SplitParams(string s)
    {
        var r = new List<string>(); int depth = 0, start = 0;
        for (int i = 0; i < s.Length; i++)
        {
            if (s[i] == '<') depth++; else if (s[i] == '>') depth--;
            else if (s[i] == ',' && depth == 0) { r.Add(s[start..i].Trim()); start = i + 1; }
        }
        if (s.Trim().Length > 0) r.Add(s[start..].Trim());
        return r;
    }

    public static string Simple(string t)
    {
        t = t.Replace(" ", "");
        string suffix = "";
        if (t.EndsWith("&")) t = t[..^1];
        while (t.EndsWith("]")) { int k = t.LastIndexOf('['); suffix = t[k..] + suffix; t = t[..k]; }
        int lt = t.IndexOf('<'); if (lt >= 0) t = t[..lt];
        int bq = t.IndexOf('`'); if (bq >= 0) t = t[..bq];
        int dot = Math.Max(t.LastIndexOf('.'), t.LastIndexOf('/')); if (dot >= 0) t = t[(dot + 1)..];
        t = t switch
        {
            "int" => "Int32", "uint" => "UInt32", "float" => "Single", "double" => "Double", "bool" => "Boolean", "string" => "String",
            "object" => "Object", "long" => "Int64", "ulong" => "UInt64", "short" => "Int16", "ushort" => "UInt16", "byte" => "Byte",
            "sbyte" => "SByte", "char" => "Char", "void" => "Void", "decimal" => "Decimal", _ => t,
        };
        return t + suffix;
    }
}

// Single-site rewrites of the idioms ILSpy normalizes.
static class Generators
{
    public static List<Edit> For(Site s)
    {
        var bodies = new List<(string Rule, BlockSyntax Body)>();
        var body = s.Body;
        foreach (var node in body.DescendantNodes())
        {
            switch (node)
            {
                case IfStatementSyntax ifs:
                    foreach (var r in IfRewrites(s, ifs)) bodies.Add(r);
                    break;
                case ConditionalExpressionSyntax ce:
                    foreach (var neg in Negations(ce.Condition))
                        bodies.Add(("ternary-flip", body.ReplaceNode(ce, SyntaxFactory.ConditionalExpression(neg, ce.WhenFalse.WithoutTrivia(), ce.WhenTrue.WithoutTrivia()).WithTriviaFrom(ce))));
                    break;
                case LocalDeclarationStatementSyntax ld when ld.Parent is BlockSyntax && ld.Declaration.Variables.Count == 1
                        && ld.Declaration.Variables[0].Initializer?.Value is ConditionalExpressionSyntax tce && ld.Declaration.Type.ToString() != "var":
                {
                    // T x = c ? a : b;  ->  T x; if (c) { x = a; } else { x = b; }
                    var v = ld.Declaration.Variables[0];
                    var decl = ld.WithDeclaration(ld.Declaration.WithVariables(SyntaxFactory.SingletonSeparatedList(v.WithInitializer(null))));
                    var id = SyntaxFactory.IdentifierName(v.Identifier.Text);
                    StatementSyntax Asg(ExpressionSyntax e) => SyntaxFactory.ExpressionStatement(SyntaxFactory.AssignmentExpression(SyntaxKind.SimpleAssignmentExpression, id, e.WithoutTrivia()));
                    var cond = tce.Condition is ParenthesizedExpressionSyntax cp ? cp.Expression : tce.Condition;
                    var ifs = SyntaxFactory.IfStatement(cond.WithoutTrivia(), Block(new[] { Asg(tce.WhenTrue) }), SyntaxFactory.ElseClause(Block(new[] { Asg(tce.WhenFalse) })));
                    bodies.Add(("ternary-to-if", body.ReplaceNode(ld, new SyntaxNode[] { decl.WithoutTrivia(), ifs })));
                    break;
                }
                case ExpressionStatementSyntax es when es.Parent is BlockSyntax && es.Expression is AssignmentExpressionSyntax { Right: ConditionalExpressionSyntax ace } aa
                        && aa.IsKind(SyntaxKind.SimpleAssignmentExpression):
                {
                    StatementSyntax Asg(ExpressionSyntax e) => SyntaxFactory.ExpressionStatement(SyntaxFactory.AssignmentExpression(SyntaxKind.SimpleAssignmentExpression, aa.Left.WithoutTrivia(), e.WithoutTrivia()));
                    var cond = ace.Condition is ParenthesizedExpressionSyntax cp ? cp.Expression : ace.Condition;
                    var ifs = SyntaxFactory.IfStatement(cond.WithoutTrivia(), Block(new[] { Asg(ace.WhenTrue) }), SyntaxFactory.ElseClause(Block(new[] { Asg(ace.WhenFalse) })));
                    bodies.Add(("ternary-to-if", body.ReplaceNode(es, ifs)));
                    break;
                }
                case BinaryExpressionSyntax add when add.IsKind(SyntaxKind.AddExpression):
                    // ILSpy drops explicit ToString() on operands of a string concatenation.
                    foreach (var operand in new[] { add.Left, add.Right })
                    {
                        if (operand is LiteralExpressionSyntax || operand.IsKind(SyntaxKind.AddExpression)) continue;
                        if (operand is InvocationExpressionSyntax { Expression: MemberAccessExpressionSyntax { Name.Identifier.Text: "ToString" } }) continue;
                        ExpressionSyntax target = operand is IdentifierNameSyntax or MemberAccessExpressionSyntax or ElementAccessExpressionSyntax or InvocationExpressionSyntax or ParenthesizedExpressionSyntax
                            ? operand.WithoutTrivia() : SyntaxFactory.ParenthesizedExpression(operand.WithoutTrivia());
                        var call = SyntaxFactory.InvocationExpression(SyntaxFactory.MemberAccessExpression(SyntaxKind.SimpleMemberAccessExpression, target, SyntaxFactory.IdentifierName("ToString")));
                        bodies.Add(("concat-tostring", body.ReplaceNode(operand, call.WithTriviaFrom(operand))));
                    }
                    break;
                case ReturnStatementSyntax rv when rv.Expression != null && rv.Parent is BlockSyntax && s.ReturnType != null
                        && rv.Expression is not IdentifierNameSyntax && rv.Expression is not LiteralExpressionSyntax:
                {
                    // return e;  ->  T tmp = e; return tmp;   (the original stored the value in a named local)
                    var name = "result" + (rv.SpanStart % 997);
                    var decl = SyntaxFactory.LocalDeclarationStatement(SyntaxFactory.VariableDeclaration(s.ReturnType.WithoutTrivia(),
                        SyntaxFactory.SingletonSeparatedList(SyntaxFactory.VariableDeclarator(name).WithInitializer(SyntaxFactory.EqualsValueClause(rv.Expression.WithoutTrivia())))));
                    bodies.Add(("return-via-local", body.ReplaceNode(rv, new SyntaxNode[] { decl, SyntaxFactory.ReturnStatement(SyntaxFactory.IdentifierName(name)) })));
                    if (IsBoolish(rv.Expression))
                        bodies.Add(("bool-ternary", body.ReplaceNode(rv.Expression, BoolTernary(rv.Expression).WithTriviaFrom(rv.Expression))));
                    if (rv.Expression is ConditionalExpressionSyntax rce2)
                    {
                        var ifs2 = SyntaxFactory.IfStatement(rce2.Condition.WithoutTrivia(), SyntaxFactory.Block(SyntaxFactory.ReturnStatement(rce2.WhenTrue.WithoutTrivia())));
                        bodies.Add(("return-ternary-split", body.ReplaceNode(rv, new SyntaxNode[] { ifs2, SyntaxFactory.ReturnStatement(rce2.WhenFalse.WithoutTrivia()) })));
                    }
                    break;
                }
                case AssignmentExpressionSyntax asg when asg.IsKind(SyntaxKind.SimpleAssignmentExpression) && IsBoolish(asg.Right):
                    bodies.Add(("bool-ternary", body.ReplaceNode(asg.Right, BoolTernary(asg.Right).WithTriviaFrom(asg.Right))));
                    break;
                case ReturnStatementSyntax ret when ret.Expression is ConditionalExpressionSyntax rce && ret.Parent is BlockSyntax:
                {
                    // return c ? a : b;  ->  if (c) { return a; } return b;
                    var ifs = SyntaxFactory.IfStatement(rce.Condition.WithoutTrivia(), SyntaxFactory.Block(SyntaxFactory.ReturnStatement(rce.WhenTrue.WithoutTrivia())));
                    bodies.Add(("return-ternary-split", body.ReplaceNode(ret, new SyntaxNode[] { ifs, SyntaxFactory.ReturnStatement(rce.WhenFalse.WithoutTrivia()) })));
                    break;
                }
            }
        }
        var result = new List<Edit>();
        var seen = new HashSet<string>();
        foreach (var (rule, nb) in bodies)
        {
            var text = nb.NormalizeWhitespace("\t", "\n").ToFullString();
            if (!seen.Add(text)) continue;
            result.Add(new Edit { File = s.File.Path, Start = body.SpanStart, Length = body.Span.Length, NewText = Reindent(text, body), Rule = rule });
        }
        return result;
    }

    static string Reindent(string text, BlockSyntax original)
    {
        var lead = original.GetLeadingTrivia().ToFullString();
        int nl = lead.LastIndexOf('\n');
        string indent = nl >= 0 ? lead[(nl + 1)..] : lead;
        var lines = text.Split('\n');
        return string.Join("\n", lines.Select((l, i) => i == 0 ? l : indent + l));
    }

    // What a jump out of the tail of this block looks like: "return" (void method end) or "continue" (loop body end).
    static string? TailJump(Site s, BlockSyntax block)
    {
        if (block == s.Body) return s.ReturnsVoid ? "return" : null;
        switch (block.Parent)
        {
            case ForStatementSyntax or ForEachStatementSyntax or WhileStatementSyntax or DoStatementSyntax:
                return "continue";
            case IfStatementSyntax pif when pif.Parent is BlockSyntax pb && IsLast(pif, pb):
                return TailJump(s, pb);
            case ElseClauseSyntax ec when ec.Parent is IfStatementSyntax eif:
            {
                var top = eif;
                while (top.Parent is ElseClauseSyntax e2 && e2.Parent is IfStatementSyntax up) top = up;
                return top.Parent is BlockSyntax tb && IsLast(top, tb) ? TailJump(s, tb) : null;
            }
        }
        return null;
    }

    static bool IsLast(StatementSyntax st, BlockSyntax b) => b.Statements.Count > 0 && b.Statements.Last() == st;

    static StatementSyntax Jump(string j) => j == "return" ? SyntaxFactory.ReturnStatement() : SyntaxFactory.ContinueStatement();

    static bool EndsWithJump(StatementSyntax st, string j) => st switch
    {
        BlockSyntax b => b.Statements.Count > 0 && EndsWithJump(b.Statements.Last(), j),
        ReturnStatementSyntax r => j == "return" && r.Expression == null,
        ContinueStatementSyntax => j == "continue",
        _ => false,
    };

    static IEnumerable<StatementSyntax> Stmts(StatementSyntax st) => st is BlockSyntax b ? b.Statements : new[] { st };

    static BlockSyntax Block(IEnumerable<StatementSyntax> st) => SyntaxFactory.Block(st.Select(x => x.WithoutTrivia()));

    static IEnumerable<(string, BlockSyntax)> IfRewrites(Site s, IfStatementSyntax ifs)
    {
        var body = s.Body;
        // if/else orientation swap.
        if (ifs.Else != null)
        {
            var elseStmt = ifs.Else.Statement is IfStatementSyntax ? Block(new[] { ifs.Else.Statement }) : ifs.Else.Statement.WithoutTrivia();
            foreach (var neg in Negations(ifs.Condition))
                yield return ("if-swap", body.ReplaceNode(ifs, SyntaxFactory.IfStatement(neg, elseStmt, SyntaxFactory.ElseClause(ifs.Statement.WithoutTrivia())).WithTriviaFrom(ifs)));
        }
        // if (c) { A }  ->  if (c) { A } else { }   (the original kept empty else blocks; mcs emits a branch for them)
        if (ifs.Else == null)
            yield return ("empty-else", body.ReplaceNode(ifs, ifs.WithElse(SyntaxFactory.ElseClause(SyntaxFactory.Block()))));
        // if (a && b) { A }  ->  if (a) { if (b) { A } }
        if (ifs.Else == null && (ifs.Condition is ParenthesizedExpressionSyntax pc0 ? pc0.Expression : ifs.Condition) is BinaryExpressionSyntax { RawKind: (int)SyntaxKind.LogicalAndExpression } and0)
            yield return ("split-and", body.ReplaceNode(ifs, SyntaxFactory.IfStatement(and0.Left.WithoutTrivia(), Block(new[] { (StatementSyntax)SyntaxFactory.IfStatement(and0.Right.WithoutTrivia(), ifs.Statement.WithoutTrivia()) }))));
        if (ifs.Parent is not BlockSyntax parent) yield break;
        // if (a || b) { jump-only } -> if (a) { jump } if (b) { jump }   (ILSpy merges consecutive guards)
        if (ifs.Else == null && Stmts(ifs.Statement).ToList() is [StatementSyntax only] && only is ReturnStatementSyntax or ContinueStatementSyntax or BreakStatementSyntax
            && (ifs.Condition is ParenthesizedExpressionSyntax pc ? pc.Expression : ifs.Condition) is BinaryExpressionSyntax { RawKind: (int)SyntaxKind.LogicalOrExpression } or)
        {
            ExpressionSyntax Strip(ExpressionSyntax e) => e is ParenthesizedExpressionSyntax p ? p.Expression : e;
            var g1 = SyntaxFactory.IfStatement(Strip(or.Left).WithoutTrivia(), Block(new[] { only }));
            var g2 = SyntaxFactory.IfStatement(Strip(or.Right).WithoutTrivia(), Block(new[] { only }));
            yield return ("split-or-guard", body.ReplaceNode(ifs, new SyntaxNode[] { g1, g2 }));
        }
        string? jump = TailJump(s, parent);
        if (jump != null && IsLast(ifs, parent))
        {
            if (ifs.Else == null)
            {
                // if (c) { S }  ->  if (!c) jump; S
                foreach (var neg in Negations(ifs.Condition))
                {
                    var guard = SyntaxFactory.IfStatement(neg, Block(new[] { Jump(jump) }));
                    yield return ("guard-" + jump, body.ReplaceNode(ifs, new SyntaxNode[] { guard }.Concat(Stmts(ifs.Statement).Select(x => x.WithoutTrivia()))));
                }
                // if (c) { S }  ->  if (c) { S; jump; }
                if (!EndsWithJump(ifs.Statement, jump))
                    yield return ("append-" + jump, body.ReplaceNode(ifs, ifs.WithStatement(Block(Stmts(ifs.Statement).Append(Jump(jump))))));
                else
                {
                    var inner = Stmts(ifs.Statement).ToList(); inner.RemoveAt(inner.Count - 1);
                    yield return ("drop-" + jump, body.ReplaceNode(ifs, ifs.WithStatement(Block(inner))));
                }
            }
            else
            {
                // if (c) { A } else { B }  ->  if (c) { A; jump; } B
                var a = Stmts(ifs.Statement).ToList();
                if (!EndsWithJump(ifs.Statement, jump)) a.Add(Jump(jump));
                var flat = SyntaxFactory.IfStatement(ifs.Condition.WithoutTrivia(), Block(a));
                yield return ("flatten-else-" + jump, body.ReplaceNode(ifs, new SyntaxNode[] { flat }.Concat(Stmts(ifs.Else.Statement).Select(x => x.WithoutTrivia()))));
                // and the swapped orientation of the same.
                var b = Stmts(ifs.Else.Statement).ToList();
                if (!EndsWithJump(ifs.Else.Statement, jump)) b.Add(Jump(jump));
                foreach (var neg in Negations(ifs.Condition))
                {
                    var flat2 = SyntaxFactory.IfStatement(neg, Block(b));
                    yield return ("flatten-else-swapped-" + jump, body.ReplaceNode(ifs, new SyntaxNode[] { flat2 }.Concat(Stmts(ifs.Statement).Select(x => x.WithoutTrivia()))));
                }
            }
        }
        if (jump != null && !IsLast(ifs, parent) && ifs.Else == null && EndsWithJump(ifs.Statement, jump))
        {
            // if (c) { A; jump; } R  ->  if (c) { A } else { R }
            int i = parent.Statements.IndexOf(ifs);
            var rest = parent.Statements.Skip(i + 1).ToList();
            var a = Stmts(ifs.Statement).ToList(); a.RemoveAt(a.Count - 1);
            var merged = SyntaxFactory.IfStatement(ifs.Condition.WithoutTrivia(), Block(a), SyntaxFactory.ElseClause(Block(rest)));
            var newParent = parent.WithStatements(SyntaxFactory.List(parent.Statements.Take(i).Append(merged)));
            yield return ("unflatten-" + jump, body.ReplaceNode(parent, newParent));
            if (a.Count == 0)
            {
                // if (c) { jump; } R  ->  if (!c) { R }
                foreach (var neg in Negations(ifs.Condition))
                {
                    var wrapped = SyntaxFactory.IfStatement(neg, Block(rest));
                    yield return ("unguard-" + jump, body.ReplaceNode(parent, parent.WithStatements(SyntaxFactory.List(parent.Statements.Take(i).Append(wrapped)))));
                }
            }
        }
        // Non-void: if (c) { return a; } return b;  ->  return c ? a : b;
        if (!s.ReturnsVoid && ifs.Else == null && Stmts(ifs.Statement).ToList() is [ReturnStatementSyntax { Expression: { } ta }])
        {
            int i = parent.Statements.IndexOf(ifs);
            if (i + 1 < parent.Statements.Count && parent.Statements[i + 1] is ReturnStatementSyntax { Expression: { } fa } next)
            {
                var ret = SyntaxFactory.ReturnStatement(SyntaxFactory.ConditionalExpression(ifs.Condition.WithoutTrivia(), ta.WithoutTrivia(), fa.WithoutTrivia()));
                var np = parent.WithStatements(SyntaxFactory.List(parent.Statements.Take(i).Append(ret).Concat(parent.Statements.Skip(i + 2))));
                yield return ("return-ternary-merge", body.ReplaceNode(parent, np));
                var ifelse = SyntaxFactory.IfStatement(ifs.Condition.WithoutTrivia(), Block(new[] { SyntaxFactory.ReturnStatement(ta.WithoutTrivia()) }),
                    SyntaxFactory.ElseClause(Block(new[] { SyntaxFactory.ReturnStatement(fa.WithoutTrivia()) })));
                var np2 = parent.WithStatements(SyntaxFactory.List(parent.Statements.Take(i).Append((StatementSyntax)ifelse).Concat(parent.Statements.Skip(i + 2))));
                yield return ("return-if-else", body.ReplaceNode(parent, np2));
            }
        }
    }

    static bool IsBoolish(ExpressionSyntax e)
    {
        var x = e is ParenthesizedExpressionSyntax p ? p.Expression : e;
        return x.Kind() is SyntaxKind.EqualsExpression or SyntaxKind.NotEqualsExpression or SyntaxKind.LessThanExpression
            or SyntaxKind.LessThanOrEqualExpression or SyntaxKind.GreaterThanExpression or SyntaxKind.GreaterThanOrEqualExpression
            or SyntaxKind.LogicalAndExpression or SyntaxKind.LogicalOrExpression or SyntaxKind.LogicalNotExpression;
    }

    // c  ->  (c) ? true : false
    static ExpressionSyntax BoolTernary(ExpressionSyntax e) => SyntaxFactory.ConditionalExpression(
        e is ParenthesizedExpressionSyntax ? e.WithoutTrivia() : SyntaxFactory.ParenthesizedExpression(e.WithoutTrivia()),
        SyntaxFactory.LiteralExpression(SyntaxKind.TrueLiteralExpression), SyntaxFactory.LiteralExpression(SyntaxKind.FalseLiteralExpression));

    // Distinct source spellings of the negation of a condition.
    public static List<ExpressionSyntax> Negations(ExpressionSyntax c)
    {
        c = c.WithoutTrivia();
        var r = new List<ExpressionSyntax>();
        var inner = c is ParenthesizedExpressionSyntax p ? p.Expression : c;
        if (inner is PrefixUnaryExpressionSyntax { RawKind: (int)SyntaxKind.LogicalNotExpression } not)
        {
            var o = not.Operand is ParenthesizedExpressionSyntax pp ? pp.Expression : not.Operand;
            r.Add(o.WithoutTrivia());
        }
        else
        {
            bool simple = inner is IdentifierNameSyntax or MemberAccessExpressionSyntax or InvocationExpressionSyntax or ElementAccessExpressionSyntax or ThisExpressionSyntax;
            r.Add(SyntaxFactory.PrefixUnaryExpression(SyntaxKind.LogicalNotExpression, simple ? inner : SyntaxFactory.ParenthesizedExpression(inner)));
        }
        if (inner is BinaryExpressionSyntax b)
        {
            SyntaxKind? flip = b.Kind() switch
            {
                SyntaxKind.EqualsExpression => SyntaxKind.NotEqualsExpression,
                SyntaxKind.NotEqualsExpression => SyntaxKind.EqualsExpression,
                SyntaxKind.LessThanExpression => SyntaxKind.GreaterThanOrEqualExpression,
                SyntaxKind.GreaterThanOrEqualExpression => SyntaxKind.LessThanExpression,
                SyntaxKind.GreaterThanExpression => SyntaxKind.LessThanOrEqualExpression,
                SyntaxKind.LessThanOrEqualExpression => SyntaxKind.GreaterThanExpression,
                _ => null,
            };
            if (flip is { } f) r.Add(SyntaxFactory.BinaryExpression(f, b.Left, b.Right));
            if (b.IsKind(SyntaxKind.LogicalAndExpression) || b.IsKind(SyntaxKind.LogicalOrExpression))
            {
                var l = Negations(b.Left)[^1]; var rr = Negations(b.Right)[^1];
                ExpressionSyntax Wrap(ExpressionSyntax e) => e is BinaryExpressionSyntax be && (be.IsKind(SyntaxKind.LogicalAndExpression) || be.IsKind(SyntaxKind.LogicalOrExpression)) ? SyntaxFactory.ParenthesizedExpression(e) : e;
                r.Add(SyntaxFactory.BinaryExpression(b.IsKind(SyntaxKind.LogicalAndExpression) ? SyntaxKind.LogicalOrExpression : SyntaxKind.LogicalAndExpression, Wrap(l), Wrap(rr)));
            }
        }
        return r;
    }
}
