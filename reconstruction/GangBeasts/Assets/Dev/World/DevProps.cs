using System.Collections.Generic;
using UnityEngine;

// The Objects tab: physics primitives, the prefabs in Resources/DevMenu, and copies of loose physics
// objects in the current level. Everything spawned is tracked so it can be cleared (safely: a beast
// holding a cleared object lets go instead of being left holding the world).
public static class DevProps
{
	public static readonly string[] primitiveNames = { "Cube", "Sphere", "Capsule", "Cylinder", "Crate", "Barrel", "Plank", "Bouncy Ball" };

	public static float size = 1f;

	public static float mass = 2f;

	private static GameObject[] prefabs;

	private static string[] prefabNames;

	private static readonly List<GameObject> levelObjects = new List<GameObject>();

	private static string[] levelObjectNames = new string[0];

	private static readonly List<GameObject> spawned = new List<GameObject>();

	private static PhysicMaterial bouncy;

	public static string[] PrefabNames
	{
		get
		{
			LoadPrefabs();
			return prefabNames;
		}
	}

	public static string[] LevelObjectNames
	{
		get { return levelObjectNames; }
	}

	public static int SpawnedCount
	{
		get
		{
			spawned.RemoveAll(g => g == null);
			return spawned.Count;
		}
	}

	public static List<GameObject> Spawned
	{
		get
		{
			spawned.RemoveAll(g => g == null);
			return spawned;
		}
	}

	public static void LevelLoaded()
	{
		spawned.Clear();
		levelObjects.Clear();
		levelObjectNames = new string[0];
	}

	private static void LoadPrefabs()
	{
		if (prefabs != null)
		{
			return;
		}
		Object[] loaded = Resources.LoadAll("DevMenu", typeof(GameObject));
		prefabs = new GameObject[loaded.Length];
		prefabNames = new string[loaded.Length];
		for (int i = 0; i < loaded.Length; i++)
		{
			prefabs[i] = (GameObject)loaded[i];
			prefabNames[i] = loaded[i].name;
		}
	}

	public static GameObject SpawnPrimitive(int kind, Vector3 at)
	{
		PrimitiveType type = PrimitiveType.Cube;
		Vector3 scale = Vector3.one;
		float kindMass = 1f;
		Color color = new Color(Random.Range(0.3f, 1f), Random.Range(0.3f, 1f), Random.Range(0.3f, 1f));
		switch (kind)
		{
		case 1:
			type = PrimitiveType.Sphere;
			break;
		case 2:
			type = PrimitiveType.Capsule;
			break;
		case 3:
			type = PrimitiveType.Cylinder;
			break;
		case 4:
			scale = Vector3.one * 1.2f;
			kindMass = 4f;
			color = new Color(0.55f, 0.38f, 0.2f);
			break;
		case 5:
			type = PrimitiveType.Cylinder;
			scale = new Vector3(0.7f, 0.5f, 0.7f);
			kindMass = 3f;
			color = new Color(0.25f, 0.4f, 0.25f);
			break;
		case 6:
			scale = new Vector3(0.3f, 0.1f, 2.5f);
			color = new Color(0.7f, 0.55f, 0.35f);
			break;
		case 7:
			type = PrimitiveType.Sphere;
			scale = Vector3.one * 0.6f;
			kindMass = 0.3f;
			break;
		}
		GameObject prop = GameObject.CreatePrimitive(type);
		prop.name = "[DevMenu] " + primitiveNames[kind];
		prop.transform.localScale = scale * size;
		prop.transform.position = at + Vector3.up * (prop.transform.localScale.y + 0.5f);
		prop.renderer.material.color = color;
		Rigidbody body = prop.AddComponent<Rigidbody>();
		body.mass = mass * kindMass;
		if (kind == 7)
		{
			if (bouncy == null)
			{
				bouncy = new PhysicMaterial("DevMenu Bouncy");
				bouncy.bounciness = 0.9f;
				bouncy.bounceCombine = PhysicMaterialCombine.Maximum;
			}
			prop.collider.material = bouncy;
		}
		spawned.Add(prop);
		return prop;
	}

	public static GameObject SpawnPrefab(int index, Vector3 at)
	{
		LoadPrefabs();
		GameObject copy = Copy(prefabs[index], at);
		spawned.Add(copy);
		return copy;
	}

	public static GameObject SpawnLevelObject(int index, Vector3 at)
	{
		if (index < 0 || index >= levelObjects.Count || levelObjects[index] == null)
		{
			return null;
		}
		GameObject copy = Copy(levelObjects[index], at);
		spawned.Add(copy);
		return copy;
	}

	private static GameObject Copy(GameObject source, Vector3 at)
	{
		GameObject copy = (GameObject)Object.Instantiate(source, source.transform.position, source.transform.rotation);
		copy.name = "[DevMenu] " + source.name;
		// The Sign is Trucks' road hazard: its mover drives it along x at 30 m/s and deletes it past
		// x = 1000. A copy stands where it is put.
		foreach (RoadSpawnObjectMover mover in copy.GetComponentsInChildren<RoadSpawnObjectMover>(true))
		{
			Object.DestroyImmediate(mover);
		}
		// Most jointed level objects hang on the world (doors, rollers, punch bags, the seesaw) or on
		// bodies outside themselves (rope segments); copies come loose, joints within the copy stay.
		foreach (Joint joint in copy.GetComponentsInChildren<Joint>(true))
		{
			if (joint.connectedBody == null || !joint.connectedBody.transform.IsChildOf(copy.transform))
			{
				Object.DestroyImmediate(joint);
			}
		}
		copy.SetActive(true);
		// Measure the copy: a prefab asset has no world bounds, and the Sign prefab's root sits at x = -999.
		Bounds bounds = WorldBounds(copy);
		copy.transform.position += at - bounds.center + Vector3.up * (bounds.extents.y + 0.1f);
		foreach (Rigidbody body in copy.GetComponentsInChildren<Rigidbody>())
		{
			if (!body.isKinematic)
			{
				body.velocity = Vector3.zero;
				body.angularVelocity = Vector3.zero;
			}
		}
		return copy;
	}

	public static Bounds WorldBounds(GameObject go)
	{
		Renderer[] renderers = go.GetComponentsInChildren<Renderer>();
		if (renderers.Length == 0)
		{
			return new Bounds(go.transform.position, Vector3.one);
		}
		Bounds bounds = renderers[0].bounds;
		for (int i = 1; i < renderers.Length; i++)
		{
			bounds.Encapsulate(renderers[i].bounds);
		}
		return bounds;
	}

	public static int Clear()
	{
		int n = 0;
		foreach (GameObject prop in spawned)
		{
			if (prop != null)
			{
				BeastRegistry.SafeDestroyObject(prop);
				n++;
			}
		}
		spawned.Clear();
		return n;
	}

	// Loose, non-kinematic physics objects in the level (topmost rigidbody of each), one per name.
	public static void RefreshLevelObjects()
	{
		levelObjects.Clear();
		List<string> names = new List<string>();
		foreach (Object o in Object.FindObjectsOfType(typeof(Rigidbody)))
		{
			Transform top = ((Rigidbody)o).transform;
			while (top.parent != null && top.parent.rigidbody != null)
			{
				top = top.parent;
			}
			GameObject go = top.gameObject;
			if (top.rigidbody.isKinematic || names.Contains(go.name) || spawned.Contains(go) || go.name.StartsWith("[Dev"))
			{
				continue;
			}
			if (top.root.GetComponent<Player>() != null || top.root.name.Contains("Player") || go.GetComponentInChildren<Camera>() != null)
			{
				continue;
			}
			if (WorldBounds(go).size.magnitude > 10f)
			{
				continue;
			}
			names.Add(go.name);
			levelObjects.Add(go);
		}
		levelObjects.Sort((a, b) => string.Compare(a.name, b.name));
		levelObjectNames = new string[levelObjects.Count];
		for (int i = 0; i < levelObjects.Count; i++)
		{
			levelObjectNames[i] = levelObjects[i].name;
		}
	}
}
