using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

// Runs test suites from the command line and writes one JSON object per line:
//   GangBeastsDev.exe -batchmode -nographics -devtest smoke,ai -devseed 1 -devout results.jsonl
// Optional: -devfilter <substring of test name>. Each test starts with Random.seed = seed and runs
// with Time.captureFramerate = 100, so every frame is exactly one 0.01 s physics step (the game's
// fixed timestep): simulated time no longer depends on how fast the machine is. The last line is
// {"type":"end"}; a results file without it means the player crashed or hung.
public class DevTestRunner : MonoBehaviour
{
	public const int SimFramerate = 100;

	public static int fixedSteps;

	public static int levelLoads;

	private static readonly List<string> logErrors = new List<string>();

	// Errors and exceptions logged since the player started (tests can diff it around an action).
	public static int ErrorCount;

	// Errors 0.0.3 itself logs (diag/vanilla_errors: each level loaded and left alone for 5 s). Only
	// ProBuilder's, when Menu loads; anything else logged during a test fails it.
	public static readonly string[] vanillaErrors = { "pb_Object.GenerateSubmeshes" };

	private StreamWriter output;

	private string[] suiteNames;

	private string filter;

	private int seed = 1;

	private int failed;

	public static bool Requested()
	{
		return Arg("-devtest") != null;
	}

	public static string Arg(string name)
	{
		string[] args = Environment.GetCommandLineArgs();
		for (int i = 0; i < args.Length - 1; i++)
		{
			if (args[i] == name)
			{
				return args[i + 1];
			}
		}
		return null;
	}

	private void Awake()
	{
		suiteNames = Arg("-devtest").Split(',');
		filter = Arg("-devfilter");
		string seedArg = Arg("-devseed");
		if (seedArg != null)
		{
			seed = int.Parse(seedArg);
		}
		string path = Arg("-devout");
		if (path == null)
		{
			path = Path.Combine(Application.dataPath, "devtest.jsonl");
		}
		output = new StreamWriter(path, false);
		output.AutoFlush = true;
		Application.RegisterLogCallback(OnLog);
		Write("{\"type\":\"start\",\"unity\":" + DevJson.String(Application.unityVersion) + ",\"level\":" + DevJson.String(Application.loadedLevelName)
			+ ",\"seed\":" + seed + ",\"suites\":" + DevJson.Array(new List<string>(suiteNames)) + "}");
	}

	private void Start()
	{
		StartCoroutine(RunAll());
	}

	private void FixedUpdate()
	{
		fixedSteps++;
	}

	private void OnLevelWasLoaded(int level)
	{
		levelLoads++;
	}

	private static void OnLog(string condition, string stackTrace, LogType type)
	{
		if (type == LogType.Error || type == LogType.Exception || type == LogType.Assert)
		{
			ErrorCount++;
			logErrors.Add(type + ": " + condition + (string.IsNullOrEmpty(stackTrace) ? "" : "\n" + stackTrace));
		}
	}

	private void Write(string line)
	{
		output.WriteLine(line);
	}

	private IEnumerator RunAll()
	{
		foreach (string suiteName in suiteNames)
		{
			DevTestSuite suite = DevTestSuites.Find(suiteName);
			if (suite == null)
			{
				failed++;
				Write("{\"type\":\"test\",\"suite\":" + DevJson.String(suiteName) + ",\"name\":\"(suite)\",\"status\":\"error\",\"failures\":[\"no such suite\"]}");
				continue;
			}
			foreach (KeyValuePair<string, DevTestBody> test in suite.tests)
			{
				if (filter != null && test.Key.IndexOf(filter, StringComparison.Ordinal) < 0)
				{
					continue;
				}
				yield return StartCoroutine(RunOne(suite.name, test.Key, test.Value));
			}
		}
		Time.captureFramerate = 0;
		Write("{\"type\":\"end\",\"failed\":" + failed + "}");
		output.Close();
		Application.Quit();
	}

	private IEnumerator RunOne(string suite, string name, DevTestBody body)
	{
		DevTestContext t = new DevTestContext(suite, name, seed);
		Time.timeScale = 1f;
		Time.captureFramerate = SimFramerate;
		UnityEngine.Random.seed = seed;
		logErrors.Clear();
		float started = Time.realtimeSinceStartup;
		int startStep = fixedSteps;
		string crash = null;
		// Drive the test by hand so an exception inside it is caught and reported (Unity would only log
		// it and silently stop the coroutine). A yielded IEnumerator runs as a nested step.
		Stack<IEnumerator> stack = new Stack<IEnumerator>();
		stack.Push(body(t));
		while (stack.Count > 0)
		{
			IEnumerator top = stack.Peek();
			bool more;
			try
			{
				more = top.MoveNext();
			}
			catch (Exception e)
			{
				crash = e.ToString();
				break;
			}
			if (!more)
			{
				stack.Pop();
				continue;
			}
			IEnumerator nested = top.Current as IEnumerator;
			if (nested != null)
			{
				stack.Push(nested);
				continue;
			}
			yield return top.Current;
		}
		int unexpected = 0;
		foreach (string e in logErrors)
		{
			bool known = false;
			foreach (string v in vanillaErrors)
			{
				known |= e.Contains(v);
			}
			if (!known)
			{
				unexpected++;
			}
		}
		if (unexpected > 0 && !t.allowLoggedErrors)
		{
			t.failures.Add(unexpected + " error(s) logged during the test (see errors)");
		}
		string status = crash != null ? "error" : (t.failures.Count > 0 ? "fail" : "pass");
		if (status != "pass")
		{
			failed++;
		}
		List<string> errors = new List<string>(logErrors);
		if (crash != null)
		{
			errors.Insert(0, "Exception in test: " + crash);
		}
		List<KeyValuePair<string, string>> fields = new List<KeyValuePair<string, string>>();
		fields.Add(new KeyValuePair<string, string>("type", DevJson.String("test")));
		fields.Add(new KeyValuePair<string, string>("suite", DevJson.String(suite)));
		fields.Add(new KeyValuePair<string, string>("name", DevJson.String(name)));
		fields.Add(new KeyValuePair<string, string>("status", DevJson.String(status)));
		fields.Add(new KeyValuePair<string, string>("seed", seed.ToString()));
		fields.Add(new KeyValuePair<string, string>("checks", t.checks.ToString()));
		fields.Add(new KeyValuePair<string, string>("steps", (fixedSteps - startStep).ToString()));
		fields.Add(new KeyValuePair<string, string>("real_seconds", DevJson.Number(Time.realtimeSinceStartup - started)));
		fields.Add(new KeyValuePair<string, string>("failures", DevJson.Array(t.failures)));
		fields.Add(new KeyValuePair<string, string>("errors", DevJson.Array(errors)));
		fields.Add(new KeyValuePair<string, string>("metrics", DevJson.Object(t.metrics, true)));
		fields.Add(new KeyValuePair<string, string>("info", DevJson.Object(t.info, false)));
		Write(DevJson.Object(fields, true));
	}
}
