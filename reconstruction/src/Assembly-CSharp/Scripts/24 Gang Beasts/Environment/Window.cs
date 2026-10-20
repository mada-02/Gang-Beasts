using UnityEngine;

public class Window : MonoBehaviour
{
	public AudioClip[] breakSound;

	private void OnCollisionEnter(Collision collision)
	{
		float num;
		if ((bool)collision.rigidbody)
		{
			num = Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity) * collision.rigidbody.mass;
		}
		else
		{
			num = Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity) * 10f;
		}
		if ((num > 20f && collision.transform.tag == "Harmful") || num > 30f)
		{
			collider.enabled = false;
			transform.renderer.enabled = false;
			transform.particleSystem.Play();
			Object.Destroy(gameObject, 5f);
			audio.PlayOneShot(breakSound[Random.Range(0, breakSound.Length - 1)]);
		}
	}
}
