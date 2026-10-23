using UnityEngine;

// An ally on the game's own mob AI (Smart AI off): keeps its NavMesh agent following its leader while it
// has no one to fight, since the mob AI only sets a destination while it has a target. Uses the same
// leash as Player.FindClosestTarget: the agent only leads while the body keeps up.
public class DevFollow : MonoBehaviour
{
	private Player self;

	private Beast beast;

	private void Start()
	{
		self = GetComponent<Player>();
	}

	private void LateUpdate()
	{
		if (beast == null || beast.player == null)
		{
			beast = BeastRegistry.Find(self);
		}
		Beast leader = beast != null ? beast.leader : null;
		if (self == null || leader == null || leader.player == null || self.agent == null || !self.agent.enabled || !self.part.ContainsKey("chest"))
		{
			return;
		}
		if (self.state == Player.State.Dead || self.state == Player.State.Stunned)
		{
			return;
		}
		Vector3 chest = self.part["chest"].position;
		Player target = self.target;
		if (target != null && target.state != Player.State.Dead && target.part.ContainsKey("chest") && Vector3.Distance(target.part["chest"].position, chest) < 10f)
		{
			return;
		}
		Vector3 leaderChest = leader.Chest;
		if (Vector3.Distance(leaderChest, chest) > 3f && Vector3.Distance(self.agent.transform.position, chest) < 2f)
		{
			self.agent.SetDestination(leaderChest);
		}
		else
		{
			self.agent.SetDestination(chest);
		}
	}
}
