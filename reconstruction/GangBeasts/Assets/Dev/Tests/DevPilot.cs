using UnityEngine;

// Steers a beast in tests. Writes in LateUpdate: a human's Player.Update zeroes direction every frame
// before reading its controller, so anything written earlier is lost; Movement reads it in the next
// FixedUpdate.
public class DevPilot : MonoBehaviour
{
	public Vector3 direction;

	private Player player;

	public static DevPilot On(Beast beast)
	{
		DevPilot pilot = beast.gameObject.GetComponent<DevPilot>();
		if (pilot == null)
		{
			pilot = beast.gameObject.AddComponent<DevPilot>();
		}
		return pilot;
	}

	private void LateUpdate()
	{
		if (player == null)
		{
			player = GetComponent<Player>();
		}
		player.direction = direction;
	}
}
