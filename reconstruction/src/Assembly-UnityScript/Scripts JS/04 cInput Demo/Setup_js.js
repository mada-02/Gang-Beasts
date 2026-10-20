#pragma strict


var guiSkin : GUISkin;
var backgroundColor : Color;
function Start () {
	cInput.Init();
	cGUI.cSkin = guiSkin;
	cGUI.bgColor = backgroundColor;
	cGUI.windowMaxSize = Vector2(1024, 600);
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

