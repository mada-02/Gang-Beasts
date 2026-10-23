using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Investigations: tests that measure and report rather than pass/fail, kept so a finding can be re-run.
public static class DiagTests
{
	public static DevTestSuite Suite()
	{
		return new DevTestSuite("diag")
			.Add("gondola_spawn_fling", GondolaSpawnFling)
			.Add("vanilla_errors", VanillaErrors);
	}

	// What the game itself logs as errors when each level loads and runs for 5 s untouched: the baseline
	// every "no new errors" check is held against (the runner records log errors per test).
	private static IEnumerator VanillaErrors(DevTestContext t)
	{
		t.allowLoggedErrors = true;
		foreach (string level in new string[] { "Menu", "Tutorial", "Sandbox", "Ring", "Grind", "Gondola", "Trucks", "Incinerator", "Wheel", "Subway", "Street" })
		{
			int before = DevTestRunner.ErrorCount;
			yield return t.LoadLevel(level);
			yield return t.Steps(500);
			t.Metric(level + "_errors", DevTestRunner.ErrorCount - before);
		}
	}

	// Spawned beasts in Gondola were flung (60-70 m/s). Per spot: the surface under it, whether that
	// surface moves, solid colliders overlapping the body's volume, and the beast's top part speed.
	private static IEnumerator GondolaSpawnFling(DevTestContext t)
	{
		yield return t.LoadLevel("Gondola");
		Vector3 centre;
		if (!DevGround.Snap(DevGround.ScreenCentre(), 4f, out centre))
		{
			centre = BeastRegistry.Human(0).Part("ball").position;
		}
		List<Vector3> spots = BeastFactory.PlanSpots(centre, 10, 1f, null, 0f);
		List<Beast> beasts = new List<Beast>();
		for (int i = 0; i < spots.Count; i++)
		{
			Vector3 spot = spots[i];
			RaycastHit hit;
			string surface = "none";
			if (Physics.Raycast(spot + Vector3.up * 0.5f, Vector3.down, out hit, 2f))
			{
				Rigidbody rb = hit.collider.attachedRigidbody;
				surface = hit.collider.name + (rb != null ? " rb(kinematic " + rb.isKinematic + ", v " + rb.velocity.magnitude.ToString("0.00") + ")" : " static");
			}
			int overlaps = 0;
			string first = "";
			foreach (float h in new float[] { 0.35f, 0.8f, 1.25f })
			{
				foreach (Collider c in Physics.OverlapSphere(spot + Vector3.up * h, 0.3f))
				{
					if (!c.isTrigger)
					{
						overlaps++;
						if (first == "")
						{
							first = c.name;
						}
					}
				}
			}
			t.Info("spot" + i, DevTestUtil.V(spot) + " on " + surface + ", body overlaps " + overlaps + " " + first);
			beasts.Add(BeastFactory.Spawn(new SpawnSpec(), spot + Vector3.up * BeastFactory.HipsHeight(BeastBody.Normal), 0f));
		}
		float[] top = new float[beasts.Count];
		for (int s = 0; s < 50; s++)
		{
			yield return new WaitForFixedUpdate();
			for (int i = 0; i < beasts.Count; i++)
			{
				if (beasts[i].player != null)
				{
					top[i] = Mathf.Max(top[i], DevTestUtil.MaxPartSpeed(beasts[i]));
				}
			}
		}
		for (int i = 0; i < beasts.Count; i++)
		{
			t.Metric("spot" + i + "_max_speed", top[i]);
		}
	}
}
