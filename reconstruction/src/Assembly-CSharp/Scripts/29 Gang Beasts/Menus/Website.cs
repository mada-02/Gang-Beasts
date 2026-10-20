using UnityEngine;

public class Website : MonoBehaviour
{
	public string url;

	private void Start()
	{
		if (url == string.Empty)
		{
			GetComponent<TextMesh>().text = string.Empty;
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
		if (url != string.Empty)
		{
			Application.OpenURL(url);
		}
	}
}
