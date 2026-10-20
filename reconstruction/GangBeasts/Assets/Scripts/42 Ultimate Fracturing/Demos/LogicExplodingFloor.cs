using UnityEngine;

public class LogicExplodingFloor : MonoBehaviour
{
	private void OnGUI()
	{
		if (!LogicGlobalFracturing.HelpVisible)
		{
			return;
		}

		LogicGlobalFracturing.GlobalGUI();
		GUILayout.Label("This scene shows a floor with:");
		GUILayout.Label("-BSP fracturing");
		GUILayout.Label("-Moving explosion source with radius");
		GUILayout.Label(string.Empty);
		if (GUILayout.Button("Restart"))
		{
			Application.LoadLevel(Application.loadedLevel);
		}
	}
}
