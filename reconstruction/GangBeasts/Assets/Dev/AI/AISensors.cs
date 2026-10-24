using System.Collections.Generic;
using UnityEngine;

// What the AI asks of the level, cheaply: line of sight and "is there a drop here". The reference
// (DevGround) uses RaycastAll, which allocates an array per ray; this project's raycasts also hit
// triggers (every beast carries a 1.5 m targetFinder trigger) and Unity 4.3 has no switch for that in 3D.
// Here: single raycasts that skip beast layers and step past triggers (noting kill zones on the way),
// with results cached briefly (not over moving ground). The AI tests hold it to DevGround's answers.
public static class AISensors
{
	// Beasts don't block (their parts are skipped like triggers). Not by layer: Sandbox's cubes and truck and
	// Grind's grinder teeth sit on the beasts' layers 8 and 9.
	private static readonly Dictionary<int, bool> beastCollider = new Dictionary<int, bool>();

	private struct Cached
	{
		public bool value;

		public float time;
	}

	private static readonly Dictionary<long, Cached> sight = new Dictionary<long, Cached>();

	private static readonly Dictionary<long, Cached> drops = new Dictionary<long, Cached>();

	public static int raysThisFrame;

	private static int rayFrame = -1;

	public static void LevelLoaded()
	{
		sight.Clear();
		drops.Clear();
		beastCollider.Clear();
	}

	private static bool OnBeast(Collider c)
	{
		bool value;
		int id = c.GetInstanceID();
		if (!beastCollider.TryGetValue(id, out value))
		{
			value = c.transform.root.GetComponent<Player>() != null;
			beastCollider[id] = value;
		}
		return value;
	}

	// The first solid hit along the ray, stepping past triggers (a ray starting inside a collider does not
	// hit it, so each trigger is crossed once); killZone: a KillZone trigger was crossed before it.
	private static bool Ray(Vector3 from, Vector3 direction, float distance, out RaycastHit hit, out bool killZone)
	{
		return Ray(from, direction, distance, -1, out hit, out killZone);
	}

	// Sight lines leave out layers 8 and 9 (beast parts and balls) so a line across a crowd is not stepped
	// part by part; the cost is that Grind's grinder teeth (also layer 9) do not block sight.
	private const int SightMask = ~((1 << 8) | (1 << 9));

	private static bool Ray(Vector3 from, Vector3 direction, float distance, int mask, out RaycastHit hit, out bool killZone)
	{
		if (rayFrame != Time.frameCount)
		{
			rayFrame = Time.frameCount;
			raysThisFrame = 0;
		}
		killZone = false;
		float left = distance;
		for (int step = 0; step < 24; step++)
		{
			raysThisFrame++;
			if (!Physics.Raycast(from, direction, out hit, left, mask))
			{
				return false;
			}
			if (!hit.collider.isTrigger && !OnBeast(hit.collider))
			{
				return true;
			}
			if (hit.collider.GetComponent<KillZone>() != null)
			{
				killZone = true;
			}
			// Step just past where it was entered (a ray starting inside a collider does not hit it: see
			// diag/ray_from_inside).
			float advance = hit.distance + 0.01f;
			left -= advance;
			from += direction * advance;
			if (left <= 0f)
			{
				return false;
			}
		}
		hit = new RaycastHit();
		return false;
	}

	// Same answer as DevGround.Drop: no solid ground within depth below a ground-level point, a kill zone
	// on the way down to it, or spinning machinery underfoot.
	public static bool Drop(Vector3 point, float depth)
	{
		long key = (((long)Mathf.RoundToInt(point.x * 4f)) << 40) ^ (((long)Mathf.RoundToInt(point.z * 4f) & 0xFFFFF) << 20) ^ ((long)Mathf.RoundToInt(point.y * 4f) & 0xFFFFF) ^ ((long)(depth * 4f) << 60);
		Cached c;
		if (drops.TryGetValue(key, out c) && Time.time - c.time < 0.5f && Time.time >= c.time)
		{
			return c.value;
		}
		RaycastHit hit;
		bool killZone;
		bool value;
		bool cacheable = true;
		if (!Ray(point + Vector3.up, Vector3.down, depth + 1f, out hit, out killZone))
		{
			value = true;
		}
		else if (killZone || hit.collider.GetComponent<KillZone>() != null)
		{
			// (Street's kill zone under the road is a solid box, not a trigger.)
			value = true;
		}
		else if (hit.rigidbody != null)
		{
			value = hit.rigidbody.angularVelocity.sqrMagnitude > 1f;
			cacheable = false;
		}
		else
		{
			value = false;
		}
		if (cacheable)
		{
			c.value = value;
			c.time = Time.time;
			drops[key] = c;
		}
		return value;
	}

	// Nothing solid between two points (beasts don't block).
	public static bool CanSee(Vector3 eye, Vector3 point)
	{
		Vector3 to = point - eye;
		float distance = to.magnitude;
		if (distance < 1e-4f)
		{
			return true;
		}
		RaycastHit hit;
		bool killZone;
		return !Ray(eye, to / distance, distance, SightMask, out hit, out killZone);
	}

	// Cached per observer and target for 0.5 s.
	public static bool CanSee(int observer, int target, Vector3 eye, Vector3 point)
	{
		long key = ((long)observer << 32) ^ (uint)target;
		Cached c;
		if (sight.TryGetValue(key, out c) && Time.time - c.time < 0.5f && Time.time >= c.time)
		{
			return c.value;
		}
		c.value = CanSee(eye, point);
		c.time = Time.time;
		sight[key] = c;
		return c.value;
	}

	// A steep solid surface (not a walkable slope) within distance.
	public static bool Wall(Vector3 from, Vector3 direction, float distance)
	{
		RaycastHit hit;
		bool killZone;
		return Ray(from, direction, distance, out hit, out killZone) && hit.normal.y < 0.5f;
	}

	// Something knee-high ahead with room above it: worth jumping onto or over.
	public static bool LowObstacle(Vector3 feet, Vector3 direction)
	{
		return Wall(feet + Vector3.up * 0.3f, direction, 0.6f) && !Wall(feet + Vector3.up * 1.4f, direction, 0.9f);
	}
}
