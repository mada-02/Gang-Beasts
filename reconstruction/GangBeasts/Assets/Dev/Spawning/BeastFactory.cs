using System.Collections.Generic;
using UnityEngine;

public delegate void BeastConfigure(GameObject inactiveCopy);

// What to spawn: body, side, colour and starting health. Where comes from the caller.
public class SpawnSpec
{
	public BeastBody body = BeastBody.Normal;

	public bool mob = true;

	// Mobs use 4 like the level's own: outside the P1-P4 slots, so they never take a player's lives.
	public int slot = 4;

	public string gang = "DevMenu Mob";

	public bool useColor;

	public Color color;

	// Starting (and maximum) health; below 0: the template's (the level's), or the shape's for a boss.
	public float health = -1f;
}

// Makes beasts. Player.Awake moves every part with a rigidbody straight under the root, so a live beast
// cannot be cloned as it is (the clone's Awake would not find its parts). Right after each level load,
// before any physics step, Capture copies one level beast while it is switched off and puts the copy's
// parts back in their scene hierarchy; every spawn and rebuild instantiates that template.
public static class BeastFactory
{
	public static readonly string[] partPaths =
	{
		"hips",
		"hips/chest", "hips/stomach", "hips/groin", "hips/leftThigh", "hips/rightThigh", "hips/ball",
		"hips/chest/head", "hips/chest/leftArm", "hips/chest/rightArm", "hips/chest/targetFinder",
		"hips/leftThigh/leftLeg", "hips/rightThigh/rightLeg",
		"hips/chest/leftArm/leftForarm", "hips/chest/rightArm/rightForarm",
		"hips/chest/leftArm/leftForarm/leftHand", "hips/chest/rightArm/rightForarm/rightHand"
	};

	private static readonly string[] handPaths = { "hips/chest/leftArm/leftForarm/leftHand", "hips/chest/rightArm/rightForarm/rightHand" };

	private static GameObject template;

	private static string templateSource = "";

	private static float templateHealth = 100f;

	private static bool hasNavMesh;

	private static int spawnCount;

	public static GameObject Template
	{
		get { return template; }
	}

	public static string TemplateSource
	{
		get { return templateSource; }
	}

	// The template's starting health: its source's level value (Street's mobs: 50).
	public static float TemplateHealth
	{
		get { return templateHealth; }
	}

	public static bool HasNavMesh
	{
		get { return hasNavMesh; }
	}

	public static void LevelLoaded()
	{
		template = null;
		templateSource = "";
		templateHealth = 100f;
		hasNavMesh = false;
	}

	// Copies the best beast in the level. Safe only before the beasts have moved (see the class comment);
	// later (Retry) it still works, but the copy keeps the source's live sag.
	public static bool Capture()
	{
		Player source = null;
		foreach (Object o in Object.FindObjectsOfType(typeof(Player)))
		{
			Player p = (Player)o;
			if (p.state == Player.State.Dead || !p.part.ContainsKey("chest"))
			{
				continue;
			}
			if (source == null || TemplateRank(p) > TemplateRank(source))
			{
				source = p;
			}
		}
		if (source == null)
		{
			return false;
		}
		if (template != null)
		{
			Object.Destroy(template);
		}
		GameObject original = source.gameObject;
		bool wasActive = original.activeSelf;
		original.SetActive(false);
		template = (GameObject)Object.Instantiate(original, original.transform.position, original.transform.rotation);
		original.SetActive(wasActive);
		if (wasActive)
		{
			// Switching off reports no trigger exits and switching on re-enters every overlap, so the
			// source's and its neighbours' Targeting lists would hold each part twice.
			BeastRegistry.ReleaseHoldsOn(original.transform);
			foreach (Targeting t in original.GetComponentsInChildren<Targeting>())
			{
				if (t.targetsInSphere != null)
				{
					t.targetsInSphere.Clear();
				}
			}
		}
		template.name = "[Dev] Beast Template";
		templateSource = original.name + (source.mob ? " (mob)" : "");
		HealthAndStamina stats = original.GetComponent<HealthAndStamina>();
		templateHealth = stats != null ? DevReflection.MaxHealth(stats) : 100f;
		Transform root = template.transform;
		foreach (string path in partPaths)
		{
			RestorePart(root, path);
		}
		// StatusBar.Start parents its bars to the root; each copy makes its own.
		DestroyChildren(root, "healthBar");
		DestroyChildren(root, "staminaBar");
		ResetLiveState(template);
		NavMeshHit hit;
		hasNavMesh = NavMesh.SamplePosition(root.Find("hips").position, out hit, 10f, -1);
		return true;
	}

	// A level mob of normal size first (it is set up like the game's own AI), then a normal-sized human.
	private static int TemplateRank(Player p)
	{
		int rank = Mathf.Abs(p.transform.localScale.x - 1f) < 0.01f ? 2 : 0;
		return p.mob ? rank + 1 : rank;
	}

	private static void RestorePart(Transform root, string path)
	{
		if (root.Find(path) != null)
		{
			return;
		}
		int slash = path.LastIndexOf('/');
		Transform part = root.Find(path.Substring(slash + 1));
		Transform parent = slash < 0 ? root : root.Find(path.Substring(0, slash));
		if (part != null && parent != null)
		{
			part.parent = parent;
		}
	}

	private static void DestroyChildren(Transform root, string name)
	{
		Transform child;
		while ((child = root.Find(name)) != null)
		{
			Object.DestroyImmediate(child.gameObject);
		}
	}

	// The copy must not share live state with its source: Targeting still lists the source's
	// neighbours, a grabbing hand's joint still holds on, a punching hand is still harmful.
	private static void ResetLiveState(GameObject beast)
	{
		foreach (Targeting t in beast.GetComponentsInChildren<Targeting>(true))
		{
			if (t.targetsInSphere != null)
			{
				t.targetsInSphere.Clear();
			}
			t.punchTarget = null;
			t.grabTarget = null;
		}
		foreach (string path in handPaths)
		{
			Transform hand = beast.transform.Find(path);
			if (hand == null)
			{
				continue;
			}
			foreach (HingeJoint joint in hand.GetComponents<HingeJoint>())
			{
				Object.DestroyImmediate(joint);
			}
			hand.tag = "Body Part";
		}
		Player player = beast.GetComponent<Player>();
		player.leftPunch = false;
		player.rightPunch = false;
		player.leftGrab = false;
		player.rightGrab = false;
		player.leftLift = false;
		player.rightLift = false;
		player.taunt = false;
		player.duck = false;
		player.direction = Vector3.zero;
		player.target = null;
		player.targetInRange = false;
		player.state = Player.State.Standing;
		player.devBrain = false;
		foreach (MonoBehaviour b in beast.GetComponents<MonoBehaviour>())
		{
			if (b is DevBeast || b is DevAfterStart)
			{
				Object.DestroyImmediate(b);
			}
		}
		HealthAndStamina stats = beast.GetComponent<HealthAndStamina>();
		if (stats != null)
		{
			stats.dead = false;
		}
	}

	// An inactive copy of the template with this body. Null without a template.
	public static GameObject Build(BeastBody body)
	{
		if (template == null)
		{
			return null;
		}
		GameObject copy = (GameObject)Object.Instantiate(template, template.transform.position, template.transform.rotation);
		copy.name = "[Dev] Beast";
		BeastShape shape = BeastShape.Of(body);
		if (shape != null)
		{
			shape.ApplyBody(copy);
		}
		return copy;
	}

	// Places an inactive copy with its hips at hips, facing yaw (degrees about up), switches it on and
	// registers it.
	public static Beast Activate(GameObject copy, BeastBody body, Vector3 hips, float yaw)
	{
		copy.transform.rotation = Quaternion.Euler(0f, yaw, 0f);
		copy.transform.position += hips - copy.transform.Find("hips").position;
		copy.SetActive(true);
		Beast beast = BeastRegistry.Register(copy.GetComponent<Player>());
		beast.spawned = true;
		beast.body = body;
		return beast;
	}

	public static Beast Spawn(SpawnSpec spec, Vector3 hips, float yaw)
	{
		GameObject copy = Build(spec.body);
		if (copy == null)
		{
			return null;
		}
		spawnCount++;
		Player player = copy.GetComponent<Player>();
		player.mob = spec.mob;
		player.player = spec.slot;
		player.gangName = spec.gang;
		if (spec.useColor)
		{
			player.actorColor = spec.color;
		}
		BeastShape shape = BeastShape.Of(spec.body);
		if (shape != null)
		{
			shape.ApplyStats(copy);
		}
		HealthAndStamina stats = copy.GetComponent<HealthAndStamina>();
		if (stats != null)
		{
			if (spec.health > 0f)
			{
				stats.health = spec.health;
			}
			else if (shape == null)
			{
				stats.health = templateHealth;
			}
			// A mob's death takes a life from score[4], past the P1-P4 scores (IndexOutOfRange); with the
			// score hook off, runOnce skips it as on the additional branch.
			if (spec.slot >= 4 && !DevHooks.fixScoreIndex)
			{
				stats.runOnce = true;
			}
		}
		copy.name = "[Dev] " + (shape != null ? "Boss " : "Beast ") + spawnCount;
		return Activate(copy, spec.body, hips, yaw);
	}

	// Remakes a beast from the template with another (or the same) body, keeping its level settings,
	// side, colour, place, facing, speed, health share and stun, and swaps it in (BeastRegistry.Replace).
	// shapeStats: take the new body's stats (health, stun threshold, gait) instead of the original's.
	public static Beast Rebuild(Beast original, BeastBody body, bool shapeStats)
	{
		return Rebuild(original, body, shapeStats, null);
	}

	// configure runs on the inactive copy last, before it is placed and switched on: its health then is
	// taken as the new maximum (the health share carries over).
	public static Beast Rebuild(Beast original, BeastBody body, bool shapeStats, BeastConfigure configure)
	{
		if (original == null || original.player == null || template == null)
		{
			return null;
		}
		GameObject copy = Build(body);
		Player op = original.player;
		DevFields.CopySettings(op, copy.GetComponent<Player>());
		DevFields.CopySettings(original.stats, copy.GetComponent<HealthAndStamina>());
		DevFields.CopySettings(original.movement, copy.GetComponent<Movement>());
		DevFields.CopySettings(original.jump, copy.GetComponent<Jump>());
		DevFields.CopySettings(original.punch, copy.GetComponent<PunchAndGrab>());
		DevFields.CopySettings(original.targeting, copy.GetComponentInChildren<Targeting>());
		float healthShare = original.stats != null ? Mathf.Clamp01(original.stats.health / Mathf.Max(1f, original.MaxHealth)) : 1f;
		float maxHealth = original.MaxHealth;
		BeastShape shape = BeastShape.Of(body);
		if (shapeStats && shape != null)
		{
			shape.ApplyStats(copy);
			if (shape.health > 0f)
			{
				maxHealth = shape.health;
			}
		}
		else if (shapeStats && shape == null)
		{
			// Back to a normal body: the template's (normal beast's) gait and stun threshold.
			Movement tm = template.GetComponent<Movement>();
			Movement cm = copy.GetComponent<Movement>();
			cm.movementSpeed = tm.movementSpeed;
			cm.animationSpeed = tm.animationSpeed;
		}
		HealthAndStamina stats = copy.GetComponent<HealthAndStamina>();
		if (stats != null)
		{
			stats.health = maxHealth;
			stats.runOnce = original.stats != null && original.stats.runOnce;
		}
		if (configure != null)
		{
			configure(copy);
		}
		copy.name = op.name;
		Transform chest = op.part["chest"];
		Vector3 facing = chest.forward;
		facing.y = 0f;
		float yaw = facing.sqrMagnitude > 1e-6f ? Quaternion.LookRotation(facing).eulerAngles.y : op.transform.eulerAngles.y;
		Rigidbody hipsBody = op.part["hips"].rigidbody;
		Vector3 velocity = hipsBody != null ? hipsBody.velocity : Vector3.zero;
		// The new body may stand taller: line up the balance balls (feet), not the hips.
		Vector3 ballOffset = copy.transform.Find("hips/ball").position - copy.transform.Find("hips").position;
		Vector3 hips = op.part["ball"].position - ballOffset;
		Beast beast = Activate(copy, body, hips, yaw);
		beast.spawned = original.spawned;
		foreach (Rigidbody rb in copy.GetComponentsInChildren<Rigidbody>())
		{
			rb.velocity = velocity;
		}
		DevAfterStart after = copy.AddComponent<DevAfterStart>();
		after.healthShare = healthShare;
		after.stunTimer = original.stats != null ? DevReflection.StunTimer(original.stats) : 0f;
		after.stunned = op.state == Player.State.Stunned;
		BeastRegistry.Replace(original, beast);
		return beast;
	}

	// Up to count spots for beasts of this size round centre, nearest first, on safe ground and clear
	// of each other and of existing beasts (keepAway: also this far from that beast, e.g. P1).
	public static List<Vector3> PlanSpots(Vector3 centre, int count, float size, Beast keepAway, float keepAwayRadius)
	{
		float spacing = 1.0f * Mathf.Max(1f, size);
		List<Vector3> candidates = new List<Vector3>();
		int rings = Mathf.CeilToInt(Mathf.Sqrt(count) * 1.5f) + 3;
		float reach = Mathf.Min(rings * spacing, 15f);
		Vector3 a = new Vector3(spacing, 0f, 0f);
		Vector3 b = new Vector3(spacing * 0.5f, 0f, spacing * 0.8660254f);
		for (int i = -rings; i <= rings; i++)
		{
			for (int j = -rings; j <= rings; j++)
			{
				Vector3 p = centre + a * i + b * j;
				if ((p - centre).magnitude <= reach)
				{
					candidates.Add(p);
				}
			}
		}
		candidates.Sort((x, y) => (x - centre).sqrMagnitude.CompareTo((y - centre).sqrMagnitude));
		List<Vector3> spots = new List<Vector3>();
		foreach (Vector3 c in candidates)
		{
			if (spots.Count >= count)
			{
				break;
			}
			Vector3 ground;
			if (!DevGround.Snap(c, spacing * 0.45f, out ground) || !DevGround.BodyClear(ground, Mathf.Max(1f, size)))
			{
				continue;
			}
			bool clear = true;
			foreach (Vector3 s in spots)
			{
				if ((s - ground).sqrMagnitude < spacing * spacing * 0.81f)
				{
					clear = false;
					break;
				}
			}
			if (clear)
			{
				foreach (Beast other in BeastRegistry.All)
				{
					Transform ball = other.Part("ball");
					if (ball == null)
					{
						continue;
					}
					float radius = other == keepAway ? keepAwayRadius : spacing * 0.9f * Mathf.Max(1f, other.size);
					if ((ball.position - ground).sqrMagnitude < radius * radius)
					{
						clear = false;
						break;
					}
				}
			}
			if (clear)
			{
				spots.Add(ground);
			}
		}
		return spots;
	}

	// Hips height above the ground for a standing beast of this body (the template's own stance).
	public static float HipsHeight(BeastBody body)
	{
		if (template == null)
		{
			return 1f;
		}
		Transform hips = template.transform.Find("hips");
		Transform ball = template.transform.Find("hips/ball");
		float ballRadius = ball.collider is SphereCollider ? ((SphereCollider)ball.collider).radius * ball.lossyScale.x : 0.2f;
		float height = hips.position.y - ball.position.y + ballRadius;
		BeastShape shape = BeastShape.Of(body);
		return shape != null ? height * shape.rootScale / template.transform.localScale.x : height;
	}
}
