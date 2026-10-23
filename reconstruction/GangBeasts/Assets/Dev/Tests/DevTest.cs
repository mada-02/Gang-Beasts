using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using UnityEngine;

public delegate IEnumerator DevTestBody(DevTestContext t);

// A named group of tests, run in order. Suites register themselves in DevTestSuites.
public class DevTestSuite
{
	public readonly string name;

	public readonly List<KeyValuePair<string, DevTestBody>> tests = new List<KeyValuePair<string, DevTestBody>>();

	public DevTestSuite(string name)
	{
		this.name = name;
	}

	public DevTestSuite Add(string testName, DevTestBody body)
	{
		tests.Add(new KeyValuePair<string, DevTestBody>(testName, body));
		return this;
	}
}

// What a running test sees: checks, metrics, waits and level loading. A failed check does not stop
// the test (every failure gets reported); Abort does.
public class DevTestContext
{
	public readonly string suite;

	public readonly string name;

	public readonly int seed;

	public int checks;

	public readonly List<string> failures = new List<string>();

	public readonly List<string> errors = new List<string>();

	public readonly List<KeyValuePair<string, string>> metrics = new List<KeyValuePair<string, string>>();

	public readonly List<KeyValuePair<string, string>> info = new List<KeyValuePair<string, string>>();

	public DevTestContext(string suite, string name, int seed)
	{
		this.suite = suite;
		this.name = name;
		this.seed = seed;
	}

	public bool Check(bool condition, string what)
	{
		checks++;
		if (!condition)
		{
			failures.Add(what);
		}
		return condition;
	}

	public bool Equal<T>(T expected, T actual, string what)
	{
		return Check(EqualityComparer<T>.Default.Equals(expected, actual), what + ": expected " + expected + ", got " + actual);
	}

	public bool Near(double expected, double actual, double tolerance, string what)
	{
		return Check(Math.Abs(expected - actual) <= tolerance, what + ": expected " + expected.ToString("R") + " +- " + tolerance.ToString("R") + ", got " + actual.ToString("R"));
	}

	public bool InRange(double low, double high, double actual, string what)
	{
		return Check(actual >= low && actual <= high, what + ": expected in [" + low.ToString("R") + ", " + high.ToString("R") + "], got " + actual.ToString("R"));
	}

	public void Metric(string key, double value)
	{
		metrics.Add(new KeyValuePair<string, string>(key, DevJson.Number(value)));
	}

	public void Info(string key, string value)
	{
		info.Add(new KeyValuePair<string, string>(key, value));
	}

	public void Fail(string what)
	{
		Check(false, what);
	}

	// Waits for this many physics steps.
	public IEnumerator Steps(int count)
	{
		int target = DevTestRunner.fixedSteps + count;
		while (DevTestRunner.fixedSteps < target)
		{
			yield return new WaitForFixedUpdate();
		}
	}

	public IEnumerator Frames(int count)
	{
		for (int i = 0; i < count; i++)
		{
			yield return null;
		}
	}

	// Loads a level and waits until it has run its Awake/Start and a few physics steps.
	public IEnumerator LoadLevel(string level)
	{
		int loads = DevTestRunner.levelLoads;
		Application.LoadLevel(level);
		while (DevTestRunner.levelLoads == loads)
		{
			yield return null;
		}
		yield return Frames(2);
		yield return Steps(5);
	}
}

// Minimal JSON writing (Unity 4.3 has no JSON library).
public static class DevJson
{
	public static string String(string s)
	{
		if (s == null)
		{
			return "null";
		}
		StringBuilder b = new StringBuilder(s.Length + 2);
		b.Append('"');
		foreach (char c in s)
		{
			switch (c)
			{
			case '"':
				b.Append("\\\"");
				break;
			case '\\':
				b.Append("\\\\");
				break;
			case '\n':
				b.Append("\\n");
				break;
			case '\r':
				b.Append("\\r");
				break;
			case '\t':
				b.Append("\\t");
				break;
			default:
				if (c < ' ')
				{
					b.Append("\\u").Append(((int)c).ToString("x4"));
				}
				else
				{
					b.Append(c);
				}
				break;
			}
		}
		b.Append('"');
		return b.ToString();
	}

	public static string Number(double value)
	{
		if (double.IsNaN(value) || double.IsInfinity(value))
		{
			return String(value.ToString());
		}
		return value.ToString("R", System.Globalization.CultureInfo.InvariantCulture);
	}

	public static string Object(List<KeyValuePair<string, string>> fields, bool rawValues)
	{
		StringBuilder b = new StringBuilder("{");
		for (int i = 0; i < fields.Count; i++)
		{
			if (i > 0)
			{
				b.Append(',');
			}
			b.Append(String(fields[i].Key)).Append(':').Append(rawValues ? fields[i].Value : String(fields[i].Value));
		}
		return b.Append('}').ToString();
	}

	public static string Array(List<string> items)
	{
		StringBuilder b = new StringBuilder("[");
		for (int i = 0; i < items.Count; i++)
		{
			if (i > 0)
			{
				b.Append(',');
			}
			b.Append(String(items[i]));
		}
		return b.Append(']').ToString();
	}
}
