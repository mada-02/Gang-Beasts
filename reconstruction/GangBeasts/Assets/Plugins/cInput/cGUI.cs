using System;
using UnityEngine;

public class cGUI : MonoBehaviour
{
	public static bool cAudioExists = false;

	public static bool cInputExists = false;

	public static bool cVideoExists = false;

	public static GUISkin cSkin;

	private static bool _showAudioGUI = false;

	private static bool _showInputGUI = false;

	private static bool _showVideoGUI = false;

	private static Color _bgColor = GUI.color;

	private static Vector2 _windowSize = new Vector2(1024f, 600f);

	private static Vector2 resScroll;

	public static event Action OnGUIToggled;

	public static Vector2 windowMaxSize
	{
		get
		{
			return _windowSize;
		}
		set
		{
			if (value.x < 800f)
			{
				value.x = 800f;
				Debug.LogWarning("cGUI.windowSize error: " + value.x + " width is too low. Minimum width is 800 for this menu. Defaulting the width to 800.");
			}
			if (value.y < 600f)
			{
				value.y = 600f;
				Debug.LogWarning("cGUI.windowSize error: " + value.y + " height is too low. Minimum height is 600 for this menu. Defaulting the height to 600.");
			}
			_windowSize = value;
		}
	}

	public static Color bgColor
	{
		get
		{
			return _bgColor;
		}
		set
		{
			_bgColor = value;
			UpdateGUIColors();
		}
	}

	public static bool showingAudioGUI
	{
		get
		{
			return _showAudioGUI;
		}
	}

	public static bool showingInputGUI
	{
		get
		{
			return _showInputGUI;
		}
	}

	public static bool showingVideoGUI
	{
		get
		{
			return _showVideoGUI;
		}
	}

	public static bool showingAnyGUI
	{
		get
		{
			return showingAudioGUI || showingInputGUI || showingVideoGUI;
		}
	}

	public static void ToggleGUI()
	{
		if (showingAnyGUI)
		{
			_HideGUI();
			if (OnGUIToggled != null)
			{
				OnGUIToggled();
			}
		}
		else
		{
			_ShowGUI();
			if (OnGUIToggled != null)
			{
				OnGUIToggled();
			}
		}
	}

	private void Start()
	{
		if (!cSkin)
		{
			Debug.Log("No cGUI skin loaded. Please use cGUI.cSkin to load a skin.");
		}
	}

	public static void ShowAudioGUI()
	{
		if (!cAudioExists)
		{
			return;
		}

		_showAudioGUI = true;
		_showInputGUI = false;
		_showVideoGUI = false;
	}

	public static void ShowInputGUI()
	{
		if (!cInputExists)
		{
			return;
		}

		_showAudioGUI = false;
		_showInputGUI = true;
		_showVideoGUI = false;
	}

	public static void ShowVideoGUI()
	{
		if (!cVideoExists)
		{
			return;
		}

		_showAudioGUI = false;
		_showInputGUI = false;
		_showVideoGUI = true;
	}

	public static bool SelectBox(Rect rect, string[] stringArray, int maxShown, ref bool displayList, ref int index)
	{
		int num = Mathf.Clamp(stringArray.Length, 1, maxShown);
		Rect position = new Rect(rect.x, rect.y + rect.height, rect.width, rect.height * (float)num);
		Rect viewRect = new Rect(rect.x, rect.y, rect.width - 15f, rect.height * (float)stringArray.Length);
		Rect rect2 = new Rect(rect.x, rect.y, rect.width, rect.height * (float)(num + 1));
		bool result = false;
		string text = "dropdownbox";
		string text2 = "selectionbox";
		if (!cSkin)
		{
			text = "button";
			text2 = "button";
		}
		if (GUI.Button(rect, stringArray[index], text))
		{
			displayList = !displayList;
			resScroll = Vector2.zero;
		}
		if (displayList)
		{
			resScroll = GUI.BeginScrollView(position, resScroll, viewRect);
			for (int i = 0; i < stringArray.Length; i++)
			{
				Rect position2 = new Rect(rect.x, rect.y + rect.height * (float)i, rect.width, rect.height);
				if (GUI.Button(position2, stringArray[i].ToString(), text2))
				{
					index = i;
					displayList = false;
					result = true;
				}
			}
			GUI.EndScrollView();
		}
		if (!rect2.Contains(Event.current.mousePosition) && Input.GetMouseButtonDown(0))
		{
			displayList = false;
		}
		return result;
	}

	public static void UpdateGUIColors()
	{
		GUI.backgroundColor = bgColor;
		Color textColor = bgColor * 0.75f;
		if ((bool)cSkin)
		{
			cSkin.button.normal.textColor = textColor;
			cSkin.label.normal.textColor = textColor;
			cSkin.textField.normal.textColor = textColor;
			cSkin.textArea.normal.textColor = textColor;
			for (int i = 0; i < 6; i++)
			{
				cSkin.customStyles[i].normal.textColor = textColor;
			}
			cSkin.customStyles[1].normal.textColor = Color.white;
			cSkin.customStyles[7].normal.textColor = Color.white;
			cSkin.customStyles[6].normal.textColor = Color.white;
		}
	}

	private static void _ShowGUI()
	{
		if (cInputExists)
		{
			ShowInputGUI();
		}
		else if (cAudioExists)
		{
			ShowAudioGUI();
		}
		else if (cVideoExists)
		{
			ShowVideoGUI();
		}
	}

	private static void _HideGUI()
	{
		_showAudioGUI = false;
		_showInputGUI = false;
		_showVideoGUI = false;
	}
}
