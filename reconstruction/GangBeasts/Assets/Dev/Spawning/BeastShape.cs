using UnityEngine;

// A body shape as data (see Generated/BeastShapes.cs): the root's scale, bone local positions and scales,
// chest capsules, part masses and drags, and stats that come with the shape. Applied to an inactive
// copy whose parts are back in their original hierarchy, so the local values mean what they mean in a
// scene file. -1 means "keep the copy's value".
public class BeastShape
{
	public class Bone
	{
		public readonly string path;

		public readonly Vector3 localPosition;

		public readonly Vector3 localScale;

		public Bone(string path, Vector3 localPosition, Vector3 localScale)
		{
			this.path = path;
			this.localPosition = localPosition;
			this.localScale = localScale;
		}
	}

	public class Capsule
	{
		public readonly string path;

		public readonly float radius;

		public readonly float height;

		public readonly int direction;

		public readonly Vector3 center;

		public Capsule(string path, float radius, float height, int direction, Vector3 center)
		{
			this.path = path;
			this.radius = radius;
			this.height = height;
			this.direction = direction;
			this.center = center;
		}
	}

	public class Body
	{
		public readonly string path;

		public readonly float mass;

		public readonly float drag;

		public Body(string path, float mass, float drag)
		{
			this.path = path;
			this.mass = mass;
			this.drag = drag;
		}
	}

	public readonly float rootScale;

	public readonly Bone[] bones;

	public readonly Capsule[] capsules;

	public readonly Body[] bodies;

	public readonly float health;

	public readonly float stunThreshold;

	public readonly float movementSpeed;

	public readonly float animationSpeed;

	public BeastShape(float rootScale, Bone[] bones, Capsule[] capsules, Body[] bodies, float health, float stunThreshold, float movementSpeed, float animationSpeed)
	{
		this.rootScale = rootScale;
		this.bones = bones;
		this.capsules = capsules;
		this.bodies = bodies;
		this.health = health;
		this.stunThreshold = stunThreshold;
		this.movementSpeed = movementSpeed;
		this.animationSpeed = animationSpeed;
	}

	public static BeastShape Of(BeastBody body)
	{
		switch (body)
		{
		case BeastBody.Boss003:
			return BeastShapes.Boss003;
		case BeastBody.Boss002:
			return BeastShapes.Boss002;
		}
		return null;
	}

	// The shape's body (bones, colliders, masses) on an inactive copy in its original hierarchy.
	public void ApplyBody(GameObject beast)
	{
		Transform root = beast.transform;
		root.localScale = Vector3.one * rootScale;
		foreach (Bone bone in bones)
		{
			Transform t = root.Find(bone.path);
			if (t != null)
			{
				t.localPosition = bone.localPosition;
				t.localScale = bone.localScale;
			}
		}
		// Capsules come per part, in component order; a part with a different count is rebuilt.
		string done = "";
		foreach (Capsule c in capsules)
		{
			if (done.Contains("|" + c.path + "|"))
			{
				continue;
			}
			done += "|" + c.path + "|";
			ApplyCapsules(root.Find(c.path), c.path);
		}
		foreach (Body b in bodies)
		{
			Transform t = root.Find(b.path);
			if (t == null || t.rigidbody == null)
			{
				continue;
			}
			if (b.mass >= 0f)
			{
				t.rigidbody.mass = b.mass;
			}
			if (b.drag >= 0f)
			{
				t.rigidbody.drag = b.drag;
			}
		}
	}

	private void ApplyCapsules(Transform part, string path)
	{
		if (part == null)
		{
			return;
		}
		int wanted = 0;
		foreach (Capsule c in capsules)
		{
			if (c.path == path)
			{
				wanted++;
			}
		}
		CapsuleCollider[] existing = part.GetComponents<CapsuleCollider>();
		if (existing.Length != wanted)
		{
			PhysicMaterial material = existing.Length > 0 ? existing[0].sharedMaterial : null;
			foreach (CapsuleCollider old in existing)
			{
				Object.DestroyImmediate(old);
			}
			existing = new CapsuleCollider[wanted];
			for (int i = 0; i < wanted; i++)
			{
				existing[i] = part.gameObject.AddComponent<CapsuleCollider>();
				existing[i].sharedMaterial = material;
			}
		}
		int k = 0;
		foreach (Capsule c in capsules)
		{
			if (c.path != path)
			{
				continue;
			}
			existing[k].radius = c.radius;
			existing[k].height = c.height;
			existing[k].direction = c.direction;
			existing[k].center = c.center;
			k++;
		}
	}

	// The stats that come with the shape (the boss's health, stun threshold and gait).
	public void ApplyStats(GameObject beast)
	{
		HealthAndStamina stats = beast.GetComponent<HealthAndStamina>();
		if (stats != null && health >= 0f)
		{
			stats.health = health;
		}
		if (stats != null && stunThreshold >= 0f)
		{
			stats.stunThreshold = stunThreshold;
		}
		Movement movement = beast.GetComponent<Movement>();
		if (movement != null && movementSpeed >= 0f)
		{
			movement.movementSpeed = movementSpeed;
		}
		if (movement != null && animationSpeed >= 0f)
		{
			movement.animationSpeed = animationSpeed;
		}
	}
}
