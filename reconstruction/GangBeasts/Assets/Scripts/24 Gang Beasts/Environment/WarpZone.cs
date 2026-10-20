using UnityEngine;

public class WarpZone : MonoBehaviour
{
	public Vector3 offset;

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.transform.root.tag == "Player")
		{
			CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
			{
				Application.LoadLevel(Application.loadedLevel);
			});
		}
	}
}
