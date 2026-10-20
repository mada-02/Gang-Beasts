using UnityEngine;

public class ShowHelpInfo : MonoBehaviour
{
	public string[] helpInfo;

	private void Start()
	{
	}

	private void Update()
	{
	}

	private void OnGUI()
	{
		float num = 0f;
		string[] array = helpInfo;
		foreach (string text in array)
		{
			GUI.Label(new Rect(5f, num * 20f + 5f, 1000f, 22f), text);
			num++;
		}
	}
}
