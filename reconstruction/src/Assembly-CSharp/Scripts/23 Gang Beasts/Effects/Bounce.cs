using UnityEngine;

public class Bounce : MonoBehaviour
{
	private void Start()
	{
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.contacts.Length > 0)
		{
			collision.rigidbody.AddForce(-collision.contacts[0].normal * (collision.relativeVelocity.magnitude * 100f), ForceMode.Impulse);
		}
	}
}
