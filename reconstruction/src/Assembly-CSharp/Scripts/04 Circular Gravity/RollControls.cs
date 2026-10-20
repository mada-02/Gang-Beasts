using UnityEngine;

public class RollControls : MonoBehaviour
{
	public float movementForce = 3f;

	private void Start()
	{
	}

	private void Update()
	{
	}

	private void FixedUpdate()
	{
		float num = movementForce * Input.GetAxis("Horizontal");
		float num2 = movementForce * Input.GetAxis("Vertical");
		float num3 = movementForce * Input.GetAxis("Mouse ScrollWheel");
		if (num != 0f)
		{
			transform.rigidbody.AddForce(new Vector3(num, 0f, 0f), ForceMode.Impulse);
		}
		if (num2 != 0f)
		{
			transform.rigidbody.AddForce(new Vector3(0f, 0f, num2), ForceMode.Impulse);
		}
		if (num3 != 0f)
		{
			transform.rigidbody.AddForce(new Vector3(0f, num3 * 4f, 0f), ForceMode.Impulse);
		}
	}
}
