using System;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

// Which serialized fields of the beast components are level settings (copied when a beast is rebuilt
// from the template, so the copy plays like the original) and which are live state (left as the
// template's reset values). Every Unity-serialized field must be in exactly one list; the core tests
// check that, so a field the game adds or renames cannot be missed silently.
public static class DevFields
{
	public static readonly Dictionary<Type, string[]> settings = new Dictionary<Type, string[]>();

	public static readonly Dictionary<Type, string[]> live = new Dictionary<Type, string[]>();

	static DevFields()
	{
		settings[typeof(Player)] = new string[] { "player", "gangName", "actorColor", "force", "mob" };
		live[typeof(Player)] = new string[] { "direction", "jumpReset", "canJump", "onGround", "fallTimer", "groundTimer", "leftHandTimer", "leftGrab",
			"leftPunch", "leftLift", "leftInputDown", "rightHandTimer", "rightGrab", "rightPunch", "rightLift", "rightInputDown", "taunt", "duck",
			"applyedForce", "punchRetriggerDelay", "agent", "target", "targetInRange", "leftLegOnGround", "rightLegOnGround", "ballOnGround",
			"grabNotMoveableLeft", "grabNotMoveableRight", "climb", "state" };
		settings[typeof(HealthAndStamina)] = new string[] { "health", "healthRegenerationSpeed", "maxStunTime", "stunThreshold", "canDie",
			"hurtSound", "stunSound", "deathSound", "punchSound" };
		live[typeof(HealthAndStamina)] = new string[] { "stamina", "dead", "runOnce", "stunRetriggerDelay", "blink" };
		settings[typeof(Movement)] = new string[] { "movementSpeed", "animationSpeed" };
		live[typeof(Movement)] = new string[] { "leftLimbPosition", "rightLimbPosition" };
		settings[typeof(Jump)] = new string[] { "jumpStrength", "fallTime", "airSpeed" };
		live[typeof(Jump)] = new string[] { "currentJumpStrength", "jumpTimer" };
		settings[typeof(PunchAndGrab)] = new string[] { "useStamina", "liftForce" };
		live[typeof(PunchAndGrab)] = new string[0];
		settings[typeof(Targeting)] = new string[] { "fov" };
		live[typeof(Targeting)] = new string[] { "targetsInSphere", "punchTarget", "grabTarget" };
	}

	// Unity serializes public instance fields (and [SerializeField] private ones) of these kinds.
	public static List<FieldInfo> SerializedFields(Type type)
	{
		List<FieldInfo> fields = new List<FieldInfo>();
		for (Type t = type; t != null && t != typeof(MonoBehaviour); t = t.BaseType)
		{
			foreach (FieldInfo f in t.GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.DeclaredOnly))
			{
				bool serialized = f.IsPublic ? !f.IsNotSerialized : f.GetCustomAttributes(typeof(SerializeField), true).Length > 0;
				if (serialized && Serializable(f.FieldType))
				{
					fields.Add(f);
				}
			}
		}
		return fields;
	}

	private static bool Serializable(Type t)
	{
		if (t.IsArray)
		{
			return t.GetArrayRank() == 1 && Serializable(t.GetElementType());
		}
		if (t.IsGenericType)
		{
			return t.GetGenericTypeDefinition() == typeof(List<>) && Serializable(t.GetGenericArguments()[0]);
		}
		return t.IsPrimitive || t.IsEnum || t == typeof(string) || typeof(UnityEngine.Object).IsAssignableFrom(t) || t == typeof(Vector2) || t == typeof(Vector3)
			|| t == typeof(Vector4) || t == typeof(Quaternion) || t == typeof(Color) || t == typeof(Rect) || t == typeof(AnimationCurve) || t == typeof(Bounds);
	}

	// Copies the settings fields from one beast's component to another's of the same type.
	public static void CopySettings(Component from, Component to)
	{
		string[] names;
		if (from == null || to == null || !settings.TryGetValue(from.GetType(), out names))
		{
			return;
		}
		foreach (string name in names)
		{
			FieldInfo f = from.GetType().GetField(name, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
			if (f != null)
			{
				f.SetValue(to, f.GetValue(from));
			}
		}
	}

	// Fields of the listed types that are in neither list (should be empty).
	public static List<string> Unclassified()
	{
		List<string> missing = new List<string>();
		foreach (KeyValuePair<Type, string[]> entry in settings)
		{
			List<string> known = new List<string>(entry.Value);
			known.AddRange(live[entry.Key]);
			foreach (FieldInfo f in SerializedFields(entry.Key))
			{
				if (!known.Contains(f.Name))
				{
					missing.Add(entry.Key.Name + "." + f.Name);
				}
			}
			foreach (string name in known)
			{
				if (entry.Key.GetField(name, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic) == null)
				{
					missing.Add(entry.Key.Name + "." + name + " (no such field)");
				}
			}
		}
		return missing;
	}
}
