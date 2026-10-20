using System;
using UnityEngine;

public class CircularGravityVisualizer : MonoBehaviour
{
	[Serializable]
	public class SizeProperties
	{
		public float min = 0.01f;

		public float max = 35f;
	}

	[Serializable]
	public class ForcePower
	{
		public float min = -200f;

		public float max = 200f;
	}

	[Serializable]
	public class CapsuleRadius
	{
		public float min = 0.01f;

		public float max = 25f;
	}

	[Serializable]
	public class PulseSpeed
	{
		public float min;

		public float max = 100f;
	}

	[Serializable]
	public class PulseMinSize
	{
		public float min = 1f;

		public float max = 74f;
	}

	[Serializable]
	public class PulseMaxSize
	{
		public float min = 2f;

		public float max = 75f;
	}

	[Serializable]
	public class SceneTimeScale
	{
		public float min;

		public float max = 1f;
	}

	public GameObject circularGravityGameObject;

	public Vector2 guiLocation = new Vector2(0f, 0f);

	public SizeProperties sizeProperties;

	public ForcePower forcePower;

	public CapsuleRadius capsuleRadius;

	public PulseSpeed pulseSpeed;

	public PulseMinSize pulseMinSize;

	public PulseMaxSize pulseMaxSize;

	public SceneTimeScale sceneTimeScale;

	public GameObject defaultAttachedGameObject;

	public bool toggleGravityEffect;

	public bool noGravity;

	private float hSliderSize;

	private float hSceneTimeScale;

	private float hSliderForcePower;

	private float hSliderCapsuleRadius;

	private bool togglePulse;

	private bool toggleNoGravity;

	private bool toggleDrawForce;

	private float hSliderPulseSpeed;

	private float hSliderPulseMinSize;

	private float hSliderPulseMaxSize;

	private Vector3 previewsGravity = new Vector3(0f, -9.78f, 0f);

	private Vector3 gravityZeroG = new Vector3(0f, 0f, 0f);

	private void Start()
	{
		Physics.gravity = gravityZeroG;
		try
		{
			CircularGravity component = circularGravityGameObject.GetComponent<CircularGravity>();
			hSliderSize = component.sizeProperties.size;
			hSceneTimeScale = Time.timeScale;
			hSliderForcePower = component.forcePower;
			hSliderCapsuleRadius = component.sizeProperties.capsuleRadius;
			togglePulse = component.pulseProperties.pulse;
			toggleDrawForce = component.drawGravityProperties.drawGravityForce;
			hSliderPulseSpeed = component.pulseProperties.speed;
			hSliderPulseMinSize = component.pulseProperties.minSize;
			hSliderPulseMaxSize = component.pulseProperties.maxSize;
			noGravity = toggleNoGravity;
		}
		catch (Exception)
		{
			Debug.LogWarning("Error reading CircularGravity GameObject");
		}
	}

	private void Awake()
	{
		if (Physics.gravity == gravityZeroG || noGravity)
		{
			toggleNoGravity = true;
		}
		else
		{
			toggleNoGravity = false;
			previewsGravity = Physics.gravity;
		}
	}

	private void Update()
	{
		ToggleGravity();
	}

	private void OnGUI()
	{
		GUIStyle gUIStyle = new GUIStyle();
		gUIStyle.normal.textColor = Color.white;
		gUIStyle.alignment = TextAnchor.MiddleRight;
		GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 5f, 100f, 20f), "Shape:", gUIStyle);
		if (GUI.Button(new Rect(guiLocation.x + 110f, guiLocation.y + 5f, 63f, 20f), "Sphere"))
		{
			circularGravityGameObject.GetComponent<CircularGravity>().shape = CircularGravity.Shape.Sphere;
		}
		else if (GUI.Button(new Rect(guiLocation.x + 178f, guiLocation.y + 5f, 63f, 20f), "Capsule"))
		{
			circularGravityGameObject.GetComponent<CircularGravity>().shape = CircularGravity.Shape.Capsule;
		}
		else if (GUI.Button(new Rect(guiLocation.x + 248f, guiLocation.y + 5f, 63f, 20f), "Raycast"))
		{
			circularGravityGameObject.GetComponent<CircularGravity>().shape = CircularGravity.Shape.RayCast;
		}
		GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 25f, 100f, 20f), "Force Power:", gUIStyle);
		hSliderForcePower = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 30f, 200f, 20f), hSliderForcePower, forcePower.min, forcePower.max);
		if (circularGravityGameObject.GetComponent<CircularGravity>().shape == CircularGravity.Shape.Capsule)
		{
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 50f, 100f, 20f), "Capsule Radius:", gUIStyle);
			hSliderCapsuleRadius = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 55f, 200f, 20f), hSliderCapsuleRadius, capsuleRadius.min, capsuleRadius.max);
		}
		toggleGravityEffect = GUI.Toggle(new Rect(guiLocation.x + 315f, guiLocation.y + 25f, 150f, 20f), toggleGravityEffect, "Gravity Effect");
		togglePulse = GUI.Toggle(new Rect(guiLocation.x + 315f, guiLocation.y + 50f, 50f, 20f), togglePulse, "Pulse");
		toggleDrawForce = GUI.Toggle(new Rect(guiLocation.x + 315f, guiLocation.y + 75f, 80f, 20f), toggleDrawForce, "Draw Force");
		toggleNoGravity = GUI.Toggle(new Rect(guiLocation.x + 315f, guiLocation.y + 100f, 80f, 20f), toggleNoGravity, "No Gravity");
		float num;
		if (!togglePulse)
		{
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 75f, 100f, 20f), "Custom Size:", gUIStyle);
			hSliderSize = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 80f, 200f, 20f), hSliderSize, sizeProperties.min, sizeProperties.max);
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 100f, 100f, 20f), "Time Scale:", gUIStyle);
			hSceneTimeScale = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 105f, 200f, 20f), hSceneTimeScale, sceneTimeScale.min, sceneTimeScale.max);
			num = 125f;
		}
		else
		{
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 75f, 100f, 20f), "pulse Max Size:", gUIStyle);
			hSliderPulseMaxSize = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 80f, 200f, 20f), hSliderPulseMaxSize, pulseMaxSize.min, pulseMaxSize.max);
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 100f, 100f, 20f), "Pulse Min Size:", gUIStyle);
			hSliderPulseMinSize = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 105f, 200f, 20f), hSliderPulseMinSize, pulseMinSize.min, pulseMinSize.max);
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 125f, 100f, 20f), "Pulse Speed:", gUIStyle);
			hSliderPulseSpeed = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 130f, 200f, 20f), hSliderPulseSpeed, pulseSpeed.min, pulseSpeed.max);
			GUI.Label(new Rect(guiLocation.x + 5f, guiLocation.y + 150f, 100f, 20f), "Time Scale:", gUIStyle);
			hSceneTimeScale = GUI.HorizontalSlider(new Rect(guiLocation.x + 110f, guiLocation.y + 155f, 200f, 20f), hSceneTimeScale, sceneTimeScale.min, sceneTimeScale.max);
			num = 175f;
		}
		if (GUI.Button(new Rect(guiLocation.x + 260f, guiLocation.y + num, 50f, 20f), "Reset"))
		{
			Application.LoadLevel(Application.loadedLevelName);
			hSceneTimeScale = 1f;
		}
		try
		{
			CircularGravity component = circularGravityGameObject.GetComponent<CircularGravity>();
			if (component.specialEffect.attachedGameObject == null && defaultAttachedGameObject != null)
			{
				component.specialEffect.attachedGameObject = defaultAttachedGameObject;
			}
			if (!togglePulse)
			{
				component.sizeProperties.size = hSliderSize;
			}
			if (toggleGravityEffect)
			{
				component.specialEffect.timeEffected = 3f;
				component.specialEffect.physicsEffect = CircularGravity.PhysicsEffect.NoGravity;
			}
			else
			{
				component.specialEffect.timeEffected = 0f;
				component.specialEffect.physicsEffect = CircularGravity.PhysicsEffect.None;
			}
			component.forcePower = hSliderForcePower;
			component.sizeProperties.capsuleRadius = hSliderCapsuleRadius;
			component.pulseProperties.pulse = togglePulse;
			component.drawGravityProperties.drawGravityForce = toggleDrawForce;
			component.pulseProperties.speed = hSliderPulseSpeed;
			component.pulseProperties.minSize = hSliderPulseMinSize;
			component.pulseProperties.maxSize = hSliderPulseMaxSize;
			Time.timeScale = hSceneTimeScale;
		}
		catch (Exception)
		{
			Debug.LogWarning("Error reading CircularGravity GameObject");
		}
	}

	private void ToggleGravity()
	{
		if (toggleNoGravity)
		{
			if (Physics.gravity != gravityZeroG)
			{
				Physics.gravity = gravityZeroG;
			}
		}
		else if (Physics.gravity != previewsGravity)
		{
			Physics.gravity = previewsGravity;
		}
	}
}
