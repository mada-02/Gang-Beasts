using UnityEngine;

public class LookAtObject : MonoBehaviour
{
	public GameObject lookAtObject;

	private void Start()
	{
	}

	private void Update()
	{
		Camera.main.transform.LookAt(lookAtObject.transform);
	}
}
