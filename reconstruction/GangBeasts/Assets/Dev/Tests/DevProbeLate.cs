using UnityEngine;

// Execution order +1 (see DevCamProbe).
public class DevProbeLate : MonoBehaviour
{
	private void Update()
	{
		DevCamProbe.Update();
	}
}
