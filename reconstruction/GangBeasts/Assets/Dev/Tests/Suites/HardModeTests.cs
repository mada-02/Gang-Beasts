using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Hard Mode against its oracle (Generated/HardModeData.cs, from the 0.0.2 build) and against 0.0.3:
// every value in place, exact restore, joints locked at rest, and 0.0.2's Player/CollisionEvent rules.
public static class HardModeTests
{
	private static readonly string[] levels = { "Tutorial", "Sandbox", "Ring", "Grind", "Gondola", "Trucks", "Incinerator", "Wheel", "Subway", "Street" };

	public static DevTestSuite Suite()
	{
		return new DevTestSuite("hardmode")
			.Add("values_every_level", ValuesEveryLevel)
			.Add("toggle_no_drift", ToggleNoDrift)
			.Add("wrists_lock_at_rest", WristsLockAtRest)
			.Add("limp_at_once", LimpAtOnce)
			.Add("recovers_at_force_over_8", RecoveryRate)
			.Add("never_falls", NeverFalls)
			.Add("hand_tags_kept_when_stunned", HandTagsKept)
			.Add("impact_damage_100x_less", FallDamage)
			.Add("subway_generic_stats", SubwayGeneric)
			.Add("morph_and_spawn_under_hard_mode", MorphAndSpawn)
			.Add("level_loads_while_on", LevelLoadsWhileOn);
	}

	private static void CheckApplied(DevTestContext t, Beast b, string name)
	{
		if (!t.Check(HardMode.IsHard(b), name + ": in Hard Mode"))
		{
			return;
		}
		int bad = 0;
		foreach (HardModeData.Field f in HardMode.PhysicsFor(b).physics)
		{
			float v = HardMode.ReadPhysics(b, f.path, f.key);
			if (Mathf.Abs(v - f.v002) > 1e-5f * Mathf.Max(1f, Mathf.Abs(f.v002)))
			{
				if (bad++ < 3)
				{
					t.Fail(name + ": " + f.path + " " + f.key + " = " + v + ", 0.0.2: " + f.v002);
				}
			}
		}
		HardModeData.ClassData role = HardMode.RoleFor(b);
		HardModeData.ClassData boss = b.body != BeastBody.Normal ? HardMode.BossData() : null;
		foreach (HardModeData.ClassData data in new HardModeData.ClassData[] { role, boss })
		{
			if (data == null)
			{
				continue;
			}
			foreach (HardModeData.Field f in data.stats)
			{
				bool body = HardMode.IsBodyStat(f.key);
				if (boss != null && boss != role && ((data == role && body) || (data == boss && !body)))
				{
					continue;
				}
				float v = HardMode.ReadStat(b, f.key);
				t.Check(Mathf.Abs(v - f.v002) < 1e-4f * Mathf.Max(1f, Mathf.Abs(f.v002)), name + ": " + f.key + " = " + v + ", 0.0.2: " + f.v002);
			}
		}
		for (int i = 0; i < HardModeData.hitboxes.GetLength(0); i++)
		{
			string path = HardModeData.hitboxes[i, 0];
			Transform part = b.Part(path.Substring(path.LastIndexOf('/') + 1));
			List<Collider> solid = new List<Collider>();
			foreach (Collider c in part.GetComponents<Collider>())
			{
				if (!c.isTrigger)
				{
					solid.Add(c);
				}
			}
			MeshCollider m = solid.Count == 1 ? solid[0] as MeshCollider : null;
			bool ok = m != null && m.convex && m.sharedMesh.name == "0.0.2 " + HardModeData.hitboxes[i, 1]
				&& m.smoothSphereCollisions == (HardModeData.hitboxes[i, 2] == "true")
				&& (HardModeData.hitboxes[i, 3] == null ? m.sharedMaterial == null : m.sharedMaterial != null && m.sharedMaterial.name == HardModeData.hitboxes[i, 3]);
			t.Check(ok, name + ": 0.0.2 hitbox on " + path);
		}
		t.Check(!b.movement.enabled && !b.jump.enabled && !b.punch.enabled, name + ": 0.0.3 Movement/Jump/PunchAndGrab off");
		t.Check(b.gameObject.GetComponent<Movement002>().enabled && b.gameObject.GetComponent<Jump002>().enabled && b.gameObject.GetComponent<PunchAndGrab002>().enabled, name + ": 0.0.2 ones on");
		t.Equal(0, b.gameObject.GetComponentsInChildren<CollisionEvent>().Length, name + ": no 0.0.3 CollisionEvent left");
		t.Check(b.gameObject.GetComponentsInChildren<CollisionEvent002>().Length >= 16, name + ": 0.0.2 CollisionEvent on every part");
	}

	private static Dictionary<string, List<string>> Snapshot()
	{
		Dictionary<string, List<string>> all = new Dictionary<string, List<string>>();
		foreach (Beast b in BeastRegistry.All)
		{
			List<string> lines = DevTestUtil.Signature(b);
			lines.AddRange(DevTestUtil.Settings(b, true));
			lines.Add("max health " + b.MaxHealth.ToString("R"));
			lines.Add("components " + b.movement.enabled + b.jump.enabled + b.punch.enabled + " " + b.gameObject.GetComponentsInChildren<CollisionEvent>().Length);
			string key = b.player.name + " " + b.player.gangName + " " + (b.player.mob ? "mob" : "human") + " " + b.body;
			int n = 0;
			while (all.ContainsKey(key + " #" + n))
			{
				n++;
			}
			all[key + " #" + n] = lines;
		}
		return all;
	}

	private static void CompareSnapshots(DevTestContext t, Dictionary<string, List<string>> a, Dictionary<string, List<string>> b, string what)
	{
		t.Equal(a.Count, b.Count, what + ": same beasts");
		foreach (KeyValuePair<string, List<string>> e in a)
		{
			List<string> other;
			if (!b.TryGetValue(e.Key, out other))
			{
				t.Fail(what + ": " + e.Key + " missing");
				continue;
			}
			List<string> diff = DevTestUtil.Diff(e.Value, other, 4);
			t.Check(diff.Count == 0, what + ": " + e.Key + " differs: " + string.Join(" / ", diff.ToArray()));
		}
	}

	private static Beast SpawnOne(BeastBody body)
	{
		AISpawnRequest r = new AISpawnRequest();
		r.body = body;
		r.at = DevSpawnAt.NearP1;
		r.randomColor = false;
		List<Beast> list = DevSpawner.Spawn(r);
		return list.Count > 0 ? list[0] : null;
	}

	private static IEnumerator ValuesEveryLevel(DevTestContext t)
	{
		foreach (string level in levels)
		{
			yield return t.LoadLevel(level);
			Dictionary<string, List<string>> before = Snapshot();
			HardMode.Set(true);
			yield return t.Frames(2);
			Beast mob = SpawnOne(BeastBody.Normal);
			Beast boss = SpawnOne(BeastBody.Boss002);
			yield return t.Frames(3);
			foreach (Beast b in BeastRegistry.All)
			{
				CheckApplied(t, b, level + " " + b);
			}
			t.Check(mob != null && boss != null, level + ": spawned under Hard Mode");
			if (level == "Street")
			{
				int bosses002 = 0;
				foreach (Beast b in BeastRegistry.All)
				{
					t.Check(b.body != BeastBody.Boss003, "Street: no 0.0.3 boss body left");
					if (b.body == BeastBody.Boss002)
					{
						bosses002++;
					}
				}
				t.Equal(2, bosses002, "Street: level boss rebuilt with 0.0.2's body (+ the spawned one)");
			}
			BeastRegistry.SafeDestroy(mob);
			BeastRegistry.SafeDestroy(boss);
			yield return t.Frames(1);
			HardMode.Set(false);
			yield return t.Frames(3);
			CompareSnapshots(t, before, Snapshot(), level + " after switching off");
		}
	}

	private static IEnumerator ToggleNoDrift(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Dictionary<string, List<string>> before = Snapshot();
		for (int i = 0; i < 25; i++)
		{
			HardMode.Set(true);
			yield return t.Frames(2);
			HardMode.Set(false);
			yield return t.Frames(2);
		}
		CompareSnapshots(t, before, Snapshot(), "after 25 on/off");
	}

	// Locking a joint keeps the pose it is in: switched on while the arms flail, the wrists must still lock
	// at their rest pose.
	private static IEnumerator WristsLockAtRest(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Beast b = SpawnOne(BeastBody.Normal);
		b.player.devBrain = true;
		Transform hand = b.Part("leftHand");
		Transform forearm = b.Part("leftForarm");
		Quaternion restRelative = Quaternion.Inverse(forearm.rotation) * hand.rotation;
		Random.seed = t.seed;
		for (int s = 0; s < 60; s++)
		{
			hand.rigidbody.AddTorque(Random.onUnitSphere * 30f, ForceMode.Impulse);
			yield return new WaitForFixedUpdate();
		}
		float bent = Quaternion.Angle(restRelative, Quaternion.Inverse(forearm.rotation) * hand.rotation);
		t.Metric("wrist_bend_before_deg", bent);
		HardMode.Set(true);
		float worst = 0f;
		for (int s = 0; s < 100; s++)
		{
			hand.rigidbody.AddTorque(Random.onUnitSphere * 30f, ForceMode.Impulse);
			yield return new WaitForFixedUpdate();
			worst = Mathf.Max(worst, Quaternion.Angle(restRelative, Quaternion.Inverse(forearm.rotation) * hand.rotation));
		}
		HardMode.Set(false);
		t.Metric("wrist_off_rest_while_locked_deg", worst);
		t.Check(bent > 5f, "the wrist was bent when Hard Mode came on (" + bent + " deg)");
		t.Check(worst < 3f, "locked at its rest pose (worst " + worst + " deg)");
	}

	private static IEnumerator Stun(Beast b)
	{
		b.stats.health = b.MaxHealth * 0.5f;
		DevReflection.SetStunTimer(b.stats, 2f);
		yield return null;
	}

	private static IEnumerator LimpAtOnce(DevTestContext t)
	{
		foreach (bool hard in new bool[] { false, true })
		{
			yield return t.LoadLevel("Sandbox");
			HardMode.Set(hard);
			Beast b = BeastRegistry.Human(0);
			yield return t.Steps(50);
			float force = b.player.applyedForce;
			yield return Stun(b);
			yield return t.Frames(1);
			t.Metric((hard ? "hard" : "vanilla") + "_applyedForce_one_frame_after_stun", b.player.applyedForce);
			if (hard)
			{
				t.Near(0.0, b.player.applyedForce, 1e-6, "0.0.2: limp at once when stunned");
			}
			else
			{
				t.Check(b.player.applyedForce > force * 0.9f, "0.0.3: drains gradually");
			}
			HardMode.Set(false);
		}
	}

	private static IEnumerator RecoveryRate(DevTestContext t)
	{
		foreach (bool hard in new bool[] { false, true })
		{
			yield return t.LoadLevel("Sandbox");
			HardMode.Set(hard);
			Beast b = BeastRegistry.Human(0);
			yield return t.Steps(20);
			b.player.applyedForce = 0f;
			yield return t.Frames(100);
			float rate = b.player.applyedForce / b.player.force;
			t.Metric((hard ? "hard" : "vanilla") + "_recovered_share_after_1s", rate);
			t.Near(hard ? 1.0 / 8.0 : 1.0 / 6.0, rate, 0.01, (hard ? "0.0.2" : "0.0.3") + ": recovers force/" + (hard ? 8 : 6) + " per second");
			HardMode.Set(false);
		}
	}

	private static IEnumerator NeverFalls(DevTestContext t)
	{
		foreach (bool hard in new bool[] { false, true })
		{
			yield return t.LoadLevel("Sandbox");
			HardMode.Set(hard);
			Beast b = BeastRegistry.Human(0);
			yield return t.Steps(20);
			foreach (Rigidbody rb in b.gameObject.GetComponentsInChildren<Rigidbody>())
			{
				rb.position += Vector3.up * 6f;
				rb.velocity = Vector3.zero;
			}
			bool fell = false;
			for (int s = 0; s < 90; s++)
			{
				yield return new WaitForFixedUpdate();
				fell |= b.player.state == Player.State.Falling;
			}
			if (hard)
			{
				t.Check(!fell, "0.0.2: never Falling, even in the air");
			}
			else
			{
				t.Check(fell, "0.0.3: Falling after 0.5 s in the air");
			}
			HardMode.Set(false);
		}
	}

	private static IEnumerator HandTagsKept(DevTestContext t)
	{
		foreach (bool hard in new bool[] { false, true })
		{
			yield return t.LoadLevel("Sandbox");
			HardMode.Set(hard);
			Beast b = BeastRegistry.Human(0);
			yield return t.Steps(10);
			b.Part("leftHand").tag = "Body Part (Harmful)";
			yield return Stun(b);
			yield return t.Frames(2);
			string tag = b.Part("leftHand").tag;
			if (hard)
			{
				t.Equal("Body Part (Harmful)", tag, "0.0.2: a stunned beast's hand keeps its tag");
			}
			else
			{
				t.Equal("Body Part", tag, "0.0.3: stunning resets it");
			}
			HardMode.Set(false);
		}
	}

	// Static impacts (code_diff.md C1, P3). A contact within 45 degrees of up counts as ground, not damage,
	// unless the beast is Falling (0.5 s off the ground); 0.0.2 never falls, so its landings never hurt, and
	// its other static impacts do 10/100 where 0.0.3's do 1000/100. Measured on a landing after 0.6 s in
	// the air and on a slam into the nearest wall, both at 25 m/s (drag 0.5 caps a plain fall near 14 m/s,
	// under the 15 m/s damage gate). In Street, open to the sky.
	private static IEnumerator FallDamage(DevTestContext t)
	{
		float[,] lost = new float[2, 2];
		for (int k = 0; k < 2; k++)
		{
			bool hard = k == 1;
			string name = hard ? "hard" : "vanilla";
			for (int wall = 0; wall < 2; wall++)
			{
				yield return t.LoadLevel("Street");
				HardMode.Set(hard);
				Beast b = BeastRegistry.Human(0);
				b.stats.canDie = false;
				b.stats.healthRegenerationSpeed = 0f;
				yield return t.Steps(20);
				Vector3 push = Vector3.down;
				if (wall == 1)
				{
					Vector3 from = b.Part("hips").position + Vector3.up * 0.5f;
					float nearest = 20f;
					Vector3 dir = Vector3.zero;
					for (int i = 0; i < 16; i++)
					{
						Vector3 d = Quaternion.AngleAxis(i * 22.5f, Vector3.up) * Vector3.forward;
						foreach (RaycastHit hit in Physics.RaycastAll(from, d, nearest))
						{
							if (!hit.collider.isTrigger && hit.rigidbody == null && Mathf.Abs(hit.normal.y) < 0.3f && hit.distance < nearest
								&& hit.collider.transform.root.GetComponent<Player>() == null)
							{
								nearest = hit.distance;
								dir = d;
							}
						}
					}
					if (!t.Check(dir != Vector3.zero, name + ": a wall within 20 m of P1"))
					{
						continue;
					}
					Vector3 move = dir * (nearest - 3f);
					foreach (Rigidbody rb in b.gameObject.GetComponentsInChildren<Rigidbody>())
					{
						rb.position += move;
					}
					push = dir;
				}
				else
				{
					// Off the ground long enough for 0.0.3 to call it Falling.
					for (int s = 0; s < 60; s++)
					{
						foreach (Rigidbody rb in b.gameObject.GetComponentsInChildren<Rigidbody>())
						{
							if (s == 0)
							{
								rb.position += Vector3.up * 8f;
							}
							rb.velocity = Vector3.zero;
						}
						yield return new WaitForFixedUpdate();
					}
					t.Metric(name + "_state_before_landing_" + b.player.state, 1);
				}
				foreach (Rigidbody rb in b.gameObject.GetComponentsInChildren<Rigidbody>())
				{
					rb.velocity = push * 25f;
				}
				float health = b.stats.health;
				float lowest = health;
				for (int s = 0; s < 150; s++)
				{
					yield return new WaitForFixedUpdate();
					lowest = Mathf.Min(lowest, b.stats.health);
				}
				lost[k, wall] = health - lowest;
				t.Metric(name + (wall == 1 ? "_health_lost_wall" : "_health_lost_landing"), lost[k, wall]);
				HardMode.Set(false);
			}
		}
		t.Check(lost[0, 0] > 20f, "0.0.3: landing after a fall hurts (" + lost[0, 0] + ")");
		t.Check(lost[1, 0] < 1f, "0.0.2: never Falling, so landings do not hurt (" + lost[1, 0] + ")");
		t.Check(lost[0, 1] > 20f, "0.0.3: slamming into a wall hurts (" + lost[0, 1] + ")");
		t.Check(lost[1, 1] < lost[0, 1] / 10f, "0.0.2: far less (" + lost[1, 1] + " vs " + lost[0, 1] + ")");
	}

	// Subway is not in 0.0.2: only values every 0.0.2 level shares; its own mob stats stay.
	private static IEnumerator SubwayGeneric(DevTestContext t)
	{
		yield return t.LoadLevel("Subway");
		Beast mob = SpawnOne(BeastBody.Normal);
		yield return t.Frames(3);
		float stun = mob.stats.stunThreshold;
		float health = mob.MaxHealth;
		HardMode.Set(true);
		yield return t.Frames(2);
		t.Near(80.0, mob.player.force, 1e-4, "generic 0.0.2 mob force");
		t.Near(300.0, mob.jump.jumpStrength, 1e-4, "generic 0.0.2 jump strength");
		t.Near(stun, mob.stats.stunThreshold, 1e-4, "stun threshold not generic: kept (" + stun + ")");
		t.Near(health, mob.MaxHealth, 1e-4, "health not generic: kept");
		Beast p1 = BeastRegistry.Human(0);
		t.Near(12.0, p1.stats.stunThreshold, 1e-4, "humans' 0.0.2 stun threshold 12 is generic");
		HardMode.Set(false);
	}

	private static IEnumerator MorphAndSpawn(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		HardMode.Set(true);
		Beast p1 = Morph.ToBoss(0);
		yield return t.Frames(3);
		t.Equal(BeastBody.Boss002, p1.body, "morphed under Hard Mode: 0.0.2 boss body");
		CheckApplied(t, p1, "morphed P1");
		t.Near(5.0, p1.stats.healthRegenerationSpeed, 1e-4, "morphed P1 keeps a human's regeneration");
		HardMode.Set(false);
		yield return t.Frames(3);
		Beast now = BeastRegistry.Human(0);
		t.Equal(BeastBody.Boss003, now.body, "switching off gives it 0.0.3's boss body");
		t.Near(20.0, now.stats.stunThreshold, 1e-4, "boss stun threshold");
		t.Check(now.movement.enabled && !HardMode.IsHard(now), "back on 0.0.3's code");
	}

	private static IEnumerator LevelLoadsWhileOn(DevTestContext t)
	{
		HardMode.Set(true);
		foreach (string level in new string[] { "Street", "Sandbox", "Street" })
		{
			yield return t.LoadLevel(level);
			yield return t.Frames(3);
			foreach (Beast b in BeastRegistry.All)
			{
				t.Check(HardMode.IsHard(b), level + ": " + b + " in Hard Mode right after loading");
				t.Check(b.body != BeastBody.Boss003, level + ": no 0.0.3 boss body");
			}
		}
		HardMode.Set(false);
	}
}
