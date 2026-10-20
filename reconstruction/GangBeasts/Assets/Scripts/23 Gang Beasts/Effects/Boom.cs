using UnityEngine;

public class Boom : MonoBehaviour
{
	public float radius = 5f;

	public float power = 10f;

	public float timer = 5f;

	private void Update()
	{
		timer -= Time.deltaTime;
		if (timer <= 0f)
		{
			Explode();
		}
	}

	private void Explode()
	{
		Vector3 position = transform.position;
		Collider[] array = Physics.OverlapSphere(position, radius);
		Collider[] array2 = array;
		foreach (Collider collider in array2)
		{
			if ((bool)collider && (bool)collider.rigidbody)
			{
				collider.rigidbody.AddExplosionForce(power, position, radius, 3f);
			}
		}
	}
}
