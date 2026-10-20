using UnityEngine;

public class Music : MonoBehaviour
{
	private SceneManager sceneManager;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
		audio.mute = sceneManager.muteMusic;
		audio.Play();
	}

	private void Update()
	{
		audio.mute = sceneManager.muteMusic;
	}
}
