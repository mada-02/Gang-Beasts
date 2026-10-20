using UnityEngine;

public class StartGame : MonoBehaviour
{
	private SceneManager sceneManager;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
	}

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape))
		{
			CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
			{
				Application.Quit();
			});
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
		CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
		{
			Application.LoadLevel(sceneManager.levelList[sceneManager.levelSelection]);
		});
	}
}
