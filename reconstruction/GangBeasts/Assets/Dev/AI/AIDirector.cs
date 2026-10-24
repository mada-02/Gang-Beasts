using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

// The Smart AI's shared half, on the DevRoot object. Ten times a second it takes a snapshot of every beast,
// buckets them in a spatial hash, refreshes what each brain knows (sight, hearing, teammates' alerts),
// assigns enemies (TargetAssigner: a few engaged per enemy, the rest queued) and spreads the attackers
// on each enemy round it (SlotPlanner). Brains steer and fight every frame from these orders.
public class AIDirector : MonoBehaviour
{
	public static AIDirector instance;

	public static AILevel level = AILevel.Hard;

	// Smart AI drives the level's own mobs too.
	public static bool smartLevelMobs;

	public const float Tick = 0.1f;

	public const float HearRange = 8f;

	public const float SightRange = 30f;

	public const float AlertRange = 8f;

	public readonly List<AIBrain> brains = new List<AIBrain>();

	public readonly SpatialHash hash = new SpatialHash(2f);

	// The snapshot: beasts alive this tick and their chests.
	public Beast[] beasts = new Beast[0];

	public Vector3[] chests = new Vector3[0];

	public int count;

	// The brain driving each snapshot beast, or null.
	public AIBrain[] brainAt = new AIBrain[0];

	private readonly Dictionary<string, int> gangIds = new Dictionary<string, int>();

	private readonly TargetAssigner assigner = new TargetAssigner();

	private TargetAssigner.Fighter[] agents = new TargetAssigner.Fighter[0];

	private TargetAssigner.Enemy[] enemies = new TargetAssigner.Enemy[0];

	private TargetAssigner.Result[] results = new TargetAssigner.Result[0];

	private readonly Dictionary<Beast, int> index = new Dictionary<Beast, int>();

	private readonly List<int> near = new List<int>();

	private readonly List<int> order = new List<int>();

	private readonly List<Vector3> crowd = new List<Vector3>();

	private readonly List<AIBrain> crowdBrains = new List<AIBrain>();

	private float[] bearings = new float[16];

	private float nextTick;

	private readonly Stopwatch watch = new Stopwatch();

	// Milliseconds of the last world tick, and of all brains' work in the last frame.
	public float tickMs;

	public float brainMs;

	private int brainFrame;

	public int ticks;

	// Sight lines left this tick, shared by every brain (a line across a crowd steps through many
	// triggers; hearing, teammates' alerts and an 8 s memory cover the rest).
	public int sightBudget;

	// Milliseconds of each stage of the last tick: snapshot, sense, alert, assign, slots.
	public readonly float[] stageMs = new float[5];

	private readonly Stopwatch stage = new Stopwatch();

	private void Lap(int i)
	{
		stage.Stop();
		stageMs[i] = (float)stage.Elapsed.TotalMilliseconds;
		stage.Reset();
		stage.Start();
	}

	private TargetAssigner.Knows knows;

	public static AIDifficulty Difficulty
	{
		get { return AIDifficulty.Of(level); }
	}

	private static readonly string[] levelNames = { "Easy", "Normal", "Hard", "Brutal" };

	private void Awake()
	{
		instance = this;
		knows = Knows;
		DevMenu.aiSections.Add(DrawSection);
		DevRoot.LevelStarting += () =>
		{
			gangIds.Clear();
			AISensors.LevelLoaded();
		};
		DevSpawner.attachBrain = Attach;
		BeastRegistry.Added += b =>
		{
			if (smartLevelMobs && b.player.mob && !b.spawned && b.gameObject.GetComponent<AIBrain>() == null)
			{
				b.gameObject.AddComponent<AIBrain>();
			}
		};
	}

	// DevSpawner: smart AI gets a brain; otherwise the game's own AI runs (with DevFollow for allies).
	private static void Attach(Beast beast, bool smart)
	{
		if (smart)
		{
			beast.gameObject.AddComponent<AIBrain>();
		}
		else if (beast.leader != null)
		{
			beast.gameObject.AddComponent<DevFollow>();
		}
	}

	public static void SetSmartLevelMobs(bool value)
	{
		smartLevelMobs = value;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player == null || !b.player.mob || b.spawned)
			{
				continue;
			}
			AIBrain brain = b.gameObject.GetComponent<AIBrain>();
			if (value && brain == null)
			{
				b.gameObject.AddComponent<AIBrain>();
			}
			else if (!value && brain != null)
			{
				Destroy(brain);
			}
		}
	}

	// Spawned AI: brains on or off (off: the game's own AI, allies keep up with DevFollow).
	public static void SetSmartSpawned(bool value)
	{
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player == null || !b.player.mob || !b.spawned)
			{
				continue;
			}
			AIBrain brain = b.gameObject.GetComponent<AIBrain>();
			DevFollow follow = b.gameObject.GetComponent<DevFollow>();
			if (value && brain == null)
			{
				b.gameObject.AddComponent<AIBrain>();
			}
			else if (!value && brain != null)
			{
				Destroy(brain);
			}
			if (!value && b.leader != null && follow == null)
			{
				b.gameObject.AddComponent<DevFollow>();
			}
			if (follow != null)
			{
				follow.enabled = !value;
			}
		}
	}

	private static void DrawSection()
	{
		AISpawnRequest r = DevMenu.instance.request;
		bool smart = GUILayout.Toggle(r.smart, "Smart AI (teams up, queues, dodges, finishes)");
		if (smart != r.smart)
		{
			r.smart = smart;
			SetSmartSpawned(smart);
		}
		bool mobs = GUILayout.Toggle(smartLevelMobs, "Smart AI for level mobs too");
		if (mobs != smartLevelMobs)
		{
			SetSmartLevelMobs(mobs);
		}
		level = (AILevel)GUILayout.Toolbar((int)level, levelNames);
	}

	public int Gang(Player p)
	{
		int id;
		if (!gangIds.TryGetValue(p.gangName, out id))
		{
			id = gangIds.Count;
			gangIds[p.gangName] = id;
		}
		return id;
	}

	public int IndexOf(Beast b)
	{
		int i;
		return b != null && index.TryGetValue(b, out i) ? i : -1;
	}

	// Brains report the time they spend; the total per frame is brainMs.
	public void AddBrainTime(float ms)
	{
		if (brainFrame != Time.frameCount)
		{
			brainFrame = Time.frameCount;
			brainMs = 0f;
		}
		brainMs += ms;
	}

	private void Update()
	{
		if (brains.Count == 0)
		{
			return;
		}
		if (Time.time >= nextTick || Time.time < nextTick - Tick * 2f)
		{
			nextTick = Time.time + Tick;
			watch.Reset();
			watch.Start();
			WorldTick();
			watch.Stop();
			tickMs = (float)watch.Elapsed.TotalMilliseconds;
			ticks++;
		}
	}

	private void Grow(int n)
	{
		if (beasts.Length >= n)
		{
			return;
		}
		int size = Mathf.Max(n, beasts.Length * 2);
		beasts = new Beast[size];
		chests = new Vector3[size];
		brainAt = new AIBrain[size];
		enemies = new TargetAssigner.Enemy[size];
	}

	private void WorldTick()
	{
		stage.Reset();
		stage.Start();
		List<Beast> all = BeastRegistry.All;
		Grow(all.Count);
		count = 0;
		index.Clear();
		foreach (Beast b in all)
		{
			if (b.player == null || !b.player.part.ContainsKey("chest"))
			{
				continue;
			}
			beasts[count] = b;
			chests[count] = b.Chest;
			index[b] = count;
			count++;
		}
		hash.Build(chests, count);
		for (int i = 0; i < count; i++)
		{
			brainAt[i] = null;
		}
		foreach (AIBrain brain in brains)
		{
			int i;
			if (brain.beast != null && index.TryGetValue(brain.beast, out i))
			{
				brainAt[i] = brain;
			}
		}
		Lap(0);
		sightBudget = 16;
		// Each brain looks round every other tick (5 a second; memory lasts 8 s): half the cost per tick.
		for (int b = 0; b < brains.Count; b++)
		{
			if ((b + ticks) % 2 == 0)
			{
				brains[b].Sense(this);
			}
		}
		Lap(1);
		// Only the brains that looked round this tick have news to pass on.
		for (int b = 0; b < brains.Count; b++)
		{
			if ((b + ticks) % 2 == 0)
			{
				brains[b].Alert(this);
			}
		}
		Lap(2);
		// Enemies: every beast that can be fought; attackers: every able brain.
		for (int e = 0; e < count; e++)
		{
			Beast b = beasts[e];
			enemies[e].id = b.id;
			enemies[e].gang = Gang(b.player);
			enemies[e].position = chests[e];
			enemies[e].size = b.size;
			enemies[e].stunned = b.player.state == Player.State.Stunned;
			enemies[e].healthShare = b.stats != null ? b.stats.health / Mathf.Max(1f, b.MaxHealth) : 1f;
			enemies[e].threat = 0f;
		}
		if (agents.Length < brains.Count)
		{
			agents = new TargetAssigner.Fighter[brains.Count * 2];
			results = new TargetAssigner.Result[brains.Count * 2];
		}
		for (int a = 0; a < brains.Count; a++)
		{
			AIBrain brain = brains[a];
			agents[a].id = brain.beast != null ? brain.beast.id : -1;
			agents[a].gang = brain.beast != null ? Gang(brain.beast.player) : -1;
			agents[a].position = brain.beast != null ? brain.beast.Chest : Vector3.zero;
			agents[a].size = brain.beast != null ? brain.beast.size : 1f;
			agents[a].able = brain.Able;
			agents[a].previous = brain.enemy != null ? brain.enemy.id : -1;
		}
		// Enemies close to a brain's friend (above all its leader) come first for that side.
		for (int a = 0; a < brains.Count; a++)
		{
			brains[a].MarkThreats(this, enemies);
		}
		assigner.Assign(agents, brains.Count, enemies, count, knows, results);
		Lap(3);
		for (int a = 0; a < brains.Count; a++)
		{
			brains[a].orderEnemy = results[a].enemy >= 0 ? beasts[results[a].enemy] : null;
			brains[a].orderEngaged = results[a].engaged;
		}
		// Slots, enemy by enemy.
		for (int e = 0; e < count; e++)
		{
			crowd.Clear();
			crowdBrains.Clear();
			for (int a = 0; a < brains.Count; a++)
			{
				if (results[a].enemy == e && results[a].engaged)
				{
					crowd.Add(brains[a].beast.Chest);
					crowdBrains.Add(brains[a]);
				}
			}
			if (crowd.Count == 0)
			{
				continue;
			}
			if (bearings.Length < crowd.Count)
			{
				bearings = new float[crowd.Count * 2];
			}
			SlotPlanner.Plan(chests[e], crowd, order, bearings);
			for (int i = 0; i < crowdBrains.Count; i++)
			{
				crowdBrains[i].orderBearing = bearings[i];
			}
		}
		Lap(4);
	}

	private bool Knows(int agent, int enemy)
	{
		return brains[agent].Knows(beasts[enemy]);
	}

	// Beasts within radius of a point (indices into the snapshot).
	public List<int> Near(Vector3 point, float radius)
	{
		near.Clear();
		hash.Query(point, radius, near);
		return near;
	}
}
