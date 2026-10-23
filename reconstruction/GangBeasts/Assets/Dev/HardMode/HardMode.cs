using System.Collections.Generic;
using UnityEngine;

// Hard Mode: 0.0.2's physics and combat on 0.0.3, rebuilt from the 0.0.2 build itself (dev/hardmode/:
// code_diff.md for the behaviour code, spec.json for the data; Generated/HardModeData.cs and
// HitboxMeshes.cs come from them). On every beast it
// - sets 0.0.2's values of every rigidbody, joint and script setting that differs: physics by body (the
//   normal rig, or the pink boss's), settings by role (the level's humans, mobs or boss; a level or class
//   0.0.2 did not have gets only the values every 0.0.2 level shares);
// - swaps in 0.0.2's convex hitboxes and collision-ignore pairs;
// - runs 0.0.2's own Movement, Jump, PunchAndGrab and CollisionEvent instead of 0.0.3's, and with
//   HardPlayerPre/Post 0.0.2's Player.Update rules (limp at once when stunned, recover at force/8 per
//   second, never Falling, hand tags kept when stunned);
// - gives pink bosses 0.0.2's body (a rebuild).
// Everything it changes is saved per beast and put back exactly when it is switched off.
public static class HardMode
{
	public static bool on;

	private class Pose
	{
		public Quaternion rotation;

		public Vector3 position;
	}

	private class SavedCollider
	{
		public System.Type type;

		public Vector3 center;

		public float radius;

		public float height;

		public int direction;

		public Vector3 size;

		public PhysicMaterial material;
	}

	private class State
	{
		public readonly Dictionary<string, float> physics = new Dictionary<string, float>();

		public readonly Dictionary<string, float> stats = new Dictionary<string, float>();

		public float healthShare = 1f;

		public readonly Dictionary<Transform, List<SavedCollider>> colliders = new Dictionary<Transform, List<SavedCollider>>();

		public readonly Dictionary<Transform, AudioClip[][]> collisionEvents = new Dictionary<Transform, AudioClip[][]>();
	}

	// Body stats come with the pink boss's body, even on a player morphed into it.
	private static readonly string[] bodyStats = { "HealthAndStamina.health", "HealthAndStamina.stunThreshold", "Movement.movementSpeed", "Movement.animationSpeed", "Player.force" };

	private static readonly Dictionary<Beast, State> states = new Dictionary<Beast, State>();

	// Each beast's jointed parts relative to what they hang on, as they stood when it was registered (its
	// rest pose: level beasts before the first physics step, spawned ones before they are switched on).
	private static readonly Dictionary<Beast, Dictionary<Transform, Pose>> rest = new Dictionary<Beast, Dictionary<Transform, Pose>>();

	private static readonly Dictionary<string, Mesh> meshes = new Dictionary<string, Mesh>();

	private static bool initialised;

	public static void Init()
	{
		if (initialised)
		{
			return;
		}
		initialised = true;
		BeastRegistry.Added += OnAdded;
		BeastRegistry.Removed += b =>
		{
			states.Remove(b);
			rest.Remove(b);
		};
		DevRoot.LevelStarting += () =>
		{
			states.Clear();
			rest.Clear();
		};
		DevRoot.LevelReady += OnLevelReady;
		DevMenu.worldSections.Add(DrawSection);
	}

	public static bool IsHard(Beast beast)
	{
		return states.ContainsKey(beast);
	}

	public static IEnumerable<Beast> HardBeasts
	{
		get { return states.Keys; }
	}

	private static void OnAdded(Beast beast)
	{
		CaptureRest(beast);
		if (!on)
		{
			return;
		}
		// A 0.0.3 pink boss gets 0.0.2's body first (LevelReady or Set does it); it is applied when the
		// rebuilt one is added.
		if (beast.body == BeastBody.Boss003)
		{
			return;
		}
		Apply(beast);
	}

	private static void OnLevelReady()
	{
		if (on)
		{
			RebuildBosses(BeastBody.Boss003, BeastBody.Boss002);
		}
	}

	public static void Set(bool value)
	{
		if (value == on)
		{
			return;
		}
		if (value)
		{
			// Rebuild 0.0.3 bosses while still off (their 0.0.3 values are what gets saved), then apply all.
			RebuildBosses(BeastBody.Boss003, BeastBody.Boss002);
			on = true;
			foreach (Beast b in new List<Beast>(BeastRegistry.All))
			{
				if (b.player != null && !states.ContainsKey(b))
				{
					Apply(b);
				}
			}
			return;
		}
		foreach (Beast b in new List<Beast>(states.Keys))
		{
			Restore(b);
		}
		on = false;
		RebuildBosses(BeastBody.Boss002, BeastBody.Boss003);
	}

	private static void RebuildBosses(BeastBody from, BeastBody to)
	{
		foreach (Beast b in new List<Beast>(BeastRegistry.All))
		{
			if (b.player != null && b.body == from)
			{
				BeastFactory.Rebuild(b, to, false);
			}
		}
	}

	private static HardModeData.ClassData Data(string level, string cls)
	{
		foreach (HardModeData.ClassData c in HardModeData.classes)
		{
			if (c.level == level && c.cls == cls)
			{
				return c;
			}
		}
		foreach (HardModeData.ClassData c in HardModeData.classes)
		{
			if (c.level == "*" && c.cls == cls)
			{
				return c;
			}
		}
		return null;
	}

	private static HardModeData.ClassData PhysicsData(Beast beast, string level)
	{
		if (beast.body != BeastBody.Normal)
		{
			return Data(level, "boss");
		}
		// One rig for humans and mobs.
		foreach (HardModeData.ClassData c in HardModeData.classes)
		{
			if (c.level == level && (c.cls == "human" || c.cls == "mob"))
			{
				return c;
			}
		}
		return Data("*", "human");
	}

	private static HardModeData.ClassData RoleData(Beast beast, string level)
	{
		if (!beast.player.mob)
		{
			return Data(level, "human");
		}
		return Data(level, beast.body != BeastBody.Normal ? "boss" : "mob");
	}

	private static Transform PartAt(Beast beast, string path)
	{
		string leaf = path.Substring(path.LastIndexOf('/') + 1);
		Transform t = beast.Part(leaf);
		return t != null ? t : beast.player.transform.Find(leaf);
	}

	public static void Apply(Beast beast)
	{
		if (beast.player == null || states.ContainsKey(beast))
		{
			return;
		}
		State state = new State();
		states[beast] = state;
		string level = Application.loadedLevelName;
		HardModeData.ClassData physics = PhysicsData(beast, level);
		if (physics != null)
		{
			foreach (HardModeData.Field f in physics.physics)
			{
				Transform part = PartAt(beast, f.path);
				if (part == null)
				{
					continue;
				}
				state.physics[f.path + "|" + f.key] = GetPhysics(beast, part, f.key);
				SetPhysics(beast, part, f.key, f.v002);
			}
		}
		ApplyStats(beast, state, level);
		SwapHitboxes(beast, state);
		SwapCode(beast, state);
	}

	private static void ApplyStats(Beast beast, State state, string level)
	{
		HardModeData.ClassData role = RoleData(beast, level);
		HardModeData.ClassData body = beast.body != BeastBody.Normal ? Data(level, "boss") : role;
		state.healthShare = beast.stats != null ? Mathf.Clamp01(beast.stats.health / Mathf.Max(1f, beast.MaxHealth)) : 1f;
		foreach (HardModeData.ClassData data in new HardModeData.ClassData[] { role, body })
		{
			if (data == null)
			{
				continue;
			}
			bool bodyPass = data == body && body != role;
			foreach (HardModeData.Field f in data.stats)
			{
				bool isBodyStat = System.Array.IndexOf(bodyStats, f.key) >= 0;
				if ((data == role && body != role && isBodyStat) || (bodyPass && !isBodyStat))
				{
					continue;
				}
				if (!state.stats.ContainsKey(f.key))
				{
					state.stats[f.key] = GetStat(beast, f.key);
				}
				SetStat(beast, f.key, f.v002, state.healthShare);
			}
		}
	}

	public static void Restore(Beast beast)
	{
		State state;
		if (!states.TryGetValue(beast, out state))
		{
			return;
		}
		states.Remove(beast);
		if (beast.player == null)
		{
			return;
		}
		RestoreCode(beast, state);
		RestoreHitboxes(beast, state);
		float share = beast.stats != null ? Mathf.Clamp01(beast.stats.health / Mathf.Max(1f, beast.MaxHealth)) : 1f;
		foreach (KeyValuePair<string, float> s in state.stats)
		{
			SetStat(beast, s.Key, s.Value, share);
		}
		foreach (KeyValuePair<string, float> p in state.physics)
		{
			int bar = p.Key.IndexOf('|');
			Transform part = PartAt(beast, p.Key.Substring(0, bar));
			if (part != null)
			{
				SetPhysics(beast, part, p.Key.Substring(bar + 1), p.Value);
			}
		}
	}

	// ---------------------------------------------------------------------------------- fields

	private static float GetPhysics(Beast beast, Transform part, string key)
	{
		if (key.StartsWith("rb."))
		{
			Rigidbody rb = part.rigidbody;
			switch (key)
			{
			case "rb.m_Mass":
				return rb.mass;
			case "rb.m_Drag":
				return rb.drag;
			case "rb.m_AngularDrag":
				return rb.angularDrag;
			}
		}
		ConfigurableJoint j = part.GetComponent<ConfigurableJoint>();
		switch (key)
		{
		case "j.m_XMotion":
			return (float)j.xMotion;
		case "j.m_YMotion":
			return (float)j.yMotion;
		case "j.m_ZMotion":
			return (float)j.zMotion;
		case "j.m_AngularXMotion":
			return (float)j.angularXMotion;
		case "j.m_AngularYMotion":
			return (float)j.angularYMotion;
		case "j.m_AngularZMotion":
			return (float)j.angularZMotion;
		case "j.m_Anchor.x":
			return j.anchor.x;
		case "j.m_Anchor.y":
			return j.anchor.y;
		case "j.m_Anchor.z":
			return j.anchor.z;
		}
		if (key.StartsWith("j.m_") && key.Contains("Limit."))
		{
			SoftJointLimit limit = GetLimit(j, key);
			switch (key.Substring(key.LastIndexOf('.') + 1))
			{
			case "limit":
				return limit.limit;
			case "bounciness":
				return limit.bounciness;
			case "spring":
				return limit.spring;
			case "damper":
				return limit.damper;
			}
		}
		throw new System.ArgumentException("unknown Hard Mode physics field " + key);
	}

	private static SoftJointLimit GetLimit(ConfigurableJoint j, string key)
	{
		if (key.StartsWith("j.m_LinearLimit"))
		{
			return j.linearLimit;
		}
		if (key.StartsWith("j.m_LowAngularXLimit"))
		{
			return j.lowAngularXLimit;
		}
		if (key.StartsWith("j.m_HighAngularXLimit"))
		{
			return j.highAngularXLimit;
		}
		if (key.StartsWith("j.m_AngularYLimit"))
		{
			return j.angularYLimit;
		}
		return j.angularZLimit;
	}

	private static void SetLimit(ConfigurableJoint j, string key, SoftJointLimit limit)
	{
		if (key.StartsWith("j.m_LinearLimit"))
		{
			j.linearLimit = limit;
		}
		else if (key.StartsWith("j.m_LowAngularXLimit"))
		{
			j.lowAngularXLimit = limit;
		}
		else if (key.StartsWith("j.m_HighAngularXLimit"))
		{
			j.highAngularXLimit = limit;
		}
		else if (key.StartsWith("j.m_AngularYLimit"))
		{
			j.angularYLimit = limit;
		}
		else
		{
			j.angularZLimit = limit;
		}
	}

	private static void SetPhysics(Beast beast, Transform part, string key, float value)
	{
		if (key.StartsWith("rb."))
		{
			Rigidbody rb = part.rigidbody;
			if (key == "rb.m_Mass")
			{
				rb.mass = value;
			}
			else if (key == "rb.m_Drag")
			{
				rb.drag = value;
			}
			else if (key == "rb.m_AngularDrag")
			{
				rb.angularDrag = value;
			}
			return;
		}
		ConfigurableJoint j = part.GetComponent<ConfigurableJoint>();
		if (Mathf.Abs(GetPhysics(beast, part, key) - value) < 1e-9f)
		{
			return;
		}
		// Changing a joint rebuilds it from the parts' current pose: put the part back in its rest pose
		// relative to what it hangs on first, or a wrist locked mid-swing stays bent.
		ToRest(beast, part, j);
		ConfigurableJointMotion motion = (ConfigurableJointMotion)Mathf.RoundToInt(value);
		switch (key)
		{
		case "j.m_XMotion":
			j.xMotion = motion;
			return;
		case "j.m_YMotion":
			j.yMotion = motion;
			return;
		case "j.m_ZMotion":
			j.zMotion = motion;
			return;
		case "j.m_AngularXMotion":
			j.angularXMotion = motion;
			return;
		case "j.m_AngularYMotion":
			j.angularYMotion = motion;
			return;
		case "j.m_AngularZMotion":
			j.angularZMotion = motion;
			return;
		case "j.m_Anchor.x":
			j.anchor = new Vector3(value, j.anchor.y, j.anchor.z);
			return;
		case "j.m_Anchor.y":
			j.anchor = new Vector3(j.anchor.x, value, j.anchor.z);
			return;
		case "j.m_Anchor.z":
			j.anchor = new Vector3(j.anchor.x, j.anchor.y, value);
			return;
		}
		SoftJointLimit limit = GetLimit(j, key);
		switch (key.Substring(key.LastIndexOf('.') + 1))
		{
		case "limit":
			limit.limit = value;
			break;
		case "bounciness":
			limit.bounciness = value;
			break;
		case "spring":
			limit.spring = value;
			break;
		case "damper":
			limit.damper = value;
			break;
		}
		SetLimit(j, key, limit);
	}

	private static void CaptureRest(Beast beast)
	{
		Dictionary<Transform, Pose> poses = new Dictionary<Transform, Pose>();
		foreach (ConfigurableJoint j in beast.gameObject.GetComponentsInChildren<ConfigurableJoint>())
		{
			if (j.connectedBody == null)
			{
				continue;
			}
			Transform parent = j.connectedBody.transform;
			Pose pose = new Pose();
			pose.rotation = Quaternion.Inverse(parent.rotation) * j.transform.rotation;
			pose.position = parent.InverseTransformPoint(j.transform.position);
			poses[j.transform] = pose;
		}
		rest[beast] = poses;
	}

	private static void ToRest(Beast beast, Transform part, ConfigurableJoint j)
	{
		Dictionary<Transform, Pose> poses;
		Pose pose;
		if (j.connectedBody == null || !rest.TryGetValue(beast, out poses) || !poses.TryGetValue(part, out pose))
		{
			return;
		}
		Transform parent = j.connectedBody.transform;
		part.rotation = parent.rotation * pose.rotation;
		part.position = parent.TransformPoint(pose.position);
	}

	private static float GetStat(Beast beast, string key)
	{
		switch (key)
		{
		case "Player.force":
			return beast.player.force;
		case "Movement.movementSpeed":
			return beast.movement.movementSpeed;
		case "Movement.animationSpeed":
			return beast.movement.animationSpeed;
		case "Jump.jumpStrength":
			return beast.jump.jumpStrength;
		case "Jump.fallTime":
			return beast.jump.fallTime;
		case "PunchAndGrab.liftForce":
			return beast.punch.liftForce;
		case "HealthAndStamina.health":
			return beast.MaxHealth;
		case "HealthAndStamina.healthRegenerationSpeed":
			return beast.stats.healthRegenerationSpeed;
		case "HealthAndStamina.maxStunTime":
			return beast.stats.maxStunTime;
		case "HealthAndStamina.stunThreshold":
			return beast.stats.stunThreshold;
		case "HealthAndStamina.canDie":
			return beast.stats.canDie ? 1f : 0f;
		}
		throw new System.ArgumentException("unknown Hard Mode setting " + key);
	}

	private static void SetStat(Beast beast, string key, float value, float healthShare)
	{
		switch (key)
		{
		case "Player.force":
			beast.player.force = value;
			beast.player.applyedForce = Mathf.Min(beast.player.applyedForce, value);
			return;
		case "Movement.movementSpeed":
			beast.movement.movementSpeed = value;
			return;
		case "Movement.animationSpeed":
			beast.movement.animationSpeed = value;
			return;
		case "Jump.jumpStrength":
			beast.jump.jumpStrength = value;
			return;
		case "Jump.fallTime":
			beast.jump.fallTime = value;
			return;
		case "PunchAndGrab.liftForce":
			beast.punch.liftForce = value;
			return;
		case "HealthAndStamina.health":
			// The maximum (HealthAndStamina.Start took the scene's health as it); the share carries over.
			// Before Start has run, health itself is what Start will take.
			if (DevReflection.maxHealth != null && (float)DevReflection.maxHealth.GetValue(beast.stats) > 0f)
			{
				DevReflection.SetMaxHealth(beast.stats, value);
				beast.stats.health = value * healthShare;
			}
			else
			{
				beast.stats.health = value;
			}
			return;
		case "HealthAndStamina.healthRegenerationSpeed":
			beast.stats.healthRegenerationSpeed = value;
			return;
		case "HealthAndStamina.maxStunTime":
			beast.stats.maxStunTime = value;
			return;
		case "HealthAndStamina.stunThreshold":
			beast.stats.stunThreshold = value;
			return;
		case "HealthAndStamina.canDie":
			beast.stats.canDie = value > 0.5f;
			return;
		}
		throw new System.ArgumentException("unknown Hard Mode setting " + key);
	}

	// ---------------------------------------------------------------------------------- hitboxes

	public static Mesh HitboxMesh(string name)
	{
		Mesh mesh;
		if (meshes.TryGetValue(name, out mesh) && mesh != null)
		{
			return mesh;
		}
		int index = System.Array.IndexOf(HitboxMeshes.names, name);
		float[] v = HitboxMeshes.vertices[index];
		Vector3[] vertices = new Vector3[v.Length / 3];
		for (int i = 0; i < vertices.Length; i++)
		{
			vertices[i] = new Vector3(v[3 * i], v[3 * i + 1], v[3 * i + 2]);
		}
		mesh = new Mesh();
		mesh.name = "0.0.2 " + name;
		mesh.vertices = vertices;
		mesh.triangles = HitboxMeshes.triangles[index];
		mesh.RecalculateBounds();
		meshes[name] = mesh;
		return mesh;
	}

	private static void SwapHitboxes(Beast beast, State state)
	{
		Dictionary<string, Collider> made = new Dictionary<string, Collider>();
		for (int i = 0; i < HardModeData.hitboxes.GetLength(0); i++)
		{
			string path = HardModeData.hitboxes[i, 0];
			Transform part = PartAt(beast, path);
			if (part == null)
			{
				continue;
			}
			List<SavedCollider> saved = new List<SavedCollider>();
			PhysicMaterial feet = null;
			foreach (Collider c in part.GetComponents<Collider>())
			{
				if (c.isTrigger)
				{
					continue;
				}
				SavedCollider s = new SavedCollider();
				s.type = c.GetType();
				s.material = c.sharedMaterial;
				if (c.sharedMaterial != null && c.sharedMaterial.name == HardModeData.hitboxes[i, 3])
				{
					feet = c.sharedMaterial;
				}
				CapsuleCollider cap = c as CapsuleCollider;
				SphereCollider sph = c as SphereCollider;
				BoxCollider box = c as BoxCollider;
				if (cap != null)
				{
					s.center = cap.center;
					s.radius = cap.radius;
					s.height = cap.height;
					s.direction = cap.direction;
				}
				else if (sph != null)
				{
					s.center = sph.center;
					s.radius = sph.radius;
				}
				else if (box != null)
				{
					s.center = box.center;
					s.size = box.size;
				}
				saved.Add(s);
				// Removed, not switched off: the game reads part.collider (grabs), which would still find it.
				Object.DestroyImmediate(c);
			}
			state.colliders[part] = saved;
			MeshCollider mesh = part.gameObject.AddComponent<MeshCollider>();
			mesh.sharedMesh = HitboxMesh(HardModeData.hitboxes[i, 1]);
			mesh.convex = true;
			mesh.smoothSphereCollisions = HardModeData.hitboxes[i, 2] == "true";
			mesh.sharedMaterial = HardModeData.hitboxes[i, 3] != null ? feet : null;
			made[part.name] = mesh;
		}
		for (int i = 0; i < HardModeData.ignorePairs.GetLength(0); i++)
		{
			Collider a;
			Collider b;
			if (made.TryGetValue(HardModeData.ignorePairs[i, 0], out a) && made.TryGetValue(HardModeData.ignorePairs[i, 1], out b))
			{
				Physics.IgnoreCollision(a, b);
			}
		}
		ForgetParts(beast);
	}

	private static void RestoreHitboxes(Beast beast, State state)
	{
		foreach (KeyValuePair<Transform, List<SavedCollider>> entry in state.colliders)
		{
			Transform part = entry.Key;
			if (part == null)
			{
				continue;
			}
			foreach (MeshCollider m in part.GetComponents<MeshCollider>())
			{
				if (m.sharedMesh == null || m.sharedMesh.name.StartsWith("0.0.2 "))
				{
					Object.DestroyImmediate(m);
				}
			}
			foreach (SavedCollider s in entry.Value)
			{
				Collider c = (Collider)part.gameObject.AddComponent(s.type);
				CapsuleCollider cap = c as CapsuleCollider;
				SphereCollider sph = c as SphereCollider;
				BoxCollider box = c as BoxCollider;
				if (cap != null)
				{
					cap.center = s.center;
					cap.radius = s.radius;
					cap.height = s.height;
					cap.direction = s.direction;
				}
				else if (sph != null)
				{
					sph.center = s.center;
					sph.radius = s.radius;
				}
				else if (box != null)
				{
					box.center = s.center;
					box.size = s.size;
				}
				c.sharedMaterial = s.material;
			}
		}
		Ignore003(beast.player);
		ForgetParts(beast);
	}

	// The pairs 0.0.3's Player.Awake ignores, for rebuilt colliders.
	private static void Ignore003(Player player)
	{
		CapsuleCollider[] chest = player.part["chest"].GetComponents<CapsuleCollider>();
		CapsuleCollider[] stomach = player.part["stomach"].GetComponents<CapsuleCollider>();
		foreach (CapsuleCollider c in chest)
		{
			foreach (CapsuleCollider s in stomach)
			{
				Physics.IgnoreCollision(c, s);
				Physics.IgnoreCollision(s, player.part["hips"].collider);
				Physics.IgnoreCollision(s, player.part["groin"].collider);
				Physics.IgnoreCollision(s, player.part["leftThigh"].collider);
				Physics.IgnoreCollision(s, player.part["rightThigh"].collider);
			}
			Physics.IgnoreCollision(c, player.part["leftArm"].collider);
			Physics.IgnoreCollision(c, player.part["rightArm"].collider);
			Physics.IgnoreCollision(c, player.part["hips"].collider);
			Physics.IgnoreCollision(c, player.part["groin"].collider);
		}
	}

	// A collider removed inside a Targeting trigger never reports leaving and its replacement reports
	// entering: every list forgets this beast's parts (the new colliders enter again next step).
	private static void ForgetParts(Beast beast)
	{
		Transform root = beast.player.transform;
		foreach (Beast other in BeastRegistry.All)
		{
			if (other.targeting != null && other.targeting.targetsInSphere != null)
			{
				other.targeting.targetsInSphere.RemoveAll(g => g == null || g.transform.IsChildOf(root));
			}
		}
	}

	// ---------------------------------------------------------------------------------- behaviour code

	private static T Ensure<T>(GameObject go) where T : Component
	{
		T c = go.GetComponent<T>();
		return c != null ? c : go.AddComponent<T>();
	}

	private static void SwapCode(Beast beast, State state)
	{
		GameObject go = beast.gameObject;
		Movement002 movement = Ensure<Movement002>(go);
		movement.movementSpeed = beast.movement.movementSpeed;
		movement.animationSpeed = beast.movement.animationSpeed;
		beast.Part("ball").rigidbody.maxAngularVelocity = movement.movementSpeed;
		Jump002 jump = Ensure<Jump002>(go);
		jump.jumpStrength = beast.jump.jumpStrength;
		jump.currentJumpStrength = beast.jump.jumpStrength;
		jump.fallTime = beast.jump.fallTime;
		PunchAndGrab002 punch = Ensure<PunchAndGrab002>(go);
		punch.liftForce = beast.punch.liftForce;
		beast.movement.enabled = false;
		beast.jump.enabled = false;
		beast.punch.enabled = false;
		movement.enabled = true;
		jump.enabled = true;
		punch.enabled = true;
		// Collision messages reach disabled behaviours too, so 0.0.3's CollisionEvent is removed.
		foreach (CollisionEvent e in go.GetComponentsInChildren<CollisionEvent>())
		{
			state.collisionEvents[e.transform] = new AudioClip[][] { e.stepSound, e.punchSound };
			GameObject part = e.gameObject;
			Object.DestroyImmediate(e);
			CollisionEvent002 old = part.AddComponent<CollisionEvent002>();
			old.stepSound = state.collisionEvents[part.transform][0];
			old.punchSound = state.collisionEvents[part.transform][1];
		}
	}

	private static void RestoreCode(Beast beast, State state)
	{
		GameObject go = beast.gameObject;
		foreach (MonoBehaviour b in new MonoBehaviour[] { go.GetComponent<Movement002>(), go.GetComponent<Jump002>(), go.GetComponent<PunchAndGrab002>() })
		{
			if (b != null)
			{
				b.enabled = false;
			}
		}
		beast.movement.enabled = true;
		beast.jump.enabled = true;
		beast.punch.enabled = true;
		foreach (KeyValuePair<Transform, AudioClip[][]> entry in state.collisionEvents)
		{
			if (entry.Key == null)
			{
				continue;
			}
			CollisionEvent002 old = entry.Key.GetComponent<CollisionEvent002>();
			if (old != null)
			{
				Object.DestroyImmediate(old);
			}
			CollisionEvent e = entry.Key.gameObject.AddComponent<CollisionEvent>();
			e.stepSound = entry.Value[0];
			e.punchSound = entry.Value[1];
		}
	}

	// ---------------------------------------------------------------------------------- Player.Update

	private class Before
	{
		public Player.State state;

		public float force;

		public string leftTag;

		public string rightTag;
	}

	private static readonly Dictionary<Beast, Before> before = new Dictionary<Beast, Before>();

	// HardPlayerPre (execution order -50): each Hard Mode beast as it was before Player.Update.
	internal static void PreUpdate()
	{
		before.Clear();
		foreach (Beast b in states.Keys)
		{
			if (b.player == null)
			{
				continue;
			}
			Before x = new Before();
			x.state = b.player.state;
			x.force = b.player.applyedForce;
			x.leftTag = b.Part("leftHand").tag;
			x.rightTag = b.Part("rightHand").tag;
			before[b] = x;
		}
	}

	// HardPlayerPost (+50): 0.0.2's Player.Update where 0.0.3's differs (code_diff.md P1-P4).
	internal static void PostUpdate()
	{
		foreach (KeyValuePair<Beast, Before> entry in before)
		{
			Player p = entry.Key.player;
			Before x = entry.Value;
			if (p == null)
			{
				continue;
			}
			// P3: 0.0.2 never enters Falling.
			if (p.state == Player.State.Falling && x.state != Player.State.Falling)
			{
				p.state = x.state;
			}
			// P1, P2: limp at once when stunned or dead; otherwise recover at force/8 per second.
			if (p.state == Player.State.Dead || p.state == Player.State.Stunned)
			{
				p.applyedForce = 0f;
				// P4: hands keep their tags.
				entry.Key.Part("leftHand").tag = x.leftTag;
				entry.Key.Part("rightHand").tag = x.rightTag;
			}
			else
			{
				p.applyedForce = Mathf.Min(p.force, x.force + Time.deltaTime * (p.force / 8f));
			}
		}
	}

	// ---------------------------------------------------------------------------------- tests

	public static float ReadPhysics(Beast beast, string path, string key)
	{
		return GetPhysics(beast, PartAt(beast, path), key);
	}

	public static float ReadStat(Beast beast, string key)
	{
		return GetStat(beast, key);
	}

	public static HardModeData.ClassData PhysicsFor(Beast beast)
	{
		return PhysicsData(beast, Application.loadedLevelName);
	}

	public static HardModeData.ClassData RoleFor(Beast beast)
	{
		return RoleData(beast, Application.loadedLevelName);
	}

	public static HardModeData.ClassData BossData()
	{
		return Data(Application.loadedLevelName, "boss");
	}

	public static bool IsBodyStat(string key)
	{
		return System.Array.IndexOf(bodyStats, key) >= 0;
	}

	private static void DrawSection()
	{
		bool hard = GUILayout.Toggle(on, "Hard mode (0.0.2 physics and combat)");
		if (hard != on)
		{
			Set(hard);
		}
		if (on)
		{
			GUILayout.Label("0.0.2's movement, jumps, punches, hitboxes, joints, drag and per-level stats; pink bosses get 0.0.2's body.");
		}
	}
}
