using UnityEngine;

public interface IFreeCamInput
{
	// x: right, y: up, z: forward, each -1..1.
	Vector3 Move();

	// Degrees to turn this frame (x: yaw, y: pitch).
	Vector2 Look();

	// Mouse-wheel notches this frame.
	float Scroll();

	bool Fast();

	bool Slow();
}

// Keyboard and mouse: WASD to fly, Q/E down/up, Shift faster, Ctrl slower, the wheel sets the speed,
// and only while the right mouse button is held (so keys bound to players stay theirs otherwise).
public class KeyboardFreeCamInput : IFreeCamInput
{
	public float sensitivity = 3f;

	private bool Held()
	{
		return Input.GetMouseButton(1);
	}

	public Vector3 Move()
	{
		if (!Held())
		{
			return Vector3.zero;
		}
		Vector3 m = Vector3.zero;
		if (Input.GetKey(KeyCode.W))
		{
			m.z += 1f;
		}
		if (Input.GetKey(KeyCode.S))
		{
			m.z -= 1f;
		}
		if (Input.GetKey(KeyCode.D))
		{
			m.x += 1f;
		}
		if (Input.GetKey(KeyCode.A))
		{
			m.x -= 1f;
		}
		if (Input.GetKey(KeyCode.E))
		{
			m.y += 1f;
		}
		if (Input.GetKey(KeyCode.Q))
		{
			m.y -= 1f;
		}
		return m;
	}

	public Vector2 Look()
	{
		return Held() ? new Vector2(Input.GetAxisRaw("Mouse X"), Input.GetAxisRaw("Mouse Y")) * sensitivity : Vector2.zero;
	}

	public float Scroll()
	{
		return Input.GetAxisRaw("Mouse ScrollWheel") * 10f;
	}

	public bool Fast()
	{
		return Input.GetKey(KeyCode.LeftShift) || Input.GetKey(KeyCode.RightShift);
	}

	public bool Slow()
	{
		return Input.GetKey(KeyCode.LeftControl) || Input.GetKey(KeyCode.RightControl);
	}
}

public delegate float FreeCamClock();

// A free camera over the level's own (Camera tab, F11). The game camera keeps working underneath:
// SceneCamera moves Camera.main in FixedUpdate and human controls are read relative to Camera.main in
// Player.Update, so the camera holds the game's pose for those (FreeCamRestore, execution order -1000)
// and the free pose only for rendering (FreeCamApply, +1000, LateUpdate). Turning it off leaves the game
// camera exactly where its own smoothing has it; R and Escape keep working.
public static class FreeCam
{
	public static bool active;

	// Human controls follow the free camera instead of the game's (off: as if it were not there).
	public static bool controlsFollowFreeCam;

	public static KeyCode toggleKey = KeyCode.F11;

	public static float speed = 5f;

	public static float fieldOfView = -1f;

	// Orbit a beast instead of flying (mouse turns round it, wheel sets the distance).
	public static Beast follow;

	public static float followDistance = 4f;

	public static IFreeCamInput input = new KeyboardFreeCamInput();

	// Seconds since the last frame, not scaled: the free camera flies at time scale 0 too. Tests swap it.
	public static FreeCamClock clock = RealDelta;

	public static Camera camera;

	public static Vector3 gamePosition;

	public static Quaternion gameRotation;

	public static Vector3 freePosition;

	public static float yaw;

	public static float pitch;

	private static float savedFov;

	private static float lastReal;

	private static int restoredFrame = -1;

	private static CameraShake[] stoppedShakes = new CameraShake[0];

	private static bool initialised;

	public static void Init()
	{
		if (initialised)
		{
			return;
		}
		initialised = true;
		DevRoot.LevelReady += () => SetActive(false);
		DevMenu.extraTabs.Add(new System.Collections.Generic.KeyValuePair<string, DevMenu.Section>("Camera", DrawTab));
	}

	public static float RealDelta()
	{
		float now = Time.realtimeSinceStartup;
		float dt = Mathf.Clamp(now - lastReal, 0f, 0.1f);
		lastReal = now;
		return dt;
	}

	public static Quaternion FreeRotation
	{
		get { return Quaternion.Euler(pitch, yaw, 0f); }
	}

	public static void SetActive(bool value)
	{
		if (value == active)
		{
			return;
		}
		if (value)
		{
			camera = Camera.main;
			if (camera == null)
			{
				return;
			}
			active = true;
			gamePosition = camera.transform.position;
			gameRotation = camera.transform.rotation;
			freePosition = gamePosition;
			Vector3 euler = gameRotation.eulerAngles;
			yaw = euler.y;
			pitch = Mathf.DeltaAngle(0f, euler.x);
			savedFov = camera.fieldOfView;
			lastReal = Time.realtimeSinceStartup;
			// Subway's camera shake writes the camera position itself.
			System.Collections.Generic.List<CameraShake> running = new System.Collections.Generic.List<CameraShake>();
			foreach (CameraShake s in camera.GetComponents<CameraShake>())
			{
				if (s.enabled)
				{
					s.enabled = false;
					running.Add(s);
				}
			}
			stoppedShakes = running.ToArray();
			return;
		}
		active = false;
		follow = null;
		if (camera != null)
		{
			camera.transform.position = gamePosition;
			camera.transform.rotation = gameRotation;
			camera.fieldOfView = savedFov;
			foreach (CameraShake s in stoppedShakes)
			{
				if (s != null)
				{
					s.enabled = true;
				}
			}
		}
		stoppedShakes = new CameraShake[0];
	}

	// FreeCamRestore: the first FixedUpdate or Update of a frame puts the game's pose back.
	internal static void Restore(bool fixedStep)
	{
		if (!active || camera == null)
		{
			return;
		}
		if (fixedStep)
		{
			camera.transform.position = gamePosition;
			camera.transform.rotation = gameRotation;
			return;
		}
		if (restoredFrame == Time.frameCount)
		{
			return;
		}
		restoredFrame = Time.frameCount;
		camera.transform.position = controlsFollowFreeCam ? freePosition : gamePosition;
		camera.transform.rotation = controlsFollowFreeCam ? FreeRotation : gameRotation;
	}

	// FreeCamApply.FixedUpdate: SceneCamera has moved the camera; that is the game's pose.
	internal static void SaveGamePose()
	{
		if (!active || camera == null)
		{
			return;
		}
		gamePosition = camera.transform.position;
		gameRotation = camera.transform.rotation;
	}

	// FreeCamApply.LateUpdate: fly, then show the free pose.
	internal static void Apply()
	{
		if (active && camera == null)
		{
			SetActive(false);
		}
		if (!active)
		{
			return;
		}
		float dt = clock();
		Vector2 look = input.Look();
		yaw += look.x;
		pitch = Mathf.Clamp(pitch - look.y, -89f, 89f);
		speed = Mathf.Clamp(speed * Mathf.Pow(1.25f, input.Scroll()), 0.5f, 100f);
		if (follow != null && follow.player != null)
		{
			followDistance = Mathf.Clamp(followDistance - input.Scroll(), 1f, 30f);
			Vector3 centre = follow.Chest;
			freePosition = centre - FreeRotation * Vector3.forward * followDistance;
		}
		else
		{
			float v = speed * (input.Fast() ? 4f : 1f) * (input.Slow() ? 0.25f : 1f);
			Vector3 m = input.Move();
			freePosition += (FreeRotation * new Vector3(m.x, 0f, m.z) + Vector3.up * m.y) * v * dt;
		}
		camera.transform.position = freePosition;
		camera.transform.rotation = FreeRotation;
		if (fieldOfView > 0f)
		{
			camera.fieldOfView = fieldOfView;
		}
		// StatusBar turns the bars to Camera.main in Update, when it held the game's pose.
		foreach (Beast b in BeastRegistry.All)
		{
			if (b.player == null)
			{
				continue;
			}
			Transform bar = b.player.transform.Find("healthBar");
			if (bar != null)
			{
				bar.rotation = FreeRotation;
			}
			bar = b.player.transform.Find("staminaBar");
			if (bar != null)
			{
				bar.rotation = FreeRotation;
			}
		}
	}

	private static void DrawTab()
	{
		bool on = GUILayout.Toggle(active, "Free camera (" + toggleKey + ")");
		if (on != active)
		{
			SetActive(on);
		}
		GUILayout.Label("Hold the right mouse button: look, WASD fly, Q/E down/up, Shift fast, Ctrl slow, wheel speed.");
		speed = DevMenu.Slider("Speed", speed, 0.5f, 100f, "0.0");
		float fov = DevMenu.Slider("FOV", fieldOfView > 0f ? fieldOfView : (camera != null ? camera.fieldOfView : 60f), 10f, 120f, "0");
		if (active)
		{
			fieldOfView = fov;
		}
		controlsFollowFreeCam = GUILayout.Toggle(controlsFollowFreeCam, "Player controls follow the free camera");
		GUILayout.Label("Orbit:");
		GUILayout.BeginHorizontal();
		if (GUILayout.Button("Fly"))
		{
			follow = null;
		}
		for (int slot = 0; slot < 4; slot++)
		{
			Beast human = BeastRegistry.Human(slot);
			if (human != null && GUILayout.Button("P" + (slot + 1)))
			{
				SetActive(true);
				follow = human;
			}
		}
		GUILayout.EndHorizontal();
	}
}
