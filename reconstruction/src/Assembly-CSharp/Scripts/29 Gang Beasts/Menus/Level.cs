using UnityEngine;

public class Level : MonoBehaviour
{
	private SceneManager sceneManager;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
		GetComponent<TextMesh>().text = "Level: " + sceneManager.levelList[sceneManager.levelSelection];
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
		sceneManager.levelSelection++;
		if (sceneManager.levelSelection >= sceneManager.levelList.Length)
		{
			sceneManager.levelSelection = 0;
		}
		GetComponent<TextMesh>().text = "Level: " + sceneManager.levelList[sceneManager.levelSelection];
	}
}
