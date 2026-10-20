using System.Collections.Generic;
using UnityEngine;

public class Lift : MonoBehaviour
{
	public List<GameObject> targetsInSphere;

	public GameObject lowerDoorLeft;

	public GameObject lowerDoorRight;

	public GameObject upperDoorLeft;

	public GameObject upperDoorRight;

	public bool toggle;

	public bool change;

	public bool stop;

	public float position;

	public float rotation;

	public Vector3 startPosition;

	public Vector3 endPosition;

	private void FixedUpdate()
	{
		if (change && !stop)
		{
			position += Time.deltaTime / 10f;
			if (position >= 1f)
			{
				position = 1f;
				stop = true;
			}
			Vector3 vector = Vector3.Lerp(startPosition, endPosition, position);
			rigidbody.MovePosition(vector);
		}
		if (!change && !stop)
		{
			position -= Time.deltaTime / 10f;
			if (position <= 0f)
			{
				position = 0f;
				stop = true;
			}
			Vector3 vector2 = Vector3.Lerp(startPosition, endPosition, position);
			rigidbody.MovePosition(vector2);
		}
		if (change && stop)
		{
			upperDoorLeft.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
			upperDoorRight.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorLeft.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorRight.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
		}
		if (!change && stop)
		{
			upperDoorLeft.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
			upperDoorRight.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorLeft.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorRight.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
		}
		if (!stop)
		{
			upperDoorLeft.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
			upperDoorRight.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorLeft.rigidbody.AddForce(Vector3.left * 100f, ForceMode.Impulse);
			lowerDoorRight.rigidbody.AddForce(-Vector3.left * 100f, ForceMode.Impulse);
		}
	}

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.name == "chest")
		{
			targetsInSphere.Add(collider.gameObject);
		}
		if (!toggle && targetsInSphere.Count > 0)
		{
			toggle = true;
			Invoke("Change", 2f);
		}
	}

	private void OnTriggerExit(Collider collider)
	{
		targetsInSphere.Remove(collider.gameObject);
		if (targetsInSphere.Count == 0)
		{
			toggle = false;
		}
	}

	private void Change()
	{
		stop = false;
		change = !change;
	}
}
