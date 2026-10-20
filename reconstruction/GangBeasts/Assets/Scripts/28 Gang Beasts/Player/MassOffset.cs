using UnityEngine;

public class MassOffset : MonoBehaviour
{
	public Vector3 newCenterOfMass;

	private void Start()
	{
		rigidbody.centerOfMass = newCenterOfMass;
	}
}
