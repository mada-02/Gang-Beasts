using UnityEngine;

public class Teleporter : MonoBehaviour
{
	public Vector3 movePoint;

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.transform.tag == "Prop" || collision.transform.tag == "Prop (Harmful)")
		{
			collision.rigidbody.isKinematic = true;
			collision.transform.position = movePoint;
			collision.rigidbody.isKinematic = false;
		}
	}
}
