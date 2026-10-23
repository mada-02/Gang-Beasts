using UnityEngine;

// Execution order -1000: before SceneCamera's FixedUpdate and Player.Update, the camera holds the game's
// pose (see FreeCam).
public class FreeCamRestore : MonoBehaviour
{
	private void FixedUpdate()
	{
		FreeCam.Restore(true);
	}

	private void Update()
	{
		if (Input.GetKeyDown(FreeCam.toggleKey))
		{
			FreeCam.SetActive(!FreeCam.active);
		}
		FreeCam.Restore(false);
	}
}
