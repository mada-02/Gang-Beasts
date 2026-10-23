using System.Collections.Generic;
using UnityEngine;

public delegate void BeastEvent(Beast beast);

public delegate void BeastReplacedEvent(Beast old, Beast replacement);

// Every live beast in the level, so modules never scan the scene themselves. Beasts made by the level
// or the game are found by Sweep (DevRoot runs it after each level load and once a second); beasts the
// developer layer makes register at once. A DevBeast marker reports each one's destruction.
public static class BeastRegistry
{
	private static readonly List<Beast> all = new List<Beast>();

	private static readonly Dictionary<Player, Beast> byPlayer = new Dictionary<Player, Beast>();

	private static int nextId = 1;

	public static event BeastEvent Added;

	public static event BeastEvent Removed;

	public static event BeastReplacedEvent Replaced;

	// Live beasts, in registration order. Do not modify; may include a beast destroyed this frame.
	public static List<Beast> All
	{
		get { return all; }
	}

	public static void LevelLoaded()
	{
		all.Clear();
		byPlayer.Clear();
	}

	public static Beast Find(Player player)
	{
		Beast beast;
		return player != null && byPlayer.TryGetValue(player, out beast) ? beast : null;
	}

	// Registers a beast (once). Only beasts that have run Player.Awake (their part table is filled).
	public static Beast Register(Player player)
	{
		Beast beast = Find(player);
		if (beast != null || player == null || !player.part.ContainsKey("chest"))
		{
			return beast;
		}
		beast = new Beast(nextId++, player);
		// A level beast scaled exactly like Street's pink boss is that boss.
		if (Mathf.Abs(beast.size - BeastShapes.Boss003.rootScale) < 1e-4f)
		{
			beast.body = BeastBody.Boss003;
		}
		else if (Mathf.Abs(beast.size - BeastShapes.Boss002.rootScale) < 1e-4f)
		{
			beast.body = BeastBody.Boss002;
		}
		DevBeast marker = player.GetComponent<DevBeast>();
		if (marker == null)
		{
			marker = player.gameObject.AddComponent<DevBeast>();
		}
		marker.beast = beast;
		all.Add(beast);
		byPlayer[player] = beast;
		if (Added != null)
		{
			Added(beast);
		}
		return beast;
	}

	// Registers beasts made by the level or by game code; drops any destroyed without notice.
	public static void Sweep()
	{
		for (int i = all.Count - 1; i >= 0; i--)
		{
			if (all[i].player == null)
			{
				Drop(all[i]);
			}
		}
		foreach (Object o in Object.FindObjectsOfType(typeof(Player)))
		{
			Register((Player)o);
		}
	}

	internal static void Forget(DevBeast marker)
	{
		if (marker.beast != null && all.Contains(marker.beast))
		{
			Drop(marker.beast);
		}
	}

	private static void Drop(Beast beast)
	{
		all.Remove(beast);
		if ((object)beast.player != null)
		{
			byPlayer.Remove(beast.player);
		}
		if (Removed != null)
		{
			Removed(beast);
		}
	}

	public static Beast Human(int slot)
	{
		foreach (Beast b in all)
		{
			if (b.player != null && !b.player.mob && b.player.player == slot && b.player.state != Player.State.Dead)
			{
				return b;
			}
		}
		return null;
	}

	// Tells every module that replacement now stands for old, then destroys old safely.
	public static void Replace(Beast old, Beast replacement)
	{
		if (Replaced != null)
		{
			Replaced(old, replacement);
		}
		SafeDestroy(old);
	}

	// Destroys a beast without leaving anything holding on to it: other beasts' grab joints on its parts
	// are removed, and every Targeting list forgets its parts.
	public static void SafeDestroy(Beast beast)
	{
		if (beast == null || beast.player == null)
		{
			return;
		}
		Transform root = beast.player.transform;
		ReleaseHoldsOn(root);
		Drop(beast);
		Object.Destroy(beast.gameObject);
	}

	// Same for a prop (any object other beasts may be holding).
	public static void SafeDestroyObject(GameObject go)
	{
		if (go == null)
		{
			return;
		}
		ReleaseHoldsOn(go.transform);
		Object.Destroy(go);
	}

	// Removes grab joints on other beasts' hands that hold anything under root, and purges root's
	// parts from every Targeting list (a destroyed collider never reports leaving the trigger).
	public static void ReleaseHoldsOn(Transform root)
	{
		foreach (Beast other in all)
		{
			if (other.player == null || other.player.transform == root)
			{
				continue;
			}
			ReleaseHand(other.Part("leftHand"), root);
			ReleaseHand(other.Part("rightHand"), root);
			if (other.targeting != null && other.targeting.targetsInSphere != null)
			{
				other.targeting.targetsInSphere.RemoveAll(g => g == null || g.transform.IsChildOf(root));
				if (other.targeting.punchTarget != null && other.targeting.punchTarget.transform.IsChildOf(root))
				{
					other.targeting.punchTarget = null;
				}
				if (other.targeting.grabTarget != null && other.targeting.grabTarget.transform.IsChildOf(root))
				{
					other.targeting.grabTarget = null;
				}
			}
		}
	}

	private static void ReleaseHand(Transform hand, Transform root)
	{
		if (hand == null)
		{
			return;
		}
		foreach (HingeJoint joint in hand.GetComponents<HingeJoint>())
		{
			if (joint.connectedBody != null && joint.connectedBody.transform.IsChildOf(root))
			{
				Object.DestroyImmediate(joint);
			}
		}
	}
}
