using UnityEngine;

// Execution order -1 (see DevCamProbe).
public class DevProbeEarly : MonoBehaviour
{
	private void FixedUpdate()
	{
		DevCamProbe.FixedEarly();
	}

	private void Update()
	{
		DevCamProbe.Update();
	}
}
