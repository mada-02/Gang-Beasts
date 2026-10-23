using UnityEngine;

public enum BeastBody
{
	Normal,
	// Street's pink boss shape as in 0.0.3 / as in 0.0.2.
	Boss003,
	Boss002
}

// One live beast as the developer layer sees it: its Player plus the components every module needs,
// looked up once. Made by BeastRegistry; never kept after the beast is destroyed.
public class Beast
{
	// Registration order, for stable iteration and tie-breaks.
	public readonly int id;

	public readonly Player player;

	public readonly GameObject gameObject;

	public readonly HealthAndStamina stats;

	public readonly Movement movement;

	public readonly Jump jump;

	public readonly PunchAndGrab punch;

	public readonly Targeting targeting;

	// Made by the developer layer (AI tab, morph or a rebuild), not placed in the level.
	public bool spawned;

	public BeastBody body;

	// Size relative to a normal beast (the root's uniform scale).
	public float size = 1f;

	public Beast(int id, Player player)
	{
		this.id = id;
		this.player = player;
		gameObject = player.gameObject;
		stats = player.GetComponent<HealthAndStamina>();
		movement = player.GetComponent<Movement>();
		jump = player.GetComponent<Jump>();
		punch = player.GetComponent<PunchAndGrab>();
		Transform finder = Part("targetFinder");
		targeting = finder != null ? finder.GetComponent<Targeting>() : null;
		size = player.transform.localScale.x;
	}

	public bool Alive
	{
		get { return player != null && player.state != Player.State.Dead; }
	}

	public bool IsHuman
	{
		get { return player != null && !player.mob; }
	}

	public Transform Part(string name)
	{
		Transform t;
		return player != null && player.part.TryGetValue(name, out t) ? t : null;
	}

	public Vector3 Chest
	{
		get { return player.part["chest"].position; }
	}

	public float MaxHealth
	{
		get { return stats != null ? DevReflection.MaxHealth(stats) : 100f; }
	}

	public override string ToString()
	{
		return "#" + id + " " + (player != null ? player.name + " (" + player.gangName + ")" : "(destroyed)");
	}
}
