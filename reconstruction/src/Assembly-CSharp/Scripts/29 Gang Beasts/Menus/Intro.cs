using UnityEngine;

public class Intro : MonoBehaviour
{
	public MovieTexture movTexture;

	private bool done;

	private void Start()
	{
		renderer.enabled = false;
		renderer.material.mainTexture = movTexture;
		movTexture.Play();
		renderer.enabled = true;
		CameraFade.StartAlphaFade(Color.black, true, 1f, 0f);
	}

	private void Update()
	{
		if (!done && (!movTexture.isPlaying || Input.anyKey))
		{
			MonoBehaviour.print("Done");
			done = true;
			CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
			{
				Application.LoadLevel("Menu");
			});
		}
	}
}
