using UnityEngine;

public class RotateAround : MonoBehaviour
{
	public GameObject rotateAroundObject;

	public float speed = 10f;

	public Vector3 axis = Vector3.up;

	private void Start()
	{
	}

	private void Update()
	{
		transform.RotateAround(rotateAroundObject.transform.position, axis, speed * Time.deltaTime);
	}
}
