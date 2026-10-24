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
			.Add("vanilla_errors", VanillaErrors)
			.Add("sensor_disagreements", SensorDisagreements)
			.Add("ray_from_inside", RayFromInside);
	}

	// Does a raycast that starts inside a collider (trigger or not, box or sphere) hit it? Decides how the
	// AI's rays step past triggers.
	private static IEnumerator RayFromInside(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		foreach (bool trigger in new bool[] { true, false })
		{
			foreach (PrimitiveType shape in new PrimitiveType[] { PrimitiveType.Cube, PrimitiveType.Sphere })
			{
				GameObject go = GameObject.CreatePrimitive(shape);
				go.transform.position = new Vector3(0f, 1000f, 0f);
				go.transform.localScale = Vector3.one * 10f;
				go.collider.isTrigger = trigger;
				yield return new WaitForFixedUpdate();
				RaycastHit hit;
				bool any = Physics.Raycast(go.transform.position, Vector3.down, out hit, 20f);
				string name = (trigger ? "trigger_" : "solid_") + shape;
				t.Info(name + "_from_inside", any ? "hit " + hit.collider.name + " at " + hit.distance : "no hit");
				any = Physics.Raycast(go.transform.position + Vector3.up * 8f, Vector3.down, out hit, 20f);
				t.Info(name + "_from_outside", any ? "hit at " + hit.distance : "no hit");
				Object.Destroy(go);
				yield return null;
			}
		}
	}

	// Where AISensors.Drop and DevGround.Drop disagree: the reference's hits along the ray.
	private static IEnumerator SensorDisagreements(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		foreach (string level in new string[] { "Street", "Grind", "Sandbox" })
		{
			yield return t.LoadLevel(level);
			yield return t.Steps(5);
			AISensors.LevelLoaded();
			Beast p1 = BeastRegistry.Human(0);
			Vector3 c = p1 != null ? p1.Part("ball").position : Vector3.zero;
			int shown = 0;
			int bad = 0;
			for (int i = 0; i < 2000; i++)
			{
				Vector3 p = c + new Vector3((float)(r.NextDouble() * 60 - 30), (float)(r.NextDouble() * 3 - 1), (float)(r.NextDouble() * 60 - 30));
				bool mine = AISensors.Drop(p, 2f);
				bool reference = DevGround.Drop(p, 2f);
				if (mine == reference)
				{
					continue;
				}
				bad++;
				if (shown++ >= 6)
				{
					continue;
				}
				string hits = "";
				RaycastHit[] all = Physics.RaycastAll(p + Vector3.up, Vector3.down, 3f);
				System.Array.Sort(all, (a, b) => a.distance.CompareTo(b.distance));
				foreach (RaycastHit h in all)
				{
					hits += " | " + h.collider.name + " (" + h.collider.GetType().Name + ", layer " + h.collider.gameObject.layer + (h.collider.isTrigger ? ", trigger" : "")
						+ (h.collider.GetComponent<KillZone>() != null ? ", KILLZONE" : "") + (h.rigidbody != null ? ", rb" : "") + ") at " + h.distance.ToString("0.00");
				}
				t.Info(level + "_" + shown, DevTestUtil.V(p) + " mine " + mine + " ref " + reference + hits);
			}
			t.Metric(level + "_disagreements", bad);
		}
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
