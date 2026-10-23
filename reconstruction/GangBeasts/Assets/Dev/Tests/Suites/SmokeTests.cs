using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// The feasibility spike: does a headless player boot, step physics at the expected rate, load a
// level with working renderers, and replay the same seed the same way?
public static class SmokeTests
{
	public static DevTestSuite Suite()
	{
		return new DevTestSuite("smoke")
			.Add("boot", Boot)
			.Add("fixed_steps", FixedSteps)
			.Add("load_street", LoadStreet)
			.Add("determinism", Determinism);
	}

	private static IEnumerator Boot(DevTestContext t)
	{
		t.Info("unity", Application.unityVersion);
		t.Info("level", Application.loadedLevelName);
		t.Info("graphics", SystemInfo.graphicsDeviceName);
		t.Info("args", string.Join(" ", Environment.GetCommandLineArgs()));
		t.Metric("fixed_delta", Time.fixedDeltaTime);
		t.Near(0.01, Time.fixedDeltaTime, 1e-6, "fixed timestep");
		t.Check(DevRoot.instance != null, "DevRoot exists");
		yield break;
	}

	private static IEnumerator FixedSteps(DevTestContext t)
	{
		int start = DevTestRunner.fixedSteps;
		float simStart = Time.time;
		yield return t.Frames(100);
		int steps = DevTestRunner.fixedSteps - start;
		t.Metric("steps_per_100_frames", steps);
		t.Metric("sim_seconds", Time.time - simStart);
		t.InRange(99, 101, steps, "one physics step per frame");
	}

	private static IEnumerator LoadStreet(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		t.Equal("Street", Application.loadedLevelName, "level");
		int humans = 0;
		int mobs = 0;
		float headSize = 0f;
		foreach (UnityEngine.Object o in UnityEngine.Object.FindObjectsOfType(typeof(Player)))
		{
			Player p = (Player)o;
			if (p.mob)
			{
				mobs++;
			}
			else
			{
				humans++;
			}
			if (p.part.ContainsKey("head") && p.part["head"].renderer != null)
			{
				headSize = Mathf.Max(headSize, p.part["head"].renderer.bounds.size.magnitude);
			}
		}
		t.Metric("humans", humans);
		t.Metric("mobs", mobs);
		t.Metric("head_bounds", headSize);
		t.Equal(10, mobs, "Street mobs (9 + the pink boss)");
		t.Check(humans >= 1, "at least one human");
		t.Check(headSize > 0.1f, "renderer bounds work");
	}

	// Loads Street three times with the same seed (and once with another) and hashes every rigidbody's
	// pose each physics step. Bit-for-bit equal runs mean tests can replay exactly; otherwise they must
	// be statistical.
	private static IEnumerator Determinism(DevTestContext t)
	{
		const int Steps = 600;
		List<List<uint>> runs = new List<List<uint>>();
		for (int run = 0; run < 4; run++)
		{
			UnityEngine.Random.seed = run < 3 ? t.seed : t.seed + 1;
			yield return t.LoadLevel("Street");
			UnityEngine.Random.seed = run < 3 ? t.seed : t.seed + 1;
			List<uint> hashes = new List<uint>();
			for (int i = 0; i < Steps; i++)
			{
				yield return new WaitForFixedUpdate();
				hashes.Add(PoseHash());
			}
			runs.Add(hashes);
		}
		for (int run = 1; run < runs.Count; run++)
		{
			int diverged = -1;
			for (int i = 0; i < Steps; i++)
			{
				if (runs[run][i] != runs[0][i])
				{
					diverged = i;
					break;
				}
			}
			t.Metric((run < 3 ? "same_seed_run" : "other_seed_run") + run + "_diverged_at", diverged);
		}
		t.Info("note", "diverged_at = -1 means the run matched run 0 bit for bit; runs 1-2 share its seed, run 3 does not");
	}

	// Every rigidbody's name and the raw bits of its pose, FNV-1a per body, summed: independent of the
	// order FindObjectsOfType returns them in (a sort is no fix: same-named bodies tie and List.Sort is
	// unstable, which made identical states hash differently).
	public static uint PoseHash()
	{
		uint sum = 0u;
		foreach (UnityEngine.Object o in UnityEngine.Object.FindObjectsOfType(typeof(Rigidbody)))
		{
			Rigidbody body = (Rigidbody)o;
			uint hash = 2166136261u;
			foreach (char c in body.transform.root.name + "/" + body.name)
			{
				hash = (hash ^ c) * 16777619u;
			}
			Vector3 p = body.position;
			Quaternion q = body.rotation;
			hash = Mix(hash, p.x);
			hash = Mix(hash, p.y);
			hash = Mix(hash, p.z);
			hash = Mix(hash, q.x);
			hash = Mix(hash, q.y);
			hash = Mix(hash, q.z);
			hash = Mix(hash, q.w);
			sum += hash;
		}
		return sum;
	}

	private static uint Mix(uint hash, float value)
	{
		byte[] bytes = BitConverter.GetBytes(value);
		for (int i = 0; i < 4; i++)
		{
			hash ^= bytes[i];
			hash *= 16777619u;
		}
		return hash;
	}
}
