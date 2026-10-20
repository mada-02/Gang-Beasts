using System.Collections;
using UnityEngine;

public class KillZone : MonoBehaviour
{
	public float killDelay = 1f;

	public AudioClip killSound;

	private void OnTriggerStay(Collider collider)
	{
		if (collider.transform.root.name.Contains("Player") && collider.transform.name != "targetFinder")
		{
			HealthAndStamina component = collider.transform.root.GetComponent<HealthAndStamina>();
			StartCoroutine(KillPlayer(component));
		}
	}

	private IEnumerator KillPlayer(HealthAndStamina target)
	{
		yield return new WaitForSeconds(killDelay);
		target.canDie = true;
		target.TakeDamage(null, 100000000f, true);
		target.TakeDamage(null, 100000000f, true);
		target.TakeDamage(null, 100000000f, true);
	}

	private void SoundAtPoint(AudioClip clip, Vector3 position, float volume, float pitch)
	{
		GameObject gameObject = new GameObject();
		gameObject.transform.position = position;
		gameObject.name = clip.name;
		gameObject.AddComponent<AudioSource>();
		gameObject.audio.pitch = pitch;
		gameObject.audio.PlayOneShot(clip, volume);
		Object.Destroy(gameObject, clip.length / pitch);
	}
}
