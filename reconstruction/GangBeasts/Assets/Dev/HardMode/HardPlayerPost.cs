using UnityEngine;

// Execution order 50: after Player.Update for Hard Mode beasts (see HardMode).
public class HardPlayerPost : MonoBehaviour
{
	private void Update()
	{
		if (HardMode.on)
		{
			HardMode.PostUpdate();
		}
	}
}
