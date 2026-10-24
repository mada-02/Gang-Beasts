using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

// TEST BASELINE ONLY: the additional branch's Smart AI (DevMenuBrain, commit bd3a380) with only the class
// renamed, so the new AI can be measured against it. Not used by the dev menu.

// Smarter AI for a mob beast, added by DevMenu to the AI it spawns (and to level mobs when asked).
// Player's own mob AI (Player.Update) only notices enemies within 10 m in front of it, punches from
// 0.5-1 m after a random 0.05-0.55 s delay, never jumps or grabs, and stands still without a target.
// This runs in LateUpdate, after Player.Update, and overwrites what that AI wrote before Movement,
// Jump and PunchAndGrab read it in the next FixedUpdate: move direction, punches, grabs, jumps and
// taunts. It plans its own NavMesh paths (walking straight where there are none), so the beast's
// agent, which Player.FindClosestTarget keeps steering, is left alone.
public class OldBrain : MonoBehaviour
{
	// Ally P1: stays near this player and defends it.
	public Player leader;

	// Pink Boss: slower, heavier punches and fewer jumps.
	public bool heavy;

	private const float HearRange = 8f;

	private const float SightRange = 30f;

	private const float MemoryTime = 8f;

	// How far a shout carries. Only enemies a beast senses itself are passed on, so news spreads
	// mate to mate as fast as they can walk, not across the whole level in one think.
	private const float AlertRange = 8f;

	// Enemies and friends this close count when weighing up a fight.
	private const float FightRange = 6f;

	// How far a beast that is losing will run to fetch help.
	private const float CallRange = 40f;

	private const float PunchReach = 1.45f;

	private const float LeaderLeash = 12f;

	// A punch strikes from 0.2 to 0.4 s and only ends at 0.6 s (PunchAndGrab, whose timers are
	// private). The brain cuts the follow-through short so the hand is ready again sooner.
	private static readonly FieldInfo leftTimerField = typeof(PunchAndGrab).GetField("leftTimer", BindingFlags.NonPublic | BindingFlags.Instance);

	private static readonly FieldInfo rightTimerField = typeof(PunchAndGrab).GetField("rightTimer", BindingFlags.NonPublic | BindingFlags.Instance);

	// HealthAndStamina.Start stores the beast's starting health here (0 until Start runs).
	private static readonly FieldInfo maxHealthField = typeof(HealthAndStamina).GetField("maxHealth", BindingFlags.NonPublic | BindingFlags.Instance);

	private static readonly List<OldBrain> brains = new List<OldBrain>();

	private static readonly List<Player> beasts = new List<Player>();

	private static float beastsTime = float.NegativeInfinity;

	private static readonly List<OldBrain> team = new List<OldBrain>();

	private static readonly List<Player> forget = new List<Player>();

	private static readonly Vector3[] noPath = new Vector3[0];

	private Player self;

	private HealthAndStamina stats;

	private PunchAndGrab punchAndGrab;

	private NavMeshPath path;

	private Player enemy;

	// Enemies this beast knows about (seen, heard, hit by, or told of by a teammate) and when.
	private readonly Dictionary<Player, float> known = new Dictionary<Player, float>();

	// The ones it saw, heard or was hit by itself, and when: only these are passed on to teammates.
	private readonly Dictionary<Player, float> sensed = new Dictionary<Player, float>();

	// Outnumbered or badly hurt: running to the nearest free teammate, shouting for help.
	private bool fleeing;

	private float fleeStarted;

	private float fleeCooldown;

	private OldBrain helper;

	private Vector3 threatCentre;

	private float fullHealth;

	private Vector3 lastSeen;

	private float lastSeenTime = float.NegativeInfinity;

	private Player revenge;

	private float revengeUntil;

	private float lastHealth;

	private float thinkTimer;

	private float slotAngle;

	private Vector3 slotReference;

	private Vector3[] corners = noPath;

	private int corner;

	private bool partialPath;

	private Vector3 pathGoal;

	private float repathTimer;

	private Vector3 move;

	// Away from the drops around the beast, sampled each think.
	private Vector3 edgeAway;

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

	private Player carried;

	private bool holding;

	private float carryStarted;

	private Vector3 throwSpot;

	private float grabCooldown;

	private Vector3 wanderPoint;

	private float wanderUntil;

	// Idle beasts patrol round a post (where they first went idle), resting between spots.
	private Vector3 post;

	private bool hasPost;

	private bool patrolling;

	private float restUntil;

	// Set while patrolling: no jumping about.
	private bool calm;

	private void Awake()
	{
		self = GetComponent<Player>();
		stats = GetComponent<HealthAndStamina>();
		punchAndGrab = GetComponent<PunchAndGrab>();
		path = new NavMeshPath();
		thinkTimer = Random.Range(0f, 0.25f);
		leftNext = Random.value < 0.5f;
		if (stats != null)
		{
			lastHealth = stats.health;
			fullHealth = stats.health;
		}
	}

	private void OnEnable()
	{
		brains.Add(this);
	}

	private void OnDisable()
	{
		brains.Remove(this);
		carried = null;
		holding = false;
		enemy = null;
		fleeing = false;
		helper = null;
		if (self != null)
		{
			// Hand the beast back to Player's own AI.
			LetGo();
			self.taunt = false;
			self.punchRetriggerDelay = 0f;
		}
	}

	private void LateUpdate()
	{
		if (self == null || !self.part.ContainsKey("ball") || self.state == Player.State.Dead)
		{
			return;
		}
		float dt = Time.deltaTime;
		Tick(dt);
		// Keeps Player's own punch trigger (targetInRange + punchRetriggerDelay) from firing.
		self.punchRetriggerDelay = 1f;
		self.targetInRange = false;
		// Player.Update has already dropped every grab and punch.
		if (self.state == Player.State.Stunned)
		{
			carried = null;
			holding = false;
			move = Vector3.zero;
			return;
		}
		Vector3 chest = self.part["chest"].position;
		Vector3 feet = Ground(self);
		NoticeDamage(chest);
		thinkTimer -= dt;
		if (thinkTimer <= 0f)
		{
			thinkTimer = Random.Range(0.2f, 0.3f);
			Think(chest);
			SenseEdges(feet);
		}
		Vector3 desired = Act(chest, feet);
		if (carried == null)
		{
			desired += Separation(chest) + edgeAway * 0.7f;
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
		self.target = enemy;
		self.taunt = Time.time < tauntUntil && enemy == null && carried == null;
		ShortenPunches();
		TrackProgress(feet, desired, dt);
	}

	private void Tick(float dt)
	{
		jumpCooldown -= dt;
		punchTimer -= dt;
		grabCooldown -= dt;
		repathTimer -= dt;
		// A jump only ends when a part lands on something (CollisionEvent.GroundCheck); if that
		// landing was missed the beast stays "Jumping" and flops about instead of walking.
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

	// Every beast in the level, refreshed twice a second and shared by all brains. Entries can be
	// destroyed in between, so callers skip nulls.
	private static List<Player> Beasts()
	{
		if (Time.time - beastsTime > 0.5f || Time.time < beastsTime)
		{
			beastsTime = Time.time;
			beasts.Clear();
			foreach (Object o in Object.FindObjectsOfType(typeof(Player)))
			{
				Player p = (Player)o;
				if (p.part.ContainsKey("chest") && p.part.ContainsKey("ball"))
				{
					beasts.Add(p);
				}
			}
		}
		return beasts;
	}

	private bool IsEnemy(Player p)
	{
		// Beasts tagged "Player (Dont Track)" are falling out of the level; dead ones are untagged.
		return p != null && p != self && p.gangName != self.gangName && p.state != Player.State.Dead && p.CompareTag("Player");
	}

	private bool IsFriend(Player p)
	{
		return p != null && p != self && p.gangName == self.gangName && p.state != Player.State.Dead;
	}

	private bool IsTeammate(OldBrain b)
	{
		return b != this && b.self != null && b.self.gangName == self.gangName && b.self.state != Player.State.Dead && b.self.part.ContainsKey("chest");
	}

	private Player Leader()
	{
		if (leader != null && leader.state != Player.State.Dead && leader.part.ContainsKey("chest"))
		{
			return leader;
		}
		return null;
	}

	// Ground under the beast's balance ball.
	private static Vector3 Ground(Player p)
	{
		Transform ball = p.part["ball"];
		if (ball.collider == null)
		{
			return ball.position;
		}
		Bounds bounds = ball.collider.bounds;
		return new Vector3(bounds.center.x, bounds.min.y, bounds.center.z);
	}

	private static Vector3 Flat(Vector3 v)
	{
		v.y = 0f;
		return v;
	}

	// Horizontal speed of the body: a beast rolls on a while after it stops pushing.
	private float Speed()
	{
		Rigidbody hips = self.part["hips"].rigidbody;
		return hips != null ? Flat(hips.velocity).magnitude : 0f;
	}

	// Beasts keep rolling on their balance ball, and simply letting go of the stick near an edge
	// still carried them over it. Steer against the motion when a drop lies within stopping distance.
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
		if (Drop(feet + heading * (0.4f + speed * 0.45f), 2f))
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
			if (Drop(feet + direction * 0.9f, 2f))
			{
				edgeAway -= direction;
			}
		}
		if (edgeAway.sqrMagnitude > 1f)
		{
			edgeAway.Normalize();
		}
	}

	// Share of its own starting health a beast has left: Street's mobs start at 50 and the pink boss
	// at 200, so measured against 100 a fresh mob looked half beaten and a hurt boss untouched.
	private static float HealthLeft(HealthAndStamina stats)
	{
		float full = maxHealthField != null ? (float)maxHealthField.GetValue(stats) : 0f;
		return Mathf.Clamp01(stats.health / (full > 0f ? full : 100f));
	}

	private static float SignedAngle(Vector3 from, Vector3 to)
	{
		float angle = Vector3.Angle(from, to);
		return Vector3.Cross(from, to).y < 0f ? -angle : angle;
	}

	// Level geometry: not a trigger and not part of any beast.
	private static bool Solid(Collider c)
	{
		return !c.isTrigger && c.transform.root.GetComponent<Player>() == null;
	}

	private void Think(Vector3 chest)
	{
		float now = Time.time;
		if (enemy != null && enemy.state == Player.State.Dead)
		{
			// Our enemy just went down: gloat for a moment if we were in on it.
			if (Vector3.Distance(enemy.part["chest"].position, chest) < 4f)
			{
				tauntUntil = now + 3.5f;
			}
			enemy = null;
		}
		Player lead = Leader();
		Player best = null;
		float bestScore = float.PositiveInfinity;
		foreach (Player p in Beasts())
		{
			if (!IsEnemy(p))
			{
				continue;
			}
			Vector3 pc = p.part["chest"].position;
			float distance = Vector3.Distance(pc, chest);
			if (distance < HearRange || (distance < SightRange && CanSee(pc)))
			{
				known[p] = now;
				sensed[p] = now;
			}
			float seen;
			if (!known.TryGetValue(p, out seen) || now - seen > MemoryTime)
			{
				continue;
			}
			// An ally stays with its leader: it only takes on enemies near the leader, or on top of itself.
			if (lead != null && distance > 3f && Vector3.Distance(pc, lead.part["chest"].position) > LeaderLeash)
			{
				continue;
			}
			float score = distance;
			if (p == enemy)
			{
				score -= 2f;
			}
			if (p == revenge && now < revengeUntil)
			{
				score -= 3f;
			}
			if (p.state == Player.State.Stunned)
			{
				score -= 1.5f;
			}
			HealthAndStamina health = p.GetComponent<HealthAndStamina>();
			if (health != null)
			{
				score -= (1f - HealthLeft(health)) * 2f;
			}
			score -= ThreatToFriends(pc, lead);
			// Two on one is plenty while other enemies are about.
			score += Mathf.Max(0, MatesOn(p) - 1) * 2.5f;
			if (score < bestScore)
			{
				bestScore = score;
				best = p;
			}
		}
		enemy = best;
		WeighUp(chest, now);
		if (fleeing)
		{
			enemy = null;
			tauntUntil = 0f;
			Shout(chest);
			// Close enough to the helper that it heard: turn and fight alongside it.
			if (helper != null && Vector3.Distance(helper.self.part["chest"].position, chest) < AlertRange * 0.75f)
			{
				StopFleeing(now);
			}
		}
		else if (enemy != null)
		{
			tauntUntil = 0f;
			if (Sensed(enemy, now))
			{
				Alert(enemy, chest);
			}
		}
		AssignSlot(chest, lead);
		Forget(now);
	}

	private bool Sensed(Player p, float now)
	{
		float when;
		return sensed.TryGetValue(p, out when) && now - when < 0.5f;
	}

	// Count the enemies on this beast against the friends beside it. Clearly outnumbered, or
	// outnumbered and badly hurt, it breaks off and runs for help; it comes back once help is
	// near, it has got clear and recovered, or after a while.
	private void WeighUp(Vector3 chest, float now)
	{
		int threats = 0;
		Vector3 centre = Vector3.zero;
		foreach (KeyValuePair<Player, float> item in known)
		{
			Player p = item.Key;
			if (!IsEnemy(p) || p.state == Player.State.Stunned || now - item.Value > 2f)
			{
				continue;
			}
			Vector3 pc = p.part["chest"].position;
			if (Vector3.Distance(pc, chest) < FightRange)
			{
				threats++;
				centre += pc;
			}
		}
		int friends = 1;
		foreach (Player f in Beasts())
		{
			if (IsFriend(f) && Vector3.Distance(f.part["chest"].position, chest) < FightRange)
			{
				OldBrain b = f.GetComponent<OldBrain>();
				if (b == null || !b.enabled || !b.fleeing)
				{
					friends++;
				}
			}
		}
		if (threats > 0)
		{
			threatCentre = centre / threats;
		}
		float hp = stats != null && fullHealth > 0f ? stats.health / fullHealth : 1f;
		bool overwhelmed = threats >= friends + 2 || (threats >= friends && hp < 0.35f);
		if (fleeing)
		{
			float fled = now - fleeStarted;
			if (fled > 8f || (fled > 2f && !overwhelmed && (threats == 0 || hp > 0.6f)))
			{
				StopFleeing(now);
				return;
			}
			helper = FindHelper(chest);
		}
		else if (overwhelmed && now > fleeCooldown && carried == null)
		{
			fleeing = true;
			fleeStarted = now;
			helper = FindHelper(chest);
		}
	}

	private void StopFleeing(float now)
	{
		fleeing = false;
		helper = null;
		// Stand and fight a while before thinking of running again.
		fleeCooldown = now + 5f;
	}

	// The nearest teammate not already in this fight, preferring one with nothing else to do.
	private OldBrain FindHelper(Vector3 chest)
	{
		OldBrain best = null;
		float bestScore = float.PositiveInfinity;
		foreach (OldBrain b in brains)
		{
			if (!IsTeammate(b) || b.fleeing)
			{
				continue;
			}
			float distance = Vector3.Distance(b.self.part["chest"].position, chest);
			if (distance < FightRange || distance > CallRange)
			{
				continue;
			}
			float score = distance + (b.enemy != null ? 10f : 0f);
			if (score < bestScore)
			{
				bestScore = score;
				best = b;
			}
		}
		return best;
	}

	// Call out every enemy close by to the teammates within earshot.
	private void Shout(Vector3 chest)
	{
		foreach (KeyValuePair<Player, float> item in known)
		{
			if (IsEnemy(item.Key) && Vector3.Distance(item.Key.part["chest"].position, chest) < 12f)
			{
				Alert(item.Key, chest);
			}
		}
	}

	private bool CanSee(Vector3 point)
	{
		Vector3 eye = self.part["head"].position;
		Vector3 to = point - eye;
		foreach (RaycastHit hit in Physics.RaycastAll(eye, to.normalized, to.magnitude))
		{
			if (Solid(hit.collider))
			{
				return false;
			}
		}
		return true;
	}

	// Enemies close to a friend, and above all to the leader, come first.
	private float ThreatToFriends(Vector3 enemyChest, Player lead)
	{
		float bonus = 0f;
		foreach (Player f in Beasts())
		{
			if (IsFriend(f) && Vector3.Distance(f.part["chest"].position, enemyChest) < 2.5f)
			{
				bonus = Mathf.Max(bonus, f == lead ? 4f : 2f);
			}
		}
		return bonus;
	}

	private int MatesOn(Player p)
	{
		int count = 0;
		foreach (OldBrain b in brains)
		{
			if (b.enemy == p && IsTeammate(b))
			{
				count++;
			}
		}
		return count;
	}

	// Tell teammates nearby about an enemy, so they join in even if they cannot see it.
	private void Alert(Player p, Vector3 chest)
	{
		float now = Time.time;
		foreach (OldBrain b in brains)
		{
			if (IsTeammate(b) && Vector3.Distance(b.self.part["chest"].position, chest) < AlertRange)
			{
				b.known[p] = now;
			}
		}
	}

	// Teammates on the same enemy take spots spread around it instead of queueing behind each
	// other, but not straight across from each other, where a punch that misses (or the lunge
	// after it) lands on the teammate. Allies with no enemy fan out behind their leader.
	private void AssignSlot(Vector3 chest, Player lead)
	{
		slotAngle = 0f;
		slotReference = Vector3.zero;
		team.Clear();
		if (enemy == null)
		{
			if (lead == null)
			{
				return;
			}
			int index = 0;
			foreach (OldBrain b in brains)
			{
				if (b != this && b.enemy == null && b.Leader() == lead && b.GetInstanceID() < GetInstanceID())
				{
					index++;
				}
			}
			slotAngle = (index + 1) / 2 * 40f * (index % 2 == 0 ? 1f : -1f);
			return;
		}
		Vector3 ec = enemy.part["chest"].position;
		Vector3 centre = Vector3.zero;
		foreach (OldBrain b in brains)
		{
			if (b.enemy == enemy && (b == this || IsTeammate(b)))
			{
				team.Add(b);
				centre += b.self.part["chest"].position;
			}
		}
		slotReference = Flat(chest - ec);
		if (team.Count < 2)
		{
			return;
		}
		Vector3 reference = Flat(centre / team.Count - ec);
		if (reference.sqrMagnitude < 0.01f)
		{
			reference = slotReference;
		}
		team.Sort((a, b) => SignedAngle(reference, Flat(a.self.part["chest"].position - ec)).CompareTo(SignedAngle(reference, Flat(b.self.part["chest"].position - ec))));
		int n = team.Count;
		float spread = n == 2 ? 100f : Mathf.Min(100f, 220f / (n - 1));
		slotAngle = (team.IndexOf(this) - (n - 1) * 0.5f) * spread;
		slotReference = reference;
	}

	private void Forget(float now)
	{
		forget.Clear();
		foreach (KeyValuePair<Player, float> item in known)
		{
			if (item.Key == null || item.Key.state == Player.State.Dead || now - item.Value > MemoryTime)
			{
				forget.Add(item.Key);
			}
		}
		foreach (Player p in forget)
		{
			known.Remove(p);
			sensed.Remove(p);
		}
	}

	// Hit by someone: hit back, and call nearby teammates over.
	private void NoticeDamage(Vector3 chest)
	{
		if (stats == null)
		{
			return;
		}
		// The level sets starting health after the beast wakes (Pink Boss: 200).
		fullHealth = Mathf.Max(fullHealth, stats.health);
		if (stats.health < lastHealth - 1f)
		{
			Player attacker = null;
			float nearest = 2.5f;
			foreach (Player p in Beasts())
			{
				if (IsEnemy(p) && p.state != Player.State.Stunned)
				{
					float distance = Vector3.Distance(p.part["chest"].position, chest);
					if (distance < nearest)
					{
						nearest = distance;
						attacker = p;
					}
				}
			}
			if (attacker != null)
			{
				revenge = attacker;
				revengeUntil = Time.time + 4f;
				known[attacker] = Time.time;
				sensed[attacker] = Time.time;
				Alert(attacker, chest);
				if (enemy == null && !fleeing)
				{
					thinkTimer = 0f;
				}
			}
		}
		lastHealth = stats.health;
	}

	private Vector3 Act(Vector3 chest, Vector3 feet)
	{
		calm = false;
		if (carried != null)
		{
			return Carry(chest, feet);
		}
		LetGo();
		if (fleeing)
		{
			return Flee(chest, feet);
		}
		if (enemy != null)
		{
			return Fight(chest, feet);
		}
		if (Time.time < tauntUntil)
		{
			return Vector3.zero;
		}
		Player lead = Leader();
		if (lead != null)
		{
			return Follow(feet, lead);
		}
		return Search(feet);
	}

	private Vector3 Fight(Vector3 chest, Vector3 feet)
	{
		Vector3 to = enemy.part["chest"].position - chest;
		Vector3 flat = Flat(to);
		float distance = to.magnitude;
		Vector3 enemyGround = Ground(enemy);
		lastSeen = enemyGround;
		lastSeenTime = Time.time;
		if (enemy.state == Player.State.Stunned && distance < 1.3f && grabCooldown <= 0f && !TeammateCarries(enemy) && StartCarry(feet))
		{
			return Carry(chest, feet);
		}
		// An enemy going over an edge is left to fall: following it, or even punching it (a punch
		// lunges the whole body after the fist), took the AI over too.
		if (distance < 3f && enemyGround.y < feet.y - 0.5f && Drop(new Vector3(enemyGround.x, feet.y, enemyGround.z), 2f))
		{
			return Vector3.zero;
		}
		Punch(chest, feet, to, distance);
		if (distance < 2.2f)
		{
			// In reach: face the enemy and keep pressing in, stepping round a teammate in the way.
			Vector3 press = flat.normalized * (distance > 1.1f ? 0.8f : 0.35f);
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
		Vector3 reference = slotReference.sqrMagnitude > 0.01f ? slotReference.normalized : -flat.normalized;
		Vector3 spot = enemyGround + Quaternion.AngleAxis(slotAngle, Vector3.up) * reference * 1.2f;
		Vector3 direction = Steer(feet, spot, 1f, 0.8f);
		// Now and then leap at an enemy just out of reach.
		if (distance < 3.2f && enemy.state != Player.State.Stunned && Vector3.Angle(Flat(self.part["chest"].forward), flat) < 30f && Random.value < Time.deltaTime * (heavy ? 0.2f : 0.7f))
		{
			Jump();
		}
		return direction;
	}

	private void Punch(Vector3 chest, Vector3 feet, Vector3 to, float distance)
	{
		if (punchTimer > 0f || distance > PunchReach || distance < 0.2f)
		{
			return;
		}
		Vector3 flat = Flat(to);
		if (Vector3.Angle(Flat(self.part["chest"].forward), flat) > 65f || AllyInTheWay(chest, to, distance))
		{
			return;
		}
		// The lunge after a punch carries the beast about a metre: not towards a drop.
		if (self.onGround && (Ledge(feet, flat.normalized, 0.6f) || Ledge(feet, flat.normalized, 1.1f)))
		{
			return;
		}
		// Alternate hands, using whichever is free.
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
		punchTimer = heavy ? Random.Range(0.25f, 0.4f) : Random.Range(0.12f, 0.2f);
	}

	private void ShortenPunches()
	{
		if (heavy || punchAndGrab == null || leftTimerField == null || rightTimerField == null)
		{
			return;
		}
		if (self.leftPunch)
		{
			ShortenPunch(leftTimerField);
		}
		if (self.rightPunch)
		{
			ShortenPunch(rightTimerField);
		}
	}

	private void ShortenPunch(FieldInfo timer)
	{
		float t = (float)timer.GetValue(punchAndGrab);
		if (t > 0.45f && t < 0.6f)
		{
			timer.SetValue(punchAndGrab, 0.6f);
		}
	}

	// A punch hurts whoever it lands on, so hold it while a friend is near the line of the punch,
	// in front of the enemy or just behind it.
	private bool AllyInTheWay(Vector3 chest, Vector3 to, float distance)
	{
		Vector3 along = to / distance;
		foreach (Player p in Beasts())
		{
			if (!IsFriend(p) || p == enemy)
			{
				continue;
			}
			Vector3 toFriend = p.part["chest"].position - chest;
			float t = Vector3.Dot(toFriend, along);
			if (t > 0f && t < distance + 1f && (toFriend - along * t).magnitude < 0.7f)
			{
				return true;
			}
		}
		return false;
	}

	// Keep a little room from friends so the gang does not pile up or block each other's punches.
	private Vector3 Separation(Vector3 chest)
	{
		Vector3 push = Vector3.zero;
		foreach (Player p in Beasts())
		{
			if (!IsFriend(p))
			{
				continue;
			}
			Vector3 away = Flat(chest - p.part["chest"].position);
			float d = away.magnitude;
			if (d > 0.01f && d < 1.4f)
			{
				push += away / d * (1.4f - d) * 1.2f;
			}
		}
		return push;
	}

	// Run to the helper (an ally to its leader), or with nobody to fetch, just away from the enemies.
	private Vector3 Flee(Vector3 chest, Vector3 feet)
	{
		if (helper != null && helper.self != null)
		{
			return Steer(feet, Ground(helper.self), 1f, 0.8f);
		}
		Player lead = Leader();
		if (lead != null)
		{
			return Steer(feet, Ground(lead), 1f, 0.8f);
		}
		Vector3 away = Flat(chest - threatCentre);
		if (away.sqrMagnitude < 0.01f)
		{
			away = -Flat(self.part["chest"].forward);
		}
		return Steer(feet, feet + away.normalized * 4f, 1f, 0.8f);
	}

	// Keep a spot behind the leader, fanned out with the other allies.
	private Vector3 Follow(Vector3 feet, Player lead)
	{
		Vector3 behind = -Flat(lead.part["chest"].forward);
		if (behind.sqrMagnitude < 0.01f)
		{
			behind = Flat(feet - Ground(lead));
		}
		Vector3 spot = Ground(lead) + Quaternion.AngleAxis(slotAngle, Vector3.up) * behind.normalized * 2f;
		float distance = Flat(spot - feet).magnitude;
		if (distance < 0.7f)
		{
			return Vector3.zero;
		}
		return Steer(feet, spot, Mathf.Clamp(distance / 3f, 0.4f, 1f), 0.8f);
	}

	// No enemy in mind: check where one was last seen, else patrol. Enemies elsewhere in the level
	// go unknown until one is seen, heard or reported by a teammate.
	private Vector3 Search(Vector3 feet)
	{
		float now = Time.time;
		if (now - lastSeenTime < 10f)
		{
			if (Flat(lastSeen - feet).magnitude > 1.5f)
			{
				return Steer(feet, lastSeen, 0.8f, 0.8f);
			}
			lastSeenTime = float.NegativeInfinity;
		}
		return Patrol(feet, now);
	}

	// Nothing to go on: stroll between spots around where the beast first went idle, standing a
	// few seconds at each (now and then a long rest), and never jumping.
	private Vector3 Patrol(Vector3 feet, float now)
	{
		calm = true;
		if (!hasPost)
		{
			post = feet;
			hasPost = true;
			restUntil = now + Random.Range(1f, 4f);
		}
		if (now < restUntil)
		{
			return Vector3.zero;
		}
		if (!patrolling)
		{
			patrolling = true;
			wanderPoint = RandomPoint(post, 8f);
			wanderUntil = now + Random.Range(6f, 10f);
		}
		if (now > wanderUntil || Flat(wanderPoint - feet).magnitude < 1f)
		{
			patrolling = false;
			restUntil = now + (Random.value < 0.25f ? Random.Range(8f, 15f) : Random.Range(2f, 5f));
			return Vector3.zero;
		}
		return Steer(feet, wanderPoint, 0.4f, 0.8f);
	}

	// Direction to walk towards target: along a NavMesh path when there is one, straight otherwise.
	// Jumps over knee-high obstacles and up to higher ground, and will not walk off a ledge.
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
			if ((rise > 0.45f && rise < 2.5f && distance < 2f) || LowObstacle(feet, direction))
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
			repathTimer = Random.Range(0.4f, 0.6f);
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
		// A partial path ends as close as the NavMesh gets; walk there before heading off it.
		if (partialPath && corners.Length > 0 && Flat(corners[corners.Length - 1] - feet).magnitude > 0.6f)
		{
			return corners[corners.Length - 1];
		}
		// Otherwise the last corner is the target snapped onto the NavMesh: aim at the real one.
		return target;
	}

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

	private static Vector3 RandomPoint(Vector3 around, float radius)
	{
		Vector2 r = Random.insideUnitCircle * radius;
		Vector3 point = around + new Vector3(r.x, 0f, r.y);
		NavMeshHit hit;
		if (NavMesh.SamplePosition(point, out hit, radius, -1))
		{
			return hit.position;
		}
		return point;
	}

	private static bool Ledge(Vector3 feet, Vector3 direction, float ahead)
	{
		return Drop(feet + direction * ahead, 2f);
	}

	// No solid ground within depth below a ground-level point, or a kill zone before it, or
	// spinning machinery (Grind's grinders), which is no footing: it drags beasts down into it.
	internal static bool Drop(Vector3 point, float depth)
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

	// Something knee-high ahead with room above it: worth jumping onto or over.
	private static bool LowObstacle(Vector3 feet, Vector3 direction)
	{
		return Wall(feet + Vector3.up * 0.3f, direction, 0.6f) && !Wall(feet + Vector3.up * 1.4f, direction, 0.9f);
	}

	// A steep solid surface (not a walkable slope) within distance.
	private static bool Wall(Vector3 from, Vector3 direction, float distance)
	{
		foreach (RaycastHit hit in Physics.RaycastAll(from, direction, distance))
		{
			if (hit.normal.y < 0.5f && Solid(hit.collider))
			{
				return true;
			}
		}
		return false;
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
		// Never leap towards a drop.
		Vector3 heading = Flat(move);
		if (heading.sqrMagnitude > 0.01f && Drop(Ground(self) + heading.normalized * 2f, 2f))
		{
			return;
		}
		// What Player.JumpInput does when a human presses jump.
		self.jumpReset = 0.2f;
		self.canJump = false;
		self.state = Player.State.Jumping;
		jumpCooldown = heavy ? Random.Range(2f, 3f) : Random.Range(0.9f, 1.4f);
	}

	// Pushing on but not getting anywhere: jump, and after two tries walk somewhere else for a moment.
	private void TrackProgress(Vector3 feet, Vector3 desired, float dt)
	{
		// Patrols walk slowly; in a fight a gentle press against the enemy is not being stuck.
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
				// Even a patrolling beast jumps to get unstuck.
				calm = false;
				Jump();
			}
			else
			{
				stuck = 0;
				detour = RandomPoint(feet, 3f);
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

	// A stunned enemy in reach: grab it and carry it to the nearest drop to throw it off the level
	// (in most levels players only die in kill zones), or with no drop nearby, hold it up while the
	// teammates hitting it finish the job.
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
		return true;
	}

	private Vector3 Carry(Vector3 chest, Vector3 feet)
	{
		float now = Time.time;
		if (carried == null || carried.state != Player.State.Stunned || now - carryStarted > (holding ? 4f : 8f))
		{
			EndCarry(1f);
			return Vector3.zero;
		}
		Vector3 to = Flat(carried.part["chest"].position - chest);
		// Let go of anything else a hand closed on (the floor, a prop), then reach again.
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
			// Bend down to reach a beast lying on the floor (Player.Update clears duck each frame).
			self.duck = carried.part["chest"].position.y < chest.y - 0.3f;
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
			// At the edge, with the enemy held out over it: let go. No parting punch, whose lunge
			// would carry the thrower over as well.
			EndCarry(2f);
			return Vector3.zero;
		}
		// Slow down for the last stretch so the beast stops at the spot instead of rolling past it.
		return Steer(feet, throwSpot, toSpot < 2f ? 0.35f : 0.7f, 0.3f);
	}

	private bool TeammateCarries(Player p)
	{
		foreach (OldBrain b in brains)
		{
			if (b.carried == p && IsTeammate(b))
			{
				return true;
			}
		}
		return false;
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

	private static bool Holding(Transform hand, Player p)
	{
		HingeJoint joint = hand.GetComponent<HingeJoint>();
		return joint != null && joint.connectedBody != null && joint.connectedBody.transform.root == p.transform.root;
	}

	private bool WrongGrab(Transform hand)
	{
		HingeJoint joint = hand.GetComponent<HingeJoint>();
		return joint != null && (joint.connectedBody == null || joint.connectedBody.transform.root != carried.transform.root);
	}

	// The nearest edge with a fall (or a kill zone) behind it, looking in 16 directions up to 10 m
	// and not through walls or railings. The spot is just short of the edge.
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
				if (Wall(feet + direction * ground + Vector3.up * 0.6f, direction, s - ground))
				{
					break;
				}
				if (!Drop(feet + direction * s, 4f))
				{
					ground = s;
					continue;
				}
				float lo = ground;
				float hi = s;
				for (int k = 0; k < 3; k++)
				{
					float mid = (lo + hi) * 0.5f;
					if (Drop(feet + direction * mid, 4f))
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
