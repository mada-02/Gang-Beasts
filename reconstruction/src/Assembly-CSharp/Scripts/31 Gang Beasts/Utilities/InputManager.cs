using UnityEngine;

public class InputManager : MonoBehaviour
{
	public string[] buttonA;

	public string[] buttonB;

	public string[] buttonX;

	public string[] buttonY;

	public string[] buttonLeftBumper;

	public string[] buttonRightBumper;

	public string[] buttonBack;

	public string[] buttonStart;

	public string[] buttonLeftAnalogue;

	public string[] buttonRightAnalogue;

	private void Start()
	{
		buttonA = new string[Input.GetJoystickNames().Length];
		buttonB = new string[Input.GetJoystickNames().Length];
		buttonX = new string[Input.GetJoystickNames().Length];
		buttonY = new string[Input.GetJoystickNames().Length];
		buttonLeftBumper = new string[Input.GetJoystickNames().Length];
		buttonRightBumper = new string[Input.GetJoystickNames().Length];
		buttonBack = new string[Input.GetJoystickNames().Length];
		buttonStart = new string[Input.GetJoystickNames().Length];
		buttonLeftAnalogue = new string[Input.GetJoystickNames().Length];
		buttonRightAnalogue = new string[Input.GetJoystickNames().Length];
		if (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer || Application.platform == RuntimePlatform.WindowsWebPlayer || Application.platform == RuntimePlatform.WP8Player)
		{
			for (int i = 0; i < Input.GetJoystickNames().Length; i++)
			{
				switch (Input.GetJoystickNames()[i])
				{
					case "Controller (XBOX 360 For Windows)":
						buttonA[i] = "joystick " + (i + 1) + " button 0";
						buttonB[i] = "joystick " + (i + 1) + " button 1";
						buttonX[i] = "joystick " + (i + 1) + " button 2";
						buttonY[i] = "joystick " + (i + 1) + " button 3";
						buttonLeftBumper[i] = "joystick " + (i + 1) + " button 4";
						buttonRightBumper[i] = "joystick " + (i + 1) + " button 5";
						buttonBack[i] = "joystick " + (i + 1) + " button 6";
						buttonStart[i] = "joystick " + (i + 1) + " button 7";
						buttonLeftAnalogue[i] = "joystick " + (i + 1) + " button 8";
						buttonRightAnalogue[i] = "joystick " + (i + 1) + " button 9";
						break;
				}
			}
		}

		if ((Application.platform == RuntimePlatform.OSXEditor || Application.platform == RuntimePlatform.OSXPlayer) || Application.platform == RuntimePlatform.OSXWebPlayer)
		{
			for (int j = 0; j < Input.GetJoystickNames().Length; j++)
			{
				switch (Input.GetJoystickNames()[j])
				{
				}
			}
		}
	}

	private void Update()
	{
		for (int i = 0; i < Input.GetJoystickNames().Length; i++)
		{
			if (Input.GetKeyDown(buttonA[i]))
			{
				MonoBehaviour.print("A on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonB[i]))
			{
				MonoBehaviour.print("B on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonX[i]))
			{
				MonoBehaviour.print("X on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonY[i]))
			{
				MonoBehaviour.print("Y on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonLeftBumper[i]))
			{
				MonoBehaviour.print("Left Bumper on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonRightBumper[i]))
			{
				MonoBehaviour.print("Right Bumper on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonBack[i]))
			{
				MonoBehaviour.print("Back on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonStart[i]))
			{
				MonoBehaviour.print("Start on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonLeftAnalogue[i]))
			{
				MonoBehaviour.print("Left Analogue on Pad " + (i + 1));
			}
			if (Input.GetKeyDown(buttonRightAnalogue[i]))
			{
				MonoBehaviour.print("Right Analogue on Pad " + (i + 1));
			}
		}
	}
}
