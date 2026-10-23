using UnityEngine;

// Is there footing here? The reference implementation (from the additional branch's brain and spawner),
// kept simple and allocation-happy on purpose: the AI's cached, budgeted sensors are tested against it.
public static class DevGround
{
	// Level geometry: not a trigger and not part of any beast.
	public static bool Solid(Collider c)
	{
		return !c.isTrigger && c.transform.root.GetComponent<Player>() == null;
	}

	// No solid ground within depth below a ground-level point, or a kill zone before it, or spinning
	// machinery (Grind's grinders), which is no footing: it drags beasts down into it.
	public static bool Drop(Vector3 point, float depth)
	{
		RaycastHit[] hits = Physics.RaycastAll(point + Vector3.up, Vector3.down, depth + 1f);
		System.Array.Sort(hits, (a, b) => a.distance.CompareTo(b.distance));
		foreach (RaycastHit hit in hits)
		{
			if (hit.collider.GetComponent<KillZone>() != null)
			{
				return true;
			}
			if (Solid(hit.collider))
			{
				return hit.rigidbody != null && hit.rigidbody.angularVelocity.sqrMagnitude > 1f;
			}
		}
		return true;
	}

	// Footing a beast can stand on: no kill zone above or below, ground under the point and all round
	// it (not right at an edge).
	public static bool Safe(Vector3 point)
	{
		foreach (RaycastHit hit in Physics.RaycastAll(point + Vector3.up * 3f, Vector3.down, 3.5f))
		{
			if (hit.collider.GetComponent<KillZone>() != null)
			{
				return false;
			}
		}
		if (Drop(point, 2f))
		{
			return false;
		}
		for (int i = 0; i < 4; i++)
		{
			if (Drop(point + Quaternion.AngleAxis(i * 90f, Vector3.up) * Vector3.forward * 0.7f, 2f))
			{
				return false;
			}
		}
		return true;
	}

	// Room for a standing beast of this size at ground: no solid level geometry inside its body (beasts
	// are kept apart by spot spacing). Ground alone is not enough: in Gondola, beasts placed with a
	// ProBuilder block through their body were thrown out of it at 55-70 m/s.
	public static bool BodyClear(Vector3 ground, float size)
	{
		foreach (float height in new float[] { 0.35f, 0.8f, 1.25f })
		{
			foreach (Collider c in Physics.OverlapSphere(ground + Vector3.up * height * size, 0.3f * size))
			{
				if (Solid(c))
				{
					return false;
				}
			}
		}
		return true;
	}

	// Safe ground near point: on the NavMesh, else straight below.
	public static bool Snap(Vector3 point, float reach, out Vector3 ground)
	{
		NavMeshHit navHit;
		if (NavMesh.SamplePosition(point, out navHit, reach, -1) && Safe(navHit.position))
		{
			ground = navHit.position;
			return true;
		}
		RaycastHit hit;
		if (Physics.Raycast(point + Vector3.up * 2f, Vector3.down, out hit, 6f) && Solid(hit.collider) && Safe(hit.point))
		{
			ground = hit.point;
			return true;
		}
		ground = point;
		return false;
	}

	// Where the camera looks (the first solid surface on the centre ray), or 10 m ahead.
	public static Vector3 ScreenCentre()
	{
		Camera camera = Camera.main;
		if (camera == null)
		{
			return Vector3.up * 2f;
		}
		Ray ray = camera.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f));
		float nearest = float.PositiveInfinity;
		Vector3 point = ray.origin + ray.direction * 10f;
		foreach (RaycastHit hit in Physics.RaycastAll(ray, 300f))
		{
			if (!hit.collider.isTrigger && hit.distance < nearest)
			{
				nearest = hit.distance;
				point = hit.point + hit.normal * 0.25f;
			}
		}
		return point;
	}
}
