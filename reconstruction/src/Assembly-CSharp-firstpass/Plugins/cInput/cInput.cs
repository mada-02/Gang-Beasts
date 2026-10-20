using System.Collections.Generic;
using UnityEngine;

public class cInput : MonoBehaviour
{
	public static float gravity = 3f;

	public static float sensitivity = 3f;

	public static float deadzone = 0.001f;

	private static bool _allowDuplicates = false;

	private static string[,] _defaultStrings = new string[99, 5];

	private static string[] _inputName = new string[99];

	private static KeyCode[] _inputPrimary = new KeyCode[99];

	private static KeyCode[] _modifierUsedPrimary = new KeyCode[99];

	private static KeyCode[] _inputSecondary = new KeyCode[99];

	private static KeyCode[] _modifierUsedSecondary = new KeyCode[99];

	private static List<KeyCode> _modifiers = new List<KeyCode>();

	private static List<int> _markedAsAxis = new List<int>();

	private static string[] _axisName = new string[99];

	private static string[] _axisPrimary = new string[99];

	private static string[] _axisSecondary = new string[99];

	private static float[] _individualAxisSens = new float[99];

	private static float[] _individualAxisGrav = new float[99];

	private static float[] _individualAxisDead = new float[99];

	private static bool[] _invertAxis = new bool[99];

	private static int[,] _makeAxis = new int[99, 2];

	private static int _inputLength = -1;

	private static int _axisLength = -1;

	private static List<KeyCode> _forbiddenKeys = new List<KeyCode>();

	private static bool[] _getKeyArray = new bool[99];

	private static bool[] _getKeyDownArray = new bool[99];

	private static bool[] _getKeyUpArray = new bool[99];

	private static bool[] _axisTriggerArray = new bool[99];

	private static float[] _getAxis = new float[99];

	private static float[] _getAxisRaw = new float[99];

	private static float[] _getAxisArray = new float[99];

	private static float[] _getAxisArrayRaw = new float[99];

	private static bool _allowMouseAxis = false;

	private static bool _allowMouseButtons = true;

	private static bool _allowJoystickButtons = true;

	private static bool _allowJoystickAxis = true;

	private static bool _allowKeyboard = true;

	private static int _numGamepads = 4;

	private Vector2 _scrollPosition;

	private static string _menuHeaderString = "label";

	private static string _menuActionsString = "box";

	private static string _menuInputsString = "box";

	private static string _menuButtonsString = "button";

	private static bool _scanning;

	private static int _cScanIndex;

	private static int _cScanInput;

	private static cInput _cObject;

	private static bool _cKeysLoaded;

	private static Dictionary<string, float> _axisRawValues = new Dictionary<string, float>();

	private static string _exAllowDuplicates;

	private static string _exAxis;

	private static string _exAxisInverted;

	private static string _exDefaults;

	private static string _exInputs;

	private static string _exCalibrations;

	private static string _exCalibrationValues;

	private static bool _externalSaving = false;

	private static Dictionary<string, KeyCode> _string2Key = new Dictionary<string, KeyCode>();

	private static int[] _axisType = new int[10 * _numGamepads];

	private static Dictionary<string, float> _axisCalibrationOffset = new Dictionary<string, float>();

	private static string[,] _joyStrings = new string[_numGamepads + 1, 11];

	private static string[,] _joyStringsPos = new string[_numGamepads + 1, 11];

	private static string[,] _joyStringsNeg = new string[_numGamepads + 1, 11];

	public static GUISkin cSkin
	{
		get
		{
			Debug.LogWarning("cInput.cSkin has been deprecated. Please use cGUI.cSkin.");
			return cGUI.cSkin;
		}
		set
		{
			Debug.LogWarning("cInput.cSkin has been deprecated. Please use cGUI.cSkin.");
			cGUI.cSkin = value;
		}
	}

	public static bool scanning
	{
		get
		{
			return _scanning;
		}
	}

	public static int length
	{
		get
		{
			_cInputInit();
			return _inputLength + 1;
		}
	}

	public static bool allowDuplicates
	{
		get
		{
			_cInputInit();
			return _allowDuplicates;
		}
		set
		{
			_allowDuplicates = value;
			PlayerPrefs.SetString("cInput_dubl", value.ToString());
			_exAllowDuplicates = value.ToString();
		}
	}

	private void Awake()
	{
		Object.DontDestroyOnLoad(this);
		for (int i = 0; i < 99; i++)
		{
			_individualAxisSens[i] = -99f;
			_individualAxisGrav[i] = -99f;
			_individualAxisDead[i] = -99f;
		}
	}

	private void Start()
	{
		_CreateDictionary();
		if (_externalSaving)
		{
			_LoadExternalInputs();
		}
		else
		{
			_LoadInputs();
		}
		AddModifier(KeyCode.None);
	}

	private void Update()
	{
		if (_scanning)
		{
			if (_cScanInput != 0)
			{
				_InputScans();
			}
			else
			{
				string primary;
				if (string.IsNullOrEmpty(_axisPrimary[_cScanIndex]))
				{
					primary = _inputPrimary[_cScanIndex].ToString();
				}
				else
				{
					primary = _axisPrimary[_cScanIndex];
				}
				string secondary;
				if (string.IsNullOrEmpty(_axisSecondary[_cScanIndex]))
				{
					secondary = _inputSecondary[_cScanIndex].ToString();
				}
				else
				{
					secondary = _axisSecondary[_cScanIndex];
				}
				_ChangeKey(_cScanIndex, _inputName[_cScanIndex], primary, secondary);
				_scanning = false;
			}
		}
		else
		{
			_CheckInputs();
		}
	}

	public static void Init()
	{
		_cInputInit();
	}

	private static void _CreateDictionary()
	{
		if (_string2Key.Count == 0)
		{
			for (int i = 0; i <= 429; i++)
			{
				KeyCode keyCode = (KeyCode)i;
				_string2Key.Add(keyCode.ToString(), keyCode);
			}
			for (int j = 1; j <= _numGamepads; j++)
			{
				for (int k = 1; k <= 10; k++)
				{
					_joyStrings[j, k] = "Joy" + j + " Axis " + k;
					_joyStringsPos[j, k] = "Joy" + j + " Axis " + k + "+";
					_joyStringsNeg[j, k] = "Joy" + j + " Axis " + k + "-";
				}
			}
		}
	}

	public static void ForbidKey(KeyCode key)
	{
		_cInputInit();
		if (!_forbiddenKeys.Contains(key))
		{
			_forbiddenKeys.Add(key);
		}
	}

	public static void ForbidKey(string keyString)
	{
		_cInputInit();
		KeyCode key = _ConvertString2Key(keyString);
		ForbidKey(key);
	}

	public static void AddModifier(KeyCode modifierKey)
	{
		_cInputInit();
		_modifiers.Add(modifierKey);
	}

	public static void AddModifier(string modifier)
	{
		_cInputInit();
		AddModifier(_ConvertString2Key(modifier));
	}

	public static void RemoveModifier(KeyCode modifierKey)
	{
		_cInputInit();
		_modifiers.Remove(modifierKey);
	}

	public static void RemoveModifier(string modifier)
	{
		_cInputInit();
		RemoveModifier(_ConvertString2Key(modifier));
	}

	private static KeyCode _ConvertString2Key(string str)
	{
		if (string.IsNullOrEmpty(str))
		{
			return KeyCode.None;
		}
		if (_string2Key.Count == 0)
		{
			_CreateDictionary();
		}
		if (_string2Key.ContainsKey(str))
		{
			KeyCode keyCode = _string2Key[str];
			return keyCode;
		}
		if (!_IsAxisValid(str))
		{
			Debug.Log("cInput error: " + str + " is not a valid input.");
		}
		return KeyCode.None;
	}

	public static void SetKey(string action, string primary)
	{
		SetKey(action, primary, "None", primary, "None");
	}

	public static void SetKey(string action, string primary, string secondary)
	{
		SetKey(action, primary, secondary, primary, secondary);
	}

	public static void SetKey(string action, string primary, string secondary, string primaryModifier)
	{
		SetKey(action, primary, secondary, primaryModifier, secondary);
	}

	public static void SetKey(string action, string primary, string secondary, string primaryModifier, string secondaryModifier)
	{
		_cInputInit();
		if (_FindKeyByDescription(action) == -1)
		{
			int num = _inputLength + 1;
			primaryModifier = (primaryModifier == "None" ? primary : primaryModifier);
			secondaryModifier = (secondaryModifier == "None" ? secondary : secondaryModifier);
			_SetDefaultKey(num, action, primary, secondary, primaryModifier, secondaryModifier);
		}
		else if (!_externalSaving || _cObject == null)
		{
			Debug.LogWarning("A key with the name of " + action + " already exists. You should use ChangeKey() if you want to change an existing key!");
		}
	}

	private static void _SetDefaultKey(int _num, string _name, string _input1, string _input2, string pMod, string sMod)
	{
		_defaultStrings[_num, 0] = _name;
		_defaultStrings[_num, 1] = _input1;
		_defaultStrings[_num, 2] = (string.IsNullOrEmpty(_input2) ? KeyCode.None.ToString() : _input2);
		_defaultStrings[_num, 3] = (string.IsNullOrEmpty(pMod) ? _input1 : pMod);
		_defaultStrings[_num, 4] = (string.IsNullOrEmpty(sMod) ? _input2 : sMod);
		if (_num > _inputLength)
		{
			_inputLength = _num;
		}

		_modifierUsedPrimary[_num] = _ConvertString2Key(_defaultStrings[_num, 3]);
		_modifierUsedSecondary[_num] = _ConvertString2Key(_defaultStrings[_num, 4]);
		_SetKey(_num, _name, _input1, _input2);
		_SaveDefaults();
	}

	private static void _SetKey(int _num, string _name, string _input1, string _input2)
	{
		_inputName[_num] = _name;
		_axisPrimary[_num] = string.Empty;
		if (_string2Key.Count == 0)
		{
			return;
		}
		if (!string.IsNullOrEmpty(_input1))
		{
			KeyCode keyCode = _ConvertString2Key(_input1);
			_inputPrimary[_num] = keyCode;
			string text = _ChangeStringToAxisName(_input1);
			if (_input1 != text)
			{
				_axisPrimary[_num] = _input1;
			}
		}
		_axisSecondary[_num] = string.Empty;
		if (!string.IsNullOrEmpty(_input2))
		{
			KeyCode keyCode2 = _ConvertString2Key(_input2);
			_inputSecondary[_num] = keyCode2;
			string text2 = _ChangeStringToAxisName(_input2);
			if (_input2 != text2)
			{
				_axisSecondary[_num] = _input2;
			}
		}
	}

	public static void SetAxis(string description, string negativeInput, string positiveInput)
	{
		SetAxis(description, negativeInput, positiveInput, sensitivity, gravity, deadzone);
	}

	public static void SetAxis(string description, string negativeInput, string positiveInput, float axisSensitivity)
	{
		SetAxis(description, negativeInput, positiveInput, axisSensitivity, gravity, deadzone);
	}

	public static void SetAxis(string description, string negativeInput, string positiveInput, float axisSensitivity, float axisGravity)
	{
		SetAxis(description, negativeInput, positiveInput, axisSensitivity, axisGravity, deadzone);
	}

	public static void SetAxis(string description, string input)
	{
		SetAxis(description, input, "-1", sensitivity, gravity, deadzone);
	}

	public static void SetAxis(string description, string input, float axisSensitivity)
	{
		SetAxis(description, input, "-1", axisSensitivity, gravity, deadzone);
	}

	public static void SetAxis(string description, string input, float axisSensitivity, float axisGravity)
	{
		SetAxis(description, input, "-1", axisSensitivity, axisGravity, deadzone);
	}

	public static void SetAxis(string description, string input, float axisSensitivity, float axisGravity, float axisDeadzone)
	{
		SetAxis(description, input, "-1", axisSensitivity, axisGravity, axisDeadzone);
	}

	public static void SetAxis(string description, string negativeInput, string positiveInput, float axisSensitivity, float axisGravity, float axisDeadzone)
	{
		_cInputInit();
		if (IsKeyDefined(negativeInput))
		{
			int num = _FindAxisByDescription(description);
			if (num == -1)
			{
				num = _axisLength + 1;
			}
			int num2 = -1;
			int num3 = _FindKeyByDescription(negativeInput);
			if (IsKeyDefined(positiveInput))
			{
				num2 = _FindKeyByDescription(positiveInput);
				_markedAsAxis.Add(_FindKeyByDescription(positiveInput));
				_markedAsAxis.Add(num3);
			}
			else if (positiveInput != "-1")
			{
				Debug.LogError("Can't define Axis named: " + description + ". Please define '" + positiveInput + "' with SetKey() first.");
				return;
			}
			_SetAxis(num, description, num3, num2);
			_individualAxisSens[num3] = axisSensitivity;
			_individualAxisGrav[num3] = axisGravity;
			_individualAxisDead[num3] = axisDeadzone;
			if (num2 >= 0)
			{
				_individualAxisSens[num2] = axisSensitivity;
				_individualAxisGrav[num2] = axisGravity;
				_individualAxisDead[num2] = axisDeadzone;
			}
		}
		else
		{
			Debug.LogError("Can't define Axis named: " + description + ". Please define '" + negativeInput + "' with SetKey() first.");
		}
	}

	private static void _SetAxis(int _num, string _description, int _negative, int _positive)
	{
		if (_num > _axisLength)
		{
			_axisLength = _num;
		}
		_axisName[_num] = _description;
		_makeAxis[_num, 0] = _negative;
		_makeAxis[_num, 1] = _positive;
		_SaveAxis();
	}

	public static void SetAxisSensitivity(string axisName, float sensitivity)
	{
		_cInputInit();
		int num = _FindAxisByDescription(axisName);
		if (num == -1)
		{
			Debug.LogError("Cannot set sensitivity of " + axisName + ". Have you defined this axis with SetAxis() yet?");
		}
		else
		{
			_individualAxisSens[_makeAxis[num, 0]] = sensitivity;
			_individualAxisSens[_makeAxis[num, 1]] = sensitivity;
		}
	}

	public static void SetAxisGravity(string axisName, float gravity)
	{
		_cInputInit();
		int num = _FindAxisByDescription(axisName);
		if (num == -1)
		{
			Debug.LogError("Cannot set gravity of " + axisName + ". Have you defined this axis with SetAxis() yet?");
		}
		else
		{
			_individualAxisGrav[_makeAxis[num, 0]] = gravity;
			_individualAxisGrav[_makeAxis[num, 1]] = gravity;
		}
	}

	public static void SetAxisDeadzone(string axisName, float deadzone)
	{
		_cInputInit();
		int num = _FindAxisByDescription(axisName);
		if (num == -1)
		{
			Debug.LogError("Cannot set deadzone of " + axisName + ". Have you defined this axis with SetAxis() yet?");
		}
		else
		{
			_individualAxisDead[_makeAxis[num, 0]] = deadzone;
			_individualAxisDead[_makeAxis[num, 1]] = deadzone;
		}
	}

	public static void Calibrate()
	{
		_cInputInit();
		string text = string.Empty;
		_axisCalibrationOffset = _GetAxisRawValues();
		PlayerPrefs.SetString("cInput_calsVals", _CalibrationValuesToString());
		for (int i = 1; i <= _numGamepads; i++)
		{
			for (int j = 1; j <= 10; j++)
			{
				int num = 10 * (i - 1) + (j - 1);
				string axisName = _joyStrings[i, j];
				float axisRaw = Input.GetAxisRaw(axisName);
				_axisType[num] = ((axisRaw < -deadzone) ? 1 : ((axisRaw > deadzone) ? (-1) : 0));
				text = text + _axisType[num] + "*";
				PlayerPrefs.SetString("cInput_saveCals", text);
				_exCalibrations = text;
			}
		}
	}

	private static string _CalibrationValuesToString()
	{
		string text = string.Empty;
		foreach (KeyValuePair<string, float> item in _axisCalibrationOffset)
		{
			text += item.Key + "*" + item.Value.ToString() + "#";
		}
		return text;
	}

	private static void _CalibrationValuesFromString(string calVals)
	{
		_axisCalibrationOffset.Clear();
		string[] array = calVals.Split('#');
		for (int i = 0; i < array.Length - 1; i++)
		{
			string[] array2 = array[i].Split('*');
			_axisCalibrationOffset.Add(array2[0], float.Parse(array2[1]));
		}
	}

	private static float _GetCalibratedAxisInput(string description)
	{
		float axisRaw = Input.GetAxisRaw(_ChangeStringToAxisName(description));
		switch (description)
		{
		case "Mouse Left":
		case "Mouse Right":
		case "Mouse Up":
		case "Mouse Down":
		case "Mouse Wheel Up":
		case "Mouse Wheel Down":
			return axisRaw;
		}
		for (int i = 1; i <= _numGamepads; i++)
		{
			for (int j = 1; j <= 10; j++)
			{
				string text = _joyStringsNeg[i, j];
				string text2 = _joyStringsPos[i, j];
				if (description == text || description == text2)
				{
					int num = 10 * (i - 1) + (j - 1);
					switch (_axisType[num])
					{
					default:
						return axisRaw;
					case 1:
						return (axisRaw + 1f) / 2f;
					case -1:
						return (axisRaw - 1f) / 2f;
					}
				}
			}
		}
		Debug.LogWarning("No match found for " + description + " (" + _ChangeStringToAxisName(description) + "). This should never happen, in theory. Returning value of " + axisRaw);
		return axisRaw;
	}

	public static void ChangeKey(string action, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis, bool allowGamepadButtons, bool allowKeyboard)
	{
		_cInputInit();
		int num = _FindKeyByDescription(action);
		_ScanForNewKey(num, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, allowGamepadButtons, allowKeyboard);
	}

	public static void ChangeKey(string action)
	{
		ChangeKey(action, 1, _allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, int input)
	{
		ChangeKey(action, input, _allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, int input, bool allowMouseAxis)
	{
		ChangeKey(action, input, allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, int input, bool allowMouseAxis, bool allowMouseButtons)
	{
		ChangeKey(action, input, allowMouseAxis, allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis)
	{
		ChangeKey(action, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis, bool allowGamepadButtons)
	{
		ChangeKey(action, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, allowGamepadButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis, bool allowGamepadButtons, bool allowKeyboard)
	{
		_cInputInit();
		_ScanForNewKey(index, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, allowGamepadButtons, allowKeyboard);
	}

	public static void ChangeKey(int index)
	{
		ChangeKey(index, 1, _allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input)
	{
		ChangeKey(index, input, _allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input, bool allowMouseAxis)
	{
		ChangeKey(index, input, allowMouseAxis, _allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input, bool allowMouseAxis, bool allowMouseButtons)
	{
		ChangeKey(index, input, allowMouseAxis, allowMouseButtons, _allowJoystickAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis)
	{
		ChangeKey(index, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, _allowJoystickButtons, _allowKeyboard);
	}

	public static void ChangeKey(int index, int input, bool allowMouseAxis, bool allowMouseButtons, bool allowGamepadAxis, bool allowGamepadButtons)
	{
		ChangeKey(index, input, allowMouseAxis, allowMouseButtons, allowGamepadAxis, allowGamepadButtons, _allowKeyboard);
	}

	public static void ChangeKey(string action, string primary, string secondary, string primaryModifier, string secondaryModifier)
	{
		_cInputInit();
		int num = _FindKeyByDescription(action);
		if (string.IsNullOrEmpty(primaryModifier))
		{
			primaryModifier = primary;
		}
		if (string.IsNullOrEmpty(secondaryModifier))
		{
			secondaryModifier = secondary;
		}
		_modifierUsedPrimary[num] = _ConvertString2Key(primaryModifier);
		_modifierUsedSecondary[num] = _ConvertString2Key(secondaryModifier);
		_ChangeKey(num, action, primary, secondary);
	}

	public static void ChangeKey(string action, string primary)
	{
		int num = _FindKeyByDescription(action);
		ChangeKey(action, primary, string.Empty, primary, _modifierUsedSecondary[num].ToString());
	}

	public static void ChangeKey(string action, string primary, string secondary)
	{
		ChangeKey(action, primary, secondary, primary, secondary);
	}

	public static void ChangeKey(string action, string primary, string secondary, string primaryModifier)
	{
		ChangeKey(action, primary, secondary, primaryModifier, secondary);
	}

	private static void _ScanForNewKey(int num, int input, bool mouseAx, bool mouseBut, bool joyAx, bool joyBut, bool keyb)
	{
		_allowMouseAxis = mouseAx;
		_allowMouseButtons = mouseBut;
		_allowJoystickButtons = joyBut;
		_allowJoystickAxis = joyAx;
		_allowKeyboard = keyb;
		_cScanInput = input;
		_cScanIndex = num;
		_scanning = true;
		_axisRawValues = _GetAxisRawValues();
	}

	private static Dictionary<string, float> _GetAxisRawValues()
	{
		Dictionary<string, float> dictionary = new Dictionary<string, float>();
		dictionary.Add("Horizontal", Input.GetAxisRaw("Horizontal"));
		dictionary.Add("Vertical", Input.GetAxisRaw("Vertical"));
		dictionary.Add("Fire1", Input.GetAxisRaw("Fire1"));
		dictionary.Add("Fire2", Input.GetAxisRaw("Fire2"));
		dictionary.Add("Fire3", Input.GetAxisRaw("Fire3"));
		dictionary.Add("Jump", Input.GetAxisRaw("Jump"));
		dictionary.Add("Mouse X", Input.GetAxisRaw("Mouse X"));
		dictionary.Add("Mouse Y", Input.GetAxisRaw("Mouse Y"));
		dictionary.Add("Mouse Horizontal", Input.GetAxisRaw("Mouse Horizontal"));
		dictionary.Add("Mouse Vertical", Input.GetAxisRaw("Mouse Vertical"));
		dictionary.Add("Mouse ScrollWheel", Input.GetAxisRaw("Mouse ScrollWheel"));
		dictionary.Add("Mouse Wheel", Input.GetAxisRaw("Mouse Wheel"));
		dictionary.Add("Window Shake X", Input.GetAxisRaw("Window Shake X"));
		dictionary.Add("Window Shake Y", Input.GetAxisRaw("Window Shake Y"));
		dictionary.Add("Shift", Input.GetAxisRaw("Shift"));
		string empty = string.Empty;
		for (int i = 1; i <= _numGamepads; i++)
		{
			for (int j = 1; j <= 10; j++)
			{
				empty = "Joy" + i + " Axis " + j;
				dictionary.Add(empty, Input.GetAxis(empty));
			}
		}
		return dictionary;
	}

	private static void _ChangeKey(int num, string action, string primary, string secondary)
	{
		_SetKey(num, action, primary, secondary);
		_SaveInputs();
	}

	private static bool _DefaultsExist()
	{
		return (_defaultStrings.Length > 0) ? true : false;
	}

	public static bool IsKeyDefined(string keyName)
	{
		_cInputInit();
		return (_FindKeyByDescription(keyName) >= 0) ? true : false;
	}

	public static bool IsAxisDefined(string axisName)
	{
		_cInputInit();
		return (_FindAxisByDescription(axisName) >= 0) ? true : false;
	}

	private void _CheckInputs()
	{
		bool flag = false;
		bool flag2 = false;
		bool flag3 = false;
		bool flag4 = false;
		float num = 0f;
		float num2 = 0f;
		for (int i = 0; i < _inputLength + 1; i++)
		{
			flag = Input.GetKey(_inputPrimary[i]);
			flag2 = Input.GetKey(_inputSecondary[i]);
			bool flag5 = false;
			bool flag6 = false;
			bool flag7 = false;
			for (int j = 0; j < _modifiers.Count; j++)
			{
				if (Input.GetKey(_modifiers[j]))
				{
					flag7 = true;
					if (!flag5 && _modifiers[j] == _modifierUsedPrimary[i])
					{
						flag5 = true;
					}

					if (!flag6 && _modifiers[j] == _modifierUsedSecondary[i])
					{
						flag6 = true;
					}
				}
			}

			bool flag8 = (_modifierUsedPrimary[i] == _inputPrimary[i] && !flag7) || (_modifierUsedPrimary[i] != _inputPrimary[i] && flag5);
			bool flag9 = (_modifierUsedSecondary[i] == _inputSecondary[i] && !flag7) || (_modifierUsedSecondary[i] != _inputSecondary[i] && flag6);
			if (!string.IsNullOrEmpty(_axisPrimary[i]))
			{
				flag3 = true;
				num = _GetCalibratedAxisInput(_axisPrimary[i]) * (float)_PosOrNeg(_axisPrimary[i]);
			}
			else
			{
				flag3 = false;
				num = (flag ? 1f : 0f);
			}

			if (!string.IsNullOrEmpty(_axisSecondary[i]))
			{
				flag4 = true;
				num2 = _GetCalibratedAxisInput(_axisSecondary[i]) * (float)_PosOrNeg(_axisSecondary[i]);
			}
			else
			{
				flag4 = false;
				num2 = (flag2 ? 1f : 0f);
			}

			if ((flag && flag8) || (flag2 && flag9) || (flag3 && num > deadzone) || (flag4 && num2 > deadzone))
			{
				_getKeyArray[i] = true;
			}
			else
			{
				_getKeyArray[i] = false;
			}

			if ((flag8 && Input.GetKeyDown(_inputPrimary[i])) || (flag9 && Input.GetKeyDown(_inputSecondary[i])))
			{
				_getKeyDownArray[i] = true;
			}
			else if ((flag3 && num > deadzone && !_axisTriggerArray[i]) || (flag4 && num2 > deadzone && !_axisTriggerArray[i]))
			{
				_axisTriggerArray[i] = true;
				_getKeyDownArray[i] = true;
			}
			else
			{
				_getKeyDownArray[i] = false;
			}

			if ((Input.GetKeyUp(_inputPrimary[i]) && flag8) || (Input.GetKeyUp(_inputSecondary[i]) && flag9))
			{
				_getKeyUpArray[i] = true;
			}
			else if ((flag3 && num <= deadzone && _axisTriggerArray[i]) || (flag4 && num2 <= deadzone && _axisTriggerArray[i]))
			{
				_axisTriggerArray[i] = false;
				_getKeyUpArray[i] = true;
			}
			else
			{
				_getKeyUpArray[i] = false;
			}

			float num3 = sensitivity;
			float num4 = gravity;
			float num5 = deadzone;
			sensitivity = (_individualAxisSens[i] != -99f ? _individualAxisSens[i] : num3);
			gravity = (_individualAxisGrav[i] != -99f ? _individualAxisGrav[i] : num4);
			deadzone = (_individualAxisDead[i] != -99f ? _individualAxisDead[i] : num5);
			float num6 = (Time.deltaTime == 0f ? 0.012f : Time.deltaTime);
			if (num > deadzone || num2 > deadzone)
			{
				_getAxisRaw[i] = Mathf.Max(num, num2);
				if (_getAxis[i] < _getAxisRaw[i])
				{
					_getAxis[i] = Mathf.Min(_getAxis[i] + sensitivity * num6, _getAxisRaw[i]);
				}
			}
			else
			{
				_getAxisRaw[i] = 0f;
				if (_getAxis[i] > 0f)
				{
					_getAxis[i] = Mathf.Max(0f, _getAxis[i] - gravity * num6);
				}
			}

			sensitivity = num3;
			gravity = num4;
			deadzone = num5;
		}

		for (int k = 0; k <= _axisLength; k++)
		{
			int num7 = _makeAxis[k, 0];
			int num8 = _makeAxis[k, 1];
			if (_makeAxis[k, 1] == -1)
			{
				_getAxisArray[k] = _getAxis[num7];
				_getAxisArrayRaw[k] = _getAxisRaw[num7];
			}
			else
			{
				_getAxisArray[k] = _getAxis[num8] - _getAxis[num7];
				_getAxisArrayRaw[k] = _getAxisRaw[num8] - _getAxisRaw[num7];
			}
		}
	}

	private static int _FindKeyByDescription(string description)
	{
		for (int i = 0; i < _inputName.Length; i++)
		{
			if (_inputName[i] == description)
			{
				return i;
			}
		}
		return -1;
	}

	public static bool GetKey(string description)
	{
		_cInputInit();
		if (!_DefaultsExist())
		{
			Debug.LogError("No default inputs found. Please setup your default inputs with SetKey first.");
			return false;
		}
		if (!_cKeysLoaded)
		{
			return false;
		}
		int num = _FindKeyByDescription(description);
		if (num > -1)
		{
			return _getKeyArray[num];
		}
		Debug.LogError("Couldn't find a key match for " + description + ". Is it possible you typed it wrong or forgot to setup your defaults after making changes?");
		return false;
	}

	public static bool GetKeyDown(string description)
	{
		_cInputInit();
		if (!_DefaultsExist())
		{
			Debug.LogError("No default inputs found. Please setup your default inputs with SetKey first.");
			return false;
		}
		if (!_cKeysLoaded)
		{
			return false;
		}
		int num = _FindKeyByDescription(description);
		if (num > -1)
		{
			return _getKeyDownArray[_FindKeyByDescription(description)];
		}
		Debug.LogError("Couldn't find a key match for " + description + ". Is it possible you typed it wrong or forgot to setup your defaults after making changes?");
		return false;
	}

	public static bool GetKeyUp(string description)
	{
		_cInputInit();
		if (!_DefaultsExist())
		{
			Debug.LogError("No default inputs found. Please setup your default inputs with SetKey first.");
			return false;
		}
		if (!_cKeysLoaded)
		{
			return false;
		}
		int num = _FindKeyByDescription(description);
		if (num > -1)
		{
			return _getKeyUpArray[_FindKeyByDescription(description)];
		}
		Debug.LogError("Couldn't find a key match for " + description + ". Is it possible you typed it wrong or forgot to setup your defaults after making changes?");
		return false;
	}

	public static bool GetButton(string description)
	{
		return GetKey(description);
	}

	public static bool GetButtonDown(string description)
	{
		return GetKeyDown(description);
	}

	public static bool GetButtonUp(string description)
	{
		return GetKeyUp(description);
	}

	private static int _FindAxisByDescription(string axisName)
	{
		for (int i = 0; i < _axisName.Length; i++)
		{
			if (_axisName[i] == axisName)
			{
				return i;
			}
		}
		return -1;
	}

	public static float GetAxis(string axisName)
	{
		_cInputInit();
		if (!_DefaultsExist())
		{
			Debug.LogError("No default inputs found. Please setup your default inputs with SetKey first.");
			return 0f;
		}
		int num = _FindAxisByDescription(axisName);
		if (num > -1)
		{
			if (_invertAxis[num])
			{
				return _getAxisArray[num] * -1f;
			}
			return _getAxisArray[num];
		}
		Debug.LogError("Couldn't find an axis match for " + axisName + ". Is it possible you typed it wrong?");
		return 0f;
	}

	public static float GetAxisRaw(string axisName)
	{
		_cInputInit();
		if (!_DefaultsExist())
		{
			Debug.LogError("No default inputs found. Please setup your default inputs with SetKey first.");
			return 0f;
		}
		int num = _FindAxisByDescription(axisName);
		if (num > -1)
		{
			if (_invertAxis[num])
			{
				return _getAxisArrayRaw[num] * -1f;
			}
			return _getAxisArrayRaw[num];
		}
		Debug.LogError("Couldn't find an axis match for " + axisName + ". Is it possible you typed it wrong?");
		return 0f;
	}

	public static string GetText(string action)
	{
		return GetText(action, 1);
	}

	public static string GetText(int index)
	{
		return GetText(index, 0);
	}

	public static string GetText(string action, int input)
	{
		int index = _FindKeyByDescription(action);
		return GetText(index, input);
	}

	public static string GetText(int index, int input)
	{
		_cInputInit();
		if (input < 0 || input > 2)
		{
			Debug.LogWarning("Can't look for text #" + input + " for " + _inputName[index] + " input. Only 0, 1, or 2 is acceptable. Clamping to this range.");
			input = Mathf.Clamp(input, 0, 2);
		}

		string result;
		if (input == 1)
		{
			if (!string.IsNullOrEmpty(_axisPrimary[index]))
			{
				result = _axisPrimary[index];
			}
			else
			{
				string text = string.Empty;
				if (_modifierUsedPrimary[index] != KeyCode.None && _modifierUsedPrimary[index] != _inputPrimary[index] && _inputPrimary[index] != KeyCode.None)
				{
					text = _modifierUsedPrimary[index].ToString() + " + ";
				}

				result = text + _inputPrimary[index].ToString();
			}
		}
		else if (input == 2)
		{
			if (!string.IsNullOrEmpty(_axisSecondary[index]))
			{
				result = _axisSecondary[index];
			}
			else
			{
				string text2 = string.Empty;
				if (_modifierUsedSecondary[index] != KeyCode.None && _modifierUsedSecondary[index] != _inputSecondary[index] && _inputSecondary[index] != KeyCode.None)
				{
					text2 = _modifierUsedSecondary[index].ToString() + " + ";
				}
				result = text2 + _inputSecondary[index].ToString();
			}
		}
		else
		{
			result = _inputName[index];
			return result;
		}

		if (_scanning && index == _cScanIndex && input == _cScanInput)
		{
			result = ". . .";
		}

		return result;
	}

	private static string _ChangeStringToAxisName(string description)
	{
		switch (description)
		{
		case "Mouse Left":
			return "Mouse Horizontal";
		case "Mouse Right":
			return "Mouse Horizontal";
		case "Mouse Up":
			return "Mouse Vertical";
		case "Mouse Down":
			return "Mouse Vertical";
		case "Mouse Wheel Up":
			return "Mouse Wheel";
		case "Mouse Wheel Down":
			return "Mouse Wheel";
		default:
		{
			string text = _FindJoystringByDescription(description);
			if (text != null)
			{
				return text;
			}
			return description;
		}
		}
	}

	private static string _FindJoystringByDescription(string desc)
	{
		for (int i = 1; i <= _numGamepads; i++)
		{
			for (int j = 1; j <= 10; j++)
			{
				string text = _joyStringsPos[i, j];
				string text2 = _joyStringsNeg[i, j];
				if (desc == text || desc == text2)
				{
					return _joyStrings[i, j];
				}
			}
		}
		return null;
	}

	private static bool _IsAxisValid(string axis)
	{
		switch (axis)
		{
		case "Mouse Left":
			return true;
		case "Mouse Right":
			return true;
		case "Mouse Up":
			return true;
		case "Mouse Down":
			return true;
		case "Mouse Wheel Up":
			return true;
		case "Mouse Wheel Down":
			return true;
		default:
		{
			bool result = false;
			for (int i = 1; i <= _numGamepads; i++)
			{
				for (int j = 1; j <= 10; j++)
				{
					string text = _joyStringsPos[i, j];
					string text2 = _joyStringsNeg[i, j];
					if (axis == text || axis == text2)
					{
						result = true;
					}
				}
			}
			return result;
		}
		}
	}

	private static int _PosOrNeg(string description)
	{
		int result = 1;
		switch (description)
		{
		case "Mouse Left":
			return -1;
		case "Mouse Right":
			return 1;
		case "Mouse Up":
			return 1;
		case "Mouse Down":
			return -1;
		case "Mouse Wheel Up":
			return 1;
		case "Mouse Wheel Down":
			return -1;
		default:
		{
			for (int i = 1; i <= _numGamepads; i++)
			{
				for (int j = 1; j < 10; j++)
				{
					string text = _joyStringsPos[i, j];
					string text2 = _joyStringsNeg[i, j];
					if (description == text)
					{
						return 1;
					}
					if (description == text2)
					{
						return -1;
					}
				}
			}
			return result;
		}
		}
	}

	private static void _SaveAxis()
	{
		int num = _axisLength + 1;
		string text = string.Empty;
		string text2 = string.Empty;
		string text3 = string.Empty;
		string text4 = string.Empty;
		string text5 = string.Empty;
		string text6 = string.Empty;
		for (int i = 0; i < num; i++)
		{
			text = text + _axisName[i] + "*";
			text2 = text2 + _makeAxis[i, 0] + "*";
			text3 = text3 + _makeAxis[i, 1] + "*";
			text4 = text4 + _individualAxisSens[i] + "*";
			text5 = text5 + _individualAxisGrav[i] + "*";
			text6 = text6 + _individualAxisDead[i] + "*";
		}
		string text7 = text + "#" + text2 + "#" + text3 + "#" + num;
		PlayerPrefs.SetString("cInput_axis", text7);
		PlayerPrefs.SetString("cInput_indAxSens", text4);
		PlayerPrefs.SetString("cInput_indAxGrav", text5);
		PlayerPrefs.SetString("cInput_indAxDead", text6);
		_exAxis = text7 + "¿" + text4 + "¿" + text5 + "¿" + text6;
	}

	private static void _SaveAxInverted()
	{
		int num = _axisLength + 1;
		string text = string.Empty;
		for (int i = 0; i < num; i++)
		{
			text = text + _invertAxis[i] + "*";
		}
		PlayerPrefs.SetString("cInput_axInv", text);
		_exAxisInverted = text;
	}

	private static void _SaveDefaults()
	{
		int num = _inputLength + 1;
		string text = string.Empty;
		string text2 = string.Empty;
		string text3 = string.Empty;
		string text4 = string.Empty;
		string text5 = string.Empty;
		for (int i = 0; i < num; i++)
		{
			text = text + _defaultStrings[i, 0] + "*";
			text2 = text2 + _defaultStrings[i, 1] + "*";
			text3 = text3 + _defaultStrings[i, 2] + "*";
			text4 = text4 + _defaultStrings[i, 3] + "*";
			text5 = text5 + _defaultStrings[i, 4] + "*";
		}
		string text6 = text + "#" + text2 + "#" + text3 + "#" + text4 + "#" + text5;
		PlayerPrefs.SetInt("cInput_count", num);
		PlayerPrefs.SetString("cInput_defaults", text6);
		_exDefaults = num + "¿" + text6;
	}

	private static void _SaveInputs()
	{
		int num = _inputLength + 1;
		string text = string.Empty;
		string text2 = string.Empty;
		string text3 = string.Empty;
		string text4 = string.Empty;
		string text5 = string.Empty;
		string text6 = string.Empty;
		string text7 = string.Empty;
		for (int i = 0; i < num; i++)
		{
			text = text + _inputName[i] + "*";
			text2 = string.Concat(text2, _inputPrimary[i], "*");
			text3 = string.Concat(text3, _inputSecondary[i], "*");
			text4 = text4 + _axisPrimary[i] + "*";
			text5 = text5 + _axisSecondary[i] + "*";
			text6 = string.Concat(text6, _modifierUsedPrimary[i], "*");
			text7 = string.Concat(text7, _modifierUsedSecondary[i], "*");
		}
		PlayerPrefs.SetString("cInput_descr", text);
		PlayerPrefs.SetString("cInput_inp", text2);
		PlayerPrefs.SetString("cInput_alt_inp", text3);
		PlayerPrefs.SetString("cInput_inpStr", text4);
		PlayerPrefs.SetString("cInput_alt_inpStr", text5);
		PlayerPrefs.SetString("cInput_modifierStr", text6);
		PlayerPrefs.SetString("cInput_alt_modifierStr", text7);
		_exInputs = text + "¿" + text2 + "¿" + text3 + "¿" + text4 + "¿" + text5 + "¿" + text6 + "¿" + text7;
	}

	public static string externalInputs
	{
		get
		{
			return _exAllowDuplicates + "æ" + _exAxis + "æ" + _exAxisInverted + "æ" + _exDefaults + "æ" + _exInputs + "æ" + _exCalibrations + "æ" + _exCalibrationValues;
		}
	}

	public static void LoadExternal(string externString)
	{
		_cInputInit();
		string[] array = externString.Split('æ');
		_exAllowDuplicates = array[0];
		_exAxis = array[1];
		_exAxisInverted = array[2];
		_exDefaults = array[3];
		_exInputs = array[4];
		_exCalibrations = array[5];
		_exCalibrationValues = array[6];
		_LoadExternalInputs();
	}

	private static void _LoadInputs()
	{
		if (!PlayerPrefs.HasKey("cInput_count"))
		{
			return;
		}
		if (PlayerPrefs.HasKey("cInput_dubl"))
		{
			if (PlayerPrefs.GetString("cInput_dubl") == "True")
			{
				allowDuplicates = true;
			}
			else
			{
				allowDuplicates = false;
			}
		}
		int num = PlayerPrefs.GetInt("cInput_count");
		_inputLength = num - 1;
		string text = PlayerPrefs.GetString("cInput_defaults");
		string[] array = text.Split('#');
		string[] array2 = array[0].Split('*');
		string[] array3 = array[1].Split('*');
		string[] array4 = array[2].Split('*');
		string[] array5 = array[3].Split('*');
		string[] array6 = array[4].Split('*');
		for (int i = 0; i < array2.Length - 1; i++)
		{
			_SetDefaultKey(i, array2[i], array3[i], array4[i], array5[i], array6[i]);
		}
		if (PlayerPrefs.HasKey("cInput_inp"))
		{
			string text2 = PlayerPrefs.GetString("cInput_descr");
			string text3 = PlayerPrefs.GetString("cInput_inp");
			string text4 = PlayerPrefs.GetString("cInput_alt_inp");
			string text5 = PlayerPrefs.GetString("cInput_inpStr");
			string text6 = PlayerPrefs.GetString("cInput_alt_inpStr");
			string text7 = PlayerPrefs.GetString("cInput_modifierStr");
			string text8 = PlayerPrefs.GetString("cInput_alt_modifierStr");
			string[] array7 = text2.Split('*');
			string[] array8 = text3.Split('*');
			string[] array9 = text4.Split('*');
			string[] array10 = text5.Split('*');
			string[] array11 = text6.Split('*');
			string[] array12 = text7.Split('*');
			string[] array13 = text8.Split('*');
			for (int j = 0; j < array7.Length - 1; j++)
			{
				if (array7[j] == _defaultStrings[j, 0])
				{
					_inputName[j] = array7[j];
					_inputPrimary[j] = _ConvertString2Key(array8[j]);
					_inputSecondary[j] = _ConvertString2Key(array9[j]);
					_axisPrimary[j] = array10[j];
					_axisSecondary[j] = array11[j];
					_modifierUsedPrimary[j] = _ConvertString2Key(array12[j]);
					_modifierUsedSecondary[j] = _ConvertString2Key(array13[j]);
				}
			}
			for (int k = 0; k < array2.Length - 1; k++)
			{
				for (int l = 0; l < array7.Length - 1; l++)
				{
					if (array7[l] == _defaultStrings[k, 0])
					{
						_inputName[k] = array7[l];
						_inputPrimary[k] = _ConvertString2Key(array8[l]);
						_inputSecondary[k] = _ConvertString2Key(array9[l]);
						_axisPrimary[k] = array10[l];
						_axisSecondary[k] = array11[l];
						_modifierUsedPrimary[l] = _ConvertString2Key(array12[l]);
						_modifierUsedSecondary[l] = _ConvertString2Key(array13[l]);
					}
				}
			}
		}
		if (PlayerPrefs.HasKey("cInput_axis"))
		{
			string text9 = PlayerPrefs.GetString("cInput_axInv");
			string[] array14 = text9.Split('*');
			string text10 = PlayerPrefs.GetString("cInput_axis");
			string[] array15 = text10.Split('#');
			string[] array16 = array15[0].Split('*');
			string[] array17 = array15[1].Split('*');
			string[] array18 = array15[2].Split('*');
			int num2 = int.Parse(array15[3]);
			for (int m = 0; m < num2; m++)
			{
				int negative = int.Parse(array17[m]);
				int positive = int.Parse(array18[m]);
				_SetAxis(m, array16[m], negative, positive);
				if (array14[m] == "True")
				{
					_invertAxis[m] = true;
				}
				else
				{
					_invertAxis[m] = false;
				}
			}
		}
		if (PlayerPrefs.HasKey("cInput_indAxSens"))
		{
			string text11 = PlayerPrefs.GetString("cInput_indAxSens");
			string[] array19 = text11.Split('*');
			for (int n = 0; n < array19.Length - 1; n++)
			{
				_individualAxisSens[n] = float.Parse(array19[n]);
			}
		}
		if (PlayerPrefs.HasKey("cInput_indAxGrav"))
		{
			string text12 = PlayerPrefs.GetString("cInput_indAxGrav");
			string[] array20 = text12.Split('*');
			for (int num3 = 0; num3 < array20.Length - 1; num3++)
			{
				_individualAxisGrav[num3] = float.Parse(array20[num3]);
			}
		}
		if (PlayerPrefs.HasKey("cInput_indAxDead"))
		{
			string text13 = PlayerPrefs.GetString("cInput_indAxDead");
			string[] array21 = text13.Split('*');
			for (int num4 = 0; num4 < array21.Length - 1; num4++)
			{
				_individualAxisDead[num4] = float.Parse(array21[num4]);
			}
		}
		if (PlayerPrefs.HasKey("cInput_saveCals"))
		{
			string text14 = PlayerPrefs.GetString("cInput_saveCals");
			string[] array22 = text14.Split('*');
			for (int num5 = 0; num5 < array22.Length - 1; num5++)
			{
				_axisType[num5] = int.Parse(array22[num5]);
			}
		}
		if (PlayerPrefs.HasKey("cInput_calsVals"))
		{
			string calVals = PlayerPrefs.GetString("cInput_calsVals");
			_CalibrationValuesFromString(calVals);
		}
		_cKeysLoaded = true;
	}

	private static void _LoadExternalInputs()
	{
		_externalSaving = true;
		string[] array = _exAxis.Split('¿');
		string[] array2 = _exDefaults.Split('¿');
		string[] array3 = _exInputs.Split('¿');
		allowDuplicates = (_exAllowDuplicates == "True") ? true : false;
		int num = int.Parse(array2[0]);
		_inputLength = num - 1;
		string text = array2[1];
		string[] array4 = text.Split('#');
		string[] array5 = array4[0].Split('*');
		string[] array6 = array4[1].Split('*');
		string[] array7 = array4[2].Split('*');
		string[] array8 = array4[3].Split('*');
		string[] array9 = array4[4].Split('*');
		for (int i = 0; i < array5.Length - 1; i++)
		{
			_SetDefaultKey(i, array5[i], array6[i], array7[i], array8[i], array9[i]);
		}
		if (!string.IsNullOrEmpty(array3[0]))
		{
			string text2 = array3[0];
			string text3 = array3[1];
			string text4 = array3[2];
			string text5 = array3[3];
			string text6 = array3[4];
			string text7 = array3[5];
			string text8 = array3[6];
			string[] array10 = text2.Split('*');
			string[] array11 = text3.Split('*');
			string[] array12 = text4.Split('*');
			string[] array13 = text5.Split('*');
			string[] array14 = text6.Split('*');
			string[] array15 = text7.Split('*');
			string[] array16 = text8.Split('*');
			for (int j = 0; j < array10.Length - 1; j++)
			{
				if (array10[j] == _defaultStrings[j, 0])
				{
					_inputName[j] = array10[j];
					_inputPrimary[j] = _ConvertString2Key(array11[j]);
					_inputSecondary[j] = _ConvertString2Key(array12[j]);
					_axisPrimary[j] = array13[j];
					_axisSecondary[j] = array14[j];
					_modifierUsedPrimary[j] = _ConvertString2Key(array15[j]);
					_modifierUsedSecondary[j] = _ConvertString2Key(array16[j]);
				}
			}
			for (int k = 0; k < array5.Length - 1; k++)
			{
				for (int l = 0; l < array10.Length - 1; l++)
				{
					if (array10[l] == _defaultStrings[k, 0])
					{
						_inputName[k] = array10[l];
						_inputPrimary[k] = _ConvertString2Key(array11[l]);
						_inputSecondary[k] = _ConvertString2Key(array12[l]);
						_axisPrimary[k] = array13[l];
						_axisSecondary[k] = array14[l];
						_modifierUsedPrimary[l] = _ConvertString2Key(array15[l]);
						_modifierUsedSecondary[l] = _ConvertString2Key(array16[l]);
					}
				}
			}
		}
		if (!string.IsNullOrEmpty(array[0]))
		{
			string exAxisInverted = _exAxisInverted;
			string[] array17 = exAxisInverted.Split('*');
			string text9 = array[0];
			string[] array18 = text9.Split('#');
			string[] array19 = array18[0].Split('*');
			string[] array20 = array18[1].Split('*');
			string[] array21 = array18[2].Split('*');
			int num2 = int.Parse(array18[3]);
			for (int m = 0; m < num2; m++)
			{
				int negative = int.Parse(array20[m]);
				int positive = int.Parse(array21[m]);
				_SetAxis(m, array19[m], negative, positive);
				if (array17[m] == "True")
				{
					_invertAxis[m] = true;
				}
				else
				{
					_invertAxis[m] = false;
				}
			}
		}
		if (!string.IsNullOrEmpty(array[1]))
		{
			string text10 = array[1];
			string[] array22 = text10.Split('*');
			for (int n = 0; n < array22.Length - 1; n++)
			{
				_individualAxisSens[n] = float.Parse(array22[n]);
			}
		}
		if (!string.IsNullOrEmpty(array[2]))
		{
			string text11 = array[2];
			string[] array23 = text11.Split('*');
			for (int num3 = 0; num3 < array23.Length - 1; num3++)
			{
				_individualAxisGrav[num3] = float.Parse(array23[num3]);
			}
		}
		if (!string.IsNullOrEmpty(array[3]))
		{
			string text12 = array[3];
			string[] array24 = text12.Split('*');
			for (int num4 = 0; num4 < array24.Length - 1; num4++)
			{
				_individualAxisDead[num4] = float.Parse(array24[num4]);
			}
		}
		if (!string.IsNullOrEmpty(_exCalibrations))
		{
			string exCalibrations = _exCalibrations;
			string[] array25 = exCalibrations.Split('*');
			for (int num5 = 1; num5 <= array25.Length - 2; num5++)
			{
				_axisType[num5] = int.Parse(array25[num5]);
			}
		}
		if (!string.IsNullOrEmpty(_exCalibrationValues))
		{
			_CalibrationValuesFromString(_exCalibrationValues);
		}
		_cKeysLoaded = true;
	}

	public static void ResetInputs()
	{
		_cInputInit();
		for (int i = 0; i < _inputLength + 1; i++)
		{
			_SetKey(i, _defaultStrings[i, 0], _defaultStrings[i, 1], _defaultStrings[i, 2]);
			_modifierUsedPrimary[i] = _ConvertString2Key(_defaultStrings[i, 3]);
			_modifierUsedSecondary[i] = _ConvertString2Key(_defaultStrings[i, 4]);
		}
		for (int j = 0; j < _axisLength; j++)
		{
			_invertAxis[j] = false;
		}
		Clear();
		_SaveDefaults();
		_SaveInputs();
		_SaveAxInverted();
	}

	public static void Clear()
	{
		_cInputInit();
		Debug.LogWarning("Clearing out all cInput related values from PlayerPrefs");
		PlayerPrefs.DeleteKey("cInput_axInv");
		PlayerPrefs.DeleteKey("cInput_axis");
		PlayerPrefs.DeleteKey("cInput_indAxSens");
		PlayerPrefs.DeleteKey("cInput_indAxGrav");
		PlayerPrefs.DeleteKey("cInput_indAxDead");
		PlayerPrefs.DeleteKey("cInput_count");
		PlayerPrefs.DeleteKey("cInput_defaults");
		PlayerPrefs.DeleteKey("cInput_descr");
		PlayerPrefs.DeleteKey("cInput_inp");
		PlayerPrefs.DeleteKey("cInput_alt_inp");
		PlayerPrefs.DeleteKey("cInput_inpStr");
		PlayerPrefs.DeleteKey("cInput_alt_inpStr");
		PlayerPrefs.DeleteKey("cInput_dubl");
		PlayerPrefs.DeleteKey("cInput_saveCals");
		PlayerPrefs.DeleteKey("cInput_calsVals");
		PlayerPrefs.DeleteKey("cInput_modifierStr");
		PlayerPrefs.DeleteKey("cInput_alt_modifierStr");
	}

	public static bool AxisInverted(string axisName, bool invertedStatus)
	{
		_cInputInit();
		int num = _FindAxisByDescription(axisName);
		if (num > -1)
		{
			_invertAxis[num] = invertedStatus;
			_SaveAxInverted();
			return invertedStatus;
		}
		Debug.LogWarning("Couldn't find an axis match for " + axisName + " while trying to set inversion status. Is it possible you typed it wrong?");
		return false;
	}

	public static bool AxisInverted(string axisName)
	{
		_cInputInit();
		int num = _FindAxisByDescription(axisName);
		if (num > -1)
		{
			return _invertAxis[num];
		}
		Debug.LogWarning("Couldn't find an axis match for " + axisName + " while trying to get inversion status. Is it possible you typed it wrong?");
		return false;
	}

	public static bool ShowMenu()
	{
		_cInputInit();
		Debug.LogError("cInput.ShowMenu() has been deprecated. Please use the appropriate cGUI variable, such as cGUI.showingAnyGUI");
		return false;
	}

	public static void ShowMenu(bool state)
	{
		ShowMenu(state, _menuHeaderString, _menuActionsString, _menuInputsString, _menuButtonsString);
	}

	public static void ShowMenu(bool state, string menuHeader)
	{
		ShowMenu(state, menuHeader, _menuActionsString, _menuInputsString, _menuButtonsString);
	}

	public static void ShowMenu(bool state, string menuHeader, string menuActions)
	{
		ShowMenu(state, menuHeader, menuActions, _menuInputsString, _menuButtonsString);
	}

	public static void ShowMenu(bool state, string menuHeader, string menuActions, string menuInputs)
	{
		ShowMenu(state, menuHeader, menuActions, menuInputs, _menuButtonsString);
	}

	public static void ShowMenu(bool state, string menuHeader, string menuActions, string menuInputs, string menuButtons)
	{
		_cInputInit();
		Debug.LogError("cInput.ShowMenu() has been deprecated. Please use the appropriate cGUI function, such as cGUI.ToggleGUI()");
	}

	private static void _cInputInit()
	{
		if (_cObject == null)
		{
			GameObject gameObject;
			if ((bool)GameObject.Find("cObject"))
			{
				gameObject = GameObject.Find("cObject");
			}
			else
			{
				gameObject = new GameObject();
				gameObject.name = "cObject";
			}
			if (gameObject.GetComponent<cInput>() == null)
			{
				_cObject = gameObject.AddComponent<cInput>();
			}
			if (gameObject.GetComponent<cInputGUI>() == null)
			{
				gameObject.AddComponent<cInputGUI>();
			}
		}
	}

	private void _CheckingDuplicates(int _num, int _count)
	{
		if (allowDuplicates)
		{
			return;
		}
		for (int i = 0; i < length; i++)
		{
			if (_count == 1)
			{
				if (_num != i && _inputPrimary[_num] == _inputPrimary[i] && _modifierUsedPrimary[_num] == _modifierUsedPrimary[i])
				{
					_inputPrimary[i] = KeyCode.None;
				}
				if (_inputPrimary[_num] == _inputSecondary[i] && _modifierUsedPrimary[_num] == _modifierUsedSecondary[i])
				{
					_inputSecondary[i] = KeyCode.None;
				}
			}
			if (_count == 2)
			{
				if (_inputSecondary[_num] == _inputPrimary[i] && _modifierUsedSecondary[_num] == _modifierUsedPrimary[i])
				{
					_inputPrimary[i] = KeyCode.None;
				}
				if (_num != i && _inputSecondary[_num] == _inputSecondary[i] && _modifierUsedSecondary[_num] == _modifierUsedSecondary[i])
				{
					_inputSecondary[i] = KeyCode.None;
				}
			}
		}
	}

	private void _CheckingDuplicateStrings(int _num, int _count)
	{
		if (allowDuplicates)
		{
			return;
		}
		for (int i = 0; i < length; i++)
		{
			if (_count == 1)
			{
				if (_num != i && _axisPrimary[_num] == _axisPrimary[i])
				{
					_axisPrimary[i] = string.Empty;
					_inputPrimary[i] = KeyCode.None;
				}
				if (_axisPrimary[_num] == _axisSecondary[i])
				{
					_axisSecondary[i] = string.Empty;
					_inputSecondary[i] = KeyCode.None;
				}
			}
			if (_count == 2)
			{
				if (_axisSecondary[_num] == _axisPrimary[i])
				{
					_axisPrimary[i] = string.Empty;
					_inputPrimary[i] = KeyCode.None;
				}
				if (_num != i && _axisSecondary[_num] == _axisSecondary[i])
				{
					_axisSecondary[i] = string.Empty;
					_inputSecondary[i] = KeyCode.None;
				}
			}
		}
	}

	private void _InputScans()
	{
		KeyCode keyCode = KeyCode.None;
		if (Input.GetKey(KeyCode.Escape))
		{
			if (_cScanInput == 1)
			{
				_inputPrimary[_cScanIndex] = KeyCode.None;
				_axisPrimary[_cScanIndex] = string.Empty;
				_cScanInput = 0;
			}

			if (_cScanInput == 2)
			{
				_inputSecondary[_cScanIndex] = KeyCode.None;
				_axisSecondary[_cScanIndex] = string.Empty;
				_cScanInput = 0;
			}
		}

		if (_scanning && Input.anyKeyDown && !Input.GetKey(KeyCode.Escape))
		{
			KeyCode keyCode2 = KeyCode.None;
			for (int i = 0; i < 450; i++)
			{
				KeyCode keyCode3 = (KeyCode)i;
				if (keyCode3.ToString().StartsWith("Mouse"))
				{
					if (!_allowMouseButtons)
					{
						continue;
					}
				}
				else if (keyCode3.ToString().StartsWith("Joystick"))
				{
					if (!_allowJoystickButtons)
					{
						continue;
					}
				}
				else if (!_allowKeyboard)
				{
					continue;
				}

				for (int j = 0; j < _modifiers.Count; j++)
				{
					for (int k = 0; k < _modifiers.Count; k++)
					{
						if (Input.GetKeyDown(_modifiers[j]))
						{
							return;
						}
					}

					if (Input.GetKeyDown(keyCode3))
					{
						keyCode2 = keyCode3;
						keyCode = keyCode3;
						bool flag = false;
						for (int l = 0; l < _markedAsAxis.Count; l++)
						{
							if (_cScanIndex == _markedAsAxis[l])
							{
								flag = true;
								break;
							}
						}

						if (Input.GetKey(_modifiers[j]) && !flag)
						{
							keyCode = _modifiers[j];
							break;
						}
					}
				}
			}

			if (keyCode2 != KeyCode.None)
			{
				bool flag2 = true;
				for (int m = 0; m < _forbiddenKeys.Count; m++)
				{
					if (keyCode2 == _forbiddenKeys[m])
					{
						flag2 = false;
					}
				}

				if (flag2)
				{
					if (_cScanInput == 1)
					{
						_inputPrimary[_cScanIndex] = keyCode2;
						_modifierUsedPrimary[_cScanIndex] = keyCode;
						_axisPrimary[_cScanIndex] = string.Empty;
						_CheckingDuplicates(_cScanIndex, _cScanInput);
					}

					if (_cScanInput == 2)
					{
						_inputSecondary[_cScanIndex] = keyCode2;
						_modifierUsedSecondary[_cScanIndex] = keyCode;
						_axisSecondary[_cScanIndex] = string.Empty;
						_CheckingDuplicates(_cScanIndex, _cScanInput);
					}
				}

				_cScanInput = 0;
			}
		}

		if (_allowMouseButtons)
		{
			if (Input.GetAxis("Mouse Wheel") > 0f && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Wheel Up";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Wheel Up";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}
			else if (Input.GetAxis("Mouse Wheel") < 0f && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Wheel Down";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Wheel Down";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}
		}

		if (_allowMouseAxis)
		{
			if (Input.GetAxis("Mouse Horizontal") < -deadzone && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Left";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Left";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}
			else if (Input.GetAxis("Mouse Horizontal") > deadzone && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Right";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Right";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}

			if (Input.GetAxis("Mouse Vertical") > deadzone && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Up";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Up";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}
			else if (Input.GetAxis("Mouse Vertical") < -deadzone && !Input.GetKey(KeyCode.Escape))
			{
				if (_cScanInput == 1)
				{
					_axisPrimary[_cScanIndex] = "Mouse Down";
				}

				if (_cScanInput == 2)
				{
					_axisSecondary[_cScanIndex] = "Mouse Down";
				}

				_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
				_cScanInput = 0;
			}
		}

		if (_allowJoystickAxis)
		{
			float num = 0.25f;
			for (int n = 1; n <= _numGamepads; n++)
			{
				for (int num2 = 1; num2 <= 10; num2++)
				{
					string text = _joyStrings[n, num2];
					string text2 = _joyStringsPos[n, num2];
					string text3 = _joyStringsNeg[n, num2];
					float axisRaw = Input.GetAxisRaw(text);
					if (!Mathf.Approximately(_axisRawValues[text], axisRaw))
					{
						if (num2 == 3)
						{
							string text4 = _joyStringsPos[n, 9];
							string text5 = _joyStringsPos[n, 10];
							if (_GetCalibratedAxisInput(text4) > num)
							{
								text2 = text4;
								text3 = text4;
							}
							else if (_GetCalibratedAxisInput(text5) > num)
							{
								text2 = text5;
								text3 = text5;
							}
						}

						float num3 = ((axisRaw < 0f) ? _GetCalibratedAxisInput(text3) : _GetCalibratedAxisInput(text2));
						if ((_scanning && Mathf.Abs(num3) > num) && !Input.GetKey(KeyCode.Escape))
						{
							if (_cScanInput == 1)
							{
								if (num3 > num)
								{
									_axisPrimary[_cScanIndex] = text2;
								}
								else if (num3 < -num)
								{
									_axisPrimary[_cScanIndex] = text3;
								}

								_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
								_cScanInput = 0;
								break;
							}

							if (_cScanInput == 2)
							{
								if (num3 > num)
								{
									_axisSecondary[_cScanIndex] = text2;
								}
								else if (num3 < -num)
								{
									_axisSecondary[_cScanIndex] = text3;
								}

								_CheckingDuplicateStrings(_cScanIndex, _cScanInput);
								_cScanInput = 0;
								break;
							}
						}
					}
				}
			}
		}
	}
}
