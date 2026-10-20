using System.Collections.Generic;
using UnityEngine;

public class Water : MonoBehaviour
{
	public Vector3 forceDirection;

	public List<GameObject> targetsInArea;

	private void FixedUpdate()
	{
		foreach (GameObject item in targetsInArea)
		{
			item.rigidbody.AddForce(forceDirection, ForceMode.Impulse);
		}
	}

	private void OnTriggerEnter(Collider collider)
	{
		if ((bool)collider.rigidbody)
		{
			targetsInArea.Add(collider.gameObject);
		}
	}

	private void OnTriggerExit(Collider collider)
	{
		targetsInArea.Remove(collider.gameObject);
	}
}
