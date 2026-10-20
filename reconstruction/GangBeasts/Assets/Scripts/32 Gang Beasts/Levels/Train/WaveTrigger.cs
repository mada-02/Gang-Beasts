using UnityEngine;

public class WaveTrigger : MonoBehaviour
{
	public int counter;

	public AudioClip sound;

	private bool hasPlayed;

	private float currentTimer;

	public float time;

	private void Update()
	{
		if (currentTimer > time)
		{
			Object.Destroy(gameObject, 5f);
		}
		currentTimer += Time.deltaTime;
	}

	private void PlaySound()
	{
		if (!hasPlayed)
		{
			audio.pitch = 0.5f;
			audio.PlayOneShot(sound);
			hasPlayed = true;
		}
	}
}
