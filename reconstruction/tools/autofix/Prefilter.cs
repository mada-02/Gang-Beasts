using System.Collections.Concurrent;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;

// Rejects candidate edits that cannot compile (e.g. "return;" in a non-void method, or a
// use of an unassigned local) before any smcs build is spent on them. Roslyn binds the
// edited method against the same references smcs uses (Unity's Mono 2.0 profile).
static class Prefilter
{
    public static Dictionary<string, List<Edit>> Run(string root, string asm, Dictionary<string, SourceFile> files, Dictionary<string, List<Edit>> cands)
    {
        var unity = Path.Combine(root, "..", "UnitySetup-4.3.2", "Data");
        var profile = Path.Combine(unity, "Mono", "lib", "mono", "unity");
        // Copies of UnityEngine/plugins with framework refs retargeted to the unity profile
        // (tools/retarget_refs.py): Roslyn does not unify 2.0.0.0/3.5.0.0 with 2.0.5.0 as smcs does.
        var retargeted = Path.Combine(root, "build", "prefilter-refs");
        var managed = Path.Combine(root, "..", "gang_beasts_0_0_3_windows", "Gang Beasts_Data", "Managed");
        string Sib(string n) => File.Exists(Path.Combine(root, "build", "out", n + ".dll")) ? Path.Combine(root, "build", "out", n + ".dll") : Path.Combine(managed, n + ".dll");
        var refs = new[]
        {
            Path.Combine(profile, "mscorlib.dll"), Path.Combine(profile, "System.dll"), Path.Combine(profile, "System.Core.dll"),
            Path.Combine(profile, "System.Runtime.Serialization.dll"), Path.Combine(profile, "System.Xml.Linq.dll"),
            Path.Combine(retargeted, "UnityEngine.dll"), Sib("Assembly-CSharp-firstpass"), Sib("Assembly-UnityScript-firstpass"),
            Path.Combine(retargeted, "ProBuilderCore.dll"), Path.Combine(retargeted, "SixBySeven.dll"),
        }.Where(File.Exists).Select(p => (MetadataReference)MetadataReference.CreateFromFile(p)).ToList();
        var opts = new CSharpParseOptions(LanguageVersion.CSharp4, // smcs (Mono 2.x) accepts e.g. optional parameters
             preprocessorSymbols: new[] { "UNITY_4_3_2", "UNITY_4_3", "UNITY_STANDALONE_WIN", "UNITY_STANDALONE" });
        var trees = files.ToDictionary(f => f.Key, f => CSharpSyntaxTree.ParseText(f.Value.Text, opts, f.Key));
        var comp = CSharpCompilation.Create(asm, trees.Values, refs,
            new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary, nullableContextOptions: NullableContextOptions.Disable));
        var baseline = comp.GetDiagnostics().Count(d => d.Severity == DiagnosticSeverity.Error);
        if (baseline > 0)
        {
            // Roslyn disagrees with smcs about the baseline; do not filter rather than filter wrongly.
            foreach (var d in comp.GetDiagnostics().Where(d => d.Severity == DiagnosticSeverity.Error).Take(10)) Console.WriteLine($"  prefilter baseline error: {d}");
            Console.WriteLine("  prefilter disabled for this pass");
            return cands;
        }
        var result = new ConcurrentDictionary<string, List<Edit>>();
        int kept = 0, dropped = 0;
        Parallel.ForEach(cands, kv =>
        {
            var ok = new List<Edit>();
            foreach (var e in kv.Value)
            {
                var text = files[e.File].Text;
                var newText = text[..e.Start] + e.NewText + text[(e.Start + e.Length)..];
                var tree = CSharpSyntaxTree.ParseText(newText, opts, e.File);
                var c2 = comp.ReplaceSyntaxTree(trees[e.File], tree);
                var span = new Microsoft.CodeAnalysis.Text.TextSpan(e.Start, e.NewText.Length);
                var model = c2.GetSemanticModel(tree);
                var errs = model.GetDiagnostics(span).Any(d => d.Severity == DiagnosticSeverity.Error)
                    || tree.GetDiagnostics().Any(d => d.Severity == DiagnosticSeverity.Error);
                if (errs) Interlocked.Increment(ref dropped);
                else { ok.Add(e); Interlocked.Increment(ref kept); }
            }
            result[kv.Key] = ok;
        });
        Console.WriteLine($"  prefilter: kept {kept}, dropped {dropped} non-compiling candidate(s)");
        return result.ToDictionary(k => k.Key, k => k.Value);
    }
}
