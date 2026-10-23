using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// The dev menu's modules (World, AI spawning, Objects), driven directly: OnGUI does not run headless.
public static class MenuTests
{
	public static DevTestSuite Suite()
	{
		return new DevTestSuite("menu")
			.Add("time_scale", TimeScale)
			.Add("gravity", Gravity)
			.Add("infinite_health_uses_max", InfiniteHealthUsesMax)
			.Add("balance_balls", BalanceBalls)
			.Add("punch_component_on_every_hand", PunchComponents)
			.Add("spawn_teams", SpawnTeams)
			.Add("spawn_bodies_and_health", SpawnBodiesAndHealth)
			.Add("ally_relinks_on_replace", AllyRelinksOnReplace)
			.Add("remove", Remove)
			.Add("objects", Objects)
			.Add("cleared_object_released", ClearedObjectReleased)
			.Add("level_changes_with_everything_spawned", LevelChanges);
	}

	private static List<Beast> Spawn(DevTeam team, int count, BeastBody body)
	{
		AISpawnRequest r = new AISpawnRequest();
		r.team = team;
		r.count = count;
		r.body = body;
		r.at = DevSpawnAt.NearP1;
		return DevSpawner.Spawn(r);
	}

	private static IEnumerator TimeScale(DevTestContext t)
	{
		int checkedLevels = 0;
		foreach (string level in new string[] { "Sandbox", "Ring", "Grind", "Trucks", "Wheel", "Subway", "Street" })
		{
			yield return t.LoadLevel(level);
			int sources = Object.FindObjectsOfType(typeof(AudioTimeScale)).Length;
			DevWorld.SetTimeScale(0.5f);
			yield return t.Frames(3);
			t.Near(0.5, Time.timeScale, 1e-6, level + " (" + sources + " AudioTimeScale): time scale holds");
			DevWorld.SetTimeScale(1f);
			yield return t.Frames(3);
			t.Near(1.0, Time.timeScale, 1e-6, level + ": time scale back to 1");
			if (sources > 0)
			{
				checkedLevels++;
			}
		}
		t.Metric("levels_with_AudioTimeScale", checkedLevels);
		t.Check(checkedLevels > 0, "at least one level has an AudioTimeScale to fight with");
	}

	private static IEnumerator Gravity(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		DevWorld world = DevWorld.instance;
		world.SetGravityY(-20f);
		yield return t.Frames(1);
		t.Near(-20.0, Physics.gravity.y, 1e-6, "gravity set");
		world.SetGravityY(world.defaultGravity.y);
		t.Near(-10.0, Physics.gravity.y, 1e-6, "gravity reset to the project's -10");
	}

	private static IEnumerator InfiniteHealthUsesMax(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		DevWorld world = DevWorld.instance;
		Beast boss = BeastFactory.Rebuild(BeastRegistry.Human(0), BeastBody.Boss003, true);
		Beast p2 = BeastRegistry.Human(1);
		Beast mob = null;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player.mob && b.body == BeastBody.Normal)
			{
				mob = b;
				break;
			}
		}
		yield return t.Frames(3);
		t.Near(200.0, boss.MaxHealth, 1e-3, "P1 rebuilt as a boss has 200 maximum health");
		boss.stats.health = 30f;
		p2.stats.health = 30f;
		mob.stats.healthRegenerationSpeed = 0f;
		mob.stats.health = 30f;
		world.infiniteHealthHumans = true;
		yield return t.Frames(2);
		t.Near(200.0, boss.stats.health, 1e-3, "boss-sized player refilled to its own 200 (was held at 100)");
		t.Near(100.0, p2.stats.health, 1e-3, "P2 refilled to 100");
		t.Near(30.0, mob.stats.health, 0.5, "mobs are not affected");
		world.infiniteHealthHumans = false;
		world.infiniteHealthSlot[1] = true;
		boss.stats.health = 30f;
		p2.stats.health = 30f;
		yield return t.Frames(2);
		t.Check(boss.stats.health < 50f, "P1 not refilled when only P2 has it");
		t.Near(100.0, p2.stats.health, 1e-3, "P2 refilled by its own switch");
		world.infiniteHealthSlot[1] = false;
	}

	private static IEnumerator BalanceBalls(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		DevWorld world = DevWorld.instance;
		world.SetShowBalls(true);
		List<Beast> spawned = Spawn(DevTeam.MobGang, 2, BeastBody.Normal);
		yield return t.Frames(2);
		int shown = 0;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.Part("ball").renderer.enabled)
			{
				shown++;
			}
		}
		t.Equal(BeastRegistry.All.Count, shown, "every ball shown, spawned ones too");
		t.Check(spawned.Count == 2, "spawned two");
		world.SetShowBalls(false);
		shown = 0;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.Part("ball").renderer.enabled)
			{
				shown++;
			}
		}
		t.Equal(0, shown, "every ball hidden again");
	}

	private static IEnumerator PunchComponents(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Spawn(DevTeam.MobGang, 3, BeastBody.Normal);
		yield return t.Frames(1);
		foreach (Beast b in BeastRegistry.All)
		{
			t.Check(b.Part("leftHand").GetComponent<DevPunch>() != null && b.Part("rightHand").GetComponent<DevPunch>() != null, b + ": DevPunch on both hands");
		}
	}

	private static IEnumerator SpawnTeams(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		foreach (Beast b in Spawn(DevTeam.TeamA, 3, BeastBody.Normal))
		{
			t.Equal("DevMenu Team A", b.player.gangName, "Team A gang");
			t.Check(b.player.mob && b.player.player == 4, "spawned AI is a mob in slot 4");
		}
		foreach (Beast b in Spawn(DevTeam.TeamB, 3, BeastBody.Normal))
		{
			t.Equal("DevMenu Team B", b.player.gangName, "Team B gang");
		}
		List<Beast> ffa = Spawn(DevTeam.FreeForAll, 3, BeastBody.Normal);
		List<string> gangs = new List<string>();
		foreach (Beast b in BeastRegistry.All)
		{
			if (!ffa.Contains(b))
			{
				gangs.Add(b.player.gangName);
			}
		}
		foreach (Beast b in ffa)
		{
			t.Check(!gangs.Contains(b.player.gangName), "free-for-all gang is nobody else's: " + b.player.gangName);
			gangs.Add(b.player.gangName);
		}
		Beast p2 = BeastRegistry.Human(1);
		foreach (Beast b in Spawn(DevTeam.AllyP2, 2, BeastBody.Normal))
		{
			t.Equal(p2.player.gangName, b.player.gangName, "ally takes P2's gang");
			t.Check(b.leader == p2, "ally's leader is P2");
		}
		BeastRegistry.SafeDestroy(BeastRegistry.Human(3));
		yield return t.Frames(1);
		List<Beast> none = Spawn(DevTeam.AllyP4, 2, BeastBody.Normal);
		t.Equal(0, none.Count, "no ally without P4");
		t.Check(DevSpawner.message.Contains("P4"), "the menu says why: " + DevSpawner.message);
		List<Beast> many = Spawn(DevTeam.MobGang, 50, BeastBody.Normal);
		t.Metric("placed_of_50_near_P1", many.Count);
		t.Check(many.Count == 50 || DevSpawner.message.Contains("Room for"), "a short spawn is reported: " + DevSpawner.message);
	}

	private static IEnumerator SpawnBodiesAndHealth(DevTestContext t)
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
		AISpawnRequest r = new AISpawnRequest();
		r.count = 2;
		r.body = BeastBody.Boss003;
		r.randomColor = false;
		List<Beast> bosses = DevSpawner.Spawn(r);
		r = new AISpawnRequest();
		r.count = 2;
		r.fullHealth = true;
		List<Beast> full = DevSpawner.Spawn(r);
		r.fullHealth = false;
		List<Beast> levelHealth = DevSpawner.Spawn(r);
		yield return t.Frames(3);
		t.Equal(2, bosses.Count, "two bosses");
		foreach (Beast b in bosses)
		{
			t.Equal(BeastBody.Boss003, b.body, "boss body");
			t.Near(200.0, b.MaxHealth, 1e-3, "boss health");
			t.Check(b.player.actorColor == levelBoss.player.actorColor, "boss pink is Street's boss colour: " + b.player.actorColor + " vs " + levelBoss.player.actorColor);
		}
		foreach (Beast b in full)
		{
			t.Near(100.0, b.MaxHealth, 1e-3, "100-health option");
		}
		foreach (Beast b in levelHealth)
		{
			t.Near(BeastFactory.TemplateHealth, b.MaxHealth, 1e-3, "level mob health (" + BeastFactory.TemplateHealth + ")");
		}
		t.Near(50.0, BeastFactory.TemplateHealth, 1e-3, "Street's mobs have 50");
	}

	private static IEnumerator AllyRelinksOnReplace(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		List<Beast> allies = Spawn(DevTeam.AllyP1, 3, BeastBody.Normal);
		Beast p1 = BeastRegistry.Human(0);
		Beast boss = BeastFactory.Rebuild(p1, BeastBody.Boss003, true);
		foreach (Beast a in allies)
		{
			t.Check(a.leader == boss, "ally follows the rebuilt P1 in the same frame");
		}
		yield return t.Frames(2);
		t.Check(BeastRegistry.Human(0) == boss, "the rebuilt beast is P1");
	}

	private static IEnumerator Remove(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		int levelMobs = 0;
		int humans = 0;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player.mob)
			{
				levelMobs++;
			}
			else
			{
				humans++;
			}
		}
		List<Beast> spawned = Spawn(DevTeam.MobGang, 4, BeastBody.Normal);
		yield return t.Frames(3);
		spawned[0].stats.TakeDamage(null, 1e6f, false);
		yield return t.Frames(1);
		t.Equal(1, DevSpawner.RemoveDead(), "remove dead: one");
		yield return t.Frames(1);
		t.Equal(3, DevSpawner.RemoveSpawned(), "remove spawned: the other three");
		yield return t.Frames(1);
		t.Equal(levelMobs + humans, BeastRegistry.All.Count, "level beasts untouched");
		t.Equal(levelMobs, DevSpawner.RemoveAllMobs(), "remove all: the level's mobs");
		yield return t.Frames(1);
		t.Equal(humans, BeastRegistry.All.Count, "humans remain");
	}

	private static IEnumerator Objects(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Vector3 at = BeastRegistry.Human(0).Part("ball").position + Vector3.forward * 3f;
		DevProps.mass = 2f;
		float[] kindMass = { 1f, 1f, 1f, 1f, 4f, 3f, 1f, 0.3f };
		for (int kind = 0; kind < DevProps.primitiveNames.Length; kind++)
		{
			GameObject prop = DevProps.SpawnPrimitive(kind, at + Vector3.right * kind * 1.5f);
			t.Check(prop != null && prop.rigidbody != null, DevProps.primitiveNames[kind] + ": spawned with a rigidbody");
			t.Near(2f * kindMass[kind], prop.rigidbody.mass, 1e-4, DevProps.primitiveNames[kind] + ": mass");
		}
		string[] prefabs = DevProps.PrefabNames;
		t.Equal("Glass Sheet,Sign,Window Glass (3m)", string.Join(",", Sorted(prefabs)), "the three prefabs load from Resources");
		for (int i = 0; i < prefabs.Length; i++)
		{
			GameObject copy = DevProps.SpawnPrefab(i, at + Vector3.forward * 4f + Vector3.right * i * 3f);
			t.Check(copy.GetComponentsInChildren<RoadSpawnObjectMover>(true).Length == 0, prefabs[i] + ": no road mover");
			t.Check((DevProps.WorldBounds(copy).center - at).magnitude < 20f, prefabs[i] + ": placed near the spot (the Sign's root sits at x = -999)");
		}
		DevProps.RefreshLevelObjects();
		t.Metric("sandbox_level_objects", DevProps.LevelObjectNames.Length);
		t.Check(DevProps.LevelObjectNames.Length > 0, "Sandbox has loose physics objects to copy");
		for (int i = 0; i < DevProps.LevelObjectNames.Length; i++)
		{
			GameObject copy = DevProps.SpawnLevelObject(i, at + Vector3.back * 4f + Vector3.right * (i % 6) * 2f);
			foreach (Joint j in copy.GetComponentsInChildren<Joint>())
			{
				t.Check(j.connectedBody != null && j.connectedBody.transform.IsChildOf(copy.transform), DevProps.LevelObjectNames[i] + ": no joint to outside the copy");
			}
		}
		yield return t.Steps(50);
		int count = DevProps.SpawnedCount;
		t.Equal(count, DevProps.Clear(), "clear removes all");
		yield return t.Frames(1);
		t.Equal(0, DevProps.SpawnedCount, "nothing left");
	}

	private static string[] Sorted(string[] a)
	{
		string[] copy = (string[])a.Clone();
		System.Array.Sort(copy, string.CompareOrdinal);
		return copy;
	}

	private static IEnumerator ClearedObjectReleased(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		GameObject cube = DevProps.SpawnPrimitive(0, p1.Part("ball").position + Vector3.forward);
		Transform hand = p1.Part("rightHand");
		HingeJoint grab = hand.gameObject.AddComponent<HingeJoint>();
		grab.connectedBody = cube.rigidbody;
		yield return t.Steps(3);
		DevProps.Clear();
		yield return t.Steps(3);
		t.Equal(0, hand.GetComponents<HingeJoint>().Length, "the hand let go of the cleared cube");
	}

	// Load every level with AI, objects and settings in play: nothing breaks across level changes.
	private static IEnumerator LevelChanges(DevTestContext t)
	{
		string[] levels = { "Street", "Sandbox", "Gondola", "Subway", "Ring", "Menu", "Street" };
		foreach (string level in levels)
		{
			yield return t.LoadLevel(level);
			t.Equal(level, Application.loadedLevelName, "loaded " + level);
			if (level == "Menu")
			{
				t.Equal(0, BeastRegistry.All.Count, "Menu: no beasts");
				continue;
			}
			int beasts = BeastRegistry.All.Count;
			Spawn(DevTeam.TeamA, 5, BeastBody.Normal);
			Spawn(DevTeam.TeamB, 5, BeastBody.Boss003);
			DevProps.SpawnPrimitive(1, DevGround.ScreenCentre());
			DevWorld.instance.SetShowBalls(true);
			yield return t.Steps(100);
			t.Check(BeastRegistry.All.Count > beasts, level + ": AI spawned");
			foreach (Beast b in BeastRegistry.All)
			{
				t.Check(b.player != null, level + ": no destroyed beast left in the registry");
			}
		}
		DevWorld.instance.SetShowBalls(false);
	}
}
