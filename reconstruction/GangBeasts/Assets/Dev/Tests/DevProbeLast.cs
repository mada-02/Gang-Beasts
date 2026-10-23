using UnityEngine;

// Execution order +2000 (see DevCamProbe).
public class DevProbeLast : MonoBehaviour
{
	private void FixedUpdate()
	{
		DevCamProbe.FixedLast();
	}

	private void LateUpdate()
	{
		DevCamProbe.LateLast();
	}
}
