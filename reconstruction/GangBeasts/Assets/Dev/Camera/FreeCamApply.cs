using UnityEngine;

// Execution order +1000: after SceneCamera's FixedUpdate the camera's pose is the game's (saved); last in
// LateUpdate the free pose goes on for rendering (see FreeCam).
public class FreeCamApply : MonoBehaviour
{
	private void FixedUpdate()
	{
		FreeCam.SaveGamePose();
	}

	private void LateUpdate()
	{
		FreeCam.Apply();
	}
}
