using UnityEngine;

public class RopeBreak : MonoBehaviour
{
	public float health = 1f;

	private void Start()
	{
		rigidbody.solverIterationCount = 120;
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.transform.tag == "Body Part (Harmful)" || collision.transform.tag == "Prop (Harmful)")
		{
			health -= Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity) * collision.rigidbody.mass / 100f;
			if (health < 0f)
			{
				ConfigurableJoint component = GetComponent<ConfigurableJoint>();
				Object.Destroy(component);
			}
		}
	}
}
