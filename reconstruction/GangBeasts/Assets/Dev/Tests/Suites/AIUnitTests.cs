using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// The AI's pure parts (no physics): spatial hash, target assignment, slots. Deterministic: a fixed
// System.Random per test.
public static class AIUnitTests
{
	public static DevTestSuite Suite()
	{
		return new DevTestSuite("ai_unit")
			.Add("spatial_hash_equals_brute_force", SpatialHashEqualsBruteForce)
			.Add("capacity_by_size", CapacityBySize)
			.Add("assigner_capacity_and_coverage", AssignerCapacityAndCoverage)
			.Add("assigner_order_independent", AssignerOrderIndependent)
			.Add("assigner_20v1", Assigner20v1)
			.Add("assigner_20v20_spreads", Assigner20v20)
			.Add("slot_rules", SlotRules);
	}

	private static Vector3 RandomPoint(System.Random r, float extent)
	{
		return new Vector3((float)(r.NextDouble() * 2 - 1) * extent, (float)r.NextDouble() * 4f, (float)(r.NextDouble() * 2 - 1) * extent);
	}

	private static IEnumerator SpatialHashEqualsBruteForce(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		SpatialHash hash = new SpatialHash(2f);
		List<int> got = new List<int>();
		int mismatches = 0;
		for (int test = 0; test < 5000; test++)
		{
			int n = r.Next(0, 60);
			Vector3[] points = new Vector3[n];
			for (int i = 0; i < n; i++)
			{
				points[i] = RandomPoint(r, 20f);
			}
			hash.Build(points, n);
			Vector3 centre = RandomPoint(r, 22f);
			float radius = (float)r.NextDouble() * 8f;
			got.Clear();
			hash.Query(centre, radius, got);
			got.Sort();
			List<int> want = new List<int>();
			for (int i = 0; i < n; i++)
			{
				if ((points[i] - centre).sqrMagnitude <= radius * radius)
				{
					want.Add(i);
				}
			}
			if (string.Join(",", got.ConvertAll(x => x.ToString()).ToArray()) != string.Join(",", want.ConvertAll(x => x.ToString()).ToArray()))
			{
				mismatches++;
			}
		}
		t.Equal(0, mismatches, "query results equal brute force in 5000 random cases");
		yield break;
	}

	private static IEnumerator CapacityBySize(DevTestContext t)
	{
		t.Equal(3, TargetAssigner.Capacity(1f), "normal beast: 3");
		t.Equal(5, TargetAssigner.Capacity(BeastShapes.Boss003.rootScale), "pink boss: 5");
		t.Equal(2, TargetAssigner.Capacity(0.5f), "small: at least 2");
		t.Equal(8, TargetAssigner.Capacity(2f), "huge: at most 8");
		yield break;
	}

	private static void Scenario(System.Random r, int gangs, int perGang, float extent, out TargetAssigner.Fighter[] agents, out TargetAssigner.Enemy[] enemies)
	{
		int n = gangs * perGang;
		agents = new TargetAssigner.Fighter[n];
		enemies = new TargetAssigner.Enemy[n];
		for (int i = 0; i < n; i++)
		{
			Vector3 p = RandomPoint(r, extent);
			float size = r.NextDouble() < 0.15 ? 1.29f : 1f;
			agents[i].id = i;
			agents[i].gang = i % gangs;
			agents[i].position = p;
			agents[i].size = size;
			agents[i].able = r.NextDouble() > 0.1;
			agents[i].previous = -1;
			enemies[i].id = i;
			enemies[i].gang = i % gangs;
			enemies[i].position = p;
			enemies[i].size = size;
			enemies[i].stunned = r.NextDouble() < 0.1;
			enemies[i].healthShare = (float)r.NextDouble();
		}
	}

	private static TargetAssigner.Knows Within(TargetAssigner.Fighter[] agents, TargetAssigner.Enemy[] enemies, float range)
	{
		return (a, e) => (agents[a].position - enemies[e].position).magnitude < range;
	}

	private static IEnumerator AssignerCapacityAndCoverage(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		TargetAssigner assigner = new TargetAssigner();
		int overCapacity = 0;
		int uncovered = 0;
		int needlessQueue = 0;
		for (int test = 0; test < 1000; test++)
		{
			TargetAssigner.Fighter[] agents;
			TargetAssigner.Enemy[] enemies;
			Scenario(r, r.Next(2, 5), r.Next(1, 15), 25f, out agents, out enemies);
			TargetAssigner.Result[] results = new TargetAssigner.Result[agents.Length];
			TargetAssigner.Knows knows = Within(agents, enemies, 30f);
			assigner.Assign(agents, agents.Length, enemies, enemies.Length, knows, results);
			int[] engaged = new int[enemies.Length];
			for (int a = 0; a < agents.Length; a++)
			{
				if (results[a].enemy >= 0 && results[a].engaged)
				{
					engaged[results[a].enemy]++;
				}
			}
			for (int e = 0; e < enemies.Length; e++)
			{
				if (engaged[e] > TargetAssigner.Capacity(enemies[e].size))
				{
					overCapacity++;
				}
			}
			for (int a = 0; a < agents.Length; a++)
			{
				bool anyKnown = false;
				bool freeSpot = false;
				for (int e = 0; e < enemies.Length; e++)
				{
					if (enemies[e].gang != agents[a].gang && knows(a, e))
					{
						anyKnown = true;
						freeSpot |= engaged[e] < TargetAssigner.Capacity(enemies[e].size);
					}
				}
				if (agents[a].able && anyKnown && results[a].enemy < 0)
				{
					uncovered++;
				}
				if (!agents[a].able && results[a].enemy >= 0)
				{
					uncovered++;
				}
				// Queued although a known enemy had room: only allowed when that enemy is beyond its few
				// cheapest candidates (maxCandidates).
				if (results[a].enemy >= 0 && !results[a].engaged && freeSpot && CandidatesFull(assigner, agents[a], enemies, engaged, knows, a))
				{
					needlessQueue++;
				}
			}
		}
		t.Equal(0, overCapacity, "no enemy has more engaged attackers than its capacity");
		t.Equal(0, uncovered, "every able attacker that knows an enemy gets one; unable ones get none");
		t.Equal(0, needlessQueue, "nobody queues while one of its candidates has room");
		yield break;
	}

	private static bool CandidatesFull(TargetAssigner assigner, TargetAssigner.Fighter a, TargetAssigner.Enemy[] enemies, int[] engaged, TargetAssigner.Knows knows, int ai)
	{
		List<int> known = new List<int>();
		for (int e = 0; e < enemies.Length; e++)
		{
			if (enemies[e].gang != a.gang && knows(ai, e))
			{
				known.Add(e);
			}
		}
		known.Sort((x, y) =>
		{
			int c = assigner.Cost(a, enemies[x]).CompareTo(assigner.Cost(a, enemies[y]));
			return c != 0 ? c : enemies[x].id.CompareTo(enemies[y].id);
		});
		for (int k = 0; k < known.Count && k < assigner.maxCandidates; k++)
		{
			if (engaged[known[k]] < TargetAssigner.Capacity(enemies[known[k]].size))
			{
				return true;
			}
		}
		return false;
	}

	private static IEnumerator AssignerOrderIndependent(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		TargetAssigner assigner = new TargetAssigner();
		int differ = 0;
		for (int test = 0; test < 300; test++)
		{
			TargetAssigner.Fighter[] agents;
			TargetAssigner.Enemy[] enemies;
			Scenario(r, 2, 10, 15f, out agents, out enemies);
			TargetAssigner.Result[] first = new TargetAssigner.Result[agents.Length];
			assigner.Assign(agents, agents.Length, enemies, enemies.Length, Within(agents, enemies, 30f), first);
			Dictionary<int, string> byId = new Dictionary<int, string>();
			for (int a = 0; a < agents.Length; a++)
			{
				byId[agents[a].id] = first[a].enemy < 0 ? "-" : enemies[first[a].enemy].id + (first[a].engaged ? "e" : "q");
			}
			// Same fighters, shuffled.
			for (int i = agents.Length - 1; i > 0; i--)
			{
				int j = r.Next(0, i + 1);
				TargetAssigner.Fighter fa = agents[i];
				agents[i] = agents[j];
				agents[j] = fa;
				TargetAssigner.Enemy fe = enemies[i];
				enemies[i] = enemies[j];
				enemies[j] = fe;
			}
			TargetAssigner.Result[] second = new TargetAssigner.Result[agents.Length];
			assigner.Assign(agents, agents.Length, enemies, enemies.Length, Within(agents, enemies, 30f), second);
			for (int a = 0; a < agents.Length; a++)
			{
				string got = second[a].enemy < 0 ? "-" : enemies[second[a].enemy].id + (second[a].engaged ? "e" : "q");
				if (got != byId[agents[a].id])
				{
					differ++;
				}
			}
		}
		t.Equal(0, differ, "the same fighters in another order get the same enemies");
		yield break;
	}

	private static IEnumerator Assigner20v1(DevTestContext t)
	{
		foreach (float size in new float[] { 1f, BeastShapes.Boss003.rootScale })
		{
			TargetAssigner assigner = new TargetAssigner();
			TargetAssigner.Fighter[] agents = new TargetAssigner.Fighter[20];
			for (int i = 0; i < 20; i++)
			{
				agents[i].id = i;
				agents[i].gang = 0;
				agents[i].able = true;
				agents[i].previous = -1;
				agents[i].size = 1f;
				agents[i].position = Quaternion.AngleAxis(i * 18f, Vector3.up) * Vector3.forward * (3f + i * 0.2f);
			}
			TargetAssigner.Enemy[] enemies = new TargetAssigner.Enemy[1];
			enemies[0].id = 100;
			enemies[0].gang = 1;
			enemies[0].size = size;
			enemies[0].healthShare = 1f;
			TargetAssigner.Result[] results = new TargetAssigner.Result[20];
			assigner.Assign(agents, 20, enemies, 1, (a, e) => true, results);
			int engaged = 0;
			int queued = 0;
			for (int i = 0; i < 20; i++)
			{
				if (results[i].enemy == 0)
				{
					if (results[i].engaged)
					{
						engaged++;
					}
					else
					{
						queued++;
					}
				}
			}
			int cap = TargetAssigner.Capacity(size);
			t.Equal(cap, engaged, "size " + size + ": " + cap + " engaged");
			t.Equal(20 - cap, queued, "size " + size + ": the rest queued");
			// The engaged ones are the nearest.
			for (int i = 0; i < 20; i++)
			{
				t.Check(results[i].engaged == (i < cap), "size " + size + ": attacker " + i + (i < cap ? " (near) engaged" : " (far) queued"));
			}
		}
		yield break;
	}

	private static IEnumerator Assigner20v20(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		TargetAssigner assigner = new TargetAssigner();
		int worst = 0;
		int unengaged = 0;
		for (int test = 0; test < 200; test++)
		{
			int n = 40;
			TargetAssigner.Fighter[] agents = new TargetAssigner.Fighter[n];
			TargetAssigner.Enemy[] enemies = new TargetAssigner.Enemy[n];
			for (int i = 0; i < n; i++)
			{
				int gang = i < 20 ? 0 : 1;
				Vector3 p = new Vector3((gang == 0 ? -6f : 6f) + (float)(r.NextDouble() * 6 - 3), 0f, (float)(r.NextDouble() * 16 - 8));
				agents[i].id = i;
				agents[i].gang = gang;
				agents[i].position = p;
				agents[i].size = 1f;
				agents[i].able = true;
				agents[i].previous = -1;
				enemies[i].id = i;
				enemies[i].gang = gang;
				enemies[i].position = p;
				enemies[i].size = 1f;
				enemies[i].healthShare = 1f;
			}
			TargetAssigner.Result[] results = new TargetAssigner.Result[n];
			assigner.Assign(agents, n, enemies, n, (a, e) => true, results);
			int[] engaged = new int[n];
			for (int a = 0; a < n; a++)
			{
				if (results[a].enemy >= 0 && results[a].engaged)
				{
					engaged[results[a].enemy]++;
				}
				else
				{
					unengaged++;
				}
			}
			foreach (int e in engaged)
			{
				worst = Mathf.Max(worst, e);
			}
		}
		t.Metric("worst_load", worst);
		t.Check(worst <= 2, "20 v 20: nobody has more than 2 attackers (worst " + worst + ")");
		t.Equal(0, unengaged, "20 v 20: everyone engaged");
		yield break;
	}

	private static IEnumerator SlotRules(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		List<int> order = new List<int>();
		int broken = 0;
		for (int test = 0; test < 3000; test++)
		{
			int k = r.Next(1, 9);
			Vector3 enemy = RandomPoint(r, 10f);
			List<Vector3> attackers = new List<Vector3>();
			for (int i = 0; i < k; i++)
			{
				attackers.Add(enemy + RandomPoint(r, 4f));
			}
			float[] bearings = new float[k];
			SlotPlanner.Plan(enemy, attackers, order, bearings);
			float maxSep = 0f;
			for (int i = 0; i < k; i++)
			{
				for (int j = i + 1; j < k; j++)
				{
					maxSep = Mathf.Max(maxSep, Mathf.Abs(Mathf.DeltaAngle(bearings[i], bearings[j])));
				}
			}
			bool ok = maxSep <= SlotPlanner.MaxArc + 1e-3f;
			if (k > 1)
			{
				float gap = Mathf.Abs(Mathf.DeltaAngle(bearings[order[0]], bearings[order[1]]));
				ok &= gap >= Mathf.Min(SlotPlanner.PreferredGap, SlotPlanner.MaxArc / (k - 1)) - 1e-3f;
				// Order kept: slots ascend in the attackers' own bearing order.
				for (int s = 1; s < k; s++)
				{
					ok &= Mathf.DeltaAngle(bearings[order[s - 1]], bearings[order[s]]) > 0f;
				}
			}
			if (!ok)
			{
				broken++;
			}
		}
		t.Equal(0, broken, "3000 random crowds: within 155 deg, gaps as planned, nobody crosses");
		yield break;
	}
}
