using UnityEngine;

// Execution order -50: before Player.Update for Hard Mode beasts (see HardMode).
public class HardPlayerPre : MonoBehaviour
{
	private void Update()
	{
		if (HardMode.on)
		{
			HardMode.PreUpdate();
		}
	}
}
