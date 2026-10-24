using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

// Smart AI for one mob (the per-beast half; AIDirector is the shared half). Sets Player.devBrain so the
// game's own mob AI stands down, and every LateUpdate (after Player.Update, before the next FixedUpdate
// reads them) writes the beast's move direction, punches, grabs, jumps and taunts.
//
// Roles, picked every frame from the director's orders and the fight round it:
//   Engage      its spot close round its enemy (SlotPlanner), pressing in and punching;
//   Queue       waiting further out until a spot frees up (punching only what comes into reach);
//   Regroup     clearly outnumbered: back to the nearest friends (an ally: its leader);
//   Encircled   outnumbered with nobody to fall back on: out through the widest gap in the ring;
//   Finish      a stunned enemy in reach: carry it to the nearest drop and let go (or hold it up);
//   Follow / Search / Patrol when there is no enemy.
// Steering follows NavMesh paths (straight where there are none), jumps knee-high obstacles, brakes at
// drops and kill zones, and gets itself unstuck (from the additional branch's brain).
public class AIBrain : MonoBehaviour
{
	public enum Role
	{
		Patrol,
		Search,
		Follow,
		Engage,
		Queue,
		Regroup,
		Encircled,
		Finish
	}

	public Beast beast;

	public Role role;

	public Beast enemy;

	// From the director's last tick.
	public Beast orderEnemy;

	public bool orderEngaged;

	public float orderBearing;

	private Player self;

	private readonly Dictionary<Beast, float> known = new Dictionary<Beast, float>();

	private readonly Dictionary<Beast, float> sensed = new Dictionary<Beast, float>();

	private readonly Dictionary<Beast, float> firstSeen = new Dictionary<Beast, float>();

	private static readonly List<Beast> forget = new List<Beast>();

	private System.Random random;

	private AIDifficulty difficulty;

	private NavMeshPath path;

	private Vector3[] corners = new Vector3[0];

	private int corner;

	private bool partialPath;

	private Vector3 pathGoal;

	private float repathTimer;

	private Vector3 move;

	private Vector3 edgeAway;

	private float edgeTimer;

	private Vector3 progressFrom;

	private float progressTimer;

	private int stuck;

	private Vector3 detour;

	private float detourUntil;

	private float jumpCooldown;

	private float jumpingFor;

	private float punchTimer;

	private bool leftNext;

	private float tauntUntil;

	private float sidestepUntil;

	private Vector3 sidestep;

	private Beast dodged;

	private Beast carried;

	private bool holding;

	private float carryStarted;

	private Vector3 throwSpot;

	private float grabCooldown;

	private Vector3 lastSeen;

	private float lastSeenTime = float.NegativeInfinity;

	private Vector3 post;

	private bool hasPost;

	private bool patrolling;

	private Vector3 wanderPoint;

	private float wanderUntil;

	private float restUntil;

	private bool calm;

	private ObstacleAvoidanceType savedAvoidance;

	private readonly Stopwatch watch = new Stopwatch();

	private void Awake()
	{
		self = GetComponent<Player>();
		path = new NavMeshPath();
	}

	private void Start()
	{
		beast = BeastRegistry.Find(self);
		random = new System.Random(Random.seed ^ (beast != null ? beast.id * 7919 : 1));
		leftNext = random.NextDouble() < 0.5;
	}

	private void OnEnable()
	{
		if (AIDirector.instance != null && !AIDirector.instance.brains.Contains(this))
		{
			AIDirector.instance.brains.Add(this);
		}
		self.devBrain = true;
		if (self.agent != null)
		{
			savedAvoidance = self.agent.obstacleAvoidanceType;
			self.agent.obstacleAvoidanceType = ObstacleAvoidanceType.NoObstacleAvoidance;
		}
	}

	private void OnDisable()
	{
		if (AIDirector.instance != null)
		{
			AIDirector.instance.brains.Remove(this);
		}
		if (self == null)
		{
			return;
		}
		self.devBrain = false;
		if (self.agent != null)
		{
			self.agent.obstacleAvoidanceType = savedAvoidance;
		}
		LetGo();
		self.taunt = false;
		carried = null;
		enemy = null;
	}

	// ---------------------------------------------------------------------------------- the director's side

	public bool Able
	{
		get
		{
			return beast != null && beast.player != null && beast.Alive && self.state != Player.State.Stunned && carried == null
				&& role != Role.Regroup && role != Role.Encircled;
		}
	}

	private bool IsEnemy(Beast b)
	{
		return b != null && b != beast && b.player != null && b.player.gangName != self.gangName && b.player.state != Player.State.Dead && b.player.CompareTag("Player");
	}

	private bool IsFriend(Beast b)
	{
		return b != null && b != beast && b.player != null && b.player.gangName == self.gangName && b.player.state != Player.State.Dead;
	}

	public bool Knows(Beast b)
	{
		float t;
		return known.TryGetValue(b, out t) && Time.time - t < 8f && IsEnemy(b) && (beast.leader == null || LeaderCares(b));
	}

	// An ally stays with its leader: only enemies near the leader, or on top of itself.
	private bool LeaderCares(Beast b)
	{
		Beast lead = beast.leader;
		if (lead == null || lead.player == null || lead.player.state == Player.State.Dead)
		{
			return true;
		}
		return (b.Chest - beast.Chest).magnitude < 3f || (b.Chest - lead.Chest).magnitude < 12f;
	}

	public void Sense(AIDirector d)
	{
		if (beast == null || beast.player == null)
		{
			return;
		}
		float now = Time.time;
		int sightChecks = 0;
		Vector3 chest = beast.Chest;
		Vector3 eye = beast.Part("head").position;
		Assess(d, chest);
		foreach (int i in d.Near(chest, AIDirector.SightRange))
		{
			Beast b = d.beasts[i];
			if (!IsEnemy(b))
			{
				continue;
			}
			float distance = (d.chests[i] - chest).magnitude;
			float last;
			bool fresh = sensed.TryGetValue(b, out last) && now - last < 1f;
			bool heard = distance < AIDirector.HearRange;
			// Sight lines cost rays: only for enemies not sensed in the last second, a few per tick.
			bool seen = false;
			if (!heard && !fresh && sightChecks < 4 && d.sightBudget > 0)
			{
				sightChecks++;
				d.sightBudget--;
				seen = AISensors.CanSee(beast.id, b.id, eye, d.chests[i]);
			}
			if (heard || seen)
			{
				if (!known.ContainsKey(b) || now - known[b] > 8f)
				{
					firstSeen[b] = now;
				}
				known[b] = now;
				sensed[b] = now;
			}
		}
		forget.Clear();
		foreach (KeyValuePair<Beast, float> item in known)
		{
			if (item.Key.player == null || item.Key.player.state == Player.State.Dead || now - item.Value > 8f)
			{
				forget.Add(item.Key);
			}
		}
		foreach (Beast b in forget)
		{
			known.Remove(b);
			sensed.Remove(b);
			firstSeen.Remove(b);
		}
	}

	// What this brain saw or heard itself just now goes to teammates within earshot (news travels mate
	// to mate, not across the level in one tick).
	public void Alert(AIDirector d)
	{
		if (beast == null || beast.player == null || sensed.Count == 0)
		{
			return;
		}
		float now = Time.time;
		foreach (int i in d.Near(beast.Chest, AIDirector.AlertRange))
		{
			AIBrain other = d.brainAt[i];
			if (other == null || other == this || other.self.gangName != self.gangName)
			{
				continue;
			}
			foreach (KeyValuePair<Beast, float> item in sensed)
			{
				if (now - item.Value < Tick && (!other.known.ContainsKey(item.Key) || other.known[item.Key] < now))
				{
					if (!other.known.ContainsKey(item.Key))
					{
						other.firstSeen[item.Key] = now;
					}
					other.known[item.Key] = now;
				}
			}
		}
	}

	// Sensed within the last two ticks (each brain looks round every other tick).
	private const float Tick = AIDirector.Tick * 2f + 0.01f;

	// Enemies on a friend (2) or on the leader (4) are worth more to this side.
	public void MarkThreats(AIDirector d, TargetAssigner.Enemy[] enemies)
	{
		if (beast == null || beast.player == null)
		{
			return;
		}
		foreach (int i in d.Near(beast.Chest, 2.5f))
		{
			Beast b = d.beasts[i];
			if (IsEnemy(b))
			{
				enemies[i].threat = Mathf.Max(enemies[i].threat, 2f);
			}
		}
		Beast lead = beast.leader;
		if (lead != null && lead.player != null)
		{
			foreach (int i in d.Near(lead.Chest, 2.5f))
			{
				if (IsEnemy(d.beasts[i]))
				{
					enemies[i].threat = 4f;
				}
			}
		}
	}

	// ---------------------------------------------------------------------------------- every frame

	private void LateUpdate()
	{
		if (beast == null || beast.player == null)
		{
			beast = BeastRegistry.Find(self);
			if (beast == null)
			{
				return;
			}
		}
		if (self.state == Player.State.Dead || !self.part.ContainsKey("ball"))
		{
			return;
		}
		watch.Reset();
		watch.Start();
		difficulty = AIDirector.Difficulty;
		float dt = Time.deltaTime;
		Timers(dt);
		self.targetInRange = false;
		if (self.state == Player.State.Stunned)
		{
			carried = null;
			holding = false;
			move = Vector3.zero;
			self.direction = Vector3.zero;
			Stop();
			return;
		}
		Vector3 chest = beast.Chest;
		Vector3 feet = Ground(beast);
		edgeTimer -= dt;
		if (edgeTimer <= 0f)
		{
			edgeTimer = 0.25f;
			SenseEdges(feet);
		}
		ChooseRole(chest);
		Vector3 desired = Act(chest, feet);
		if (carried == null)
		{
			desired += Separation(chest) + edgeAway * 0.7f;
		}
		if (Time.time < sidestepUntil)
		{
			desired += sidestep;
		}
		if (desired.sqrMagnitude > 1f)
		{
			desired.Normalize();
		}
		desired = Brake(feet, desired);
		move = Vector3.Lerp(move, desired, Mathf.Clamp01(dt * 10f));
		if (desired == Vector3.zero && move.sqrMagnitude < 0.01f)
		{
			move = Vector3.zero;
		}
		self.direction = move;
		self.target = enemy != null ? enemy.player : null;
		self.taunt = Time.time < tauntUntil && enemy == null && carried == null;
		TrackProgress(feet, desired, dt);
		Stop();
	}

	private void Stop()
	{
		watch.Stop();
		if (AIDirector.instance != null)
		{
			AIDirector.instance.AddBrainTime((float)watch.Elapsed.TotalMilliseconds);
		}
	}

	private void Timers(float dt)
	{
		jumpCooldown -= dt;
		punchTimer -= dt;
		grabCooldown -= dt;
		repathTimer -= dt;
		// A jump ends only when a part lands on something; a missed landing left beasts "Jumping".
		if (self.state == Player.State.Jumping)
		{
			jumpingFor += dt;
			if (jumpingFor > 1.5f && self.onGround)
			{
				self.state = Player.State.Standing;
				jumpingFor = 0f;
			}
		}
		else
		{
			jumpingFor = 0f;
		}
	}

	private void ChooseRole(Vector3 chest)
	{
		Beast previous = enemy;
		if (carried != null)
		{
			role = Role.Finish;
			return;
		}
		int threats = assessedThreats;
		int friends = assessedFriends;
		int friendCount = assessedFriendCount;
		Vector3 friendsAt = assessedFriendsAt;
		float hp = beast.stats != null ? beast.stats.health / Mathf.Max(1f, beast.MaxHealth) : 1f;
		bool overwhelmed = threats >= friends + 2 || (threats >= friends && threats > 0 && hp < 0.35f);
		Beast lead = beast.leader != null && beast.leader.player != null && beast.leader.Alive ? beast.leader : null;
		if (overwhelmed && (friendCount > 0 || lead != null))
		{
			role = Role.Regroup;
			regroupTo = lead != null ? Ground(lead) : friendsAt / Mathf.Max(1, friendCount);
			enemy = Nearest(chest);
			return;
		}
		if (overwhelmed || (threats >= 2 && friends == 1))
		{
			role = Role.Encircled;
			enemy = Nearest(chest);
			return;
		}
		enemy = orderEnemy != null && IsEnemy(orderEnemy) ? orderEnemy : null;
		if (enemy != null)
		{
			role = orderEngaged ? Role.Engage : Role.Queue;
			lastSeen = Ground(enemy);
			lastSeenTime = Time.time;
		}
		else if (lead != null)
		{
			role = Role.Follow;
		}
		else if (Time.time - lastSeenTime < 10f)
		{
			role = Role.Search;
		}
		else
		{
			role = Role.Patrol;
		}
		if (previous != null && previous.player != null && previous.player.state == Player.State.Dead && enemy == null && (Ground(previous) - Ground(beast)).magnitude < 4f)
		{
			// Gloat a little after downing an enemy.
			tauntUntil = Time.time + 3.5f;
		}
	}

	private Vector3 regroupTo;

	private int assessedThreats;

	private int assessedFriends = 1;

	private int assessedFriendCount;

	private Vector3 assessedFriendsAt;

	// Ten times a second (from Sense): enemies close by against friends beside it, and where the friends
	// further off stand (somewhere to fall back to).
	private void Assess(AIDirector d, Vector3 chest)
	{
		assessedThreats = 0;
		assessedFriends = 1;
		assessedFriendCount = 0;
		assessedFriendsAt = Vector3.zero;
		foreach (int i in d.Near(chest, 15f))
		{
			Beast b = d.beasts[i];
			float distance = (d.chests[i] - chest).magnitude;
			if (distance < 6f)
			{
				if (IsEnemy(b) && b.player.state != Player.State.Stunned && Knows(b))
				{
					assessedThreats++;
				}
				else if (IsFriend(b))
				{
					assessedFriends++;
				}
			}
			else if (IsFriend(b))
			{
				assessedFriendsAt += d.chests[i];
				assessedFriendCount++;
			}
		}
	}

	private Beast Nearest(Vector3 chest)
	{
		AIDirector d = AIDirector.instance;
		if (d == null)
		{
			return null;
		}
		Beast best = null;
		float bestDistance = float.PositiveInfinity;
		foreach (int i in d.Near(chest, 6f))
		{
			Beast b = d.beasts[i];
			float distance = (d.chests[i] - chest).magnitude;
			if (IsEnemy(b) && distance < bestDistance)
			{
				best = b;
				bestDistance = distance;
			}
		}
		return best;
	}

	private Vector3 Act(Vector3 chest, Vector3 feet)
	{
		calm = false;
		if (role == Role.Finish)
		{
			return Carry(chest, feet);
		}
		LetGo();
		if (Time.time < tauntUntil && enemy == null)
		{
			return Vector3.zero;
		}
		switch (role)
		{
		case Role.Engage:
			return Engage(chest, feet, true);
		case Role.Queue:
			return Engage(chest, feet, false);
		case Role.Regroup:
			PunchAt(chest, feet, enemy);
			return Steer(feet, regroupTo, 1f, 0.8f);
		case Role.Encircled:
			PunchAt(chest, feet, enemy);
			return Escape(chest, feet);
		case Role.Follow:
			return Follow(feet, beast.leader);
		case Role.Search:
			if (Flat(lastSeen - feet).magnitude > 1.5f)
			{
				return Steer(feet, lastSeen, 0.8f, 0.8f);
			}
			lastSeenTime = float.NegativeInfinity;
			return Vector3.zero;
		}
		return Patrol(feet);
	}

	private Vector3 Engage(Vector3 chest, Vector3 feet, bool engaged)
	{
		Vector3 to = enemy.Chest - chest;
		Vector3 flat = Flat(to);
		float distance = to.magnitude;
		Vector3 enemyGround = Ground(enemy);
		float reach = Reach();
		if (engaged && difficulty.finish && enemy.player.state == Player.State.Stunned && distance < 1.3f * beast.size && grabCooldown <= 0f && !TeammateCarries(enemy) && StartCarry(feet))
		{
			return Carry(chest, feet);
		}
		// An enemy going over an edge is left to fall: following it took the AI over too.
		if (distance < 3f && enemyGround.y < feet.y - 0.5f && AISensors.Drop(new Vector3(enemyGround.x, feet.y, enemyGround.z), 2f))
		{
			return Vector3.zero;
		}
		Dodge(chest, flat);
		PunchAt(chest, feet, enemy);
		if (engaged && distance < reach + 0.75f)
		{
			// In reach: face it and keep pressing in, stepping round a teammate in the line.
			Vector3 press = flat.normalized * (distance > reach * 0.75f ? 0.8f : 0.35f);
			if (AllyInTheWay(chest, to, distance))
			{
				press += Vector3.Cross(Vector3.up, flat.normalized) * 0.6f;
			}
			if (self.onGround && Ledge(feet, press.normalized, 0.6f + Speed() * 0.45f))
			{
				return Vector3.zero;
			}
			return press;
		}
		float radius = engaged ? SlotPlanner.Ring(enemy.size, beast.size) : SlotPlanner.QueueRing(enemy.size);
		float bearing = engaged ? orderBearing : Mathf.Atan2(chest.x - enemy.Chest.x, chest.z - enemy.Chest.z) * Mathf.Rad2Deg;
		Vector3 spot = SlotPlanner.Spot(enemyGround, bearing, radius);
		if (!engaged && Flat(spot - feet).magnitude < 0.6f)
		{
			// Waiting: face the fight.
			return flat.normalized * 0.05f;
		}
		Vector3 direction = Steer(feet, spot, engaged ? 1f : 0.7f, 0.8f);
		if (engaged && distance > reach && distance < reach + 1.6f && enemy.player.state != Player.State.Stunned
			&& Vector3.Angle(Flat(self.part["chest"].forward), flat) < 30f && random.NextDouble() < Time.deltaTime * difficulty.lunge && !FriendWithin(chest, 1.5f))
		{
			Jump();
		}
		return direction;
	}

	private float Reach()
	{
		return 1.45f * Mathf.Max(1f, beast.size);
	}

	// Punch the given enemy if it is in reach and in front, with nobody of ours in the line.
	private void PunchAt(Vector3 chest, Vector3 feet, Beast target)
	{
		if (target == null || target.player == null || punchTimer > 0f)
		{
			return;
		}
		float seen;
		if (firstSeen.TryGetValue(target, out seen) && Time.time - seen < difficulty.reaction)
		{
			return;
		}
		Vector3 to = target.Chest - chest;
		float distance = to.magnitude;
		if (distance > Reach() || distance < 0.2f)
		{
			return;
		}
		Vector3 flat = Flat(to);
		if (Vector3.Angle(Flat(self.part["chest"].forward), flat) > difficulty.facing || AllyInTheWay(chest, to, distance))
		{
			return;
		}
		// The lunge after a punch carries the beast about a metre: not towards a drop.
		if (self.onGround && (Ledge(feet, flat.normalized, 0.6f) || Ledge(feet, flat.normalized, 1.1f)))
		{
			return;
		}
		bool left;
		if (!self.leftPunch && (leftNext || self.rightPunch))
		{
			left = true;
		}
		else if (!self.rightPunch)
		{
			left = false;
		}
		else
		{
			return;
		}
		if (left)
		{
			self.leftPunch = true;
		}
		else
		{
			self.rightPunch = true;
		}
		leftNext = !left;
		punchTimer = Range(difficulty.punchMin, difficulty.punchMax) * (beast.size > 1.1f ? 1.6f : 1f);
	}

	// An enemy close in front winding up a punch (hand not yet harmful): maybe sidestep, once per punch.
	private void Dodge(Vector3 chest, Vector3 flat)
	{
		if (enemy == null || Time.time < sidestepUntil)
		{
			return;
		}
		Player p = enemy.player;
		bool windUp = (p.leftPunch && enemy.Part("leftHand").tag != "Body Part (Harmful)") || (p.rightPunch && enemy.Part("rightHand").tag != "Body Part (Harmful)");
		if (!windUp)
		{
			dodged = null;
			return;
		}
		if (dodged == enemy || flat.magnitude > 1.8f || Vector3.Angle(Flat(enemy.Part("chest").forward), -flat) > 40f)
		{
			return;
		}
		dodged = enemy;
		if (random.NextDouble() < difficulty.dodge)
		{
			sidestep = Vector3.Cross(Vector3.up, flat.normalized) * (random.NextDouble() < 0.5 ? 1f : -1f) * 0.9f;
			sidestepUntil = Time.time + 0.35f;
		}
	}

	// Alone against several: head for the widest gap between them (and punch whoever is in front).
	private Vector3 Escape(Vector3 chest, Vector3 feet)
	{
		AIDirector d = AIDirector.instance;
		List<float> bearings = new List<float>();
		foreach (int i in d.Near(chest, 6f))
		{
			if (IsEnemy(d.beasts[i]))
			{
				Vector3 to = d.chests[i] - chest;
				bearings.Add(Mathf.Atan2(to.x, to.z) * Mathf.Rad2Deg);
			}
		}
		if (bearings.Count == 0)
		{
			return Vector3.zero;
		}
		bearings.Sort();
		float bestGap = -1f;
		float bestMid = 0f;
		for (int i = 0; i < bearings.Count; i++)
		{
			float a = bearings[i];
			float b = i + 1 < bearings.Count ? bearings[i + 1] : bearings[0] + 360f;
			if (b - a > bestGap)
			{
				bestGap = b - a;
				bestMid = (a + b) * 0.5f;
			}
		}
		Vector3 away = new Vector3(Mathf.Sin(bestMid * Mathf.Deg2Rad), 0f, Mathf.Cos(bestMid * Mathf.Deg2Rad));
		return Steer(feet, feet + away * 4f, 1f, 0.8f);
	}

	private Vector3 Follow(Vector3 feet, Beast lead)
	{
		Vector3 behind = -Flat(lead.Part("chest").forward);
		if (behind.sqrMagnitude < 0.01f)
		{
			behind = Flat(feet - Ground(lead));
		}
		// Fanned out behind the leader with the other allies.
		int index = 0;
		if (AIDirector.instance != null)
		{
			foreach (AIBrain b in AIDirector.instance.brains)
			{
				if (b != this && b.beast != null && b.beast.leader == lead && b.enemy == null && b.beast.id < beast.id)
				{
					index++;
				}
			}
		}
		float angle = (index + 1) / 2 * 40f * (index % 2 == 0 ? 1f : -1f);
		Vector3 spot = Ground(lead) + Quaternion.AngleAxis(angle, Vector3.up) * behind.normalized * 2f;
		float distance = Flat(spot - feet).magnitude;
		if (distance < 0.7f)
		{
			return Vector3.zero;
		}
		return Steer(feet, spot, Mathf.Clamp(distance / 3f, 0.4f, 1f), 0.8f);
	}

	private Vector3 Patrol(Vector3 feet)
	{
		calm = true;
		float now = Time.time;
		if (!hasPost)
		{
			post = feet;
			hasPost = true;
			restUntil = now + Range(1f, 4f);
		}
		if (now < restUntil)
		{
			return Vector3.zero;
		}
		if (!patrolling)
		{
			patrolling = true;
			Vector2 r = new Vector2(Range(-1f, 1f), Range(-1f, 1f)) * 8f;
			NavMeshHit hit;
			Vector3 p = post + new Vector3(r.x, 0f, r.y);
			wanderPoint = NavMesh.SamplePosition(p, out hit, 8f, -1) ? hit.position : p;
			wanderUntil = now + Range(6f, 10f);
		}
		if (now > wanderUntil || Flat(wanderPoint - feet).magnitude < 1f)
		{
			patrolling = false;
			restUntil = now + (random.NextDouble() < 0.25 ? Range(8f, 15f) : Range(2f, 5f));
			return Vector3.zero;
		}
		return Steer(feet, wanderPoint, 0.4f, 0.8f);
	}

	// ---------------------------------------------------------------------------------- steering

	private static Vector3 Flat(Vector3 v)
	{
		v.y = 0f;
		return v;
	}

	private float Range(float a, float b)
	{
		return a + (float)random.NextDouble() * (b - a);
	}

	// Ground under the beast's balance ball.
	public static Vector3 Ground(Beast b)
	{
		Transform ball = b.Part("ball");
		if (ball.collider == null)
		{
			return ball.position;
		}
		Bounds bounds = ball.collider.bounds;
		return new Vector3(bounds.center.x, bounds.min.y, bounds.center.z);
	}

	private float Speed()
	{
		Rigidbody hips = self.part["hips"].rigidbody;
		return hips != null ? Flat(hips.velocity).magnitude : 0f;
	}

	// A beast keeps rolling on its ball after it stops pushing: steer against the motion when a drop lies
	// within stopping distance.
	private Vector3 Brake(Vector3 feet, Vector3 desired)
	{
		Rigidbody hips = self.part["hips"].rigidbody;
		if (hips == null || !self.onGround)
		{
			return desired;
		}
		Vector3 velocity = Flat(hips.velocity);
		float speed = velocity.magnitude;
		if (speed < 0.6f)
		{
			return desired;
		}
		Vector3 heading = velocity / speed;
		if (AISensors.Drop(feet + heading * (0.4f + speed * 0.45f), 2f))
		{
			return -heading * Mathf.Clamp01(speed * 0.5f);
		}
		return desired;
	}

	private void SenseEdges(Vector3 feet)
	{
		edgeAway = Vector3.zero;
		for (int i = 0; i < 8; i++)
		{
			Vector3 direction = Quaternion.AngleAxis(i * 45f, Vector3.up) * Vector3.forward;
			if (AISensors.Drop(feet + direction * 0.9f, 2f))
			{
				edgeAway -= direction;
			}
		}
		if (edgeAway.sqrMagnitude > 1f)
		{
			edgeAway.Normalize();
		}
	}

	private static bool Ledge(Vector3 feet, Vector3 direction, float ahead)
	{
		return AISensors.Drop(feet + direction * ahead, 2f);
	}

	private Vector3 Steer(Vector3 feet, Vector3 target, float speed, float ledgeCheck)
	{
		if (Time.time < detourUntil)
		{
			target = detour;
		}
		Vector3 point = NextPoint(feet, target);
		Vector3 flat = Flat(point - feet);
		float distance = flat.magnitude;
		if (distance < 0.1f)
		{
			return Vector3.zero;
		}
		Vector3 direction = flat / distance;
		if (self.onGround)
		{
			float rise = point.y - feet.y;
			if ((rise > 0.45f && rise < 2.5f && distance < 2f) || (stuck > 0 && AISensors.LowObstacle(feet, direction)))
			{
				Jump();
			}
			else if (Ledge(feet, direction, ledgeCheck + Speed() * 0.45f))
			{
				return Vector3.zero;
			}
		}
		return direction * speed;
	}

	private Vector3 NextPoint(Vector3 feet, Vector3 target)
	{
		if (repathTimer <= 0f || ((target - pathGoal).sqrMagnitude > 1f && repathTimer < 0.3f))
		{
			repathTimer = Range(0.4f, 0.6f);
			pathGoal = target;
			corners = Plan(feet, target);
			corner = 1;
		}
		while (corner < corners.Length - 1 && Flat(corners[corner] - feet).magnitude < 0.5f)
		{
			corner++;
		}
		if (corner < corners.Length - 1)
		{
			return corners[corner];
		}
		if (partialPath && corners.Length > 0 && Flat(corners[corners.Length - 1] - feet).magnitude > 0.6f)
		{
			return corners[corners.Length - 1];
		}
		return target;
	}

	private static readonly Vector3[] noPath = new Vector3[0];

	private Vector3[] Plan(Vector3 from, Vector3 to)
	{
		partialPath = false;
		NavMeshHit start;
		NavMeshHit end;
		if (!NavMesh.SamplePosition(from, out start, 1.5f, -1) || !NavMesh.SamplePosition(to, out end, 3f, -1))
		{
			return noPath;
		}
		if (!NavMesh.CalculatePath(start.position, end.position, -1, path) || path.status == NavMeshPathStatus.PathInvalid)
		{
			return noPath;
		}
		partialPath = path.status == NavMeshPathStatus.PathPartial;
		return path.corners;
	}

	private void Jump()
	{
		if (calm || jumpCooldown > 0f || carried != null || !self.onGround || self.jumpReset > 0f || self.applyedForce < self.force * 0.5f)
		{
			return;
		}
		if (self.state != Player.State.Standing && self.state != Player.State.Running)
		{
			return;
		}
		Vector3 heading = Flat(move);
		if (heading.sqrMagnitude > 0.01f && AISensors.Drop(Ground(beast) + heading.normalized * 2f, 2f))
		{
			return;
		}
		// What Player.JumpInput does when a human presses jump.
		self.jumpReset = 0.2f;
		self.canJump = false;
		self.state = Player.State.Jumping;
		jumpCooldown = beast.size > 1.1f ? Range(2f, 3f) : Range(0.9f, 1.4f);
	}

	// Pushing on but not getting anywhere: jump, and after two tries walk somewhere else for a moment.
	private void TrackProgress(Vector3 feet, Vector3 desired, float dt)
	{
		if (desired.sqrMagnitude < (calm ? 0.1f : 0.5f) || !self.onGround)
		{
			progressTimer = 0f;
			progressFrom = feet;
			return;
		}
		progressTimer += dt;
		if (progressTimer < 1f)
		{
			return;
		}
		if (Flat(feet - progressFrom).magnitude < 0.3f)
		{
			stuck++;
			if (stuck <= 2)
			{
				calm = false;
				Jump();
			}
			else
			{
				stuck = 0;
				NavMeshHit hit;
				Vector2 r = new Vector2(Range(-1f, 1f), Range(-1f, 1f)) * 3f;
				Vector3 p = feet + new Vector3(r.x, 0f, r.y);
				detour = NavMesh.SamplePosition(p, out hit, 3f, -1) ? hit.position : p;
				detourUntil = Time.time + 1.5f;
			}
		}
		else
		{
			stuck = 0;
		}
		progressTimer = 0f;
		progressFrom = feet;
	}

	// A punch hurts whoever it lands on: hold it while a friend is near the line of the punch.
	private bool AllyInTheWay(Vector3 chest, Vector3 to, float distance)
	{
		AIDirector d = AIDirector.instance;
		if (d == null)
		{
			return false;
		}
		Vector3 along = to / distance;
		foreach (int i in d.Near(chest + along * distance * 0.5f, distance * 0.5f + 1.2f))
		{
			Beast b = d.beasts[i];
			if (!IsFriend(b) || b == enemy)
			{
				continue;
			}
			Vector3 toFriend = d.chests[i] - chest;
			float t = Vector3.Dot(toFriend, along);
			if (t > 0f && t < distance + 1f && (toFriend - along * t).magnitude < 0.9f)
			{
				return true;
			}
		}
		return false;
	}

	// A leap lands on whoever is beside it.
	private bool FriendWithin(Vector3 chest, float radius)
	{
		AIDirector d = AIDirector.instance;
		if (d == null)
		{
			return false;
		}
		foreach (int i in d.Near(chest, radius))
		{
			if (IsFriend(d.beasts[i]))
			{
				return true;
			}
		}
		return false;
	}

	// Keep a little room from friends so the gang does not pile up.
	private Vector3 Separation(Vector3 chest)
	{
		AIDirector d = AIDirector.instance;
		Vector3 push = Vector3.zero;
		if (d == null)
		{
			return push;
		}
		float room = 1.4f * beast.size;
		foreach (int i in d.Near(chest, room + 0.6f))
		{
			Beast b = d.beasts[i];
			if (!IsFriend(b))
			{
				continue;
			}
			Vector3 away = Flat(chest - d.chests[i]);
			float distance = away.magnitude;
			float want = 0.7f * (beast.size + b.size);
			if (distance > 0.01f && distance < want)
			{
				push += away / distance * (want - distance) * 1.2f;
			}
		}
		return push;
	}

	// ---------------------------------------------------------------------------------- finishing

	// A stunned enemy in reach: carry it to the nearest drop and let go there, or with no drop near, hold
	// it up while the teammates hitting it finish the job.
	private bool StartCarry(Vector3 feet)
	{
		bool drop = FindThrowSpot(feet, out throwSpot);
		if (!drop && MatesOn(enemy) == 0)
		{
			grabCooldown = 1.5f;
			return false;
		}
		carried = enemy;
		holding = !drop;
		carryStarted = Time.time;
		role = Role.Finish;
		return true;
	}

	private int MatesOn(Beast b)
	{
		int n = 0;
		if (AIDirector.instance != null)
		{
			foreach (AIBrain other in AIDirector.instance.brains)
			{
				if (other != this && other.enemy == b && other.self.gangName == self.gangName)
				{
					n++;
				}
			}
		}
		return n;
	}

	private bool TeammateCarries(Beast b)
	{
		if (AIDirector.instance != null)
		{
			foreach (AIBrain other in AIDirector.instance.brains)
			{
				if (other != this && other.carried == b && other.self.gangName == self.gangName)
				{
					return true;
				}
			}
		}
		return false;
	}

	private Vector3 Carry(Vector3 chest, Vector3 feet)
	{
		float now = Time.time;
		if (carried == null || carried.player == null || carried.player.state != Player.State.Stunned || now - carryStarted > (holding ? 4f : 8f))
		{
			EndCarry(1f);
			return Vector3.zero;
		}
		Vector3 to = Flat(carried.Chest - chest);
		self.leftGrab = !WrongGrab(self.part["leftHand"]);
		self.rightGrab = !WrongGrab(self.part["rightHand"]);
		if (!Holding(self.part["leftHand"], carried) && !Holding(self.part["rightHand"], carried))
		{
			self.leftLift = false;
			self.rightLift = false;
			if (now - carryStarted > 2f)
			{
				EndCarry(2f);
				return Vector3.zero;
			}
			// Bend down to reach a beast lying on the floor.
			self.duck = carried.Chest.y < chest.y - 0.3f;
			return to.normalized * (to.magnitude > 0.7f ? 0.5f : 0.1f);
		}
		self.leftLift = true;
		self.rightLift = true;
		if (holding)
		{
			return Vector3.zero;
		}
		float toSpot = Flat(throwSpot - feet).magnitude;
		if (toSpot < 0.5f)
		{
			// At the edge with the enemy held out over it: let go (no parting punch, whose lunge would
			// carry the thrower over too).
			EndCarry(2f);
			return Vector3.zero;
		}
		return Steer(feet, throwSpot, toSpot < 2f ? 0.35f : 0.7f, 0.3f);
	}

	private void EndCarry(float cooldown)
	{
		carried = null;
		holding = false;
		grabCooldown = cooldown;
		LetGo();
	}

	private void LetGo()
	{
		self.leftGrab = false;
		self.rightGrab = false;
		self.leftLift = false;
		self.rightLift = false;
	}

	private static bool Holding(Transform hand, Beast b)
	{
		HingeJoint joint = hand.GetComponent<HingeJoint>();
		return joint != null && joint.connectedBody != null && joint.connectedBody.transform.root == b.player.transform;
	}

	private bool WrongGrab(Transform hand)
	{
		HingeJoint joint = hand.GetComponent<HingeJoint>();
		return joint != null && (joint.connectedBody == null || joint.connectedBody.transform.root != carried.player.transform);
	}

	// The nearest edge with a fall (or a kill zone) behind it, in 16 directions up to 10 m and not through
	// walls; the spot is just short of the edge.
	private static bool FindThrowSpot(Vector3 feet, out Vector3 spot)
	{
		spot = feet;
		float best = 10f;
		bool found = false;
		for (int i = 0; i < 16; i++)
		{
			Vector3 direction = Quaternion.AngleAxis(i * 22.5f, Vector3.up) * Vector3.forward;
			float ground = 0f;
			for (float s = 0.75f; s < best; s += 0.75f)
			{
				if (AISensors.Wall(feet + direction * ground + Vector3.up * 0.6f, direction, s - ground))
				{
					break;
				}
				if (!AISensors.Drop(feet + direction * s, 4f))
				{
					ground = s;
					continue;
				}
				float lo = ground;
				float hi = s;
				for (int k = 0; k < 3; k++)
				{
					float mid = (lo + hi) * 0.5f;
					if (AISensors.Drop(feet + direction * mid, 4f))
					{
						hi = mid;
					}
					else
					{
						lo = mid;
					}
				}
				if (lo < best)
				{
					best = lo;
					spot = feet + direction * Mathf.Max(0f, lo - 0.6f);
					found = true;
				}
				break;
			}
		}
		return found;
	}
}
