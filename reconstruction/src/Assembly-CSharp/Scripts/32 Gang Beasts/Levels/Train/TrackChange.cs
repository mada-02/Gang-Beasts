using UnityEngine;

public class TrackChange : MonoBehaviour
{
	public GameObject target;

	public bool toggle;

	public float position;

	public float rotation;

	public Vector3 startPosition;

	public Vector3 endPosition;

	public Quaternion rotationA;

	public Quaternion rotationB;

	private void Start()
	{
		startPosition = target.transform.position;
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (!toggle)
		{
			toggle = true;
			Invoke("Reset", 20f);
		}
	}

	private void FixedUpdate()
	{
		if (toggle)
		{
			position += Time.deltaTime / 10f;
			rotation -= Time.deltaTime / 10f * 180f;
			if (position >= 1f)
			{
				position = 1f;
				collider.enabled = false;
			}
			if (rotation <= 0f)
			{
				rotation = 0f;
			}
		}
		else
		{
			position -= Time.deltaTime;
			rotation += Time.deltaTime * 180f;
			if (position <= 0f)
			{
				position = 0f;
				collider.enabled = true;
			}
			if (rotation >= 180f)
			{
				rotation = 180f;
			}
		}
		Vector3 vector = Vector3.Lerp(startPosition, endPosition, position);
		target.rigidbody.MovePosition(vector);
		target.rigidbody.MoveRotation(Quaternion.Euler(0f, rotation, 0f));
	}

	private void Reset()
	{
		toggle = false;
	}
}
