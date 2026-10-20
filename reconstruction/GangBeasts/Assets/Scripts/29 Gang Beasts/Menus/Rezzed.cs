using UnityEngine;

public class Rezzed : MonoBehaviour
{
	private SceneManager sceneManager;

	public int lives;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
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
		sceneManager.rezzedSelectedLevel = 0;
		sceneManager.rezzed = true;
		sceneManager.startingLives = lives;
		string level = sceneManager.rezzedLevelList[sceneManager.rezzedSelectedLevel];
		CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
		{
			Application.LoadLevel(level);
		});
	}
}
