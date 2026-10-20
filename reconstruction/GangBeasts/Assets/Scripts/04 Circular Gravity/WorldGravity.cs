using UnityEngine;

public class WorldGravity : MonoBehaviour
{
	public Vector3 worldGravity = new Vector3(0f, 0f, 0f);

	private void Start()
	{
		Physics.gravity = worldGravity;
	}

	private void Update()
	{
	}
}
