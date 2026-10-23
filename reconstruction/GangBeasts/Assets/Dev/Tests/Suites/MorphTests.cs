using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Morphing a human player into the Pink Boss and back.
public static class MorphTests
{
	private static readonly string[] levels = { "Tutorial", "Sandbox", "Ring", "Grind", "Gondola", "Trucks", "Incinerator", "Wheel", "Subway", "Street" };

	public static DevTestSuite Suite()
	{
		return new DevTestSuite("morph")
			.Add("identity", Identity)
			.Add("shape_and_stats", ShapeAndStats)
			.Add("placement_every_level", PlacementEveryLevel)
			.Add("control_and_camera", ControlAndCamera)
			.Add("revert_restores", RevertRestores)
			.Add("while_stunned", WhileStunned)
			.Add("mid_air", MidAir)
			.Add("while_held_and_holding", WhileHeldAndHolding)
			.Add("twice_missing_slot_and_needless_revert", TwiceMissingAndNeedlessRevert)
			.Add("two_player_round_continues", TwoPlayerRound)
			.Add("keep_across_loads", KeepAcrossLoads)
			.Add("hard_mode_boss_and_options", HardModeBossAndOptions);
	}

	private static Beast LevelBoss()
	{
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player.mob && b.body == BeastBody.Boss003)
			{
				return b;
			}
		}
		return null;
	}

	private static IEnumerator Identity(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		string gang = p1.player.gangName;
		Color color = p1.player.actorColor;
		SceneManager sm = GameObject.FindWithTag("Scene Manager").GetComponent<SceneManager>();
		int lives = sm.score[0];
		GameObject old = p1.gameObject;
		Beast boss = Morph.ToBoss(0);
		yield return t.Frames(3);
		t.Check(old == null, "the original beast is gone");
		int count = 0;
		foreach (Object o in Object.FindObjectsOfType(typeof(Player)))
		{
			Player p = (Player)o;
			if (!p.mob && p.player == 0)
			{
				count++;
			}
		}
		t.Equal(1, count, "exactly one P1");
		t.Check(BeastRegistry.Human(0) == boss, "registry's P1 is the boss");
		t.Equal("Player 0", boss.player.name, "name");
		t.Equal("Player", boss.player.tag, "tag");
		t.Equal(gang, boss.player.gangName, "gang kept");
		t.Check(boss.player.actorColor == color, "own colour kept");
		t.Equal(lives, sm.score[0], "lives untouched");
		Color board = sm.guiTextColor[0];
		t.Check(Mathf.Abs(board.r - color.r) < 1e-4f && Mathf.Abs(board.a - 0.8f) < 1e-4f, "scoreboard colour set by Player.Start");
		t.Check(Morph.IsMorphed(0), "P1 reported morphed");
	}

	private static IEnumerator ShapeAndStats(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		p1.stats.health = 60f;
		Beast boss = Morph.ToBoss(0);
		yield return t.Frames(3);
		Beast levelBoss = LevelBoss();
		List<string> diff = DevTestUtil.Diff(DevTestUtil.Signature(levelBoss), DevTestUtil.Signature(boss), 8);
		t.Check(diff.Count == 0, "morphed P1 has the level boss's physics: " + string.Join(" / ", diff.ToArray()));
		t.Near(200.0, boss.MaxHealth, 1e-3, "max health 200");
		t.Near(120.0, boss.stats.health, 0.6, "health share kept (60/100 -> 120/200)");
		t.Near(20.0, boss.stats.stunThreshold, 1e-4, "stun threshold 20");
		t.Near(30.0, boss.movement.movementSpeed, 1e-4, "movement speed 30");
		t.Near(0.4, boss.movement.animationSpeed, 1e-6, "animation speed 0.4");
		t.Near(5.0, boss.stats.healthRegenerationSpeed, 1e-4, "keeps the human's regeneration");
		t.Check(!boss.player.mob && boss.player.player == 0, "still human P1");
	}

	private static IEnumerator PlacementEveryLevel(DevTestContext t)
	{
		foreach (string level in levels)
		{
			yield return t.LoadLevel(level);
			yield return t.Steps(30);
			Beast p1 = BeastRegistry.Human(0);
			Vector3 ball = p1.Part("ball").position;
			Vector3 facing = p1.Part("chest").forward;
			facing.y = 0f;
			Beast boss = Morph.ToBoss(0);
			t.Near(0.0, (boss.Part("ball").position - ball).magnitude, 0.05, level + ": balance ball where P1's was");
			Vector3 now = boss.Part("chest").forward;
			now.y = 0f;
			t.Check(Vector3.Angle(facing, now) < 5f, level + ": faces the same way (" + Vector3.Angle(facing, now) + " deg)");
			float top = 0f;
			float lowest = float.PositiveInfinity;
			for (int s = 0; s < 200; s++)
			{
				yield return new WaitForFixedUpdate();
				if (boss.player == null)
				{
					break;
				}
				if (s < 50)
				{
					top = Mathf.Max(top, DevTestUtil.MaxPartSpeed(boss));
				}
				lowest = Mathf.Min(lowest, boss.Part("hips").position.y - ball.y);
			}
			t.Metric(level + "_max_part_speed", top);
			t.Check(top < 25f, level + ": not flung (" + top + " m/s)");
			t.Check(boss.player != null && lowest > 0f, level + ": hips stay above the ground it stood on (lowest " + lowest + ")");
		}
	}

	private static IEnumerator ControlAndCamera(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Beast boss = Morph.ToBoss(0);
		yield return t.Steps(50);
		Vector3 from = boss.Part("hips").position;
		Vector3 dir = Vector3.right;
		DevPilot.On(boss).direction = dir;
		yield return t.Steps(300);
		DevPilot.On(boss).direction = Vector3.zero;
		Vector3 moved = boss.Part("hips").position - from;
		t.Metric("moved_along_command", Vector3.Dot(moved, dir));
		t.Check(Vector3.Dot(moved, dir) > 2f, "walks where it is steered (" + Vector3.Dot(moved, dir) + " m in 3 s)");
		boss.player.leftPunch = true;
		bool harmful = false;
		for (int s = 0; s < 60; s++)
		{
			yield return new WaitForFixedUpdate();
			harmful |= boss.Part("leftHand").tag == "Body Part (Harmful)";
		}
		t.Check(harmful, "punches (the hand turns harmful during the strike)");
		SceneCamera cam = Camera.main != null ? Camera.main.GetComponent<SceneCamera>() : null;
		bool tracked = false;
		if (cam != null && cam.player != null)
		{
			foreach (Player p in cam.player)
			{
				tracked |= p == boss.player;
			}
		}
		t.Check(tracked, "the game camera tracks the morphed player");
	}

	private static IEnumerator RevertRestores(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		yield return t.Steps(10);
		Beast p1 = BeastRegistry.Human(0);
		List<string> signature = DevTestUtil.Signature(p1);
		List<string> settings = DevTestUtil.Settings(p1, true);
		Morph.ToBoss(0);
		yield return t.Frames(3);
		Beast back = Morph.Revert(0);
		yield return t.Frames(3);
		List<string> diff = DevTestUtil.Diff(signature, DevTestUtil.Signature(back), 8);
		t.Check(diff.Count == 0, "physics back to P1's own: " + string.Join(" / ", diff.ToArray()));
		diff = DevTestUtil.Diff(settings, DevTestUtil.Settings(back, true), 8);
		t.Check(diff.Count == 0, "settings back to P1's own: " + string.Join(" / ", diff.ToArray()));
		t.Near(100.0, back.MaxHealth, 1e-3, "max health back to 100");
		t.Equal(BeastBody.Normal, back.body, "normal body");
		t.Check(!Morph.IsMorphed(0), "no longer morphed");
	}

	private static IEnumerator WhileStunned(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		// (TakeDamage without a collision throws on non-lethal damage: it looks up the punch sound. And at
		// full health HealthAndStamina clears the stun every frame, so the health goes down too.)
		p1.stats.health = 50f;
		DevReflection.SetStunTimer(p1.stats, 4f);
		yield return t.Frames(2);
		t.Equal(Player.State.Stunned, p1.player.state, "P1 stunned before the morph");
		float stun = DevReflection.StunTimer(p1.stats);
		Beast boss = Morph.ToBoss(0);
		yield return t.Frames(2);
		t.Equal(Player.State.Stunned, boss.player.state, "still stunned after");
		t.Check(DevReflection.StunTimer(boss.stats) > 0f && DevReflection.StunTimer(boss.stats) <= stun, "stun time carried over");
	}

	private static IEnumerator MidAir(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Beast p1 = BeastRegistry.Human(0);
		foreach (Rigidbody rb in p1.gameObject.GetComponentsInChildren<Rigidbody>())
		{
			rb.velocity = Vector3.up * 6f;
		}
		yield return t.Steps(15);
		Beast boss = Morph.ToBoss(0);
		t.Check(boss.Part("hips").rigidbody.velocity.y > 0f, "keeps its upward speed");
		float top = 0f;
		for (int s = 0; s < 100; s++)
		{
			yield return new WaitForFixedUpdate();
			top = Mathf.Max(top, DevTestUtil.MaxPartSpeed(boss));
		}
		t.Check(top < 25f, "lands without being flung (" + top + ")");
	}

	private static IEnumerator WhileHeldAndHolding(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		Beast p2 = BeastRegistry.Human(1);
		// P2 holds P1; P1 holds a cube.
		HingeJoint held = p2.Part("leftHand").gameObject.AddComponent<HingeJoint>();
		held.connectedBody = p1.Part("chest").rigidbody;
		GameObject cube = DevProps.SpawnPrimitive(0, p1.Part("ball").position + Vector3.forward);
		HingeJoint holding = p1.Part("rightHand").gameObject.AddComponent<HingeJoint>();
		holding.connectedBody = cube.rigidbody;
		yield return t.Steps(3);
		Beast boss = Morph.ToBoss(0);
		yield return t.Steps(3);
		t.Equal(0, p2.Part("leftHand").GetComponents<HingeJoint>().Length, "P2's grab on the old P1 is released (not pinned to the world)");
		t.Equal(0, boss.Part("rightHand").GetComponents<HingeJoint>().Length, "the new boss starts empty-handed");
		int holds = 0;
		foreach (Object o in Object.FindObjectsOfType(typeof(HingeJoint)))
		{
			if (((HingeJoint)o).connectedBody == cube.rigidbody)
			{
				holds++;
			}
		}
		t.Equal(0, holds, "nothing holds the cube any more");
	}

	private static IEnumerator TwiceMissingAndNeedlessRevert(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Beast p1 = BeastRegistry.Human(0);
		int settingsBefore = DevTestUtil.Settings(p1, true).Count;
		Morph.ToBoss(0);
		yield return t.Frames(2);
		Beast again = Morph.ToBoss(0);
		yield return t.Frames(2);
		t.Equal(BeastBody.Boss003, again.body, "morphing a boss again keeps it a boss");
		Beast back = Morph.Revert(0);
		yield return t.Frames(3);
		t.Near(100.0, back.MaxHealth, 1e-3, "one revert undoes both");
		t.Equal(settingsBefore, DevTestUtil.Settings(back, true).Count, "settings intact");
		t.Check(Morph.Revert(0) == null, "reverting a normal P1 does nothing");
		BeastRegistry.SafeDestroy(BeastRegistry.Human(3));
		yield return t.Frames(1);
		t.Check(Morph.ToBoss(3) == null, "no P4: nothing to morph");
	}

	// SceneManager reloads the level once at most one player is left; morphing must not look like that.
	private static IEnumerator TwoPlayerRound(DevTestContext t)
	{
		DevTestUtil.SetPlayers(2);
		yield return t.LoadLevel("Ring");
		int loads = DevTestRunner.levelLoads;
		Morph.ToBoss(0);
		yield return t.Steps(400);
		t.Equal(loads, DevTestRunner.levelLoads, "no level reload within 4 s of the morph");
		t.Equal("Ring", Application.loadedLevelName, "still in Ring");
		DevTestUtil.SetPlayers(4);
	}

	private static IEnumerator KeepAcrossLoads(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Morph.keepAcrossLoads = true;
		Morph.ToBoss(1);
		yield return t.LoadLevel("Street");
		Beast p2 = BeastRegistry.Human(1);
		t.Check(p2 != null && p2.body == BeastBody.Boss003, "P2 is a boss again after the reload");
		t.Check(BeastRegistry.Human(0).body == BeastBody.Normal, "P1 untouched");
		Morph.keepAcrossLoads = false;
		yield return t.LoadLevel("Street");
		t.Check(BeastRegistry.Human(1).body == BeastBody.Normal, "with the option off, a reload brings P2 back normal");
	}

	private static IEnumerator HardModeBossAndOptions(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		HardMode.on = true;
		Beast boss = Morph.ToBoss(0);
		HardMode.on = false;
		t.Equal(BeastBody.Boss002, boss.body, "Hard Mode morphs into 0.0.2's boss");
		t.Near(BeastShapes.Boss002.rootScale, boss.player.transform.localScale.x, 1e-5, "0.0.2 boss size");
		t.Near(20.0, boss.Part("leftHand").rigidbody.mass, 1e-4, "0.0.2 boss fists 20 kg");
		Morph.bossPink = true;
		boss = Morph.ToBoss(1);
		Morph.bossPink = false;
		t.Check(boss.player.actorColor == DevSpawner.bossColor, "boss pink option");
		Morph.custom = true;
		Morph.customSize = 1.6f;
		Morph.customHealth = 500f;
		Morph.customFistMass = 30f;
		boss = Morph.ToBoss(2);
		Morph.custom = false;
		yield return t.Frames(3);
		t.Near(1.6, boss.player.transform.localScale.x, 1e-5, "custom size");
		t.Near(500.0, boss.MaxHealth, 1e-3, "custom health");
		t.Near(30.0, boss.Part("rightHand").rigidbody.mass, 1e-4, "custom fist mass");
		float top = 0f;
		for (int s = 0; s < 50; s++)
		{
			yield return new WaitForFixedUpdate();
			top = Mathf.Max(top, DevTestUtil.MaxPartSpeed(boss));
		}
		t.Check(top < 30f, "a big custom boss is not flung either (" + top + ")");
	}
}
