using UnityEngine;

// Marker on every registered beast: tells the registry when the beast is destroyed, by any code.
public class DevBeast : MonoBehaviour
{
	public Beast beast;

	private void OnDestroy()
	{
		BeastRegistry.Forget(this);
	}
}
