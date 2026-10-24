using UnityEngine;

public delegate void DevEvent();

// The developer layer's root, added to the persistent SceneManager object by the hook in
// SceneManager.Awake (developer branch only; see CLAUDE.md). Every dev module hangs off this object,
// so it lives as long as the game and survives level loads.
//
// Level lifecycle: on each level load (OnLevelWasLoaded runs after the new scene's Awake calls and
// before any Start or physics step, so every beast still stands in its scene pose) the registry and
// factory reset, the template is captured, the level's beasts are registered and LevelReady fires.
// The first scene gets no OnLevelWasLoaded; Start covers it.
public class DevRoot : MonoBehaviour
{
	public static DevRoot instance;

	// A level was loaded: before its beasts are registered (modules drop per-level state here).
	public static event DevEvent LevelStarting;

	// After a level load, once the template is captured and the level's beasts are registered.
	public static event DevEvent LevelReady;

	private bool started;

	private float nextSweep;

	public static int levelsStarted;

	private void Awake()
	{
		instance = this;
		DevSpawner.Init();
		Morph.Init();
		FreeCam.Init();
		HardMode.Init();
		gameObject.AddComponent<DevWorld>();
		gameObject.AddComponent<DevMenu>();
		gameObject.AddComponent<FreeCamRestore>();
		gameObject.AddComponent<FreeCamApply>();
		gameObject.AddComponent<HardPlayerPre>();
		gameObject.AddComponent<HardPlayerPost>();
		gameObject.AddComponent<AIDirector>();
		if (DevTestRunner.Requested())
		{
			gameObject.AddComponent<DevTestRunner>();
		}
	}

	private void Start()
	{
		if (!started)
		{
			StartLevel();
		}
	}

	private void OnLevelWasLoaded(int level)
	{
		StartLevel();
	}

	private void StartLevel()
	{
		started = true;
		levelsStarted++;
		BeastRegistry.LevelLoaded();
		BeastFactory.LevelLoaded();
		DevProps.LevelLoaded();
		if (LevelStarting != null)
		{
			LevelStarting();
		}
		BeastFactory.Capture();
		BeastRegistry.Sweep();
		if (LevelReady != null)
		{
			LevelReady();
		}
		nextSweep = Time.realtimeSinceStartup + 0.5f;
	}

	private void Update()
	{
		// Beasts the game makes later (Respawn) or switches on (Subway's mobs) are registered here.
		if (Time.realtimeSinceStartup >= nextSweep)
		{
			nextSweep = Time.realtimeSinceStartup + 1f;
			BeastRegistry.Sweep();
		}
	}

	private void OnDestroy()
	{
		if (instance == this)
		{
			instance = null;
		}
	}
}
