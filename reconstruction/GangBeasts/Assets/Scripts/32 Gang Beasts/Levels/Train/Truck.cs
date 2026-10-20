using UnityEngine;

public class Truck : MonoBehaviour
{
	public int seed;

	public Vector3 turnDirection;

	public Vector3 speedDirection;

	private int turnCheckValue;

	private int speedCheckValue;

	private float counter;

	private void Start()
	{
		Random.seed = seed;
	}

	private void FixedUpdate()
	{
		counter -= Time.deltaTime;
		if (counter < 0f)
		{
			turnCheckValue = Random.Range(1, 40);
			speedCheckValue = Random.Range(1, 40);
			counter = Random.Range(10, 30);
			counter = 0f;
		}
		if (turnCheckValue <= 10)
		{
			rigidbody.AddRelativeTorque(turnDirection, ForceMode.Impulse);
		}
		if (turnCheckValue >= 31)
		{
			rigidbody.AddRelativeTorque(-turnDirection, ForceMode.Impulse);
		}
		if (speedCheckValue <= 10)
		{
			rigidbody.AddRelativeForce(speedDirection / 2f, ForceMode.Impulse);
		}
		if (speedCheckValue >= 16)
		{
			rigidbody.AddRelativeForce(-speedDirection, ForceMode.Impulse);
		}
	}
}
