// ildiff: metadata-layout and IL comparison for the Gang Beasts reconstruction.
//
//   ildiff layout <dll>                 types / fields / methods in metadata (token) order
//   ildiff diff <original> <rebuilt>    per-method comparison:
//        RAW   raw IL bytes, locals and EH identical (tokens included)
//        SEM   identical once tokens are resolved to names (layout-only difference)
//        DIFF  different code after resolving tokens
//   ildiff il <dll> <type-filter> [member-filter]   normalized IL of matching methods
using System.Collections.Immutable;
using System.Reflection;
using System.Reflection.Emit;
using System.Reflection.Metadata;
using System.Reflection.Metadata.Ecma335;
using System.Reflection.PortableExecutable;
using System.Text;

static class Program
{
    static int Main(string[] args)
    {
        if (args.Length < 2) { Console.Error.WriteLine("usage: ildiff layout|diff|il ..."); return 2; }
        switch (args[0])
        {
            case "layout": Layout(new Assembly(args[1])); return 0;
            case "diff": return Diff(new Assembly(args[1]), new Assembly(args[2]), args.Skip(3).ToArray());
            case "dist":
            {
                // Per-method distance (LCS over index-normalized IL + header mismatch), one line per original method.
                var o = new Assembly(args[1]); var r = new Assembly(args[2]);
                foreach (var (key, om) in o.Methods)
                    Console.WriteLine($"{(r.Methods.TryGetValue(key, out var rm) ? Dist(om, rm) : 1000)}	{key}");
                return 0;
            }
            case "il":
                var a = new Assembly(args[1]);
                foreach (var m in a.Methods.Values.Where(m => m.TypeName.Contains(args[2]) && (args.Length < 4 || m.Name == args[3])))
                {
                    Console.WriteLine($"// {m.Key}  token=0x{m.Token:x8}  rva={m.Rva}");
                    foreach (var l in m.Normalized) Console.WriteLine("  " + l);
                }
                return 0;
        }
        return 2;
    }

    static void Layout(Assembly a)
    {
        foreach (var t in a.TypeOrder)
        {
            Console.WriteLine($"type 0x{t.Token:x8} {t.Attributes} {t.FullName} : {t.BaseType}");
            foreach (var f in t.Fields) Console.WriteLine($"    field {f}");
            foreach (var m in t.MethodKeys) Console.WriteLine($"    method {m}");
        }
    }

    static int Diff(Assembly o, Assembly r, string[] opts)
    {
        bool verbose = opts.Contains("-v");
        int raw = 0, sem = 0, diff = 0, missing = 0, extra = 0;
        var report = new StringBuilder();
        foreach (var (key, om) in o.Methods)
        {
            if (!r.Methods.TryGetValue(key, out var rm)) { missing++; report.AppendLine($"MISSING {key}"); continue; }
            if (om.RawEquals(rm)) { raw++; if (verbose) report.AppendLine($"RAW     {key}"); continue; }
            if (om.Normalized.SequenceEqual(rm.Normalized) && om.Header == rm.Header) { sem++; if (verbose) report.AppendLine($"SEM     {key}"); continue; }
            diff++;
            report.AppendLine($"DIFF    {key}");
            if (verbose) report.Append(LineDiff(om, rm));
        }
        foreach (var key in r.Methods.Keys.Where(k => !o.Methods.ContainsKey(k))) { extra++; report.AppendLine($"EXTRA   {key}"); }

        // Layout facts that also determine raw token identity.
        var ot = o.TypeOrder.Select(t => t.FullName).ToList();
        var rt = r.TypeOrder.Select(t => t.FullName).ToList();
        bool typeOrder = ot.SequenceEqual(rt);
        int typeShapeDiffs = 0;
        foreach (var t in o.TypeOrder)
        {
            var other = r.TypeOrder.FirstOrDefault(x => x.FullName == t.FullName);
            if (other == null) { report.AppendLine($"TYPE-MISSING {t.FullName}"); typeShapeDiffs++; continue; }
            if (t.Attributes != other.Attributes || t.BaseType != other.BaseType || !t.Interfaces.SequenceEqual(other.Interfaces))
            { report.AppendLine($"TYPE-HEADER  {t.FullName}: {t.Attributes} : {t.BaseType} [{string.Join(",", t.Interfaces)}]  vs  {other.Attributes} : {other.BaseType} [{string.Join(",", other.Interfaces)}]"); typeShapeDiffs++; }
            if (!t.Fields.SequenceEqual(other.Fields))
            { report.AppendLine($"FIELDS       {t.FullName}\n      orig: {string.Join(" | ", t.Fields)}\n      ours: {string.Join(" | ", other.Fields)}"); typeShapeDiffs++; }
            if (!t.MethodKeys.SequenceEqual(other.MethodKeys))
            { report.AppendLine($"METHOD-ORDER {t.FullName}"); typeShapeDiffs++; }
            if (!t.Properties.SequenceEqual(other.Properties))
            { report.AppendLine($"PROPERTIES   {t.FullName}\n      orig: {string.Join(" | ", t.Properties)}\n      ours: {string.Join(" | ", other.Properties)}"); typeShapeDiffs++; }
            if (!t.CustomAttributes.SequenceEqual(other.CustomAttributes))
            { report.AppendLine($"ATTRIBUTES   {t.FullName}\n      orig: {string.Join(" | ", t.CustomAttributes)}\n      ours: {string.Join(" | ", other.CustomAttributes)}"); typeShapeDiffs++; }
        }
        foreach (var t in rt.Where(n => !ot.Contains(n))) { report.AppendLine($"TYPE-EXTRA   {t}"); typeShapeDiffs++; }
        if (!typeOrder)
        {
            report.AppendLine("TYPE-ORDER differs (first divergence):");
            for (int i = 0; i < Math.Max(ot.Count, rt.Count); i++)
                if (i >= ot.Count || i >= rt.Count || ot[i] != rt[i])
                { report.AppendLine($"      #{i}: orig {(i < ot.Count ? ot[i] : "-")}  ours {(i < rt.Count ? rt[i] : "-")}"); break; }
        }
        var heapNote = $"#US heap {o.UserStringHeapSize} vs {r.UserStringHeapSize}; MemberRef rows {o.MemberRefCount} vs {r.MemberRefCount}; TypeRef rows {o.TypeRefCount} vs {r.TypeRefCount}";
        Console.Write(report);
        Console.WriteLine($"SUMMARY methods={o.Methods.Count} raw={raw} semantic-only={sem} diff={diff} missing={missing} extra={extra} type-order={(typeOrder ? "same" : "DIFFERENT")} type-shape-diffs={typeShapeDiffs}");
        Console.WriteLine($"        {heapNote}");
        return diff + missing + extra + typeShapeDiffs == 0 ? 0 : 1;
    }

    public static int Dist(Method a, Method b)
    {
        var x = a.Indexed(); var y = b.Indexed();
        int n = x.Count, m = y.Count;
        var prev = new int[m + 1]; var cur = new int[m + 1];
        for (int i = n - 1; i >= 0; i--)
        {
            Array.Clear(cur);
            for (int j = m - 1; j >= 0; j--)
                cur[j] = x[i] == y[j] ? prev[j + 1] + 1 : Math.Max(prev[j], cur[j + 1]);
            (prev, cur) = (cur, prev);
        }
        return (n - prev[0]) + (m - prev[0]) + (a.Header == b.Header ? 0 : 1);
    }

    static string LineDiff(Method a, Method b)
    {
        var sb = new StringBuilder();
        if (a.Header != b.Header) sb.AppendLine($"    header: {a.Header}\n        vs: {b.Header}");
        // Simple LCS-based line diff.
        var x = a.Normalized; var y = b.Normalized;
        int n = x.Count, m = y.Count;
        var dp = new int[n + 1, m + 1];
        for (int i = n - 1; i >= 0; i--) for (int j = m - 1; j >= 0; j--)
            dp[i, j] = x[i] == y[j] ? dp[i + 1, j + 1] + 1 : Math.Max(dp[i + 1, j], dp[i, j + 1]);
        int p = 0, q = 0, shown = 0;
        while ((p < n || q < m) && shown < 60)
        {
            if (p < n && q < m && x[p] == y[q]) { p++; q++; continue; }
            if (q < m && (p == n || dp[p, q + 1] >= dp[p + 1, q])) { sb.AppendLine($"    + {y[q++]}"); shown++; }
            else { sb.AppendLine($"    - {x[p++]}"); shown++; }
        }
        return sb.ToString();
    }
}

