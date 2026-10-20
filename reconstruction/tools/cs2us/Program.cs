// cs2us: drafts UnityScript (.js) source from ILSpy's C# decompilation of an
// assembly compiled by Unity 4.3.2's us.exe. The draft is a starting point; the
// final .js files are corrected by hand against the original IL (tools/cmp.sh).
//
//   cs2us <decompiled-dir> <output-dir> <map>
//
// map lines: "<path>.js: <Type> [<Type> ...]" — the types a script file declares, in order.
using System.Text;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

static class Program
{
    static int Main(string[] args)
    {
        var decls = new Dictionary<string, MemberDeclarationSyntax>();
        foreach (var f in Directory.EnumerateFiles(args[0], "*.cs", SearchOption.AllDirectories))
        {
            var root = CSharpSyntaxTree.ParseText(File.ReadAllText(f)).GetRoot();
            foreach (var m in root.DescendantNodes().OfType<MemberDeclarationSyntax>())
                if (m.Parent is CompilationUnitSyntax or BaseNamespaceDeclarationSyntax)
                    if (m is BaseTypeDeclarationSyntax bt) decls[bt.Identifier.Text] = bt;
                    else if (m is DelegateDeclarationSyntax dd) decls[dd.Identifier.Text] = dd;
        }
        foreach (var line in File.ReadAllLines(args[2]).Where(l => l.Trim().Length > 0 && !l.StartsWith("#")))
        {
            int c = line.LastIndexOf(".js:", StringComparison.Ordinal) + 3;
            var path = line[..c].Trim();
            var types = line[(c + 1)..].Split(' ', StringSplitOptions.RemoveEmptyEntries);
            var scriptName = Path.GetFileNameWithoutExtension(path);
            var w = new Writer();
            w.Line("#pragma strict");
            w.Line("");
            foreach (var t in types)
            {
                if (!decls.TryGetValue(t, out var d)) { Console.Error.WriteLine($"missing {t}"); continue; }
                new Translator(w, scriptName).Type(d, topLevel: true);
            }
            var outPath = Path.Combine(args[1], path);
            Directory.CreateDirectory(Path.GetDirectoryName(outPath)!);
            File.WriteAllText(outPath, w.ToString());
        }
        return 0;
    }
}

sealed class Writer
{
    readonly StringBuilder sb = new();
    public int Indent;
    public void Line(string s) => sb.Append(s.Length == 0 ? "\n" : new string('\t', Indent) + s + "\n");
    public override string ToString() => sb.ToString();
}

sealed class Translator
{
    readonly Writer w; readonly string script;
    // UnityScript locals are function-scoped: a re-declared name becomes an assignment.
    HashSet<string> locals = new();
    string Declare(string name, string typed) => locals.Add(name) ? $"var {name}{typed}" : name;
    public Translator(Writer w, string script) { this.w = w; this.script = script; }

    public void Type(MemberDeclarationSyntax d, bool topLevel)
    {
        switch (d)
        {
            case EnumDeclarationSyntax e:
                w.Line($"{Mods(e.Modifiers, forType: true)}enum {e.Identifier.Text} {{");
                w.Indent++;
                foreach (var m in e.Members)
                    w.Line(m.Identifier.Text + (m.EqualsValue != null ? " = " + Expr(m.EqualsValue.Value) : "") + ",");
                w.Indent--;
                w.Line("}");
                w.Line("");
                break;
            case ClassDeclarationSyntax or StructDeclarationSyntax:
                Class((TypeDeclarationSyntax)d, topLevel);
                break;
            case InterfaceDeclarationSyntax i:
                w.Line($"interface {i.Identifier.Text} {{");
                w.Indent++;
                foreach (var m in i.Members.OfType<MethodDeclarationSyntax>())
                    w.Line($"function {m.Identifier.Text} ({Params(m.ParameterList)}){Ret(m.ReturnType)};");
                w.Indent--;
                w.Line("}");
                break;
            default:
                w.Line("// TODO untranslated: " + d.Kind());
                break;
        }
    }

    void Class(TypeDeclarationSyntax c, bool topLevel)
    {
        string baseType = c.BaseList?.Types.FirstOrDefault()?.Type.ToString() ?? "";
        bool implicitScript = topLevel && c.Identifier.Text == script && baseType == "MonoBehaviour" && c is ClassDeclarationSyntax;
        foreach (var a in c.AttributeLists.SelectMany(l => l.Attributes))
        {
            var n = a.Name.ToString();
            if (n is "Serializable" or "System.Serializable") continue;
            w.Line($"@script {n}{AttrArgs(a, script: true)}");
        }
        if (c.AttributeLists.Count > 0) w.Line("");
        if (!implicitScript)
        {
            var ext = baseType.Length > 0 && baseType != "object" ? " extends " + TypeName(baseType) : "";
            var kw = c is StructDeclarationSyntax ? "class" : "class";
            w.Line($"{Mods(c.Modifiers, forType: true)}{kw} {c.Identifier.Text}{ext} {{");
            w.Indent++;
        }
        // Field initializers were moved into the constructor by us.exe; move them back.
        var inits = new Dictionary<string, ExpressionSyntax>();
        var ctor = c.Members.OfType<ConstructorDeclarationSyntax>().FirstOrDefault(k => !k.Modifiers.Any(SyntaxKind.StaticKeyword) && k.ParameterList.Parameters.Count == 0);
        var leftoverCtor = new List<StatementSyntax>();
        if (ctor?.Body != null)
            foreach (var st in ctor.Body.Statements)
            {
                if (st is ExpressionStatementSyntax { Expression: AssignmentExpressionSyntax { Left: IdentifierNameSyntax id } asg } && asg.IsKind(SyntaxKind.SimpleAssignmentExpression) && !inits.ContainsKey(id.Identifier.Text))
                    inits[id.Identifier.Text] = asg.Right;
                else leftoverCtor.Add(st);
            }
        var sinits = new Dictionary<string, ExpressionSyntax>();
        var cctor = c.Members.OfType<ConstructorDeclarationSyntax>().FirstOrDefault(k => k.Modifiers.Any(SyntaxKind.StaticKeyword));
        var leftoverCctor = new List<StatementSyntax>();
        if (cctor?.Body != null)
            foreach (var st in cctor.Body.Statements)
            {
                if (st is ExpressionStatementSyntax { Expression: AssignmentExpressionSyntax { Left: IdentifierNameSyntax id } asg } && !sinits.ContainsKey(id.Identifier.Text))
                    sinits[id.Identifier.Text] = asg.Right;
                else leftoverCctor.Add(st);
            }

        foreach (var m in c.Members)
        {
            switch (m)
            {
                case BaseTypeDeclarationSyntax nested:
                    Type(nested, topLevel: false); break;
                case FieldDeclarationSyntax f:
                    foreach (var v in f.Declaration.Variables)
                    {
                        foreach (var a in f.AttributeLists.SelectMany(l => l.Attributes))
                            w.Line($"@{AttrName(a.Name.ToString())}{AttrArgs(a, script: false)}");
                        var name = v.Identifier.Text;
                        bool isStatic = f.Modifiers.Any(SyntaxKind.StaticKeyword);
                        var init = v.Initializer?.Value ?? (isStatic ? sinits.GetValueOrDefault(name) : inits.GetValueOrDefault(name));
                        w.Line($"{Mods(f.Modifiers)}var {name} : {TypeName(f.Declaration.Type.ToString())}{(init != null ? " = " + Expr(init) : "")};");
                    }
                    break;
                case ConstructorDeclarationSyntax k:
                    if (k == ctor && leftoverCtor.Count == 0) break;
                    if (k == cctor && leftoverCctor.Count == 0) break;
                    w.Line($"{(k.Modifiers.Any(SyntaxKind.StaticKeyword) ? "static " : "")}function {c.Identifier.Text} ({Params(k.ParameterList)}) {{");
                    w.Indent++;
                    foreach (var st in k == ctor ? leftoverCtor : k == cctor ? leftoverCctor : k.Body!.Statements.ToList()) Stmt(st);
                    w.Indent--;
                    w.Line("}");
                    w.Line("");
                    break;
                case MethodDeclarationSyntax md:
                    if (md.Identifier.Text == "Main" && md.ParameterList.Parameters.Count == 0)
                    {
                        if (md.Body == null || md.Body.Statements.Count == 0) break;
                        w.Line("// --- script body (compiled into Main) ---");
                        foreach (var st in md.Body.Statements) Stmt(st);
                        w.Line("");
                        break;
                    }
                    foreach (var a in md.AttributeLists.SelectMany(l => l.Attributes))
                        w.Line($"@{AttrName(a.Name.ToString())}{AttrArgs(a, script: false)}");
                    bool virt = md.Modifiers.Any(SyntaxKind.VirtualKeyword) || md.Modifiers.Any(SyntaxKind.OverrideKeyword) || md.Modifiers.Any(SyntaxKind.AbstractKeyword);
                    bool stat = md.Modifiers.Any(SyntaxKind.StaticKeyword);
                    string mods = Mods(md.Modifiers) + (!virt && !stat && c is ClassDeclarationSyntax ? "final " : "");
                    string generic = md.TypeParameterList != null ? ".<" + string.Join(", ", md.TypeParameterList.Parameters.Select(p => p.Identifier.Text)) + ">" : "";
                    locals = new HashSet<string>(md.ParameterList.Parameters.Select(p => p.Identifier.Text));
                    w.Line($"{mods}function {md.Identifier.Text}{generic} ({Params(md.ParameterList)}){Ret(md.ReturnType)} {{");
                    w.Indent++;
                    if (md.Body != null) foreach (var st in ReturnPoints(md.Body).Statements) Stmt(st);
                    w.Indent--;
                    w.Line("}");
                    w.Line("");
                    break;
                case PropertyDeclarationSyntax p:
                    foreach (var acc in p.AccessorList?.Accessors ?? default)
                    {
                        if (acc.Keyword.IsKind(SyntaxKind.GetKeyword))
                            w.Line($"{Mods(p.Modifiers)}function get {p.Identifier.Text} (){Ret(p.Type)} {{");
                        else
                            w.Line($"{Mods(p.Modifiers)}function set {p.Identifier.Text} (value : {TypeName(p.Type.ToString())}) {{");
                        w.Indent++;
                        if (acc.Body != null) foreach (var st in acc.Body.Statements) Stmt(st);
                        w.Indent--;
                        w.Line("}");
                        w.Line("");
                    }
                    break;
                default:
                    w.Line("// TODO untranslated member: " + m.Kind());
                    break;
            }
        }
        if (!implicitScript)
        {
            w.Indent--;
            w.Line("}");
            w.Line("");
        }
    }

    static string AttrName(string n) => n switch
    {
        "NonSerialized" => "System.NonSerialized",
        _ => n,
    };

    string AttrArgs(AttributeSyntax a, bool script)
    {
        if (a.ArgumentList == null || a.ArgumentList.Arguments.Count == 0) return "";
        return " (" + string.Join(", ", a.ArgumentList.Arguments.Select(x => Expr(x.Expression))) + ")";
    }

    static string Mods(SyntaxTokenList mods, bool forType = false)
    {
        var sb = new StringBuilder();
        if (mods.Any(SyntaxKind.PrivateKeyword)) sb.Append("private ");
        if (mods.Any(SyntaxKind.ProtectedKeyword)) sb.Append("protected ");
        if (mods.Any(SyntaxKind.InternalKeyword)) sb.Append("internal ");
        if (mods.Any(SyntaxKind.StaticKeyword) && !forType) sb.Append("static ");
        return sb.ToString();
    }

    string Params(BaseParameterListSyntax ps) => string.Join(", ", ps.Parameters.Select(p =>
        (p.Modifiers.Any(SyntaxKind.RefKeyword) || p.Modifiers.Any(SyntaxKind.OutKeyword) ? "ref " : "") + p.Identifier.Text + " : " + TypeName(p.Type!.ToString())));

    string Ret(TypeSyntax t) => t.ToString() == "void" ? "" : " : " + TypeName(t.ToString());

    public static string TypeName(string t)
    {
        t = t.Trim();
        if (t.EndsWith("[]")) return TypeName(t[..^2]) + "[]";
        int lt = t.IndexOf('<');
        if (lt > 0 && t.EndsWith(">"))
            return TypeName(t[..lt]) + ".<" + string.Join(", ", SplitTop(t[(lt + 1)..^1]).Select(TypeName)) + ">";
        return t switch
        {
            "bool" => "boolean", "string" => "String", "object" => "System.Object", "int" => "int", "float" => "float",
            "double" => "double", "long" => "long", "byte" => "byte", "char" => "char", "uint" => "uint", "short" => "short",
            "Object" => "UnityEngine.Object",
            _ => t,
        };
    }

    static IEnumerable<string> SplitTop(string s)
    {
        int depth = 0, start = 0;
        for (int i = 0; i < s.Length; i++)
        {
            if (s[i] == '<') depth++; else if (s[i] == '>') depth--;
            else if (s[i] == ',' && depth == 0) { yield return s[start..i]; start = i + 1; }
        }
        yield return s[start..];
    }

    // Boo compiles every "return x;" as a branch to one shared ret, which ILSpy renders as
    // "T result = ...; ... result = x; ... return result;". Restore the direct returns.
    static BlockSyntax ReturnPoints(BlockSyntax body)
    {
        if (body.Statements.LastOrDefault() is not ReturnStatementSyntax { Expression: IdentifierNameSyntax last }) return body;
        string name = last.Identifier.Text;
        if (name != "result") return body;
        var decl = body.Statements.OfType<LocalDeclarationStatementSyntax>().FirstOrDefault(d => d.Declaration.Variables.Any(v => v.Identifier.Text == name));
        // Every assignment to the variable must be a whole statement.
        var assigns = body.DescendantNodes().OfType<IdentifierNameSyntax>().Where(i => i.Identifier.Text == name).ToList();
        foreach (var a in assigns)
        {
            if (a.Parent == last.Parent) continue;
            if (a.Parent is AssignmentExpressionSyntax asg && asg.Left == a && asg.Parent is ExpressionStatementSyntax) continue;
            return body;
        }
        var nb = body.ReplaceNodes(body.DescendantNodes().OfType<ExpressionStatementSyntax>()
                .Where(es => es.Expression is AssignmentExpressionSyntax { Left: IdentifierNameSyntax l } && l.Identifier.Text == name),
            (o, _) => SyntaxFactory.ReturnStatement(((AssignmentExpressionSyntax)o.Expression).Right.WithoutTrivia()));
        var stmts = nb.Statements.ToList();
        stmts.RemoveAt(stmts.Count - 1);
        stmts.RemoveAll(st => st is LocalDeclarationStatementSyntax ld && ld.Declaration.Variables.Any(v => v.Identifier.Text == name));
        return nb.WithStatements(SyntaxFactory.List(stmts));
    }

    // ---- statements ----
    void Block(StatementSyntax s)
    {
        w.Indent++;
        if (s is BlockSyntax b) foreach (var x in b.Statements) Stmt(x); else Stmt(s);
        w.Indent--;
    }

    void Stmt(StatementSyntax s)
    {
        switch (s)
        {
            case BlockSyntax b:
                foreach (var x in b.Statements) Stmt(x); break;
            case LocalDeclarationStatementSyntax ld:
                foreach (var v in ld.Declaration.Variables)
                {
                    var type = ld.Declaration.Type.ToString();
                    var t = type == "var" ? "" : " : " + TypeName(type);
                    // us.exe zero-initializes "var x : T;" which ILSpy renders as "T x = default(T);"
                    var iv = v.Initializer?.Value is ParenthesizedExpressionSyntax pe ? pe.Expression : v.Initializer?.Value;
                    if (iv is AssignmentExpressionSyntax nested && nested.IsKind(SyntaxKind.SimpleAssignmentExpression))
                    {
                        // ILSpy folds "var x = e; target = x;" into "var x = (target = e);"
                        w.Line($"{Declare(v.Identifier.Text, t)} = {Expr(nested.Right)};");
                        w.Line($"{Expr(nested.Left)} = {v.Identifier.Text};");
                        continue;
                    }
                    bool noInit = v.Initializer == null || v.Initializer.Value is DefaultExpressionSyntax;
                    var decl = Declare(v.Identifier.Text, t);
                    if (noInit && !decl.StartsWith("var ")) break; // already declared: nothing to emit
                    w.Line($"{decl}{(noInit ? "" : " = " + Expr(v.Initializer!.Value))};");
                }
                break;
            case ExpressionStatementSyntax es:
                w.Line(Expr(es.Expression) + ";"); break;
            case ReturnStatementSyntax r:
                w.Line(r.Expression != null ? $"return {Expr(r.Expression)};" : "return;"); break;
            case YieldStatementSyntax y:
                w.Line(y.IsKind(SyntaxKind.YieldBreakStatement) ? "return;" : $"yield {Expr(y.Expression!)};"); break;
            case BreakStatementSyntax: w.Line("break;"); break;
            case ContinueStatementSyntax: w.Line("continue;"); break;
            case IfStatementSyntax ifs:
                w.Line($"if ({Expr(ifs.Condition)}) {{");
                Block(ifs.Statement);
                var el = ifs.Else;
                while (el != null)
                {
                    if (el.Statement is IfStatementSyntax ei)
                    {
                        w.Line($"}} else if ({Expr(ei.Condition)}) {{");
                        Block(ei.Statement);
                        el = ei.Else;
                    }
                    else
                    {
                        w.Line("} else {");
                        Block(el.Statement);
                        el = null;
                    }
                }
                w.Line("}");
                break;
            case WhileStatementSyntax ws:
                w.Line($"while ({Expr(ws.Condition)}) {{"); Block(ws.Statement); w.Line("}"); break;
            case DoStatementSyntax ds:
                w.Line("do {"); Block(ds.Statement); w.Line($"}} while ({Expr(ds.Condition)});"); break;
            case ForStatementSyntax fs:
            {
                string init = fs.Declaration != null
                    ? string.Join(", ", fs.Declaration.Variables.Select(v => Declare(v.Identifier.Text, " : " + TypeName(fs.Declaration.Type.ToString())) + (v.Initializer != null ? " = " + Expr(v.Initializer.Value) : "")))
                    : string.Join(", ", fs.Initializers.Select(Expr));
                w.Line($"for ({init}; {(fs.Condition != null ? Expr(fs.Condition) : "")}; {string.Join(", ", fs.Incrementors.Select(Expr))}) {{");
                Block(fs.Statement); w.Line("}");
                break;
            }
            case ForEachStatementSyntax fe:
            {
                var t = fe.Type.ToString() == "var" ? "" : " : " + TypeName(fe.Type.ToString());
                w.Line($"for ({Declare(fe.Identifier.Text, t)} in {Expr(fe.Expression)}) {{"); Block(fe.Statement); w.Line("}");
                break;
            }
            case SwitchStatementSyntax sw:
                w.Line($"switch ({Expr(sw.Expression)}) {{");
                foreach (var sec in sw.Sections)
                {
                    foreach (var lab in sec.Labels)
                        w.Line(lab is CaseSwitchLabelSyntax cl ? $"case {Expr(cl.Value)}:" : "default:");
                    w.Indent++;
                    foreach (var st in sec.Statements) Stmt(st);
                    w.Indent--;
                }
                w.Line("}");
                break;
            case TryStatementSyntax ts:
                w.Line("try {"); Block(ts.Block);
                foreach (var cc in ts.Catches) { w.Line($"}} catch ({cc.Declaration?.Identifier.Text ?? "e"} : {TypeName(cc.Declaration?.Type.ToString() ?? "System.Exception")}) {{"); Block(cc.Block); }
                if (ts.Finally != null) { w.Line("} finally {"); Block(ts.Finally.Block); }
                w.Line("}");
                break;
            case ThrowStatementSyntax th:
                w.Line(th.Expression != null ? $"throw {Expr(th.Expression)};" : "throw;"); break;
            case EmptyStatementSyntax: break;
            case LabeledStatementSyntax ls:
                w.Line($":{ls.Identifier.Text}"); Stmt(ls.Statement); break;
            case GotoStatementSyntax gs:
                w.Line($"goto {Expr(gs.Expression!)};"); break;
            default:
                w.Line("// TODO untranslated statement: " + s.ToString().Replace("\n", " "));
                break;
        }
    }

    // ---- expressions ----
    public string Expr(ExpressionSyntax e)
    {
        switch (e)
        {
            case LiteralExpressionSyntax lit:
                if (lit.IsKind(SyntaxKind.NumericLiteralExpression))
                {
                    var t = lit.Token.Text;
                    if (t.EndsWith("f") || t.EndsWith("F"))
                    {
                        t = t[..^1];
                        if (!t.Contains('.') && !t.Contains('E') && !t.Contains('e')) t += ".0";
                        return t;
                    }
                    return t;
                }
                return lit.Token.Text;
            case IdentifierNameSyntax id: return id.Identifier.Text;
            case GenericNameSyntax g: return g.Identifier.Text + ".<" + string.Join(", ", g.TypeArgumentList.Arguments.Select(a => TypeName(a.ToString()))) + ">";
            case PredefinedTypeSyntax pt: return TypeName(pt.ToString());
            case QualifiedNameSyntax qn: return qn.ToString();
            case ThisExpressionSyntax: return "this";
            case BaseExpressionSyntax: return "super";
            case ParenthesizedExpressionSyntax p: return "(" + Expr(p.Expression) + ")";
            case MemberAccessExpressionSyntax ma when ma.ToString() == "Math.PI":
                return "Mathf.PI";
            case MemberAccessExpressionSyntax ma:
                if (ma.Expression is PredefinedTypeSyntax pre && pre.Keyword.Text == "string") return "String." + ma.Name.Identifier.Text;
                return Expr(ma.Expression) + "." + Expr(ma.Name);
            case InvocationExpressionSyntax inv when inv.Expression.ToString() is "RuntimeServices.EqualityOperator" && inv.ArgumentList.Arguments.Count == 2:
                return Expr(inv.ArgumentList.Arguments[0].Expression) + " == " + Expr(inv.ArgumentList.Arguments[1].Expression);
            case InvocationExpressionSyntax inv:
                return Expr(inv.Expression) + "(" + string.Join(", ", inv.ArgumentList.Arguments.Select(Arg)) + ")";
            case ElementAccessExpressionSyntax ea:
                return Expr(ea.Expression) + "[" + string.Join(", ", ea.ArgumentList.Arguments.Select(a => Expr(a.Expression))) + "]";
            case ObjectCreationExpressionSyntax oc:
                return TypeName(oc.Type.ToString()) + "(" + string.Join(", ", (oc.ArgumentList?.Arguments ?? default).Select(Arg)) + ")";
            case ArrayCreationExpressionSyntax ac:
                if (ac.Initializer != null)
                    return "[" + string.Join(", ", ac.Initializer.Expressions.Select(Expr)) + "]";
                return "new " + TypeName(ac.Type.ElementType.ToString()) + string.Concat(ac.Type.RankSpecifiers.Select(r => "[" + string.Join(", ", r.Sizes.Select(Expr)) + "]"));
            case ImplicitArrayCreationExpressionSyntax ia:
                return "[" + string.Join(", ", ia.Initializer.Expressions.Select(Expr)) + "]";
            case CastExpressionSyntax ce:
            {
                var t = ce.Type.ToString();
                if (ce.Expression.ToString() == "Math.PI") return "Mathf.PI";
                if (t == "bool") return Expr(ce.Expression);
                if (ce.Expression is InvocationExpressionSyntax gi && gi.Expression.ToString().EndsWith("GetComponent") || ce.Expression.ToString().Contains("GetComponent(typeof") || ce.Expression.ToString().Contains("AddComponent(typeof") || ce.Expression.ToString().Contains("FindObjectOfType(typeof") || ce.Expression.ToString().Contains("Instantiate("))
                    return Expr(ce.Expression);
                if (t is "int" or "float" or "double" or "long" or "byte" or "short" or "uint" or "char")
                    return Expr(ce.Expression); // UnityScript converts numerics implicitly; reviewed by hand against IL
                return $"({Expr(ce.Expression)} as {TypeName(t)})";
            }
            case TypeOfExpressionSyntax to: return TypeName(to.Type.ToString());
            case PrefixUnaryExpressionSyntax pu: return pu.OperatorToken.Text + Expr(pu.Operand);
            case PostfixUnaryExpressionSyntax po: return Expr(po.Operand) + po.OperatorToken.Text;
            case BinaryExpressionSyntax be:
                if (be.IsKind(SyntaxKind.SubtractExpression) && be.Left is LiteralExpressionSyntax z && (z.Token.Text is "0f" or "0.0"))
                    return "-" + Expr(be.Right);
                if (be.IsKind(SyntaxKind.IsExpression)) return $"{Expr(be.Left)} instanceof {TypeName(be.Right.ToString())}";
                if (be.IsKind(SyntaxKind.AsExpression)) return $"{Expr(be.Left)} as {TypeName(be.Right.ToString())}";
                return Expr(be.Left) + " " + be.OperatorToken.Text + " " + Expr(be.Right);
            case AssignmentExpressionSyntax a: return Expr(a.Left) + " " + a.OperatorToken.Text + " " + Expr(a.Right);
            case ConditionalExpressionSyntax c: return $"{Expr(c.Condition)} ? {Expr(c.WhenTrue)} : {Expr(c.WhenFalse)}";
            case DefaultExpressionSyntax d: return $"default({TypeName(d.Type.ToString())})";
            case CheckedExpressionSyntax ck: return Expr(ck.Expression);
            case SimpleLambdaExpressionSyntax or ParenthesizedLambdaExpressionSyntax or AnonymousMethodExpressionSyntax:
                return "/* TODO lambda: " + e.ToString().Replace("*/", "* /") + " */";
            default:
                return "/* TODO expr: " + e.ToString().Replace("*/", "* /") + " */";
        }
    }

    string Arg(ArgumentSyntax a) => (a.RefKindKeyword.IsKind(SyntaxKind.None) ? "" : "") + Expr(a.Expression);
}
