using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine;

public class CircularGravity : MonoBehaviour
{
	[Serializable]
	public class SizeProperties
	{
		public float size = 10f;

		public float capsuleRadius = 2f;
	}

	[Serializable]
	public class SpecialEffect
	{
		public float timeEffected;

		public GameObject attachedGameObject;

		public PhysicsEffect physicsEffect;

		public EffectedObjects effectedObjects;

		public SpecialEffect()
		{
			effectedObjects = new EffectedObjects();
		}
	}

	[Serializable]
	public class PulseProperties
	{
		public bool pulse;

		public float speed = 50f;

		public float minSize = 1f;

		public float maxSize = 5f;
	}

	[Serializable]
	public class TriggerAreaFilter
	{
		public enum TriggerAreaFilterOptions
		{
			Disabled,
			OnlyEffectWithinTigger,
			DontEffectWithinTigger
		}

		public Collider triggerArea;

		public TriggerAreaFilterOptions triggerAreaFilterOptions;
	}

	[Serializable]
	public class TagFilter
	{
		public enum TagFilterOptions
		{
			Disabled,
			OnlyEffectListedTags,
			DontEffectListedTags
		}

		public TagFilterOptions tagFilterOptions;

		public string[] tagsList;
	}

	[Serializable]
	public class DrawGravityProperties
	{
		public float thickness = 0.05f;

		public Material gravityLineMaterial;

		public bool drawGravityForce = true;
	}

	public enum Shape
	{
		Sphere,
		Capsule,
		RayCast
	}

	public enum PhysicsEffect
	{
		None,
		NoGravity
	}

	public class EffectedObjects
	{
		public EffectedObjects()
		{
			effectedObjectList = new List<EffectedObject>();
		}
		public List<EffectedObject> effectedObjectList { get; set; }

		public void AddedEffectedObject(Rigidbody touchedObject, PhysicsEffect physicsEffect, GameObject attachedGameObject)
		{
			if (effectedObjectList.Count == 0)
			{
				EffectedObject item = new EffectedObject(Time.time, touchedObject, physicsEffect);
				effectedObjectList.Add(item);
				CreateAttachedGameObject(touchedObject, attachedGameObject);
			}
			else
			{
				if (effectedObjectList.Count > 0)
				{
					bool flag = false;
					foreach (EffectedObject effectedObject in effectedObjectList)
					{
						if (effectedObject.touchedObject == touchedObject)
						{
							effectedObject.effectedTime = Time.time;
							flag = true;
							break;
						}
					}

					if (!flag)
					{
						EffectedObject item2 = new EffectedObject(Time.time, touchedObject, physicsEffect);
						effectedObjectList.Add(item2);
						CreateAttachedGameObject(touchedObject, attachedGameObject);
					}
				}
			}
		}

		private static void CreateAttachedGameObject(Rigidbody touchedObject, GameObject attachGameObject)
		{
			if (attachGameObject != null && touchedObject.transform.FindChild(SpecialEffectGameObject) == null)
			{
				GameObject gameObject = UnityEngine.Object.Instantiate(attachGameObject, touchedObject.gameObject.transform.position, touchedObject.gameObject.transform.rotation) as GameObject;
				gameObject.name = SpecialEffectGameObject;
				gameObject.transform.parent = touchedObject.gameObject.transform;
			}
		}

		private static void RemoveAttachedGameObject(Rigidbody touchedObject, GameObject attachGameObject)
		{
			if (touchedObject != null && attachGameObject != null && touchedObject.transform.FindChild(SpecialEffectGameObject) != null)
			{
				UnityEngine.Object.Destroy(touchedObject.transform.FindChild(SpecialEffectGameObject).gameObject);
			}
		}

		public void RefreshEffectedObjectListOverTime(float timer, GameObject attachedGameObject)
		{
			if (effectedObjectList.Count != 0)
			{
				List<EffectedObject> list = new List<EffectedObject>();
				foreach (EffectedObject effectedObject in effectedObjectList)
				{
					if (effectedObject.effectedTime + timer < Time.time)
					{
						PhysicsEffect physicsEffect = effectedObject.physicsEffect;
						if (physicsEffect != PhysicsEffect.None && physicsEffect == PhysicsEffect.NoGravity && effectedObject.touchedObject != null)
						{
							effectedObject.touchedObject.useGravity = true;
						}

						RemoveAttachedGameObject(effectedObject.touchedObject, attachedGameObject);
						list.Add(effectedObject);
					}
				}

				foreach (EffectedObject item in list)
				{
					effectedObjectList.Remove(item);
				}
			}
		}
	}

	public class EffectedObject
	{
		public EffectedObject()
		{
		}

		public EffectedObject(float effectedTime, Rigidbody touchedObject, PhysicsEffect physicsEffect)
		{
			this.effectedTime = effectedTime;
			this.touchedObject = touchedObject;
			this.physicsEffect = physicsEffect;
		}
		public float effectedTime { get; set; }

		public Rigidbody touchedObject { get; set; }

		public PhysicsEffect physicsEffect { get; set; }
	}

	public bool enable = true;

	public float forcePower = 10f;

	public Shape shape;

	public GameObject forcePoint;

	public GameObject[] forcePoints;

	public SizeProperties sizeProperties;

	public SpecialEffect specialEffect;

	private static string SpecialEffectGameObject = "CirularGravityForce_SpecialEffect";

	public PulseProperties pulseProperties;

	public TriggerAreaFilter triggerAreaFilter;

	public TagFilter tagFilter;

	public DrawGravityProperties drawGravityProperties;

	private bool pulse_Positive;

	private static string CirularGravityLineName = "CirularGravityForce_LineDisplay";

	private GameObject CirularGravityLine;

	private void Awake()
	{
		if (sizeProperties == null)
		{
			sizeProperties = new SizeProperties();
		}
		if (specialEffect == null)
		{
			specialEffect = new SpecialEffect();
		}
		if (pulseProperties == null)
		{
			pulseProperties = new PulseProperties();
		}
		if (triggerAreaFilter == null)
		{
			triggerAreaFilter = new TriggerAreaFilter();
		}
		if (tagFilter == null)
		{
			tagFilter = new TagFilter();
		}
		if (drawGravityProperties == null)
		{
			drawGravityProperties = new DrawGravityProperties();
		}
		if (pulseProperties.pulse)
		{
			sizeProperties.size = pulseProperties.minSize;
			pulse_Positive = true;
		}
	}

	private void Start()
	{
	}

	private void Update()
	{
		if (enable)
		{
			if (pulseProperties.pulse)
			{
				CalculatePulse();
			}
			if (drawGravityProperties.drawGravityForce)
			{
				if (CirularGravityLine == null)
				{
					CirularGravityLine = new GameObject(CirularGravityLineName);
					CirularGravityLine.transform.position = transform.position;
					CirularGravityLine.transform.parent = gameObject.transform;
					CirularGravityLine.AddComponent<LineRenderer>();
				}
				DrawGravityForceLineRenderer();
			}
			else if (CirularGravityLine != null)
			{
				UnityEngine.Object.Destroy(CirularGravityLine);
			}
		}
		else if (CirularGravityLine != null)
		{
			UnityEngine.Object.Destroy(CirularGravityLine);
		}
	}

	private void FixedUpdate()
	{
		if (enable && forcePower != 0f)
		{
			CalculateAndEstimateForce();
		}
		specialEffect.effectedObjects.RefreshEffectedObjectListOverTime(specialEffect.timeEffected, specialEffect.attachedGameObject);
	}

	private void CalculatePulse()
	{
		if (pulseProperties.pulse)
		{
			if (pulse_Positive)
			{
				if (sizeProperties.size <= pulseProperties.maxSize)
				{
					sizeProperties.size = sizeProperties.size + (pulseProperties.speed * Time.deltaTime);
				}
				else
				{
					pulse_Positive = false;
				}
			}
			else
			{
				if (sizeProperties.size >= pulseProperties.minSize)
				{
					sizeProperties.size = sizeProperties.size - (pulseProperties.speed * Time.deltaTime);
				}
				else
				{
					pulse_Positive = true;
				}
			}
		}
	}

	private void CalculateAndEstimateForce()
	{
		Collider[] array = null;
		RaycastHit[] array2 = null;
		if (shape == Shape.Sphere)
		{
			array = Physics.OverlapSphere(base.transform.position, sizeProperties.size);
			if (array.Length <= 0)
			{
				return;
			}

			IEnumerable<Collider> source = array.Select((Collider h) => h);
			source = source.Where((Collider h) => h.rigidbody != rigidbody);
			source = source.Where((Collider h) => (bool)h.rigidbody == true);
			switch (tagFilter.tagFilterOptions)
			{
				case TagFilter.TagFilterOptions.OnlyEffectListedTags:
					source = source.Where((Collider h) => tagFilter.tagsList.Contains(h.tag));
					break;
				case TagFilter.TagFilterOptions.DontEffectListedTags:
					source = source.Where((Collider h) => !tagFilter.tagsList.Contains(h.tag));
					break;
			}

			switch (triggerAreaFilter.triggerAreaFilterOptions)
			{
				case TriggerAreaFilter.TriggerAreaFilterOptions.OnlyEffectWithinTigger:
					source = source.Where((Collider h) => triggerAreaFilter.triggerArea.collider.bounds.Contains(h.transform.position));
					break;
				case TriggerAreaFilter.TriggerAreaFilterOptions.DontEffectWithinTigger:
					source = source.Where((Collider h) => !triggerAreaFilter.triggerArea.collider.bounds.Contains(h.transform.position));
					break;
			}

			{
				foreach (Collider item in source)
				{
					if (forcePoint == null && forcePoints.Length == 0)
					{
						SetupSpecialEffect(item.rigidbody);
						item.rigidbody.AddExplosionForce(forcePower, base.transform.position, sizeProperties.size);
					}
					else if (forcePoint != null)
					{
						SetupSpecialEffect(item.rigidbody);
						item.rigidbody.AddExplosionForce(forcePower, forcePoint.transform.position, sizeProperties.size);
					}

					if (forcePoints.Length > 0)
					{
						GameObject[] array3 = forcePoints;
						foreach (GameObject gameObject in array3)
						{
							GameObject gameObject2 = gameObject;
							SetupSpecialEffect(item.rigidbody);
							item.rigidbody.AddExplosionForce(forcePower, gameObject2.transform.position, sizeProperties.size);
						}
					}
				}

				return;
			}
		}

		Transform transform = base.transform;
		if (shape == Shape.RayCast)
		{
			array2 = Physics.RaycastAll(transform.position, transform.rotation * Vector3.forward, sizeProperties.size);
		}
		else if (shape == Shape.Capsule)
		{
			array2 = Physics.CapsuleCastAll(transform.position, transform.position + transform.rotation * Vector3.back, sizeProperties.capsuleRadius, transform.position - (transform.position + transform.rotation * Vector3.back), sizeProperties.size);
		}

		if (array2.Length > 0)
		{
			IEnumerable<RaycastHit> source2 = array2.Select((RaycastHit h2) => h2);
			source2 = source2.Where((RaycastHit h2) => h2.rigidbody != rigidbody);
			source2 = source2.Where((RaycastHit h2) => (bool)h2.rigidbody == true);
			switch (tagFilter.tagFilterOptions)
			{
				case TagFilter.TagFilterOptions.OnlyEffectListedTags:
					source2 = source2.Where((RaycastHit h2) => tagFilter.tagsList.Contains(h2.transform.gameObject.tag));
					break;
				case TagFilter.TagFilterOptions.DontEffectListedTags:
					source2 = source2.Where((RaycastHit h2) => !tagFilter.tagsList.Contains(h2.transform.gameObject.tag));
					break;
			}

			switch (triggerAreaFilter.triggerAreaFilterOptions)
			{
				case TriggerAreaFilter.TriggerAreaFilterOptions.OnlyEffectWithinTigger:
					source2 = source2.Where((RaycastHit h) => triggerAreaFilter.triggerArea.collider.bounds.Contains(h.transform.position));
					break;
				case TriggerAreaFilter.TriggerAreaFilterOptions.DontEffectWithinTigger:
					source2 = source2.Where((RaycastHit h2) => !triggerAreaFilter.triggerArea.collider.bounds.Contains(h2.transform.position));
					break;
			}

			foreach (RaycastHit item2 in source2)
			{
				if (forcePoint == null && forcePoints.Length == 0)
				{
					SetupSpecialEffect(item2.rigidbody);
					item2.rigidbody.AddExplosionForce(forcePower, transform.position, sizeProperties.size);
				}
				else if (forcePoint != null)
				{
					SetupSpecialEffect(item2.rigidbody);
					item2.rigidbody.AddExplosionForce(forcePower, forcePoint.transform.position, sizeProperties.size);
				}

				if (forcePoints.Length > 0)
				{
					GameObject[] array4 = forcePoints;
					foreach (GameObject gameObject3 in array4)
					{
						GameObject gameObject4 = gameObject3;
						SetupSpecialEffect(item2.rigidbody);
						item2.rigidbody.AddExplosionForce(forcePower, gameObject4.transform.position, sizeProperties.size);
					}
				}
			}
		}
	}

	private void SetupSpecialEffect(Rigidbody rigidbody)
	{
		switch (specialEffect.physicsEffect)
		{
		case PhysicsEffect.None:
			break;
		case PhysicsEffect.NoGravity:
			rigidbody.useGravity = false;
			break;
		default:
			break;
		}
		if (specialEffect.timeEffected > 0f)
		{
			specialEffect.effectedObjects.AddedEffectedObject(rigidbody, specialEffect.physicsEffect, specialEffect.attachedGameObject);
		}
	}

	private void DrawGravityForceLineRenderer()
	{
		Transform transform = base.transform;
		Color color;
		if (forcePower == 0f)
		{
			color = Color.white;
		}
		else
		{
			color = (forcePower > 0f ? Color.green : Color.red);
		}

		LineRenderer component = CirularGravityLine.GetComponent<LineRenderer>();
		component.SetWidth(drawGravityProperties.thickness, drawGravityProperties.thickness);
		component.material = drawGravityProperties.gravityLineMaterial;
		component.SetColors(color, color);
		switch (shape)
		{
			case Shape.Sphere:
				component.SetVertexCount(12);
				component.SetPosition(0, transform.position + transform.rotation * Vector3.up * sizeProperties.size);
				component.SetPosition(1, transform.position);
				component.SetPosition(2, transform.position + transform.rotation * Vector3.down * sizeProperties.size);
				component.SetPosition(3, transform.position);
				component.SetPosition(4, transform.position + transform.rotation * Vector3.left * sizeProperties.size);
				component.SetPosition(5, transform.position);
				component.SetPosition(6, transform.position + transform.rotation * Vector3.right * sizeProperties.size);
				component.SetPosition(7, transform.position);
				component.SetPosition(8, transform.position + transform.rotation * Vector3.forward * sizeProperties.size);
				component.SetPosition(9, transform.position);
				component.SetPosition(10, transform.position + transform.rotation * Vector3.back * sizeProperties.size);
				component.SetPosition(11, transform.position);
				break;
			case Shape.Capsule:
			{
				component.SetVertexCount(17);
				component.SetPosition(0, transform.position + transform.rotation * Vector3.up * sizeProperties.capsuleRadius);
				component.SetPosition(1, transform.position);
				component.SetPosition(2, transform.position + transform.rotation * Vector3.down * sizeProperties.capsuleRadius);
				component.SetPosition(3, transform.position);
				component.SetPosition(4, transform.position + transform.rotation * Vector3.left * sizeProperties.capsuleRadius);
				component.SetPosition(5, transform.position);
				component.SetPosition(6, transform.position + transform.rotation * Vector3.right * sizeProperties.capsuleRadius);
				component.SetPosition(7, transform.position);
				Vector3 vector = transform.position + transform.rotation * Vector3.forward * sizeProperties.size;
				component.SetPosition(8, vector);
				component.SetPosition(9, vector + transform.rotation * Vector3.up * sizeProperties.capsuleRadius);
				component.SetPosition(10, vector);
				component.SetPosition(11, vector + transform.rotation * Vector3.down * sizeProperties.capsuleRadius);
				component.SetPosition(12, vector);
				component.SetPosition(13, vector + transform.rotation * Vector3.left * sizeProperties.capsuleRadius);
				component.SetPosition(14, vector);
				component.SetPosition(15, vector + transform.rotation * Vector3.right * sizeProperties.capsuleRadius);
				component.SetPosition(16, vector);
				break;
			}

			case Shape.RayCast:
				component.SetVertexCount(2);
				component.SetPosition(0, transform.position);
				component.SetPosition(1, transform.position + transform.rotation * Vector3.forward * sizeProperties.size);
				break;
		}
	}
}
