using UnityEngine;

public class FlameFlicker : MonoBehaviour
{
	private void Start()
	{
	}

	private void Update()
	{
		Vector3 zero = Vector3.zero;
		zero.x = Random.Range(-1f, 1f);
		zero.y = Random.Range(-1f, 1f);
		zero.z = Random.Range(-1f, 1f);
		rigidbody.AddForce(zero, ForceMode.Impulse);
	}
}
