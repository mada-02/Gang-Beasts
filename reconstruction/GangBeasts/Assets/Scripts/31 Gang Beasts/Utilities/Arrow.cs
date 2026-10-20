using UnityEngine;

public class Arrow : MonoBehaviour
{
	public float force = 2f;

	private bool hit;

	private void Start()
	{
	}

	private void FixedUpdate()
	{
		if (!hit)
		{
			force -= Time.deltaTime;
			if (force < 0f)
			{
				force = 0f;
			}
			rigidbody.AddRelativeForce(new Vector3(0f, force, 0f), ForceMode.Impulse);
		}
	}

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.transform.root.name != "Arrow" && collider.name != "ball")
		{
			FixedJoint fixedJoint = gameObject.AddComponent<FixedJoint>();
			if ((bool)collider.rigidbody)
			{
				fixedJoint.connectedBody = collider.rigidbody;
			}
			else
			{
				fixedJoint.connectedBody = null;
			}
			hit = true;
			Object.Destroy(this);
		}
	}
}
