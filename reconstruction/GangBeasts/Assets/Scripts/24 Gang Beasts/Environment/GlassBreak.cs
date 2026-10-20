using UnityEngine;

public class GlassBreak : MonoBehaviour
{
	public ParticleSystem particleEffectA;

	public ParticleSystem particleEffectB;

	public float timer;

	private void Start()
	{
		Physics.gravity = new Vector3(0f, -10f, 0f);
	}

	private void Update()
	{
		timer += Time.deltaTime;
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (collision.rigidbody.transform.root.name == "boneloaf")
		{
			collider.enabled = false;
			transform.renderer.enabled = false;
			particleEffectA.Play();
			particleEffectB.Play();
			Physics.gravity = new Vector3(0f, 0f, 5f);
			Debug.Log(timer);
		}
	}
}
