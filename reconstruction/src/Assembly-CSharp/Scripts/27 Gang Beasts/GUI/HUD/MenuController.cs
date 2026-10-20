using System.Collections;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class MenuController : MonoBehaviour
{
	public enum Actions
	{
		ResumeGame,
		RestartLevel,
		ExitToMainMenu,
		ExitToDesktop,
		StoryMode,
		BattleMode,
		Options
	}

	public GameObject[] buttons;

	public Actions[] actions;

	public int selection;

	private int lastSelection;

	public Color defaultColor = new Color(0.5f, 0.5f, 0.5f);

	public Color highlightColor = new Color(1f, 1f, 1f);

	public bool mainMenu;

	private float inputDelay = 0.1f;

	private double lastInputTime;

	private bool acceptInput = true;

	private bool menuShown;

	public AudioClip audioAccept;

	public AudioClip audioSelect;

	public LayerMask layerMask;

	private void Start()
	{
		if (!mainMenu)
		{
			Screen.showCursor = false;
			menuShown = HideMenuRenderer(true);
		}
		else
		{
			Screen.showCursor = true;
			menuShown = HideMenuRenderer(false);
		}
		CameraFade.StartAlphaFade(Color.black, true, 1f, 0.5f);
	}

	private void Update()
	{
		if (!mainMenu && (Input.GetKeyDown("escape") || Input.GetButtonDown("Start_1") || Input.GetButtonDown("Start_2") || Input.GetButtonDown("Start_3") || Input.GetButtonDown("Start_4")))
		{
			menuShown = HideMenuRenderer();
			audio.PlayOneShot(audioAccept, 0.5f);
		}

		if (menuShown)
		{
			if (acceptInput)
			{
				if (!mainMenu)
				{
					Time.timeScale = 0f;
				}

				if (Input.GetKey("down") || Input.GetAxis("L_YAxis_1") < 0f || Input.GetAxis("L_YAxis_2") < 0f || Input.GetAxis("L_YAxis_3") < 0f || Input.GetAxis("L_YAxis_4") < 0f)
				{
					selection++;
					if (selection >= buttons.Length)
					{
						selection = 0;
					}

					acceptInput = false;
					lastInputTime = Time.realtimeSinceStartup;
				}
				else if (Input.GetKey("up") || Input.GetAxis("L_YAxis_1") > 0f || Input.GetAxis("L_YAxis_2") > 0f || Input.GetAxis("L_YAxis_3") > 0f || Input.GetAxis("L_YAxis_4") > 0f)
				{
					selection--;
					if (selection < 0)
					{
						selection = buttons.Length - 1;
					}

					acceptInput = false;
					lastInputTime = Time.realtimeSinceStartup;
				}
			}
			else
			{
				float realtimeSinceStartup = Time.realtimeSinceStartup;
				if ((double)realtimeSinceStartup > lastInputTime + (double)inputDelay)
				{
					acceptInput = true;
				}
			}

			Transform transform = MouseCheck();
			if (selection != lastSelection)
			{
				audio.PlayOneShot(audioSelect, 0.5f);
			}

			lastSelection = selection;
			for (int i = 0; i < buttons.Length; i++)
			{
				if (selection == i)
				{
					buttons[i].transform.localScale = new Vector3(1.1f, 1.1f, 1.1f);
					buttons[i].renderer.material.SetColor("_Emission", highlightColor);
					buttons[i].renderer.material.SetColor("_Color", highlightColor);
				}
				else
				{
					buttons[i].transform.localScale = new Vector3(1f, 1f, 1f);
					buttons[i].renderer.material.SetColor("_Emission", defaultColor);
					buttons[i].renderer.material.SetColor("_Color", defaultColor);
				}
			}

			if ((((((Input.GetKey("enter") || Input.GetKey("return")) || Input.GetButton("A_1")) || Input.GetButton("A_2")) || Input.GetButton("A_3")) || Input.GetButton("A_4")) || (Input.GetMouseButtonDown(0) && transform == buttons[selection].transform))
			{
				audio.PlayOneShot(audioAccept, 0.5f);
				switch (actions[selection])
				{
					case Actions.ResumeGame:
						menuShown = HideMenuRenderer(true);
						break;
					case Actions.RestartLevel:
						menuShown = HideMenuRenderer(true);
						CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
						{
							Application.LoadLevel(Application.loadedLevel);
						});
						break;
					case Actions.ExitToMainMenu:
						menuShown = HideMenuRenderer(true);
						CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
						{
							Application.LoadLevel("Main Menu");
						});
						break;
					case Actions.ExitToDesktop:
						menuShown = HideMenuRenderer(true);
						CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
						{
							Application.Quit();
						});
						break;
					case Actions.StoryMode:
						menuShown = HideMenuRenderer(true);
						CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
						{
							Application.LoadLevel(1);
						});
						break;
					case Actions.BattleMode:
						menuShown = HideMenuRenderer(true);
						CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
						{
							Application.LoadLevel(2);
						});
						break;
					case Actions.Options:
						menuShown = HideMenuRenderer(true);
						break;
				}
			}
		}
		else if (!mainMenu)
		{
			Time.timeScale = 1f;
		}
	}

	private bool HideMenuRenderer(bool hide)
	{
		if (hide)
		{
			for (int i = 0; i < buttons.Length; i++)
			{
				buttons[i].renderer.enabled = false;
			}
			renderer.enabled = false;
		}
		else
		{
			for (int j = 0; j < buttons.Length; j++)
			{
				buttons[j].renderer.enabled = true;
			}
			renderer.enabled = true;
		}
		return renderer.enabled;
	}

	private bool HideMenuRenderer()
	{
		for (int i = 0; i < buttons.Length; i++)
		{
			buttons[i].renderer.enabled = !buttons[i].renderer.enabled;
		}
		renderer.enabled = !renderer.enabled;
		return renderer.enabled;
	}

	private IEnumerator ReloadLevel(float delay)
	{
		Time.timeScale = 1f;
		yield return new WaitForSeconds(delay);
		Application.LoadLevel(Application.loadedLevel);
	}

	private Transform MouseCheck()
	{
		Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
		RaycastHit hitInfo;
		if (Physics.Raycast(ray, out hitInfo, 100f, layerMask))
		{
			for (int i = 0; i < buttons.Length; i++)
			{
				if (hitInfo.transform == buttons[i].transform)
				{
					selection = i;
				}
			}
		}
		return hitInfo.transform;
	}
}
