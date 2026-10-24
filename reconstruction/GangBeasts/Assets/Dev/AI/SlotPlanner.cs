using System.Collections.Generic;
using UnityEngine;

// Where the attackers on one enemy stand. The engaged ones spread round it in bearing order (nobody
// crosses anybody) within an arc of at most 155 degrees centred on where they come from: no two stand
// within 25 degrees of straight across from each other, where a missed punch's lunge lands on the
// teammate. The queued ones wait further out, behind that arc.
public static class SlotPlanner
{
	public const float MaxArc = 155f;

	public const float PreferredGap = 55f;

	public static float Ring(float enemySize, float attackerSize)
	{
		return 0.6f * (enemySize + attackerSize);
	}

	public static float QueueRing(float enemySize)
	{
		return 2.8f + 0.6f * (enemySize - 1f);
	}

	private static float Bearing(Vector3 from, Vector3 to)
	{
		Vector3 d = to - from;
		return Mathf.Atan2(d.x, d.z) * Mathf.Rad2Deg;
	}

	// For each attacker (positions), the bearing of its spot round the enemy, in degrees; engaged ones
	// first share the arc, queued ones share the band behind it.
	public static void Plan(Vector3 enemy, List<Vector3> attackers, List<int> order, float[] bearings)
	{
		int k = attackers.Count;
		if (k == 0)
		{
			return;
		}
		// Mean bearing of where they come from.
		Vector2 sum = Vector2.zero;
		for (int i = 0; i < k; i++)
		{
			float b = Bearing(enemy, attackers[i]) * Mathf.Deg2Rad;
			sum += new Vector2(Mathf.Sin(b), Mathf.Cos(b));
		}
		float centre = sum.sqrMagnitude > 1e-6f ? Mathf.Atan2(sum.x, sum.y) * Mathf.Rad2Deg : Bearing(enemy, attackers[0]);
		// Sort by bearing relative to the centre, ties on index (stable, deterministic).
		order.Clear();
		for (int i = 0; i < k; i++)
		{
			order.Add(i);
		}
		order.Sort((a, b) =>
		{
			int c = Mathf.DeltaAngle(centre, Bearing(enemy, attackers[a])).CompareTo(Mathf.DeltaAngle(centre, Bearing(enemy, attackers[b])));
			return c != 0 ? c : a.CompareTo(b);
		});
		float arc = k > 1 ? Mathf.Min(MaxArc, (k - 1) * PreferredGap) : 0f;
		for (int s = 0; s < k; s++)
		{
			float offset = k > 1 ? -arc * 0.5f + arc * s / (k - 1) : 0f;
			bearings[order[s]] = centre + offset;
		}
	}

	public static Vector3 Spot(Vector3 enemy, float bearing, float radius)
	{
		float b = bearing * Mathf.Deg2Rad;
		return enemy + new Vector3(Mathf.Sin(b), 0f, Mathf.Cos(b)) * radius;
	}
}
