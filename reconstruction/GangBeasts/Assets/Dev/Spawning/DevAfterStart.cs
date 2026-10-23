using UnityEngine;

// Finishes a rebuilt beast once the game's own Start has run (execution order +100): HealthAndStamina.Start
// takes the current health as the maximum, so the health share and stun are set only afterwards.
public class DevAfterStart : MonoBehaviour
{
	public float healthShare = 1f;

	public float stunTimer;

	public bool stunned;

	private void Start()
	{
		HealthAndStamina stats = GetComponent<HealthAndStamina>();
		Player player = GetComponent<Player>();
		if (stats != null)
		{
			stats.health = DevReflection.MaxHealth(stats) * healthShare;
			stats.stamina = stats.health;
			if (stunTimer > 0f)
			{
				DevReflection.SetStunTimer(stats, stunTimer);
			}
		}
		if (stunned && player != null)
		{
			player.state = Player.State.Stunned;
		}
		Destroy(this);
	}
}
