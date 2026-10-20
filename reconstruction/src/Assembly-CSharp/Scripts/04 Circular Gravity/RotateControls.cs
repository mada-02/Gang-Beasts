using UnityEngine;

public class RotateControls : MonoBehaviour
{
	public float speed = 50f;

	private void Start()
	{
	}

	private void Update()
	{
		transform.rotation = transform.localRotation;
		float axis = Input.GetAxis("Horizontal");
		float axis2 = Input.GetAxis("Vertical");
		if (axis != 0f)
		{
			transform.Rotate(new Vector3(0f, axis, 0f) * speed * Time.deltaTime);
		}
		if (axis2 != 0f)
		{
			transform.Rotate(new Vector3(0f, 0f, axis2) * speed * Time.deltaTime);
		}
	}
}
