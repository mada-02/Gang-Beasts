using UnityEngine;

public class cInputDemoSetup : MonoBehaviour
{
	public GUISkin guiSkin;

	public Color menuColor = new Color(0.09f, 0.77f, 1f, 1f);

	private void Start()
	{
		cInput.Init();
		cGUI.cSkin = guiSkin;
		cGUI.bgColor = menuColor;
		cGUI.windowMaxSize = new Vector2(1024f, 600f);
		cInput.AddModifier(KeyCode.LeftShift);
		cInput.AddModifier(KeyCode.RightShift);
		cInput.AddModifier(KeyCode.LeftAlt);
		cInput.AddModifier(KeyCode.RightAlt);
		cInput.AddModifier(KeyCode.LeftControl);
		cInput.AddModifier(KeyCode.RightControl);
		cInput.SetKey("Pause", "P");
		cInput.SetKey("Left", "A", "LeftArrow");
		cInput.SetKey("Right", "D", "RightArrow");
		cInput.SetKey("Up", "W", "UpArrow");
		cInput.SetKey("Down", "S", "DownArrow");
		cInput.SetKey("Shoot", "Space", "X", "None", "LeftShift");
		cInput.SetKey("Weapon 1", "Joy1 Axis 1-");
		cInput.SetKey("Weapon 2", "Joy1 Axis 1+");
		cInput.SetKey("Weapon 3", "Joy1 Axis 1-");
		cInput.SetKey("Weapon 4", "Joy1 Axis 1+");
		cInput.SetKey("Weapon 5", "Joy1 Axis 1-");
		cInput.SetKey("Weapon 6", "Joy1 Axis 1+");
		cInput.SetAxis("Horizontal", "Left", "Right");
		cInput.SetAxis("Vertical", "Up", "Down");
	}
}
