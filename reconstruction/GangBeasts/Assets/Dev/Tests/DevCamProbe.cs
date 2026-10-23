using UnityEngine;

// Where Camera.main is at each point of a frame, checked by three probe scripts at execution orders -1
// (DevProbeEarly: before SceneCamera.FixedUpdate and Player.Update), +1 (DevProbeLate: after them) and
// +2000 (DevProbeLast: after FreeCamApply). Counts samples that break FreeCam's promise.
public static class DevCamProbe
{
	public static bool on;

	// Player controls follow the free camera: Update sees the free pose.
	public static bool expectFreeInUpdate;

	public static int samples;

	public static int fixedBad;

	public static int updateBad;

	public static int lateBad;

	public static void Reset()
	{
		samples = 0;
		fixedBad = 0;
		updateBad = 0;
		lateBad = 0;
	}

	private static bool At(Vector3 position, Quaternion rotation)
	{
		Transform t = FreeCam.camera.transform;
		return (t.position - position).magnitude < 1e-4f && Quaternion.Angle(t.rotation, rotation) < 0.01f;
	}

	// SceneCamera aims with LookAt at its "Camera Target" as it stands before the step (its MovePosition
	// lands in the physics step), so the target is noted before SceneCamera runs and the saved game
	// rotation is checked against it once FreeCamApply has saved it.
	public static Transform aimTarget;

	private static Vector3 aimFrom;

	public static float worstAim;

	internal static void FixedEarly()
	{
		if (aimTarget != null)
		{
			aimFrom = aimTarget.position;
		}
		if (!on || !FreeCam.active || FreeCam.camera == null)
		{
			return;
		}
		samples++;
		if (!At(FreeCam.gamePosition, FreeCam.gameRotation))
		{
			fixedBad++;
		}
	}

	internal static void Update()
	{
		if (!on || !FreeCam.active || FreeCam.camera == null)
		{
			return;
		}
		samples++;
		bool ok = expectFreeInUpdate ? At(FreeCam.freePosition, FreeCam.FreeRotation) : At(FreeCam.gamePosition, FreeCam.gameRotation);
		if (!ok)
		{
			updateBad++;
		}
	}

	internal static void FixedLast()
	{
		if (aimTarget == null || !FreeCam.active)
		{
			return;
		}
		Vector3 to = aimFrom - FreeCam.gamePosition;
		if (to.magnitude > 0.5f)
		{
			worstAim = Mathf.Max(worstAim, Vector3.Angle(FreeCam.gameRotation * Vector3.forward, to));
		}
	}

	// Called at the end of LateUpdate (headless players never reach WaitForEndOfFrame: nothing renders).
	public static System.Action lateCallback;

	internal static void LateLast()
	{
		if (lateCallback != null)
		{
			lateCallback();
		}
		if (!on || !FreeCam.active || FreeCam.camera == null)
		{
			return;
		}
		samples++;
		if (!At(FreeCam.freePosition, FreeCam.FreeRotation))
		{
			lateBad++;
		}
	}
}

// Scripted input and a fixed clock for the free camera.
public class ScriptedFreeCamInput : IFreeCamInput
{
	public Vector3 move;

	public Vector2 look;

	public float scroll;

	public bool fast;

	public bool slow;

	public Vector3 Move()
	{
		return move;
	}

	public Vector2 Look()
	{
		return look;
	}

	public float Scroll()
	{
		return scroll;
	}

	public bool Fast()
	{
		return fast;
	}

	public bool Slow()
	{
		return slow;
	}
}
