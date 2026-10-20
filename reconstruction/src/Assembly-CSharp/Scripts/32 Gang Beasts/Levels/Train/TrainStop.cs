using UnityEngine;

public class TrainStop : MonoBehaviour
{
	public GameObject trainCartA;

	public GameObject trainCartB;

	public GameObject[] leftHandDoors;

	public GameObject[] rightHandDoors;

	public bool toggle;

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.name == "Train Stop" && !toggle)
		{
			toggle = true;
			Invoke("Reset", 10f);
		}
	}

	private void FixedUpdate()
	{
		if (!toggle)
		{
			trainCartA.rigidbody.AddRelativeForce(-2000000f, -5000f, 0f);
			trainCartB.rigidbody.AddRelativeForce(2000000f, -5000f, 0f);
		}
		else
		{
			trainCartA.rigidbody.AddRelativeForce(40000f, -1000f, 0f);
			trainCartB.rigidbody.AddRelativeForce(-40000f, -1000f, 0f);
		}
	}

	private void Reset()
	{
		toggle = false;
	}
}
