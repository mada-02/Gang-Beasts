using UnityEngine;

public class RoadSpawnObjectMover : MonoBehaviour
{
	public float speed;

	public float leftSide;

	public float rightSide;

	public Vector3 direction;

	private void FixedUpdate()
	{
		float num = speed * Time.deltaTime;
		rigidbody.MovePosition(transform.position + direction.normalized * num);
		if (transform.position.x > leftSide)
		{
			Object.Destroy(gameObject);
		}
	}
}
