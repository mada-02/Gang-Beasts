using System;
using System.Collections.Generic;
using UnityEngine;

// Turns a human player into a Pink Boss-like beast and back (Player tab). The beast is rebuilt from the
// template with the boss's body (Street's, or 0.0.2's under Hard Mode) and swapped in: same slot, side,
// colour, place, facing, speed, health share and stun; allies and brains follow it at once.
public static class Morph
{
	// Settings of each slot before it was morphed, put back on revert.
	private static readonly Dictionary<Type, object[]>[] before = new Dictionary<Type, object[]>[4];

	// Slots that stay morphed across level loads (when keepAcrossLoads is on).
	private static readonly bool[] wanted = new bool[4];

	public static bool keepAcrossLoads;

	// Street's boss pink instead of the player's own colour.
	public static bool bossPink;

	// A custom boss instead of Street's: these replace the shape's size and stats.
	public static bool custom;

	public static float customSize = 1.3f;

	public static float customHealth = 200f;

	public static float customStunThreshold = 20f;

	public static float customFistMass = 10f;

	public static float customMovementSpeed = 30f;

	public static float customAnimationSpeed = 0.4f;

	private static bool initialised;

	public static void Init()
	{
		if (initialised)
		{
			return;
		}
		initialised = true;
		DevRoot.LevelReady += OnLevelReady;
		DevMenu.playerSections.Add(DrawSection);
	}

	public static bool IsMorphed(int slot)
	{
		Beast b = BeastRegistry.Human(slot);
		return b != null && b.body != BeastBody.Normal && before[slot] != null;
	}

	public static BeastBody BossBody
	{
		get { return HardMode.on ? BeastBody.Boss002 : BeastBody.Boss003; }
	}

	public static Beast ToBoss(int slot)
	{
		Beast human = BeastRegistry.Human(slot);
		if (human == null)
		{
			return null;
		}
		if (before[slot] == null || human.body == BeastBody.Normal)
		{
			before[slot] = DevFields.Snapshot(human);
		}
		wanted[slot] = true;
		Beast boss = BeastFactory.Rebuild(human, BossBody, true, ConfigureBoss);
		if (boss != null && bossPink)
		{
			boss.player.actorColor = DevSpawner.bossColor;
			boss.player.renderer.material.color = DevSpawner.bossColor;
		}
		return boss;
	}

	private static void ConfigureBoss(GameObject copy)
	{
		if (!custom)
		{
			return;
		}
		copy.transform.localScale = Vector3.one * customSize;
		HealthAndStamina stats = copy.GetComponent<HealthAndStamina>();
		stats.health = customHealth;
		stats.stunThreshold = customStunThreshold;
		Movement movement = copy.GetComponent<Movement>();
		movement.movementSpeed = customMovementSpeed;
		movement.animationSpeed = customAnimationSpeed;
		foreach (string hand in new string[] { "hips/chest/leftArm/leftForarm/leftHand", "hips/chest/rightArm/rightForarm/rightHand" })
		{
			copy.transform.Find(hand).rigidbody.mass = customFistMass;
		}
	}

	public static Beast Revert(int slot)
	{
		Beast boss = BeastRegistry.Human(slot);
		wanted[slot] = false;
		if (boss == null || before[slot] == null || boss.body == BeastBody.Normal)
		{
			return null;
		}
		Dictionary<Type, object[]> settings = before[slot];
		before[slot] = null;
		return BeastFactory.Rebuild(boss, BeastBody.Normal, false, copy => DevFields.Restore(settings, copy));
	}

	private static void OnLevelReady()
	{
		for (int slot = 0; slot < 4; slot++)
		{
			before[slot] = null;
			if (keepAcrossLoads && wanted[slot])
			{
				ToBoss(slot);
			}
			else
			{
				wanted[slot] = false;
			}
		}
	}

	// The Player tab's section.
	public static void DrawSection()
	{
		GUILayout.Space(6f);
		GUILayout.Label("Pink Boss morph (" + (HardMode.on ? "0.0.2" : "0.0.3") + " boss)");
		for (int slot = 0; slot < 4; slot++)
		{
			if (BeastRegistry.Human(slot) == null)
			{
				continue;
			}
			GUILayout.BeginHorizontal();
			GUILayout.Label("P" + (slot + 1), GUILayout.Width(28f));
			if (GUILayout.Button(IsMorphed(slot) ? "Morph again" : "Morph to boss"))
			{
				ToBoss(slot);
			}
			GUI.enabled = IsMorphed(slot);
			if (GUILayout.Button("Revert"))
			{
				Revert(slot);
			}
			GUI.enabled = true;
			GUILayout.EndHorizontal();
		}
		bossPink = GUILayout.Toggle(bossPink, "Boss pink");
		keepAcrossLoads = GUILayout.Toggle(keepAcrossLoads, "Stay a boss across level loads");
		custom = GUILayout.Toggle(custom, "Custom boss");
		if (custom)
		{
			customSize = DevMenu.Slider("Size", customSize, 1f, 2f, "0.00");
			customHealth = DevMenu.Slider("Health", customHealth, 50f, 1000f, "0");
			customStunThreshold = DevMenu.Slider("Stun over", customStunThreshold, 5f, 100f, "0");
			customFistMass = DevMenu.Slider("Fist kg", customFistMass, 5f, 40f, "0");
			customMovementSpeed = DevMenu.Slider("Speed", customMovementSpeed, 10f, 60f, "0");
			customAnimationSpeed = DevMenu.Slider("Gait", customAnimationSpeed, 0.1f, 0.6f, "0.00");
		}
	}
}
