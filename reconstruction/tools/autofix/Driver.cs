using System.Collections.Concurrent;
using System.Diagnostics;
using System.Text;

static class Program
{
    static string Root = "", Asm = "", SrcDir = "";
    static Assembly Original = null!;
    static int Workers = Math.Max(1, Environment.ProcessorCount - 2);

    static int Main(string[] args)
    {
        Root = Path.GetFullPath(args[0]); Asm = args[1];
        int maxPasses = args.Length > 2 ? int.Parse(args[2]) : 8;
        Original = new Assembly(Path.Combine(Root, "..", "gang_beasts_0_0_3_windows", "Gang Beasts_Data", "Managed", Asm + ".dll"));
        SrcDir = Path.Combine(Root, "src", Asm);

        var dist = Measure(null, null);
        if (dist == null) { Console.Error.WriteLine("baseline build failed"); return 1; }
        Console.WriteLine($"baseline: {dist.Count(d => d.Value > 0)} differing methods");

        for (int pass = 1; pass <= maxPasses; pass++)
        {
            var files = Directory.EnumerateFiles(SrcDir, "*.cs", SearchOption.AllDirectories).ToDictionary(f => f, f => SourceFile.Load(f));
            var index = Locator.Index(files.Values);
            // Group differing metadata methods by the source body that produces them.
            var sites = new Dictionary<string, (Site Site, List<string> Keys)>();
            foreach (var (key, d) in dist)
            {
                if (d == 0) continue;
                var site = Locator.Find(index, key);
                if (site == null) continue;
                var id = site.File.Path + "@" + site.Body.SpanStart;
                if (!sites.TryGetValue(id, out var e)) sites[id] = e = (site, new List<string>());
                e.Keys.Add(key);
            }
            var cands = Prefilter.Run(Root, Asm, files, sites.ToDictionary(x => x.Key, x => Generators.For(x.Value.Site)));
            int maxK = cands.Count == 0 ? 0 : cands.Max(c => c.Value.Count);
            Console.WriteLine($"pass {pass}: {sites.Count} source bodies, {cands.Sum(c => c.Value.Count)} candidates (max {maxK} per body)");
            if (maxK == 0) break;

            // Candidate k of every body goes into one compile; compiles run in parallel.
            var results = new ConcurrentBag<(string Site, Edit Edit, int Score)>();
            var jobs = new ConcurrentQueue<Dictionary<string, Edit>>();
            for (int k = 0; k < maxK; k++)
            {
                var batch = cands.Where(c => k < c.Value.Count).ToDictionary(c => c.Key, c => c.Value[k]);
                if (batch.Count > 0) jobs.Enqueue(batch);
            }
            var threads = Enumerable.Range(0, Workers).Select(w => new Thread(() =>
            {
                while (jobs.TryDequeue(out var batch)) Run(w, files, batch, sites, results);
            })).ToList();
            threads.ForEach(t => t.Start()); threads.ForEach(t => t.Join());

            var chosen = new Dictionary<string, Edit>();
            foreach (var (id, (site, keys)) in sites)
            {
                int baseScore = keys.Sum(k => dist[k]);
                var best = results.Where(r => r.Site == id).OrderBy(r => r.Score).FirstOrDefault();
                if (best.Edit != null && best.Score < baseScore)
                {
                    chosen[id] = best.Edit;
                    Console.WriteLine($"    + {keys[0]}{(keys.Count > 1 ? $" (+{keys.Count - 1})" : "")}  {baseScore} -> {best.Score}  [{best.Edit.Rule}]");
                }
            }
            if (chosen.Count == 0) break;
            WriteAll(SrcDir, files, chosen.Values.ToList());
            var after = Measure(null, null);
            if (after == null)
            {
                // Rare interaction between accepted edits: keep a buildable subset, adding one at a time.
                Console.WriteLine("  combined edits fail to build; adding incrementally");
                var keep = new List<Edit>();
                foreach (var e in chosen.Values)
                {
                    WriteAll(SrcDir, files, keep.Append(e).ToList());
                    if (Measure(null, null) != null) keep.Add(e);
                }
                WriteAll(SrcDir, files, keep);
                after = Measure(null, null)!;
            }
            dist = after;
            Console.WriteLine($"pass {pass}: accepted {chosen.Count}; now {dist.Count(d => d.Value > 0)} differing methods");
        }
        foreach (var (k, d) in dist.Where(d => d.Value > 0).OrderBy(d => d.Key)) Console.WriteLine($"  remaining d={d,-4} {k}");
        return 0;
    }

    static void Run(int w, Dictionary<string, SourceFile> files, Dictionary<string, Edit> batch,
        Dictionary<string, (Site Site, List<string> Keys)> sites, ConcurrentBag<(string, Edit, int)> results)
    {
        var workRoot = Path.Combine(Root, "build", "work", w.ToString());
        WriteAll(Path.Combine(workRoot, "src", Asm), files, batch.Values.ToList());
        var d = Measure(Path.Combine(workRoot, "src"), Path.Combine(workRoot, "out"));
        if (d == null)
        {
            if (batch.Count == 1) return;
            var keys = batch.Keys.ToList(); int half = keys.Count / 2;
            Run(w, files, keys.Take(half).ToDictionary(k => k, k => batch[k]), sites, results);
            Run(w, files, keys.Skip(half).ToDictionary(k => k, k => batch[k]), sites, results);
            return;
        }
        foreach (var (id, e) in batch)
            results.Add((id, e, sites[id].Keys.Sum(k => d.GetValueOrDefault(k, 1000))));
    }

    // Writes every source file of the assembly into dir (mirroring SrcDir), with edits applied.
    static void WriteAll(string dir, Dictionary<string, SourceFile> files, List<Edit> edits)
    {
        foreach (var (path, f) in files)
        {
            var mine = edits.Where(e => e.File == path).OrderByDescending(e => e.Start).ToList();
            var text = f.Text;
            foreach (var e in mine) text = text[..e.Start] + e.NewText + text[(e.Start + e.Length)..];
            var target = Path.Combine(dir, Path.GetRelativePath(SrcDir, path));
            Directory.CreateDirectory(Path.GetDirectoryName(target)!);
            var b = Encoding.UTF8.GetBytes(text);
            var bytes = f.Bom ? Encoding.UTF8.GetPreamble().Concat(b).ToArray() : b;
            if (!File.Exists(target) || !File.ReadAllBytes(target).AsSpan().SequenceEqual(bytes)) File.WriteAllBytes(target, bytes);
        }
    }

    // Builds the assembly (optionally from an isolated tree) and returns per-method distances.
    static Dictionary<string, int>? Measure(string? srcRoot, string? outDir)
    {
        var psi = new ProcessStartInfo("bash", $"tools/build.sh {Asm}")
        { WorkingDirectory = Root, RedirectStandardOutput = true, RedirectStandardError = true, UseShellExecute = false };
        if (srcRoot != null) psi.Environment["SRC_ROOT"] = srcRoot;
        if (outDir != null) psi.Environment["OUT_DIR"] = outDir;
        using var p = Process.Start(psi)!;
        var so = p.StandardOutput.ReadToEndAsync(); var se = p.StandardError.ReadToEndAsync();
        p.WaitForExit(); so.Wait(); se.Wait();
        if (p.ExitCode != 0) return null;
        var rebuilt = new Assembly(Path.Combine(outDir ?? Path.Combine(Root, "build", "out"), Asm + ".dll"));
        var result = new Dictionary<string, int>();
        foreach (var (key, om) in Original.Methods)
            result[key] = rebuilt.Methods.TryGetValue(key, out var rm) ? Distance(om, rm) : 1000;
        return result;
    }

    public static int Distance(Method a, Method b)
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
        int lcs = prev[0];
        return (n - lcs) + (m - lcs) + (a.Header == b.Header ? 0 : 1);
    }
}
