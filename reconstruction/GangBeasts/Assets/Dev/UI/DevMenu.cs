using System.Collections.Generic;
using UnityEngine;

// The F12 developer menu (IMGUI). Only draws and forwards to the modules (DevSpawner, DevProps,
// DevWorld, ...), which the tests drive directly: OnGUI never runs in a headless player.
public class DevMenu : MonoBehaviour
{
	public static DevMenu instance;

	public KeyCode toggleKey = KeyCode.F12;

	public bool open;

	public int tab;

	// Extra tabs and sections registered by later modules (camera, morph, hard mode, AI).
	public delegate void Section();

	public static readonly List<KeyValuePair<string, Section>> extraTabs = new List<KeyValuePair<string, Section>>();

	public static readonly List<Section> aiSections = new List<Section>();

	public static readonly List<Section> playerSections = new List<Section>();

	public static readonly List<Section> worldSections = new List<Section>();

	private const int WindowId = 0x6B5D1;

	private static readonly string[] baseTabs = { "AI", "Player", "Objects", "World", "Level", "Debug" };

	private static readonly string[] fallbackLevels = { "Tutorial", "Sandbox", "Ring", "Grind", "Gondola", "Trucks", "Incinerator", "Wheel", "Subway", "Street" };

	private static readonly string[] bodyNames = { "Normal", "Pink Boss" };

	private static readonly string[] teamNames = { "Mob gang", "Free-for-all", "Team A", "Team B", "Team C", "Team D", "Ally P1", "Ally P2", "Ally P3", "Ally P4" };

	private static readonly string[] spawnAtNames = { "Screen centre", "Near P1" };

	private Rect window = new Rect(20f, 20f, 320f, 440f);

	private Vector2 scroll;

	private bool cursorWasVisible;

	private bool cursorWasLocked;

	public readonly AISpawnRequest request = new AISpawnRequest();

	private int bodyIndex;

	// Per body: Normal spawns in random colours by default, Pink Boss in its own pink.
	private readonly bool[] randomColor = { true, false };

	private void Awake()
	{
		instance = this;
	}

	private void Update()
	{
		if (Input.GetKeyDown(toggleKey))
		{
			SetOpen(!open);
		}
	}

	public void SetOpen(bool value)
	{
		if (value == open)
		{
			return;
		}
		open = value;
		if (open)
		{
			cursorWasVisible = Screen.showCursor;
			cursorWasLocked = Screen.lockCursor;
			Screen.lockCursor = false;
			Screen.showCursor = true;
		}
		else
		{
			Screen.showCursor = cursorWasVisible;
			Screen.lockCursor = cursorWasLocked;
		}
	}

	private void OnGUI()
	{
		// Always the built-in skin, whatever the game's GUI scripts set.
		GUI.skin = null;
		GUI.depth = -1000;
		DevWorld world = DevWorld.instance;
		if (world != null && world.showFps)
		{
			GUI.Label(new Rect(Screen.width - 70f, 4f, 66f, 20f), world.fpsText);
		}
		if (!open)
		{
			return;
		}
		window = GUI.Window(WindowId, window, DrawWindow, "Dev Menu (" + toggleKey + ")");
		// Keep the title bar on screen so the window cannot be dragged out of reach.
		window.x = Mathf.Clamp(window.x, 0f, Mathf.Max(0f, Screen.width - window.width));
		window.y = Mathf.Clamp(window.y, 0f, Mathf.Max(0f, Screen.height - 20f));
	}

	private string[] Tabs()
	{
		List<string> names = new List<string>(baseTabs);
		foreach (KeyValuePair<string, Section> t in extraTabs)
		{
			names.Add(t.Key);
		}
		return names.ToArray();
	}

	private void DrawWindow(int id)
	{
		string[] tabs = Tabs();
		tab = Mathf.Clamp(GUILayout.SelectionGrid(tab, tabs, 4), 0, tabs.Length - 1);
		scroll = GUILayout.BeginScrollView(scroll);
		switch (tab)
		{
		case 0:
			DrawAI();
			break;
		case 1:
			DrawPlayer();
			break;
		case 2:
			DrawObjects();
			break;
		case 3:
			DrawWorld();
			break;
		case 4:
			DrawLevel();
			break;
		case 5:
			DrawDebug();
			break;
		default:
			extraTabs[tab - baseTabs.Length].Value();
			break;
		}
		GUILayout.EndScrollView();
		GUI.DragWindow(new Rect(0f, 0f, 10000f, 20f));
	}

	public static float Slider(string label, float value, float min, float max, string format)
	{
		GUILayout.BeginHorizontal();
		GUILayout.Label(label, GUILayout.Width(80f));
		GUILayout.BeginVertical();
		GUILayout.Space(8f);
		value = GUILayout.HorizontalSlider(value, min, max);
		GUILayout.EndVertical();
		GUILayout.Label(value.ToString(format), GUILayout.Width(40f));
		GUILayout.EndHorizontal();
		return value;
	}

	private void DrawAI()
	{
		if (BeastFactory.Template == null)
		{
			GUILayout.Label("No beast to copy in this level.");
			if (GUILayout.Button("Retry"))
			{
				BeastFactory.Capture();
			}
			return;
		}
		GUILayout.Label("Template: " + BeastFactory.TemplateSource);
		if (!BeastFactory.HasNavMesh)
		{
			GUILayout.Label("No NavMesh near here: the game's AI will not walk.");
		}
		request.count = Mathf.RoundToInt(Slider("Count", request.count, 1f, 50f, "0"));
		bodyIndex = GUILayout.Toolbar(bodyIndex, bodyNames);
		request.body = bodyIndex == 1 ? (HardMode.on ? BeastBody.Boss002 : BeastBody.Boss003) : BeastBody.Normal;
		request.team = (DevTeam)GUILayout.SelectionGrid((int)request.team, teamNames, 4);
		request.at = (DevSpawnAt)GUILayout.Toolbar((int)request.at, spawnAtNames);
		randomColor[bodyIndex] = GUILayout.Toggle(randomColor[bodyIndex], "Random colours");
		request.randomColor = randomColor[bodyIndex];
		if (bodyIndex == 0)
		{
			request.fullHealth = GUILayout.Toggle(request.fullHealth, "100 health (level's: " + BeastFactory.TemplateHealth.ToString("0") + ")");
		}
		foreach (Section s in aiSections)
		{
			s();
		}
		if (GUILayout.Button("Spawn AI"))
		{
			DevSpawner.Spawn(request);
		}
		if (DevSpawner.message != "")
		{
			GUILayout.Label(DevSpawner.message);
		}
		GUILayout.Label("Spawned AI alive: " + DevSpawner.CountSpawned(true) + " / " + DevSpawner.CountSpawned(false));
		GUILayout.BeginHorizontal();
		if (GUILayout.Button("Remove dead"))
		{
			DevSpawner.RemoveDead();
		}
		if (GUILayout.Button("Remove spawned"))
		{
			DevSpawner.RemoveSpawned();
		}
		GUILayout.EndHorizontal();
		if (GUILayout.Button("Remove all AI (incl. level mobs)"))
		{
			DevSpawner.RemoveAllMobs();
		}
	}

	private void DrawPlayer()
	{
		DevWorld world = DevWorld.instance;
		world.infiniteHealthHumans = GUILayout.Toggle(world.infiniteHealthHumans, "Infinite health (every player)");
		for (int slot = 0; slot < 4; slot++)
		{
			Beast human = BeastRegistry.Human(slot);
			if (human == null)
			{
				continue;
			}
			world.infiniteHealthSlot[slot] = GUILayout.Toggle(world.infiniteHealthSlot[slot], "Infinite health P" + (slot + 1));
		}
		foreach (Section s in playerSections)
		{
			s();
		}
	}

	private void DrawObjects()
	{
		DevProps.size = Slider("Size", DevProps.size, 0.25f, 3f, "0.00");
		DevProps.mass = Slider("Mass", DevProps.mass, 0.1f, 50f, "0.0");
		Vector3 at = DevGround.ScreenCentre();
		GUILayout.Label("Primitives");
		int pick = GUILayout.SelectionGrid(-1, DevProps.primitiveNames, 4);
		if (pick >= 0)
		{
			DevProps.SpawnPrimitive(pick, at);
		}
		if (DevProps.PrefabNames.Length > 0)
		{
			GUILayout.Label("Prefabs");
			pick = GUILayout.SelectionGrid(-1, DevProps.PrefabNames, 2);
			if (pick >= 0)
			{
				DevProps.SpawnPrefab(pick, at);
			}
		}
		GUILayout.BeginHorizontal();
		GUILayout.Label("Copy from this level");
		if (GUILayout.Button("Refresh", GUILayout.Width(64f)) || DevProps.LevelObjectNames.Length == 0)
		{
			DevProps.RefreshLevelObjects();
		}
		GUILayout.EndHorizontal();
		if (DevProps.LevelObjectNames.Length == 0)
		{
			GUILayout.Label("(no loose physics objects)");
		}
		pick = GUILayout.SelectionGrid(-1, DevProps.LevelObjectNames, 2);
		if (pick >= 0)
		{
			DevProps.SpawnLevelObject(pick, at);
		}
		if (GUILayout.Button("Clear spawned objects (" + DevProps.SpawnedCount + ")"))
		{
			DevProps.Clear();
		}
	}

	private void DrawWorld()
	{
		DevWorld world = DevWorld.instance;
		GUILayout.BeginHorizontal();
		float timeScale = Slider("Time scale", Time.timeScale, 0f, 2f, "0.00");
		if (GUILayout.Button("1", GUILayout.Width(24f)))
		{
			timeScale = 1f;
		}
		GUILayout.EndHorizontal();
		if (timeScale != Time.timeScale)
		{
			DevWorld.SetTimeScale(timeScale);
		}
		GUILayout.BeginHorizontal();
		float gravity = Slider("Gravity", Physics.gravity.y, -40f, 0f, "0.0");
		if (GUILayout.Button("R", GUILayout.Width(24f)))
		{
			gravity = world.defaultGravity.y;
		}
		GUILayout.EndHorizontal();
		if (gravity != Physics.gravity.y)
		{
			world.SetGravityY(gravity);
		}
		GUILayout.BeginHorizontal();
		DevPunch.power = Slider("Punch power", DevPunch.power, 1f, 10f, "0.0");
		if (GUILayout.Button("1", GUILayout.Width(24f)))
		{
			DevPunch.power = 1f;
		}
		GUILayout.EndHorizontal();
		AudioListener.volume = Slider("Volume", AudioListener.volume, 0f, 1f, "0.00");
		bool balls = GUILayout.Toggle(world.showBalls, "Show balance balls");
		if (balls != world.showBalls)
		{
			world.SetShowBalls(balls);
		}
		world.showFps = GUILayout.Toggle(world.showFps, "Show FPS");
		foreach (Section s in worldSections)
		{
			s();
		}
	}

	private void DrawLevel()
	{
		GUILayout.Label("Level: " + Application.loadedLevelName);
		GUILayout.BeginHorizontal();
		if (GUILayout.Button("Restart"))
		{
			Application.LoadLevel(Application.loadedLevel);
		}
		if (GUILayout.Button("Main menu"))
		{
			Application.LoadLevel("Menu");
		}
		GUILayout.EndHorizontal();
		GUILayout.Label("Load level");
		GameObject go = GameObject.FindWithTag("Scene Manager");
		SceneManager sm = go != null ? go.GetComponent<SceneManager>() : null;
		string[] levels = sm != null && sm.levelList != null && sm.levelList.Length > 0 ? sm.levelList : fallbackLevels;
		int pick = GUILayout.SelectionGrid(-1, levels, 2);
		if (pick >= 0)
		{
			Application.LoadLevel(levels[pick]);
		}
		GUILayout.Space(6f);
		if (GUILayout.Button("Remove spawned AI + objects"))
		{
			DevSpawner.RemoveSpawned();
			DevProps.Clear();
		}
	}

	private void DrawDebug()
	{
		GUILayout.Label("Beasts: " + BeastRegistry.All.Count + "   template: " + (BeastFactory.Template != null ? BeastFactory.TemplateSource : "none"));
		List<string> missing = DevReflection.Missing();
		if (missing.Count > 0)
		{
			GUILayout.Label("Missing game fields: " + string.Join(", ", missing.ToArray()));
		}
		GUILayout.Label("Game fixes (0.0.3 bugs):");
		DevHooks.fixMobTaunt = GUILayout.Toggle(DevHooks.fixMobTaunt, "Mobs stop taunting at a living target");
		DevHooks.fixScoreIndex = GUILayout.Toggle(DevHooks.fixScoreIndex, "No IndexOutOfRange when a mob dies");
	}
}
