using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

// The game's private fields the developer layer reads or writes, looked up once. Missing() lists any
// that were not found (a renamed field would otherwise fail silently); the Debug tab shows it.
public static class DevReflection
{
	private const BindingFlags Instance = BindingFlags.NonPublic | BindingFlags.Instance;

	// HealthAndStamina.Start stores the starting health here (0 until Start runs).
	public static readonly FieldInfo maxHealth = typeof(HealthAndStamina).GetField("maxHealth", Instance);

	public static readonly FieldInfo stunTimer = typeof(HealthAndStamina).GetField("stunTimer", Instance);

	// PunchAndGrab's per-hand punch timers: wind-up to 0.2 s, strike to 0.4 s, done at 0.6 s.
	public static readonly FieldInfo leftPunchTimer = typeof(PunchAndGrab).GetField("leftTimer", Instance);

	public static readonly FieldInfo rightPunchTimer = typeof(PunchAndGrab).GetField("rightTimer", Instance);

	// AudioTimeScale writes its own value to Time.timeScale every frame.
	public static readonly FieldInfo audioTimeScale = typeof(AudioTimeScale).GetField("timeScale", Instance);

	public static List<string> Missing()
	{
		List<string> missing = new List<string>();
		if (maxHealth == null)
		{
			missing.Add("HealthAndStamina.maxHealth");
		}
		if (stunTimer == null)
		{
			missing.Add("HealthAndStamina.stunTimer");
		}
		if (leftPunchTimer == null)
		{
			missing.Add("PunchAndGrab.leftTimer");
		}
		if (rightPunchTimer == null)
		{
			missing.Add("PunchAndGrab.rightTimer");
		}
		if (audioTimeScale == null)
		{
			missing.Add("AudioTimeScale.timeScale");
		}
		return missing;
	}

	// The beast's starting health, or its current health before HealthAndStamina.Start has run.
	public static float MaxHealth(HealthAndStamina stats)
	{
		float max = maxHealth != null ? (float)maxHealth.GetValue(stats) : 0f;
		return max > 0f ? max : stats.health;
	}

	public static void SetMaxHealth(HealthAndStamina stats, float value)
	{
		if (maxHealth != null)
		{
			maxHealth.SetValue(stats, value);
		}
	}

	public static float StunTimer(HealthAndStamina stats)
	{
		return stunTimer != null ? (float)stunTimer.GetValue(stats) : 0f;
	}

	public static void SetStunTimer(HealthAndStamina stats, float value)
	{
		if (stunTimer != null)
		{
			stunTimer.SetValue(stats, value);
		}
	}

	public static float PunchTimer(PunchAndGrab punch, bool left)
	{
		FieldInfo field = left ? leftPunchTimer : rightPunchTimer;
		return field != null ? (float)field.GetValue(punch) : 0f;
	}

	public static void SetPunchTimer(PunchAndGrab punch, bool left, float value)
	{
		FieldInfo field = left ? leftPunchTimer : rightPunchTimer;
		if (field != null)
		{
			field.SetValue(punch, value);
		}
	}
}
