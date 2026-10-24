using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// The Smart AI in real fights, measured against the game's own AI and against the additional branch's
// brain (OldBrain, kept verbatim as a baseline). Each scenario clears the level (one human slot, whose
// beast is removed; level mobs removed) so only the AI under test is in play. Statistical where physics
// decides: fixed seeds, several bouts, thresholds against the baselines measured in the same run.
public static class AIScenarioTests
{
	public static DevTestSuite Suite()
	{
		return new DevTestSuite("ai")
			.Add("sensors_match_reference", SensorsMatchReference)
			.Add("duel_vs_vanilla", DuelVsVanilla)
			.Add("swarm_20v1_capacity_and_friendly_fire", Swarm20v1)
			.Add("battle_20v20_cost", Battle20v20)
			.Add("alone_against_20", AloneAgainst20)
			.Add("lifecycle_mid_fight", LifecycleMidFight);
	}

	private static IEnumerator Arena(DevTestContext t, string level)
	{
		DevTestUtil.SetPlayers(1);
		yield return t.LoadLevel(level);
		DevSpawner.RemoveAllMobs();
		yield return t.Frames(1);
	}

	private static Vector3 Centre()
	{
		Beast p1 = BeastRegistry.Human(0);
		return p1 != null ? p1.Part("ball").position : DevGround.ScreenCentre();
	}

	private static void ClearHumans()
	{
		foreach (Beast b in new List<Beast>(BeastRegistry.All))
		{
			if (!b.player.mob)
			{
				BeastRegistry.SafeDestroy(b);
			}
		}
	}

	// Kind: "smart", "vanilla", "old" (OldBrain) or "dummy" (stands still, cannot be hurt).
	private static Beast Put(Vector3 spot, float yaw, string gang, string kind, float health)
	{
		SpawnSpec spec = new SpawnSpec();
		spec.gang = gang;
		spec.health = health;
		spec.useColor = true;
		spec.color = gang.EndsWith("A") ? Color.red : Color.blue;
		Beast b = BeastFactory.Spawn(spec, spot + Vector3.up * BeastFactory.HipsHeight(BeastBody.Normal), yaw);
		if (kind == "smart")
		{
			b.gameObject.AddComponent<AIBrain>();
		}
		else if (kind == "old")
		{
			b.gameObject.AddComponent<OldBrain>();
		}
		else if (kind == "dummy")
		{
			b.player.devBrain = true;
		}
		return b;
	}

	private static List<Beast> Crowd(Vector3 centre, int count, string gang, string kind, float health, Beast keepAway)
	{
		List<Beast> list = new List<Beast>();
		foreach (Vector3 spot in BeastFactory.PlanSpots(centre, count, 1f, keepAway, 2.5f))
		{
			Vector3 face = centre - spot;
			list.Add(Put(spot, Quaternion.LookRotation(new Vector3(face.x, 0f, face.z) + Vector3.forward * 1e-3f).eulerAngles.y, gang, kind, health));
		}
		return list;
	}

	private static int Alive(List<Beast> list)
	{
		int n = 0;
		foreach (Beast b in list)
		{
			if (b.player != null && b.player.state != Player.State.Dead)
			{
				n++;
			}
		}
		return n;
	}

	// ------------------------------------------------------------------------------------- sensors

	private static IEnumerator SensorsMatchReference(DevTestContext t)
	{
		System.Random r = new System.Random(t.seed);
		foreach (string level in new string[] { "Street", "Sandbox", "Ring", "Grind", "Gondola", "Incinerator", "Wheel", "Trucks" })
		{
			yield return t.LoadLevel(level);
			yield return t.Steps(5);
			AISensors.LevelLoaded();
			Vector3 c = Centre();
			int agree = 0;
			int total = 0;
			for (int i = 0; i < 2000; i++)
			{
				Vector3 p = c + new Vector3((float)(r.NextDouble() * 60 - 30), (float)(r.NextDouble() * 3 - 1), (float)(r.NextDouble() * 60 - 30));
				total++;
				if (AISensors.Drop(p, 2f) == DevGround.Drop(p, 2f))
				{
					agree++;
				}
			}
			int seeAgree = 0;
			for (int i = 0; i < 500; i++)
			{
				Vector3 a = c + new Vector3((float)(r.NextDouble() * 40 - 20), (float)(r.NextDouble() * 3), (float)(r.NextDouble() * 40 - 20));
				Vector3 b = c + new Vector3((float)(r.NextDouble() * 40 - 20), (float)(r.NextDouble() * 3), (float)(r.NextDouble() * 40 - 20));
				bool reference = true;
				foreach (RaycastHit hit in Physics.RaycastAll(a, (b - a).normalized, (b - a).magnitude))
				{
					if (DevGround.Solid(hit.collider))
					{
						reference = false;
						break;
					}
				}
				if (AISensors.CanSee(a, b) == reference)
				{
					seeAgree++;
				}
			}
			t.Metric(level + "_drop_agreement", agree / (float)total);
			t.Metric(level + "_sight_agreement", seeAgree / 500f);
			t.Check(agree >= total * 0.995f, level + ": drop probes agree with DevGround (" + agree + "/" + total + ")");
			// Sight lines skip layers 8/9 (beast parts) by design; Sandbox's cubes and truck and Grind's grinder
			// teeth sit on layer 9, so there the AI can see through them.
			t.Check(seeAgree >= 475, level + ": sight agrees with RaycastAll (" + seeAgree + "/500)");
		}
	}

	// ------------------------------------------------------------------------------------- duels

	private static IEnumerator Duel(DevTestContext t, string kind, int[] tally)
	{
		yield return Arena(t, "Street");
		Vector3 c = Centre();
		ClearHumans();
		yield return t.Frames(1);
		List<Vector3> spots = BeastFactory.PlanSpots(c, 2, 2f, null, 0f);
		Beast a = Put(spots[0], 0f, "Duel A", kind, 50f);
		Beast b = Put(spots[1], 0f, "Duel B", "vanilla", 50f);
		for (int s = 0; s < 2000 && a.player != null && b.player != null && a.Alive && b.Alive; s++)
		{
			yield return new WaitForFixedUpdate();
		}
		if (a.player != null && a.Alive && (b.player == null || !b.Alive))
		{
			tally[0]++;
		}
		else if (b.player != null && b.Alive && (a.player == null || !a.Alive))
		{
			tally[1]++;
		}
		else
		{
			tally[2]++;
		}
	}

	// 8 bouts swung between 4 and 7 wins on the same code: 20 per side.
	private const int Bouts = 20;

	private static IEnumerator DuelVsVanilla(DevTestContext t)
	{
		int[] smart = new int[3];
		int[] old = new int[3];
		for (int i = 0; i < Bouts; i++)
		{
			Random.seed = t.seed * 100 + i;
			yield return Duel(t, "smart", smart);
			Random.seed = t.seed * 100 + i;
			yield return Duel(t, "old", old);
		}
		t.Metric("smart_wins", smart[0]);
		t.Metric("smart_losses", smart[1]);
		t.Metric("smart_undecided", smart[2]);
		t.Metric("old_wins", old[0]);
		t.Metric("old_losses", old[1]);
		t.Metric("old_undecided", old[2]);
		t.Check(smart[0] >= Bouts * 0.65f, "Smart AI beats the game's own AI in at least 65% of " + Bouts + " duels (" + smart[0] + ")");
		t.Check(smart[0] >= old[0] - 2, "and about as often as the old brain or more (" + smart[0] + " vs " + old[0] + ")");
	}

	// ------------------------------------------------------------------------------------- 20 v 1

	private static IEnumerator Swarm(DevTestContext t, string kind, float[] result)
	{
		yield return Arena(t, "Street");
		Vector3 c = Centre();
		ClearHumans();
		yield return t.Frames(1);
		Beast dummy = Put(c, 0f, "Swarm B", "dummy", 100f);
		List<Beast> crowd = Crowd(c, 20, "Swarm A", kind, 100f, dummy);
		float startHealth = 0f;
		foreach (Beast b in crowd)
		{
			startHealth += 100f;
		}
		int worstEngaged = 0;
		float lost = 0f;
		Dictionary<Beast, float> last = new Dictionary<Beast, float>();
		for (int s = 0; s < 1500; s++)
		{
			dummy.stats.health = dummy.MaxHealth;
			yield return new WaitForFixedUpdate();
			int engaged = 0;
			foreach (Beast b in crowd)
			{
				if (b.player == null)
				{
					continue;
				}
				AIBrain brain = b.gameObject.GetComponent<AIBrain>();
				// Only brains able to fight: a stunned one keeps its last role but is not attacking.
				if (brain != null && brain.Able && brain.role == AIBrain.Role.Engage && brain.enemy == dummy)
				{
					engaged++;
				}
				float h;
				if (last.TryGetValue(b, out h) && b.stats.health < h - 0.5f)
				{
					// The dummy never punches: any damage to the crowd is friendly fire (or the level).
					lost += h - b.stats.health;
				}
				last[b] = b.stats.health;
			}
			worstEngaged = Mathf.Max(worstEngaged, engaged);
		}
		result[0] = worstEngaged;
		result[1] = lost / (crowd.Count * 15f / 60f);
		result[2] = crowd.Count - Alive(crowd);
		t.Metric(kind + "_crowd_size", crowd.Count);
	}

	private static IEnumerator Swarm20v1(DevTestContext t)
	{
		float[] smart = new float[3];
		float[] old = new float[3];
		Random.seed = t.seed;
		yield return Swarm(t, "smart", smart);
		Random.seed = t.seed;
		yield return Swarm(t, "old", old);
		t.Metric("smart_most_engaged_at_once", smart[0]);
		t.Metric("smart_friendly_damage_per_attacker_minute", smart[1]);
		t.Metric("old_friendly_damage_per_attacker_minute", old[1]);
		t.Metric("smart_lost", smart[2]);
		t.Metric("old_lost", old[2]);
		t.Check(smart[0] <= TargetAssigner.Capacity(1f), "never more than " + TargetAssigner.Capacity(1f) + " engaged on one beast (" + smart[0] + ")");
		t.Check(smart[1] <= old[1], "less friendly fire than the old brain (" + smart[1] + " vs " + old[1] + " per attacker-minute)");
		t.Check(smart[2] <= old[2], "no more of the crowd lost than the old brain (" + smart[2] + " vs " + old[2] + ")");
	}

	// ------------------------------------------------------------------------------------- 20 v 20

	private static IEnumerator Battle20v20(DevTestContext t)
	{
		yield return Arena(t, "Street");
		Vector3 c = Centre();
		ClearHumans();
		yield return t.Frames(1);
		List<Beast> a = Crowd(c + Vector3.right * 6f, 20, "Battle A", "smart", 50f, null);
		List<Beast> b = Crowd(c - Vector3.right * 6f, 20, "Battle B", "smart", 50f, null);
		t.Metric("placed", a.Count + b.Count);
		List<float> brainMs = new List<float>();
		List<float> tickMs = new List<float>();
		List<float>[] stages = { new List<float>(), new List<float>(), new List<float>(), new List<float>(), new List<float>() };
		int lastTick = AIDirector.instance.ticks;
		long memoryStart = System.GC.GetTotalMemory(false);
		for (int s = 0; s < 3000; s++)
		{
			yield return null;
			brainMs.Add(AIDirector.instance.brainMs);
			if (AIDirector.instance.ticks != lastTick)
			{
				lastTick = AIDirector.instance.ticks;
				tickMs.Add(AIDirector.instance.tickMs);
				for (int k = 0; k < 5; k++)
				{
					stages[k].Add(AIDirector.instance.stageMs[k]);
				}
			}
			if (Alive(a) == 0 || Alive(b) == 0)
			{
				break;
			}
		}
		long memoryEnd = System.GC.GetTotalMemory(false);
		brainMs.Sort();
		tickMs.Sort();
		float brainP95 = brainMs[(int)(brainMs.Count * 0.95f)];
		float tickP95 = tickMs.Count > 0 ? tickMs[(int)(tickMs.Count * 0.95f)] : 0f;
		int dead = a.Count + b.Count - Alive(a) - Alive(b);
		t.Metric("brains_ms_p95_per_frame", brainP95);
		t.Metric("director_tick_ms_p95", tickP95);
		t.Metric("frames", brainMs.Count);
		t.Metric("dead", dead);
		t.Metric("heap_change_kb", (memoryEnd - memoryStart) / 1024f);
		string[] names = { "snapshot", "sense", "alert", "assign", "slots" };
		for (int k = 0; k < 5; k++)
		{
			stages[k].Sort();
			if (stages[k].Count > 0)
			{
				t.Metric("stage_" + names[k] + "_ms_p95", stages[k][(int)(stages[k].Count * 0.95f)]);
				t.Metric("stage_" + names[k] + "_ms_median", stages[k][stages[k].Count / 2]);
			}
		}
		t.Metric("director_tick_ms_median", tickMs.Count > 0 ? tickMs[tickMs.Count / 2] : 0f);
		t.Check(brainP95 <= 2f, "40 brains cost at most 2 ms a frame (p95 " + brainP95 + ")");
		t.Check(tickP95 <= 4f, "a director tick (10 a second) costs at most 4 ms (p95 " + tickP95 + ")");
		t.Check(dead >= 8, "they actually fight (" + dead + " down)");
	}

	// ------------------------------------------------------------------------------------- 1 v 20

	private static IEnumerator Alone(DevTestContext t, string kind, float[] survived, int trial)
	{
		yield return Arena(t, "Street");
		Vector3 c = Centre();
		ClearHumans();
		yield return t.Frames(1);
		Beast lone = Put(c, 0f, "Lone A", kind, 100f);
		Crowd(c, 20, "Crowd B", "vanilla", 50f, lone);
		int s = 0;
		for (; s < 3000 && lone.player != null && lone.Alive; s++)
		{
			yield return new WaitForFixedUpdate();
		}
		survived[trial] = s * Time.fixedDeltaTime;
	}

	private static IEnumerator AloneAgainst20(DevTestContext t)
	{
		float[] smart = new float[3];
		float[] old = new float[3];
		for (int i = 0; i < 3; i++)
		{
			Random.seed = t.seed * 10 + i;
			yield return Alone(t, "smart", smart, i);
			Random.seed = t.seed * 10 + i;
			yield return Alone(t, "old", old, i);
		}
		System.Array.Sort(smart);
		System.Array.Sort(old);
		t.Metric("smart_median_survival_s", smart[1]);
		t.Metric("old_median_survival_s", old[1]);
		t.Check(smart[1] >= old[1] * 0.9f, "alone against 20, it lasts at least about as long as the old brain (" + smart[1] + " vs " + old[1] + " s)");
	}

	// ------------------------------------------------------------------------------------- edge cases

	private static IEnumerator LifecycleMidFight(DevTestContext t)
	{
		yield return Arena(t, "Street");
		Vector3 c = Centre();
		List<Beast> a = Crowd(c + Vector3.right * 4f, 6, "Edge A", "smart", 50f, null);
		List<Beast> b = Crowd(c - Vector3.right * 4f, 6, "Edge B", "smart", 50f, null);
		yield return t.Steps(300);
		// The target of several brains vanishes.
		Beast victim = null;
		foreach (Beast x in b)
		{
			if (x.player != null)
			{
				victim = x;
				break;
			}
		}
		BeastRegistry.SafeDestroy(victim);
		yield return t.Steps(100);
		HardMode.Set(true);
		yield return t.Steps(150);
		HardMode.Set(false);
		DevWorld.SetTimeScale(0f);
		yield return t.Frames(50);
		DevWorld.SetTimeScale(2f);
		yield return t.Frames(100);
		DevWorld.SetTimeScale(1f);
		AIDirector.SetSmartSpawned(false);
		yield return t.Steps(50);
		foreach (Beast x in a)
		{
			if (x.player != null)
			{
				t.Check(!x.player.devBrain && x.gameObject.GetComponent<AIBrain>() == null, "Smart AI off: the game's own AI again");
			}
		}
		AIDirector.SetSmartSpawned(true);
		yield return t.Steps(50);
		foreach (Beast x in a)
		{
			if (x.player != null)
			{
				t.Check(x.player.devBrain, "Smart AI on again");
			}
		}
		DevSpawner.RemoveSpawned();
		yield return t.Steps(20);
		yield return t.LoadLevel("Street");
		t.Equal(0, AIDirector.instance.brains.Count, "no brain left after a level load");
		DevTestUtil.SetPlayers(4);
	}
}
