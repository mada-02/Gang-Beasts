using UnityEngine;

[RequireComponent(typeof(cGUI))]
public class cInputGUI : MonoBehaviour
{
	private Rect windowRect;

	private float _wHeight = cGUI.windowMaxSize.y;

	private float _wWidth = cGUI.windowMaxSize.x;

	private bool showPopUp;

	private Vector2 _scrollPosition;

	private float _clickDelay;

	private string label2;

	private string box2;

	private string popwindow;

	private string smallbutton;

	private void Start()
	{
		cGUI.cInputExists = true;
	}

	private void OnGUI()
	{
		if (cGUI.showingInputGUI)
		{
			if (cInput.scanning)
			{
				_clickDelay = Time.realtimeSinceStartup + 0.15f;
			}
			GUI.skin = cGUI.cSkin;
			cGUI.UpdateGUIColors();
			if ((float)Screen.height - cGUI.windowMaxSize.y < 0f)
			{
				_wHeight = Screen.height;
			}
			else
			{
				_wHeight = cGUI.windowMaxSize.y;
			}
			if ((float)Screen.width - cGUI.windowMaxSize.x < 0f)
			{
				_wWidth = Screen.width;
			}
			else
			{
				_wWidth = cGUI.windowMaxSize.x;
			}
			windowRect = new Rect(((float)Screen.width - _wWidth) / 2f, ((float)Screen.height - _wHeight) / 2f, _wWidth, _wHeight);
			GUI.Window(0, windowRect, MenuWindow, string.Empty);
			if (showPopUp)
			{
				GUI.Window(1, new Rect((Screen.width - 512) / 2, (Screen.height - 350) / 2, 512f, 350f), popUp, string.Empty, popwindow);
				GUI.BringWindowToFront(1);
				GUI.FocusWindow(1);
			}
		}
	}

	private void popUp(int windowID)
	{
		GUI.FocusWindow(1);
		GUI.TextField(new Rect(40f, 100f, 450f, 95f), "Please leave all analog inputs in their neutral positions.\n\nClick on OK when ready.");
		Rect position = new Rect(150f, 284f, 200f, 35f);
		GUI.Button(position, "OK", smallbutton);
		if (position.Contains(Event.current.mousePosition) && Input.GetMouseButtonUp(0) && showPopUp)
		{
			cInput.Calibrate();
			showPopUp = false;
		}
	}

	private void MenuWindow(int windowID)
	{
		if (!showPopUp)
		{
			GUI.FocusWindow(0);
		}
		GUI.backgroundColor = cGUI.bgColor;
		float num = 128f;
		float num2 = 35f;
		float left = _wWidth / 26.5f;
		int num3 = 7;
		if ((bool)cGUI.cSkin && cGUI.cSkin.name == "cGUISkin Dark")
		{
			num3 = 6;
		}
		float num4 = _wHeight / (float)num3;
		float num5 = _wHeight - _wHeight / 6f;
		float num6 = 50f;
		int num7 = 0;
		GUI.SetNextControlName("textarea");
		if (GUI.Button(new Rect(left, num4 + num6 * (float)num7++, num, num2), "  INPUTS"))
		{
		}
		GUI.FocusControl("textarea");
		if (cGUI.cAudioExists && GUI.Button(new Rect(left, num4 + num6 * (float)num7++, num, num2), "  AUDIO"))
		{
			cGUI.ShowAudioGUI();
		}
		if (cGUI.cVideoExists && GUI.Button(new Rect(left, num4 + num6 * (float)num7++, num, num2), "  VIDEO"))
		{
			cGUI.ShowVideoGUI();
		}
		if (GUI.Button(new Rect(left, num5 - num6 * 2f, num, num2), "  CALIBRATE"))
		{
			showPopUp = true;
		}
		if (GUI.Button(new Rect(left, num5 - num6, num, num2), "  DEFAULTS"))
		{
			cInput.ResetInputs();
		}
		if (GUI.Button(new Rect(left, num5, num, num2), "  EXIT"))
		{
			cGUI.ToggleGUI();
		}
		float left2 = windowRect.width / 3f;
		float num8 = windowRect.width / 1.8f;
		float num9 = windowRect.height / 9f;
		float num10 = 60f;
		if ((bool)cGUI.cSkin)
		{
			label2 = "label";
			box2 = "box2";
			popwindow = "popwindow";
			smallbutton = "smallbutton";
		}
		else
		{
			label2 = "label";
			box2 = "box";
			popwindow = "window";
			smallbutton = "button";
		}
		Rect rect = new Rect(windowRect.width / 3.6f, num9 * 2.2f, windowRect.width * 0.67f, windowRect.height);
		GUI.Label(new Rect(rect.x + rect.width / 2f - num / 2f, windowRect.height / 6.5f, num, num2), "INPUT SETTINGS", label2);
		GUI.Label(new Rect(rect.x + rect.width * 0.2f - num * 1.2f / 2f, rect.y, num * 1.2f, num2), "ACTION", label2);
		GUI.Label(new Rect(rect.x + rect.width * 0.5f - num * 1.2f / 2f, rect.y, num * 1.2f, num2), "PRIMARY", label2);
		GUI.Label(new Rect(rect.x + rect.width * 0.8f - num * 1.2f / 2f, rect.y, num * 1.2f, num2), "SECONDARY", label2);
		_scrollPosition = GUI.BeginScrollView(new Rect(left2, num9 * 3f, num8 * 1.1f, windowRect.height * 0.58f), _scrollPosition, new Rect(left2, 0f, num8, num10 * (float)(cInput.length - 5)));
		for (int i = 0; i < cInput.length; i++)
		{
			GUI.Label(new Rect(rect.x + rect.width * 0.2f - num * 1.2f / 2f, 0f + num2 * (float)i, num * 1.2f, num2), cInput.GetText(i, 0), "label");
			if (GUI.Button(new Rect(rect.x + rect.width * 0.5f - num * 1.2f / 2f, 0f + num2 * (float)i, num * 1.2f, num2), cInput.GetText(i, 1), box2) && Input.GetMouseButtonUp(0) && Time.realtimeSinceStartup > _clickDelay)
			{
				cInput.ChangeKey(i, 1);
			}
			if (GUI.Button(new Rect(rect.x + rect.width * 0.8f - num * 1.2f / 2f, 0f + num2 * (float)i, num * 1.2f, num2), cInput.GetText(i, 2), box2) && Time.realtimeSinceStartup > _clickDelay)
			{
				cInput.ChangeKey(i, 2);
			}
		}
		GUI.EndScrollView();
	}
}
