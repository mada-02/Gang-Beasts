using UnityEngine;

public class SceneManager : MonoBehaviour
{
	public string[] levelList;

	public string[] rezzedLevelList;

	public int rezzedSelectedLevel;

	public int levelSelection;

	public int startingLives = 5;

	public int totalPlayers = 1;

	public int maxPlayers = 4;

	public int[] score;

	public GameObject[] scoreboard;

	public GUIText[] scoreboardText;

	public Color[] guiTextColor;

	public string currentScene;

	public bool muteMusic;

	private bool ready;

	private bool toggle;

	public Font guiFont;

	public Font guiEndFont;

	public bool menu;

	public bool toggleHealth;

	public AudioSource music;

	public GUISkin skin;

	public bool rezzed;

	private void Awake()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("Scene Manager");
		if (array.Length > 1)
		{
			Object.Destroy(gameObject);
		}
		string loadedLevelName = Application.loadedLevelName;
		ResetScore();
		if (loadedLevelName != "Menu" && !ready)
		{
			CreateScoreboard();
			ready = true;
		}
		Object.DontDestroyOnLoad(transform.gameObject);
		if (!PlayerPrefs.HasKey("mute music"))
		{
			PlayerPrefs.SetString("mute music", "false");
		}
		if (PlayerPrefs.GetString("mute music") == "false")
		{
			muteMusic = false;
		}
		if (PlayerPrefs.GetString("mute music") == "true")
		{
			muteMusic = true;
		}
	}

	private void Start()
	{
		float axisSensitivity = 5f;
		float axisGravity = 5f;
		cInput.deadzone = 0.1f;
		cInput.SetKey("Restart Level", "R");
		cInput.SetKey("Show / Hide Framerate", "F");
		cInput.SetKey("Decrease Time Speed", "Minus");
		cInput.SetKey("Increase Time Speed", "Equals");
		for (int i = 1; i <= maxPlayers; i++)
		{
			cInput.SetKey("P" + i + " Up", "Joy" + i + " Axis 2-");
			cInput.SetKey("P" + i + " Down", "Joy" + i + " Axis 2+");
			cInput.SetAxis("P" + i + " Vertical", "P" + i + " Down", "P" + i + " Up", axisSensitivity, axisGravity);
			cInput.SetKey("P" + i + " Left", "Joy" + i + " Axis 1-");
			cInput.SetKey("P" + i + " Right", "Joy" + i + " Axis 1+");
			cInput.SetAxis("P" + i + " Horizontal", "P" + i + " Left", "P" + i + " Right", axisSensitivity, axisGravity);
			cInput.SetKey("P" + i + " Left Punch & Grab", "Joystick" + i + "Button4");
			cInput.SetKey("P" + i + " Right Punch & Grab", "Joystick" + i + "Button5");
			cInput.SetKey("P" + i + " Jump", "Joystick" + i + "Button0");
			cInput.SetKey("P" + i + " Duck", "Joystick" + i + "Button1");
			cInput.SetKey("P" + i + " Action", "Joystick" + i + "Button2");
			cInput.SetKey("P" + i + " Gesture", "Joystick" + i + "Button3");
		}
	}

	private void Update()
	{
		string loadedLevelName = Application.loadedLevelName;
		if (Input.GetKeyDown(KeyCode.Tab))
		{
			menu = !menu;
			cGUI.ToggleGUI();
		}

		if (loadedLevelName == "Menu")
		{
			ResetScore();
			ready = false;
		}
		else
		{
			if (totalPlayers > 1)
			{
				UpdateScoreboard();
				int num = GameObject.FindGameObjectsWithTag("Player").Length + GameObject.FindGameObjectsWithTag("Player (Dont Track)").Length;
				if (num <= 1 && !toggle)
				{
					MonoBehaviour.print("Restarting Level");
					toggle = true;
					int num2 = 0;
					int num3 = 0;
					for (int i = 0; i < totalPlayers; i++)
					{
						if (score[i] <= 0)
						{
							num2++;
						}
					}

					if (num2 == totalPlayers - 1)
					{
						ShowScore(true);
						GameObject gameObject = new GameObject("text");
						GUIText gUIText = (GUIText)gameObject.AddComponent(typeof(GUIText));
						gUIText.alignment = TextAlignment.Center;
						gUIText.anchor = TextAnchor.MiddleCenter;
						gUIText.transform.position = new Vector3(0.5f, 0.5f, 0f);
						for (int j = 0; j < totalPlayers; j++)
						{
							if (score[j] > 0)
							{
								num3 = j;
							}
						}

						gUIText.text = "Player " + (num3 + 1) + "\n Wins";
						gUIText.font = guiEndFont;
						gUIText.color = guiTextColor[num3];
						if (!rezzed)
						{
							CameraFade.StartAlphaFade(Color.black, false, 1f, 6f, () =>
							{
								Application.LoadLevel("Menu");
							});
						}
						else
						{
							rezzedSelectedLevel++;
							if (rezzedSelectedLevel > rezzedLevelList.Length - 1)
							{
								rezzedSelectedLevel = 0;
							}

							string level = rezzedLevelList[rezzedSelectedLevel];
							Invoke("ResetScore", 5f);
							CameraFade.StartAlphaFade(Color.black, false, 1f, 6f, () =>
							{
								Application.LoadLevel(level);
							});
							MonoBehaviour.print("Loading New Level");
						}
					}
					else
					{
						CameraFade.StartAlphaFade(Color.black, false, 1f, 3f, () =>
						{
							Application.LoadLevel(Application.loadedLevel);
						});
					}
				}
			}
		}
	}

	private void ShowScore()
	{
		for (int i = 0; i < scoreboardText.Length; i++)
		{
			scoreboardText[i].enabled = false;
		}
	}

	private void ShowScore(bool show)
	{
		for (int i = 0; i < scoreboardText.Length; i++)
		{
			scoreboardText[i].enabled = show;
		}
	}

	private void OnLevelWasLoaded()
	{
		string loadedLevelName = Application.loadedLevelName;
		toggle = false;
		CameraFade.StartAlphaFade(Color.black, true, 1f, 0.5f);
		if (score.Length <= 0)
		{
			ResetScore();
		}
		if (loadedLevelName != "Menu" && totalPlayers > 1)
		{
			CreateScoreboard();
		}
		else
		{
			ResetScore();
		}
	}

	private void ResetScore()
	{
		score = new int[totalPlayers];
		for (int i = 0; i < score.Length; i++)
		{
			score[i] = startingLives;
		}
	}

	private void CreateScoreboard()
	{
		scoreboard = new GameObject[score.Length];
		scoreboardText = new GUIText[score.Length];
		guiTextColor = new Color[score.Length];
		for (int i = 0; i < score.Length; i++)
		{
			scoreboard[i] = new GameObject("Scoreboard (Player " + i + ")");
			scoreboardText[i] = (GUIText)scoreboard[i].AddComponent(typeof(GUIText));
			scoreboardText[i].alignment = TextAlignment.Center;
			scoreboardText[i].anchor = TextAnchor.UpperCenter;
			Vector3 position = new Vector3(0f, 1f, 0f);
			float num = totalPlayers;
			float x = 1f / (num + 1f) * ((float)i + 1f);
			position.x = x;
			scoreboardText[i].transform.position = position;
			scoreboardText[i].font = guiFont;
		}
		ShowScore(true);
		Invoke("ShowScore", 6f);
	}

	private void UpdateScoreboard()
	{
		for (int i = 0; i < score.Length; i++)
		{
			scoreboardText[i].color = guiTextColor[i];
			scoreboardText[i].text = score[i].ToString();
		}
	}
}
