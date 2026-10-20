using UnityEngine;

public class Shoot : MonoBehaviour
{
	public string inputControl = "Jump";

	public GameObject bullet;

	public float bulletPower = 1000f;

	public float bulletLife = 10f;

	private void Start()
	{
	}

	private void Update()
	{
	}

	private void FixedUpdate()
	{
		if (Input.GetButtonDown(inputControl))
		{
			GameObject gameObject = Object.Instantiate(bullet, transform.position, transform.rotation) as GameObject;
			Rigidbody[] componentsInChildren = gameObject.GetComponentsInChildren<Rigidbody>();
			Rigidbody[] array = componentsInChildren;
			foreach (Rigidbody rigidbody in array)
			{
				rigidbody.rigidbody.AddForce(transform.forward * bulletPower);
			}
			Object.DestroyObject(gameObject, bulletLife);
		}
	}
}
