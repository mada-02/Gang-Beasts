using UnityEngine;

public class Exit : MonoBehaviour
{
	private void OnMouseEnter()
	{
		transform.localScale = new Vector3(1.2f, 1.2f, 1.2f);
	}

	private void OnMouseExit()
	{
		transform.localScale = new Vector3(1f, 1f, 1f);
	}

	private void OnMouseDown()
	{
		CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
		{
			Application.Quit();
		});
	}
}
