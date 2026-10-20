using UnityEngine;

public class AudioTimeScale : MonoBehaviour
{
	private float lastTimeScale;

	private float timeScale = 1f;

	public AudioSource[] audioSource;

	private void Update()
	{
		if (cInput.GetButton("Decrease Time Speed"))
		{
			timeScale -= 0.02f;
			if (timeScale < 0f)
			{
				timeScale = 0f;
			}
		}

		if (cInput.GetButton("Increase Time Speed"))
		{
			timeScale += 0.02f;
			if (timeScale > 1f)
			{
				timeScale = 1f;
			}
		}

		Time.timeScale = timeScale;
		if (Time.timeScale != lastTimeScale)
		{
			this.audioSource = Object.FindObjectsOfType(typeof(AudioSource)) as AudioSource[];
			lastTimeScale = Time.timeScale;
			AudioSource[] array = this.audioSource;
			foreach (AudioSource audioSource in array)
			{
				if (Time.timeScale > 0f)
				{
					audioSource.pitch = Time.timeScale;
				}
			}
		}
	}
}
