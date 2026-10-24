using System.Collections.Generic;
using UnityEngine;

// Who fights whom. Every attacker gets one enemy it knows of: engaged (one of the enemy's few spots
// close round it) or queued (waiting a little further out until a spot frees up). Greedy on a cost
// that grows with each attacker already on an enemy, so a crowd spreads over the enemies instead of
// piling on the nearest; ties break on ids, so the result does not depend on input order.
public class TargetAssigner
{
	public struct Fighter
	{
		public int id;

		public int gang;

		public Vector3 position;

		public float size;

		// Can take part (not stunned, dead or running for help).
		public bool able;

		// Its enemy last time (sticks to it unless something is clearly better), or -1.
		public int previous;
	}

	public struct Enemy
	{
		public int id;

		public int gang;

		public Vector3 position;

		public float size;

		public bool stunned;

		public float healthShare;

		// 0, or a bonus for being on a friend (2) or on the leader (4) of the attackers' side.
		public float threat;
	}

	public struct Result
	{
		// Index into the enemies, or -1.
		public int enemy;

		public bool engaged;
	}

	// How much one more attacker on an enemy costs, in metres of extra distance.
	public float loadCost = 5f;

	// Sticking with last time's enemy is worth this many metres.
	public float stickiness = 2f;

	public int maxCandidates = 12;

	private struct Pair
	{
		public int agent;

		public int enemy;

		public float baseCost;
	}

	private readonly List<Pair> pairs = new List<Pair>();

	private float[] topCost = new float[32];

	private int[] topEnemy = new int[32];

	private int[] load = new int[0];

	private int[] capacity = new int[0];

	// Three round a normal beast: four (52 degrees apart within the 155-degree arc) hurt each other more
	// than the old brain's crowd did (ai/swarm_20v1); three stand 77 degrees apart.
	public static int Capacity(float size)
	{
		return Mathf.Clamp(Mathf.RoundToInt(3f * size * size), 2, 8);
	}

	public float Cost(Fighter a, Enemy e)
	{
		Vector3 d = e.position - a.position;
		float cost = new Vector2(d.x, d.z).magnitude + Mathf.Abs(d.y) * 2f;
		if (e.stunned)
		{
			cost -= 1.5f;
		}
		cost -= (1f - Mathf.Clamp01(e.healthShare)) * 2f;
		cost -= e.threat;
		if (a.previous == e.id)
		{
			cost -= stickiness;
		}
		return cost;
	}

	// known(agentIndex, enemyIndex): whether that attacker knows of that enemy (senses, memory, alerts).
	public delegate bool Knows(int agent, int enemy);

	public void Assign(Fighter[] agents, int agentCount, Enemy[] enemies, int enemyCount, Knows knows, Result[] results)
	{
		pairs.Clear();
		if (topCost.Length < maxCandidates)
		{
			topCost = new float[maxCandidates];
			topEnemy = new int[maxCandidates];
		}
		if (load.Length < enemyCount)
		{
			load = new int[enemyCount * 2];
			capacity = new int[enemyCount * 2];
		}
		for (int e = 0; e < enemyCount; e++)
		{
			load[e] = 0;
			capacity[e] = Capacity(enemies[e].size);
		}
		for (int a = 0; a < agentCount; a++)
		{
			results[a].enemy = -1;
			results[a].engaged = false;
			if (!agents[a].able)
			{
				continue;
			}
			// The few cheapest enemies this attacker knows of (insertion into a short sorted list: no sort
			// with a closure, nothing allocated).
			int kept = 0;
			for (int e = 0; e < enemyCount; e++)
			{
				if (enemies[e].gang == agents[a].gang || !knows(a, e))
				{
					continue;
				}
				float c = Cost(agents[a], enemies[e]);
				int at = kept;
				while (at > 0 && (c < topCost[at - 1] || (c == topCost[at - 1] && enemies[e].id < enemies[topEnemy[at - 1]].id)))
				{
					at--;
				}
				if (at >= maxCandidates)
				{
					continue;
				}
				for (int k = Mathf.Min(kept, maxCandidates - 1); k > at; k--)
				{
					topCost[k] = topCost[k - 1];
					topEnemy[k] = topEnemy[k - 1];
				}
				topCost[at] = c;
				topEnemy[at] = e;
				kept = Mathf.Min(kept + 1, maxCandidates);
			}
			for (int k = 0; k < kept; k++)
			{
				Pair p = new Pair();
				p.agent = a;
				p.enemy = topEnemy[k];
				p.baseCost = topCost[k];
				pairs.Add(p);
			}
		}
		// Repeatedly take the cheapest pair, counting the enemy's current load, until every attacker with a
		// free spot somewhere has one.
		while (true)
		{
			int best = -1;
			float bestCost = float.PositiveInfinity;
			for (int i = 0; i < pairs.Count; i++)
			{
				Pair p = pairs[i];
				if (results[p.agent].enemy >= 0 || load[p.enemy] >= capacity[p.enemy])
				{
					continue;
				}
				float cost = p.baseCost + load[p.enemy] * loadCost;
				if (best < 0 || cost < bestCost || (cost == bestCost && Before(agents, enemies, p, pairs[best])))
				{
					best = i;
					bestCost = cost;
				}
			}
			if (best < 0)
			{
				break;
			}
			results[pairs[best].agent].enemy = pairs[best].enemy;
			results[pairs[best].agent].engaged = true;
			load[pairs[best].enemy]++;
		}
		// The rest queue on their cheapest known enemy.
		for (int i = 0; i < pairs.Count; i++)
		{
			Pair p = pairs[i];
			if (results[p.agent].enemy >= 0)
			{
				continue;
			}
			bool first = true;
			for (int j = 0; j < i; j++)
			{
				if (pairs[j].agent == p.agent)
				{
					first = false;
					break;
				}
			}
			if (first)
			{
				results[p.agent].enemy = p.enemy;
				results[p.agent].engaged = false;
			}
		}
	}

	private static bool Before(Fighter[] agents, Enemy[] enemies, Pair a, Pair b)
	{
		int c = agents[a.agent].id.CompareTo(agents[b.agent].id);
		return c != 0 ? c < 0 : enemies[a.enemy].id < enemies[b.enemy].id;
	}

	public int Load(int enemy)
	{
		return load[enemy];
	}
}
