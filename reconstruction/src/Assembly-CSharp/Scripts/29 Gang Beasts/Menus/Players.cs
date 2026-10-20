using UnityEngine;

public class Players : MonoBehaviour
{
	private SceneManager sceneManager;

	private void Start()
	{
		GameObject gameObject = GameObject.FindGameObjectWithTag("Scene Manager");
		sceneManager = gameObject.GetComponent<SceneManager>();
		SetPlayers();
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
		sceneManager.totalPlayers++;
		if (sceneManager.totalPlayers > 4)
		{
			sceneManager.totalPlayers = 1;
		}
		string empty = string.Empty;
		SetPlayers();
	}

	private void SetPlayers()
	{
		string text = string.Empty;
		switch (sceneManager.totalPlayers)
		{
		case 1:
			text = "Players: One";
			break;
		case 2:
			text = "Players: Two";
			break;
		case 3:
			text = "Players: Three";
			break;
		case 4:
			text = "Players: Four";
			break;
		}
		GetComponent<TextMesh>().text = text;
	}
}
