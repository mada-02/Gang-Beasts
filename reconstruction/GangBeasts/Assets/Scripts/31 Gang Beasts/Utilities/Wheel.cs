using UnityEngine;

public class Wheel : MonoBehaviour
{
	public WheelCollider wheelA;

	public WheelCollider wheelB;

	public WheelCollider wheelC;

	public WheelCollider wheelD;

	public float current;

	public float speed;

	public float delay;

	private void FixedUpdate()
	{
		delay += Time.deltaTime;
		if (delay > (float)Random.Range(0, 60))
		{
			rigidbody.AddRelativeForce(-Vector3.right * speed, ForceMode.Impulse);
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.transform.root.name != "Car")
		{
			speed = 0f;
		}
	}
}
