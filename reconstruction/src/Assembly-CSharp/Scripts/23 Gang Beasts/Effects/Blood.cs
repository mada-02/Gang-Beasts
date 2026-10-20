using UnityEngine;

public class Blood : MonoBehaviour
{
	public Material bloodMat;

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.transform.root.name == "World")
		{
			GameObject gameObject = GameObject.CreatePrimitive(PrimitiveType.Quad);
			gameObject.transform.position = collision.contacts[0].point + collision.contacts[0].normal / 50f;
			gameObject.transform.rotation = Quaternion.LookRotation(-collision.contacts[0].normal);
			Object.Destroy(gameObject.collider);
			float num = Random.Range(0.5f, 1f);
			float z = Random.Range(0f, 360f);
			gameObject.transform.localScale = new Vector3(num, num, num);
			gameObject.transform.Rotate(new Vector3(0f, 0f, z));
			gameObject.renderer.material = bloodMat;
			gameObject.renderer.castShadows = false;
		}
		if (collision.transform.name != "Blood")
		{
			Object.Destroy(base.gameObject);
		}
	}
}
