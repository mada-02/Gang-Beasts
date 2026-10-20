using UnityEngine;

public class cInputDemoRestart : MonoBehaviour
{
	public GUIText resetText;

	private void Start()
	{
		resetText.enabled = false;
	}

	private void OnMouseDown()
	{
		Application.LoadLevel("Main (C#)");
	}
}
