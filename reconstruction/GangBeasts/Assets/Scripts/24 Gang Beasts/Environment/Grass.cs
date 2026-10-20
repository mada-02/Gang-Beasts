using UnityEngine;

public class Grass : MonoBehaviour
{
	private void Start()
	{
		rigidbody.centerOfMass = transform.up;
	}

	private void FixedUpdate()
	{
		rigidbody.AddForce(new Vector3(Physics.gravity.x, 0f, Physics.gravity.z) * (rigidbody.mass * Random.Range(5f, 10f)));
	}

	private void OnTriggerStay(Collider collider)
	{
		if (Vector3.Distance(collider.transform.position, transform.forward) < Vector3.Distance(collider.transform.position, -transform.forward))
		{
			rigidbody.AddRelativeTorque(transform.right * 20f, ForceMode.Impulse);
		}
		else if (Vector3.Distance(collider.transform.position, -transform.forward) < Vector3.Distance(collider.transform.position, transform.forward))
		{
			rigidbody.AddRelativeTorque(-transform.right * 20f, ForceMode.Impulse);
		}
	}
}
