using System.Collections.Generic;
using UnityEngine;

public enum DevTeam
{
	MobGang,
	FreeForAll,
	TeamA,
	TeamB,
	TeamC,
	TeamD,
	AllyP1,
	AllyP2,
	AllyP3,
	AllyP4
}

public enum DevSpawnAt
{
	ScreenCentre,
	NearP1
}

public class AISpawnRequest
{
	public int count = 1;

	public BeastBody body = BeastBody.Normal;

	public DevTeam team = DevTeam.MobGang;

	public DevSpawnAt at = DevSpawnAt.ScreenCentre;

	public bool randomColor = true;

	// 100 health instead of the level mob's own (Street's: 50).
	public bool fullHealth;

	public bool smart = true;
}

public delegate void BrainAttach(Beast beast, bool smart);

// Spawns AI from the AI tab and removes it again. Spawned AI are mobs with player index 4 (outside the
// P1-P4 slots) on a gang picked by team: one mob gang, everyone for themselves, Teams A-D (AI against
// AI), or a human's own gang as its ally (staying with that human: Beast.leader).
public static class DevSpawner
{
	// Street's pink boss (Street.unity, Player.actorColor of the boss).
	public static readonly Color bossColor = new Color(0.5882353f, 0.3575548f, 0.46165016f);

	// Set by the AI module: gives a spawned beast its brain (smart) or leaves the game's own AI on.
	public static BrainAttach attachBrain;

	public static string message = "";

	private static int freeForAll;

	private static bool initialised;

	public static void Init()
	{
		if (initialised)
		{
			return;
		}
		initialised = true;
		BeastRegistry.Replaced += OnReplaced;
	}

	// An ally follows whoever replaced its leader (a morph, a rebuild) at once.
	private static void OnReplaced(Beast old, Beast replacement)
	{
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.leader == old)
			{
				b.leader = replacement;
			}
		}
	}

	public static string GangName(DevTeam team, Beast leader)
	{
		switch (team)
		{
		case DevTeam.MobGang:
			return "DevMenu Mob";
		case DevTeam.FreeForAll:
			freeForAll++;
			return "DevMenu AI " + freeForAll;
		case DevTeam.TeamA:
			return "DevMenu Team A";
		case DevTeam.TeamB:
			return "DevMenu Team B";
		case DevTeam.TeamC:
			return "DevMenu Team C";
		case DevTeam.TeamD:
			return "DevMenu Team D";
		}
		return leader != null ? leader.player.gangName : "DevMenu Mob";
	}

	public static int LeaderSlot(DevTeam team)
	{
		return team >= DevTeam.AllyP1 ? (int)team - (int)DevTeam.AllyP1 : -1;
	}

	public static List<Beast> Spawn(AISpawnRequest r)
	{
		List<Beast> spawned = new List<Beast>();
		if (BeastFactory.Template == null)
		{
			message = "No beast to copy in this level.";
			return spawned;
		}
		int slot = LeaderSlot(r.team);
		Beast leader = slot >= 0 ? BeastRegistry.Human(slot) : null;
		if (slot >= 0 && leader == null)
		{
			message = "No P" + (slot + 1) + " in this level to ally with.";
			return spawned;
		}
		Beast p1 = BeastRegistry.Human(0);
		Vector3 centre;
		Beast keepAway = null;
		if (r.at == DevSpawnAt.NearP1 && p1 != null)
		{
			centre = p1.Part("ball").position;
			keepAway = p1;
		}
		else if (!DevGround.Snap(DevGround.ScreenCentre(), 4f, out centre))
		{
			// The centre of the screen can be sky, a far wall or a pit: fall back to beside P1.
			centre = p1 != null ? p1.Part("ball").position : DevGround.ScreenCentre();
			keepAway = p1;
		}
		BeastShape shape = BeastShape.Of(r.body);
		float size = shape != null ? shape.rootScale : 1f;
		List<Vector3> spots = BeastFactory.PlanSpots(centre, r.count, size, keepAway, 2.5f);
		float hips = BeastFactory.HipsHeight(r.body);
		int offMesh = 0;
		foreach (Vector3 spot in spots)
		{
			SpawnSpec spec = new SpawnSpec();
			spec.body = r.body;
			spec.gang = GangName(r.team, leader);
			if (r.randomColor)
			{
				spec.useColor = true;
				spec.color = new Color(Random.Range(0.2f, 1f), Random.Range(0.2f, 1f), Random.Range(0.2f, 1f));
			}
			else if (shape != null)
			{
				spec.useColor = true;
				spec.color = bossColor;
			}
			if (r.fullHealth && shape == null)
			{
				spec.health = 100f;
			}
			Vector3 facing = centre - spot;
			float yaw = facing.sqrMagnitude > 0.01f ? Quaternion.LookRotation(new Vector3(facing.x, 0f, facing.z)).eulerAngles.y : Random.Range(0f, 360f);
			Beast beast = BeastFactory.Spawn(spec, spot + Vector3.up * hips, yaw);
			beast.team = r.team.ToString();
			beast.leader = leader;
			if (attachBrain != null)
			{
				attachBrain(beast, r.smart);
			}
			else if (leader != null)
			{
				beast.gameObject.AddComponent<DevFollow>();
			}
			// The game's own AI calls SetDestination every frame, which logs an error for an agent off the
			// NavMesh (Gondola's cars, Subway's carriages). It could not walk there anyway: stand it down.
			NavMeshHit hit;
			if (!beast.player.devBrain && !NavMesh.SamplePosition(beast.player.agent.transform.position, out hit, 1f, -1))
			{
				beast.player.devBrain = true;
				offMesh++;
			}
			spawned.Add(beast);
		}
		message = spots.Count < r.count ? "Room for " + spots.Count + " of " + r.count + "." : "";
		if (offMesh > 0)
		{
			message += (message != "" ? " " : "") + offMesh + " off the NavMesh stand still (the game's AI needs one).";
		}
		return spawned;
	}

	public static int RemoveDead()
	{
		return Remove(true, false);
	}

	public static int RemoveSpawned()
	{
		return Remove(false, false);
	}

	public static int RemoveAllMobs()
	{
		return Remove(false, true);
	}

	private static int Remove(bool deadOnly, bool levelMobsToo)
	{
		List<Beast> victims = new List<Beast>();
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player == null || !b.player.mob)
			{
				continue;
			}
			if ((b.spawned || levelMobsToo) && (!deadOnly || b.player.state == Player.State.Dead))
			{
				victims.Add(b);
			}
		}
		foreach (Beast b in victims)
		{
			BeastRegistry.SafeDestroy(b);
		}
		return victims.Count;
	}

	public static int CountSpawned(bool aliveOnly)
	{
		int n = 0;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player != null && b.spawned && b.player.mob && (!aliveOnly || b.Alive))
			{
				n++;
			}
		}
		return n;
	}
}
