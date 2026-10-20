using UnityEngine;

public class MuteMusic : MonoBehaviour
{
	private SceneManager sceneManager;

	public Texture2D notMutedTexture;

	public Texture2D mutedTexture;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
		if (sceneManager.muteMusic)
		{
			renderer.material.mainTexture = mutedTexture;
		}
		else
		{
			renderer.material.mainTexture = notMutedTexture;
		}
	}

	private void OnMouseEnter()
	{
		transform.localScale = new Vector3(1.2f, 1.2f, 1.2f);
	}

	private void OnMouseExit()
	{
		transform.localScale = new Vector3(1f, 1f, 1f);
	}

	private void OnMouseUpAsButton()
	{
		sceneManager.muteMusic = !sceneManager.muteMusic;
		if (sceneManager.muteMusic)
		{
			renderer.material.mainTexture = mutedTexture;
			PlayerPrefs.SetString("mute music", "true");
		}
		else
		{
			renderer.material.mainTexture = notMutedTexture;
			PlayerPrefs.SetString("mute music", "false");
		}
		PlayerPrefs.Save();
	}
}
