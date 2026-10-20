using UnityEngine;

public class DontTrackZone : MonoBehaviour
{
	private void OnTriggerEnter(Collider collider)
	{
		if (collider.name != "targetFinder" && collider.transform.root.tag == "Player")
		{
			collider.transform.root.tag = "Player (Dont Track)";
		}
	}

	private void OnTriggerExit(Collider collider)
	{
		if (collider.name != "targetFinder" && collider.transform.root.tag == "Player (Dont Track)")
		{
			collider.transform.root.tag = "Player";
		}
	}
}
