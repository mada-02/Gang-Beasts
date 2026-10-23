using UnityEngine;

// World and player settings from the dev menu: time scale, gravity, volume, infinite health, balance
// balls, the FPS counter and punch power. Lives on the DevRoot object.
public class DevWorld : MonoBehaviour
{
	public static DevWorld instance;

	public Vector3 defaultGravity;

	// Every human player, or single slots (P1-P4).
	public bool infiniteHealthHumans;

	public readonly bool[] infiniteHealthSlot = new bool[4];

	public bool showBalls;

	public bool showFps;

	public string fpsText = "";

	private int fpsFrames;

	private float fpsSince;

	private void Awake()
	{
		instance = this;
		defaultGravity = Physics.gravity;
		BeastRegistry.Added += OnAdded;
	}

	private void OnDestroy()
	{
		BeastRegistry.Added -= OnAdded;
		if (instance == this)
		{
			instance = null;
		}
	}

	// Every beast gets the punch-power component on its hands and the balance-ball setting.
	private void OnAdded(Beast beast)
	{
		foreach (string hand in new string[] { "leftHand", "rightHand" })
		{
			Transform t = beast.Part(hand);
			if (t != null && t.GetComponent<DevPunch>() == null)
			{
				t.gameObject.AddComponent<DevPunch>();
			}
		}
		ApplyBall(beast);
	}

	private void ApplyBall(Beast beast)
	{
		Transform ball = beast.Part("ball");
		if (ball != null && ball.renderer != null)
		{
			ball.renderer.enabled = showBalls;
		}
	}

	public void SetShowBalls(bool value)
	{
		showBalls = value;
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player != null)
			{
				ApplyBall(b);
			}
		}
	}

	// AudioTimeScale (in some levels) writes its own private value to Time.timeScale every frame, so
	// that value is changed too.
	public static void SetTimeScale(float value)
	{
		Time.timeScale = value;
		if (DevReflection.audioTimeScale == null)
		{
			return;
		}
		foreach (Object o in Object.FindObjectsOfType(typeof(AudioTimeScale)))
		{
			DevReflection.audioTimeScale.SetValue(o, value);
		}
	}

	public void SetGravityY(float y)
	{
		Physics.gravity = new Vector3(defaultGravity.x, y, defaultGravity.z);
	}

	public bool InfiniteHealth(Beast beast)
	{
		if (beast.player == null || beast.player.mob)
		{
			return false;
		}
		int slot = beast.player.player;
		return infiniteHealthHumans || (slot >= 0 && slot < infiniteHealthSlot.Length && infiniteHealthSlot[slot]);
	}

	private void Update()
	{
		// Full health also ends any stun (HealthAndStamina.ReplenishStats clears the stun timer at full
		// health). The beast's own maximum: a 200-health boss is not held at 100.
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.stats != null && b.Alive && InfiniteHealth(b))
			{
				b.stats.health = b.MaxHealth;
			}
		}
		fpsFrames++;
		float elapsed = Time.realtimeSinceStartup - fpsSince;
		if (elapsed >= 0.5f)
		{
			fpsText = (fpsFrames / elapsed).ToString("0") + " fps";
			fpsFrames = 0;
			fpsSince = Time.realtimeSinceStartup;
		}
	}
}
