using UnityEngine;

public class PrintCollision : MonoBehaviour
{
	private void OnCollisionEnter(Collision collision)
	{
		MonoBehaviour.print(collision);
	}
}
