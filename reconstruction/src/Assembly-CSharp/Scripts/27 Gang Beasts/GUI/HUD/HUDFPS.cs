using UnityEngine;

public class HUDFPS : MonoBehaviour
{
	public float updateInterval = 0.5f;

	public AudioClip beep;

	private float accum;

	private int frames;

	private float timeleft;

	public Vector3 screenPosition = new Vector3(1f, 1f, 0f);

	public bool showOnStart;

	private void Start()
	{
		transform.position = screenPosition;
		if (!guiText)
		{
			Debug.Log("UtilityFramesPerSecond needs a GUIText component!");
			enabled = false;
			return;
		}
		if (!showOnStart)
		{
			guiText.enabled = false;
		}
		else
		{
			guiText.enabled = true;
		}
		timeleft = updateInterval;
	}

	private void Update()
	{
		if (cInput.GetKeyDown("Show / Hide Framerate"))
		{
			guiText.enabled = !guiText.enabled;
		}

		if (guiText.enabled)
		{
			timeleft -= Time.deltaTime;
			accum += Time.timeScale / Time.deltaTime;
			frames++;
			if ((double)timeleft <= 0.0)
			{
				float num = Mathf.Round(accum / (float)frames);
				guiText.text = num.ToString();
				if (num > 10f && num < 30f)
				{
					guiText.material.color = new Color(1f, 1f, 0f, 0.25f);
					if (!audio.isPlaying)
					{
						audio.volume = 0.2f;
						audio.PlayOneShot(beep);
					}
				}
				else if (num < 10f)
				{
					guiText.material.color = new Color(1f, 0f, 0f, 0.25f);
					if (!audio.isPlaying)
					{
						audio.volume = 1f;
						audio.PlayOneShot(beep);
					}
				}
				else
				{
					guiText.material.color = new Color(0f, 1f, 0f, 0.25f);
				}

				timeleft = updateInterval;
				accum = 0f;
				frames = 0;
			}
		}
	}
}
