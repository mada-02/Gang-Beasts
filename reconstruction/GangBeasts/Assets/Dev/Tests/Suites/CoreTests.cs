using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// The core layer: registry, template, spawning, rebuilding, safe destruction and the game-script hooks.
public static class CoreTests
{
	private static readonly string[] allScenes = { "Menu", "Tutorial", "Sandbox", "Ring", "Grind", "Gondola", "Trucks", "Incinerator", "Wheel", "Subway", "Street" };

	public static DevTestSuite Suite()
	{
		return new DevTestSuite("core")
			.Add("fields_classified", FieldsClassified)
			.Add("registry_matches_scene", RegistryMatchesScene)
			.Add("template_capture", TemplateCapture)
			.Add("rebuild_fidelity", RebuildFidelity)
			.Add("boss_spawn_matches_level_boss", BossSpawnMatchesLevelBoss)
			.Add("spawn_packing", SpawnPacking)
			.Add("grab_release_on_destroy", GrabReleaseOnDestroy)
			.Add("score_index_hook", ScoreIndexHook)
			.Add("mob_taunt_hook", MobTauntHook);
	}

	private static IEnumerator FieldsClassified(DevTestContext t)
	{
		List<string> unclassified = DevFields.Unclassified();
		t.Check(unclassified.Count == 0, "unclassified beast fields: " + string.Join(", ", unclassified.ToArray()));
		List<string> missing = DevReflection.Missing();
		t.Check(missing.Count == 0, "private fields not found: " + string.Join(", ", missing.ToArray()));
		System.Reflection.FieldInfo devBrain = typeof(Player).GetField("devBrain");
		t.Check(devBrain != null && devBrain.IsNotSerialized, "Player.devBrain exists and is not serialized");
		t.Check(DevHooks.fixMobTaunt && DevHooks.fixScoreIndex, "game fixes on by default");
		yield break;
	}

	private static IEnumerator RegistryMatchesScene(DevTestContext t)
	{
		foreach (string level in allScenes)
		{
			yield return t.LoadLevel(level);
			yield return t.Frames(60);
			Object[] players = Object.FindObjectsOfType(typeof(Player));
			t.Metric(level + "_beasts", players.Length);
			t.Equal(players.Length, BeastRegistry.All.Count, level + ": registry size");
			foreach (Object o in players)
			{
				DevBeast marker = ((Player)o).GetComponent<DevBeast>();
				t.Check(marker != null && marker.beast != null && marker.beast.player == o, level + ": " + o.name + " registered");
			}
		}
		// Destroyed by anyone: the registry drops it and says so.
		int removed = 0;
		BeastEvent onRemoved = b => removed++;
		BeastRegistry.Removed += onRemoved;
		Beast victim = null;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player.mob)
			{
				victim = b;
				break;
			}
		}
		int before = BeastRegistry.All.Count;
		Object.Destroy(victim.gameObject);
		yield return t.Frames(2);
		BeastRegistry.Removed -= onRemoved;
		t.Equal(before - 1, BeastRegistry.All.Count, "registry size after a plain Destroy");
		t.Equal(1, removed, "Removed events");
	}

	private static IEnumerator TemplateCapture(DevTestContext t)
	{
		foreach (string level in allScenes)
		{
			yield return t.LoadLevel(level);
			GameObject template = BeastFactory.Template;
			if (level == "Menu")
			{
				t.Check(template == null, "Menu: no template (no beasts)");
				continue;
			}
			if (!t.Check(template != null, level + ": template captured"))
			{
				continue;
			}
			t.Info(level + "_source", BeastFactory.TemplateSource);
			t.Check(!template.activeSelf, level + ": template inactive");
			foreach (string path in BeastFactory.partPaths)
			{
				t.Check(template.transform.Find(path) != null, level + ": template has " + path);
			}
			t.Check(template.transform.Find("healthBar") == null && template.transform.Find("staminaBar") == null, level + ": no status bars");
			t.Check(template.GetComponent<DevBeast>() == null, level + ": no dev marker");
			t.Near(1.0, template.transform.localScale.x, 0.01, level + ": normal-sized template");
		}
		yield return t.LoadLevel("Street");
		t.Check(BeastFactory.TemplateSource.EndsWith("(mob)"), "Street's template is a mob: " + BeastFactory.TemplateSource);
	}

	// Rebuilding a beast from the template with its own body reproduces its physics and settings.
	private static IEnumerator RebuildFidelity(DevTestContext t)
	{
		foreach (string level in new string[] { "Street", "Sandbox", "Subway", "Incinerator" })
		{
			yield return t.LoadLevel(level);
			yield return t.Frames(3);
			List<Beast> originals = new List<Beast>(BeastRegistry.All);
			int replaced = 0;
			BeastReplacedEvent onReplaced = (a, b) => replaced++;
			BeastRegistry.Replaced += onReplaced;
			foreach (Beast b in originals)
			{
				if (b.player == null || !b.Alive)
				{
					continue;
				}
				List<string> signature = DevTestUtil.Signature(b);
				List<string> settings = DevTestUtil.Settings(b, true);
				float max = b.MaxHealth;
				float health = b.stats.health;
				string name = level + " " + b.player.name + (b.player.mob ? " mob" : " human") + (b.body != BeastBody.Normal ? " " + b.body : "");
				Beast rebuilt = BeastFactory.Rebuild(b, b.body, false);
				if (!t.Check(rebuilt != null, name + ": rebuilt"))
				{
					continue;
				}
				yield return t.Frames(3);
				List<string> diff = DevTestUtil.Diff(signature, DevTestUtil.Signature(rebuilt), 6);
				t.Check(diff.Count == 0, name + ": physics differ: " + string.Join(" / ", diff.ToArray()));
				diff = DevTestUtil.Diff(settings, DevTestUtil.Settings(rebuilt, true), 6);
				t.Check(diff.Count == 0, name + ": settings differ: " + string.Join(" / ", diff.ToArray()));
				t.Near(max, rebuilt.MaxHealth, 1e-3, name + ": max health");
				t.Near(health, rebuilt.stats.health, 0.05, name + ": health");
				t.Check(b.player == null, name + ": original destroyed");
				t.Check(BeastRegistry.Find(rebuilt.player) == rebuilt, name + ": rebuilt one registered");
			}
			BeastRegistry.Replaced -= onReplaced;
			t.Metric(level + "_rebuilt", replaced);
			t.Check(replaced > 0, level + ": something rebuilt");
		}
	}

	// The generated 0.0.3 boss shape on the template is Street's own pink boss.
	private static IEnumerator BossSpawnMatchesLevelBoss(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast levelBoss = null;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.body == BeastBody.Boss003)
			{
				levelBoss = b;
			}
		}
		if (!t.Check(levelBoss != null, "Street's boss recognised by its scale"))
		{
			yield break;
		}
		List<Vector3> spots = BeastFactory.PlanSpots(levelBoss.Part("ball").position + Vector3.forward * 4f, 1, 1.3f, null, 0f);
		if (!t.Check(spots.Count == 1, "room for a boss"))
		{
			yield break;
		}
		SpawnSpec spec = new SpawnSpec();
		spec.body = BeastBody.Boss003;
		spec.gang = levelBoss.player.gangName;
		Beast spawned = BeastFactory.Spawn(spec, spots[0] + Vector3.up * BeastFactory.HipsHeight(BeastBody.Boss003), 0f);
		yield return t.Frames(3);
		List<string> diff = DevTestUtil.Diff(DevTestUtil.Signature(levelBoss), DevTestUtil.Signature(spawned), 8);
		t.Check(diff.Count == 0, "spawned boss physics differ from the level boss: " + string.Join(" / ", diff.ToArray()));
		diff = DevTestUtil.Diff(DevTestUtil.Settings(levelBoss, false), DevTestUtil.Settings(spawned, false), 8);
		t.Check(diff.Count == 0, "spawned boss settings differ: " + string.Join(" / ", diff.ToArray()));
		t.Near(levelBoss.MaxHealth, spawned.MaxHealth, 1e-3, "boss max health");
		BeastRegistry.SafeDestroy(spawned);
	}

	private static IEnumerator SpawnPacking(DevTestContext t)
	{
		foreach (string level in new string[] { "Street", "Sandbox", "Ring", "Gondola" })
		{
			bool hazards = level == "Gondola";
			foreach (int count in new int[] { 1, 10, 50 })
			{
				yield return t.LoadLevel(level);
				Vector3 centre;
				if (!DevGround.Snap(DevGround.ScreenCentre(), 4f, out centre))
				{
					Beast p1 = BeastRegistry.Human(0);
					centre = p1 != null ? p1.Part("ball").position : DevGround.ScreenCentre();
				}
				List<Vector3> spots = BeastFactory.PlanSpots(centre, count, 1f, null, 0f);
				string name = level + " x" + count;
				t.Metric(name + "_placed", spots.Count);
				t.Check(spots.Count >= Mathf.Min(count, 10), name + ": placed at least min(count, 10)");
				float closest = float.PositiveInfinity;
				for (int i = 0; i < spots.Count; i++)
				{
					for (int j = i + 1; j < spots.Count; j++)
					{
						closest = Mathf.Min(closest, (spots[i] - spots[j]).magnitude);
					}
				}
				if (spots.Count > 1)
				{
					t.Check(closest >= 0.89f, name + ": spots at least 0.9 m apart (closest " + closest + ")");
				}
				List<Beast> beasts = new List<Beast>();
				SpawnSpec spec = new SpawnSpec();
				foreach (Vector3 spot in spots)
				{
					beasts.Add(BeastFactory.Spawn(spec, spot + Vector3.up * BeastFactory.HipsHeight(BeastBody.Normal), Random.Range(0f, 360f)));
				}
				float maxSpeed = 0f;
				for (int s = 0; s < 50; s++)
				{
					yield return new WaitForFixedUpdate();
					foreach (Beast b in beasts)
					{
						if (b.player != null)
						{
							maxSpeed = Mathf.Max(maxSpeed, DevTestUtil.MaxPartSpeed(b));
						}
					}
				}
				t.Metric(name + "_max_part_speed_first_half_second", maxSpeed);
				t.Check(maxSpeed < 25f, name + ": no part flung on spawning (max " + maxSpeed + " m/s)");
				yield return t.Steps(150);
				int fallen = 0;
				for (int i = 0; i < beasts.Count; i++)
				{
					if (beasts[i].player == null || beasts[i].Part("hips").position.y < spots[i].y - 4f)
					{
						fallen++;
					}
				}
				t.Metric(name + "_fallen_after_2s", fallen);
				if (!hazards)
				{
					t.Equal(0, fallen, name + ": spawned beasts fallen off within 2 s");
				}
			}
		}
	}

	// A grab is a HingeJoint on the hand (CollisionEvent.GrabCheck). First observe what Unity does when
	// the held beast is destroyed without care, then check SafeDestroy lets go.
	private static IEnumerator GrabReleaseOnDestroy(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		Vector3 centre = p1.Part("ball").position + Vector3.right * 4f;
		for (int round = 0; round < 2; round++)
		{
			bool safe = round == 1;
			List<Vector3> spots = BeastFactory.PlanSpots(centre + Vector3.forward * round * 4f, 2, 1f, null, 0f);
			if (!t.Check(spots.Count == 2, "room for two beasts"))
			{
				yield break;
			}
			SpawnSpec spec = new SpawnSpec();
			spec.gang = "test grab";
			Beast holder = BeastFactory.Spawn(spec, spots[0] + Vector3.up * BeastFactory.HipsHeight(BeastBody.Normal), 0f);
			Beast held = BeastFactory.Spawn(spec, spots[1] + Vector3.up * BeastFactory.HipsHeight(BeastBody.Normal), 0f);
			holder.player.devBrain = true;
			held.player.devBrain = true;
			yield return t.Steps(20);
			Transform hand = holder.Part("leftHand");
			HingeJoint grab = hand.gameObject.AddComponent<HingeJoint>();
			grab.useLimits = true;
			grab.connectedBody = held.Part("chest").rigidbody;
			grab.breakForce = 150f;
			holder.player.leftGrab = true;
			yield return t.Steps(5);
			if (safe)
			{
				BeastRegistry.SafeDestroy(held);
			}
			else
			{
				Object.Destroy(held.gameObject);
			}
			yield return t.Steps(3);
			HingeJoint[] left = hand.GetComponents<HingeJoint>();
			int toWorld = 0;
			foreach (HingeJoint j in left)
			{
				if (j.connectedBody == null)
				{
					toWorld++;
				}
			}
			int stale = 0;
			foreach (GameObject g in holder.targeting.targetsInSphere)
			{
				if (g == null)
				{
					stale++;
				}
			}
			string prefix = safe ? "safe_" : "vanilla_";
			t.Metric(prefix + "joints_left", left.Length);
			t.Metric(prefix + "joints_to_world", toWorld);
			t.Metric(prefix + "stale_targets", stale);
			// Walk the holder for a second: a hand pinned to the world stays put while the body moves.
			Vector3 handFrom = hand.position;
			Vector3 hipsFrom = holder.Part("hips").position;
			for (int s = 0; s < 100; s++)
			{
				holder.player.direction = Vector3.right;
				yield return new WaitForFixedUpdate();
			}
			t.Metric(prefix + "hand_moved", (hand.position - handFrom).magnitude);
			t.Metric(prefix + "hips_moved", (holder.Part("hips").position - hipsFrom).magnitude);
			if (safe)
			{
				t.Equal(0, left.Length, "SafeDestroy: no grab joint left on the holder's hand");
				t.Equal(0, stale, "SafeDestroy: no destroyed parts left in the holder's Targeting list");
			}
			holder.player.leftGrab = false;
			BeastRegistry.SafeDestroy(holder);
			yield return t.Frames(2);
		}
	}

	private static IEnumerator ScoreIndexHook(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		List<Vector3> spots = BeastFactory.PlanSpots(p1.Part("ball").position + Vector3.right * 5f, 2, 1f, null, 0f);
		SpawnSpec spec = new SpawnSpec();
		spec.gang = "test score";
		Beast a = BeastFactory.Spawn(spec, spots[0] + Vector3.up, 0f);
		Beast b = BeastFactory.Spawn(spec, spots[1] + Vector3.up, 0f);
		yield return t.Frames(3);
		SceneManager sm = GameObject.FindWithTag("Scene Manager").GetComponent<SceneManager>();
		int[] before = (int[])sm.score.Clone();
		bool threw = false;
		try
		{
			a.stats.TakeDamage(null, 1e6f, false);
		}
		catch (System.IndexOutOfRangeException)
		{
			threw = true;
		}
		t.Check(!threw, "fix on: a mob dying does not throw");
		t.Check(a.player.state == Player.State.Dead, "fix on: the mob is dead");
		t.Equal(string.Join(",", System.Array.ConvertAll(before, x => x.ToString())), string.Join(",", System.Array.ConvertAll(sm.score, x => x.ToString())), "fix on: scores untouched");
		DevHooks.fixScoreIndex = false;
		threw = false;
		try
		{
			b.stats.TakeDamage(null, 1e6f, false);
		}
		catch (System.IndexOutOfRangeException)
		{
			threw = true;
		}
		DevHooks.fixScoreIndex = true;
		t.Check(threw, "fix off: 0.0.3's IndexOutOfRangeException is back");
	}

	private static IEnumerator MobTauntHook(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		List<Vector3> spots = BeastFactory.PlanSpots(p1.Part("ball").position + Vector3.right * 5f, 2, 1f, null, 0f);
		SpawnSpec spec = new SpawnSpec();
		spec.gang = "test taunt A";
		Beast mob = BeastFactory.Spawn(spec, spots[0] + Vector3.up, 0f);
		spec.gang = "test taunt B";
		Beast target = BeastFactory.Spawn(spec, spots[1] + Vector3.up, 0f);
		yield return t.Frames(3);
		// Keep FindClosestTarget out of it: the target stays the one set here.
		mob.player.devBrain = true;
		mob.player.target = target.player;
		mob.player.taunt = true;
		yield return t.Frames(2);
		t.Check(!mob.player.taunt, "fix on: a living target stops the taunt");
		target.player.state = Player.State.Dead;
		yield return t.Frames(2);
		t.Check(mob.player.taunt, "fix on: a dead target starts it");
		target.player.state = Player.State.Standing;
		DevHooks.fixMobTaunt = false;
		yield return t.Frames(2);
		bool stuck = mob.player.taunt;
		DevHooks.fixMobTaunt = true;
		t.Check(stuck, "fix off: 0.0.3 keeps taunting at a living target");
	}
}
