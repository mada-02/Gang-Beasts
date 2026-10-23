using System.Collections;
using UnityEngine;

// The free camera: where Camera.main is at each point of the frame, flying, looking, orbiting, exiting.
public static class FreeCamTests
{
	private const float Dt = 1f / 60f;

	private static ScriptedFreeCamInput scripted;

	public static DevTestSuite Suite()
	{
		return new DevTestSuite("freecam")
			.Add("pose_isolation", PoseIsolation)
			.Add("game_camera_keeps_tracking", GameCameraKeepsTracking)
			.Add("controls_follow_option", ControlsFollowOption)
			.Add("exit_restores", ExitRestores)
			.Add("flies_at_any_time_scale", FliesAtAnyTimeScale)
			.Add("look_clamp_no_roll", LookClampNoRoll)
			.Add("orbit", Orbit)
			.Add("level_change_while_on", LevelChangeWhileOn)
			.Add("subway_shake_paused", SubwayShakePaused)
			.Add("status_bars_face_free_camera", StatusBarsFace);
	}

	private static float FixedClock()
	{
		return Dt;
	}

	private static void Begin()
	{
		scripted = new ScriptedFreeCamInput();
		FreeCam.input = scripted;
		FreeCam.clock = FixedClock;
		FreeCam.speed = 5f;
		FreeCam.fieldOfView = -1f;
		FreeCam.controlsFollowFreeCam = false;
		GameObject root = DevRoot.instance.gameObject;
		if (root.GetComponent<DevProbeEarly>() == null)
		{
			root.AddComponent<DevProbeEarly>();
			root.AddComponent<DevProbeLate>();
			root.AddComponent<DevProbeLast>();
		}
		DevCamProbe.Reset();
		DevCamProbe.expectFreeInUpdate = false;
		DevCamProbe.on = true;
	}

	private static void End()
	{
		FreeCam.SetActive(false);
		FreeCam.input = new KeyboardFreeCamInput();
		FreeCam.clock = FreeCam.RealDelta;
		DevCamProbe.on = false;
		DevCamProbe.lateCallback = null;
		DevWorld.SetTimeScale(1f);
	}

	// Flies 30 m up, then checks every frame at several time scales (0.5: frames without a physics step;
	// 2: frames with two; 0: none at all).
	private static IEnumerator PoseIsolation(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		FreeCam.SetActive(true);
		scripted.move = Vector3.up;
		yield return t.Frames(100);
		scripted.move = Vector3.zero;
		t.Check((FreeCam.freePosition - FreeCam.gamePosition).magnitude > 10f, "free camera well away from the game camera");
		foreach (float scale in new float[] { 1f, 0.5f, 2f, 0f })
		{
			DevWorld.SetTimeScale(scale);
			DevCamProbe.Reset();
			yield return t.Frames(150);
			t.Metric("samples_at_" + scale, DevCamProbe.samples);
			t.Equal(0, DevCamProbe.fixedBad, "time scale " + scale + ": SceneCamera always starts from the game pose");
			t.Equal(0, DevCamProbe.updateBad, "time scale " + scale + ": Player.Update sees the game pose");
			t.Equal(0, DevCamProbe.lateBad, "time scale " + scale + ": the free pose is on after LateUpdate");
		}
		End();
	}

	// SceneCamera aims its camera at the "Camera Target" it moves; under the free camera it still does.
	private static IEnumerator GameCameraKeepsTracking(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		FreeCam.SetActive(true);
		scripted.move = new Vector3(1f, 1f, 0f);
		Beast p1 = BeastRegistry.Human(0);
		DevPilot.On(p1).direction = Vector3.forward;
		DevCamProbe.aimTarget = GameObject.Find("Camera Target").transform;
		DevCamProbe.worstAim = 0f;
		yield return t.Frames(300);
		float worst = DevCamProbe.worstAim;
		DevCamProbe.aimTarget = null;
		DevPilot.On(p1).direction = Vector3.zero;
		t.Metric("worst_aim_error_deg", worst);
		t.Check(worst < 0.05f, "the game camera keeps aiming exactly where SceneCamera aims it (worst " + worst + " deg)");
		End();
	}

	private static IEnumerator ControlsFollowOption(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		FreeCam.SetActive(true);
		scripted.move = Vector3.up;
		yield return t.Frames(30);
		FreeCam.controlsFollowFreeCam = true;
		DevCamProbe.expectFreeInUpdate = true;
		DevCamProbe.Reset();
		yield return t.Frames(100);
		t.Equal(0, DevCamProbe.updateBad, "with the option on, Player.Update sees the free pose");
		t.Equal(0, DevCamProbe.fixedBad, "SceneCamera still starts from the game pose");
		End();
	}

	private static IEnumerator ExitRestores(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		Camera cam = Camera.main;
		float fov = cam.fieldOfView;
		FreeCam.SetActive(true);
		FreeCam.fieldOfView = 30f;
		scripted.move = new Vector3(1f, 1f, 1f);
		yield return t.Frames(60);
		t.Near(30.0, cam.fieldOfView, 1e-4, "field of view while on");
		Vector3 game = FreeCam.gamePosition;
		Quaternion rot = FreeCam.gameRotation;
		FreeCam.SetActive(false);
		t.Near(0.0, (cam.transform.position - game).magnitude, 1e-5, "camera back at the game pose");
		t.Check(Quaternion.Angle(cam.transform.rotation, rot) < 0.01f, "camera back at the game rotation");
		t.Near(fov, cam.fieldOfView, 1e-4, "field of view restored");
		End();
	}

	private static IEnumerator FliesAtAnyTimeScale(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Begin();
		foreach (float scale in new float[] { 0f, 0.5f, 1f, 2f })
		{
			DevWorld.SetTimeScale(scale);
			FreeCam.SetActive(true);
			Vector3 from = FreeCam.freePosition;
			// W flies along the view, pitch included (as in Unity's own scene view).
			Vector3 forward = FreeCam.FreeRotation * Vector3.forward;
			scripted.move = Vector3.forward;
			yield return t.Frames(60);
			scripted.move = Vector3.zero;
			Vector3 moved = FreeCam.freePosition - from;
			t.Near(5.0, Vector3.Dot(moved, forward), 0.01, "time scale " + scale + ": 1 s at 5 m/s is 5 m along the view");
			t.Near(0.0, (moved - forward * Vector3.Dot(moved, forward)).magnitude, 0.01, "time scale " + scale + ": no sideways drift");
			FreeCam.SetActive(false);
		}
		DevWorld.SetTimeScale(1f);
		FreeCam.SetActive(true);
		Vector3 start = FreeCam.freePosition;
		scripted.move = Vector3.up;
		scripted.fast = true;
		yield return t.Frames(60);
		t.Near(20.0, FreeCam.freePosition.y - start.y, 0.01, "Shift: four times as fast");
		scripted.fast = false;
		scripted.slow = true;
		start = FreeCam.freePosition;
		yield return t.Frames(60);
		t.Near(1.25, FreeCam.freePosition.y - start.y, 0.01, "Ctrl: a quarter");
		End();
	}

	private static IEnumerator LookClampNoRoll(DevTestContext t)
	{
		yield return t.LoadLevel("Sandbox");
		Begin();
		FreeCam.SetActive(true);
		Random.seed = t.seed;
		float worstPitch = 0f;
		float worstRoll = 0f;
		for (int i = 0; i < 2000; i++)
		{
			scripted.look = new Vector2(Random.Range(-90f, 90f), Random.Range(-90f, 90f));
			yield return null;
			worstPitch = Mathf.Max(worstPitch, Mathf.Abs(FreeCam.pitch));
			float roll = Mathf.Abs(Mathf.DeltaAngle(0f, FreeCam.camera.transform.eulerAngles.z));
			worstRoll = Mathf.Max(worstRoll, roll);
		}
		t.Metric("worst_pitch", worstPitch);
		t.Metric("worst_roll", worstRoll);
		t.Check(worstPitch <= 89f, "pitch stays within 89 degrees");
		t.Check(worstRoll < 0.01f, "no roll builds up");
		End();
	}

	private static IEnumerator Orbit(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		Beast p1 = BeastRegistry.Human(0);
		FreeCam.SetActive(true);
		FreeCam.follow = p1;
		FreeCam.followDistance = 4f;
		scripted.look = new Vector2(1f, 0f);
		DevPilot.On(p1).direction = Vector3.right;
		float worstDistance = 0f;
		float worstAim = 0f;
		DevCamProbe.lateCallback = () =>
		{
			Vector3 to = p1.Chest - FreeCam.camera.transform.position;
			worstDistance = Mathf.Max(worstDistance, Mathf.Abs(to.magnitude - 4f));
			worstAim = Mathf.Max(worstAim, Vector3.Angle(FreeCam.camera.transform.forward, to));
		};
		yield return t.Frames(120);
		DevCamProbe.lateCallback = null;
		DevPilot.On(p1).direction = Vector3.zero;
		t.Check(worstDistance < 0.05f, "orbits at its distance (worst off by " + worstDistance + ")");
		t.Check(worstAim < 1f, "keeps the beast in the middle (worst " + worstAim + " deg)");
		End();
	}

	private static IEnumerator LevelChangeWhileOn(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		FreeCam.SetActive(true);
		scripted.move = Vector3.up;
		yield return t.Frames(30);
		yield return t.LoadLevel("Sandbox");
		t.Check(!FreeCam.active, "the free camera switches off on a level load");
		yield return t.Steps(50);
		SceneCamera sc = Camera.main.GetComponent<SceneCamera>();
		t.Check(sc != null && sc.enabled, "the new level's camera is the game's own");
		End();
	}

	private static IEnumerator SubwayShakePaused(DevTestContext t)
	{
		yield return t.LoadLevel("Subway");
		Begin();
		CameraShake[] shakes = Camera.main.GetComponents<CameraShake>();
		t.Metric("subway_camera_shakes", shakes.Length);
		bool[] before = new bool[shakes.Length];
		for (int i = 0; i < shakes.Length; i++)
		{
			before[i] = shakes[i].enabled;
		}
		FreeCam.SetActive(true);
		foreach (CameraShake s in shakes)
		{
			t.Check(!s.enabled, "camera shake paused while flying");
		}
		FreeCam.SetActive(false);
		for (int i = 0; i < shakes.Length; i++)
		{
			t.Equal(before[i], shakes[i].enabled, "camera shake back as it was");
		}
		End();
	}

	private static IEnumerator StatusBarsFace(DevTestContext t)
	{
		yield return t.LoadLevel("Street");
		Begin();
		Beast p1 = BeastRegistry.Human(0);
		p1.stats.health = 50f;
		yield return t.Frames(5);
		FreeCam.SetActive(true);
		scripted.look = new Vector2(30f, 10f);
		yield return t.Frames(3);
		scripted.look = Vector2.zero;
		float worst = -1f;
		DevCamProbe.lateCallback = () =>
		{
			Transform bar = p1.player.transform.Find("healthBar");
			if (bar != null)
			{
				worst = Mathf.Max(worst, Quaternion.Angle(bar.rotation, FreeCam.FreeRotation));
			}
		};
		yield return t.Frames(5);
		DevCamProbe.lateCallback = null;
		if (worst < 0f)
		{
			t.Info("note", "no health bar shown in this run");
		}
		else
		{
			t.Check(worst < 0.01f, "health bar faces the free camera (worst " + worst + " deg)");
		}
		End();
	}
}
