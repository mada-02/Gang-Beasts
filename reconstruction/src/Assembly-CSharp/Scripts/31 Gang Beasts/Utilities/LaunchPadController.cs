using UnityEngine;

public class LaunchPadController : MonoBehaviour
{
	public Rigidbody target;

	public bool torqueMode;

	public Vector3 direction = new Vector3(0f, 0f, 1f);

	public float force = 1000f;

	public float triggerTimer = 0.5f;

	private float timer;

	private bool launch;

	private void FixedUpdate()
	{
		if (launch && timer < triggerTimer)
		{
			if (torqueMode)
			{
				target.AddTorque(direction * force, ForceMode.Impulse);
			}
			else
			{
				target.AddForce(direction * force, ForceMode.Impulse);
			}
			rigidbody.AddForce(-transform.up * 200f, ForceMode.Impulse);
			timer += Time.deltaTime;
			if (timer >= triggerTimer)
			{
				launch = false;
				timer = 0f;
			}
		}
	}

	private void OnCollisionStay(Collision collision)
	{
		if (collision.transform.root.name != "World")
		{
			launch = true;
			timer = 0f;
		}
	}

	private void OnMouseDown()
	{
		launch = true;
		timer = 0f;
	}
}
