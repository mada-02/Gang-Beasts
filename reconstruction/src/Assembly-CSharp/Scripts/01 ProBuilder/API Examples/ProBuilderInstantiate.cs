using ProBuilder2.Common;
using System.Collections.Generic;
using UnityEngine;

public class ProBuilderInstantiate : MonoBehaviour
{
	private enum ObjectSelectionOptions
	{
		Prefab,
		Cube,
		Cylinder,
		Pipe
	}

	private const int SHAPE_ENUM_LENGTH = 4;

	public GameObject probuilderPrefab;

	private ObjectSelectionOptions objectToInstantiate;

	private Rect prefWindow = new Rect(10f, 10f, 300f, 300f);

	private List<GameObject> generatedObjects = new List<GameObject>();

	private Vector2 mPos_screen = Vector2.zero;

	private void OnGUI()
	{
		prefWindow = GUI.Window(0, prefWindow, SelectionWindow, "Object To Instantiate");
	}

	private void SelectionWindow(int id)
	{
		GUI.DragWindow(new Rect(0f, 0f, 20000f, 20f));
		GUILayout.BeginVertical();
		for (int i = 0; i < 4; i++)
		{
			if (i == (int)objectToInstantiate)
			{
				GUI.color = Color.green;
			}
			if (GUILayout.Button(((ObjectSelectionOptions)i).ToString()))
			{
				objectToInstantiate = (ObjectSelectionOptions)i;
			}
			GUI.color = Color.white;
		}
		GUI.color = Color.red;
		if (GUILayout.Button("Clear Screen"))
		{
			foreach (GameObject generatedObject in generatedObjects)
			{
				Object.Destroy(generatedObject);
			}
			generatedObjects.Clear();
		}
		GUI.color = Color.white;
		GUILayout.Label("Click to instantiate the selected object.");
		GUILayout.EndVertical();
	}

	private void Update()
	{
		mPos_screen = Input.mousePosition;
		Vector2 point = new Vector2(mPos_screen.x, (float)Screen.height - mPos_screen.y);
		if (prefWindow.Contains(point))
		{
			return;
		}

		if (Input.GetMouseButtonUp(0))
		{
			Vector3 position = Camera.main.ScreenToWorldPoint(new Vector3(mPos_screen.x, mPos_screen.y, Camera.main.transform.position.x));
			GameObject gameObject;
			switch (objectToInstantiate)
			{
				default:
					return;
				case ObjectSelectionOptions.Prefab:
					gameObject = ProBuilder.Instantiate(probuilderPrefab, Vector3.zero, Quaternion.identity);
					break;
				case ObjectSelectionOptions.Cube:
				{
					pb_Object pb_Object2 = ProBuilder.CreatePrimitive(ProBuilder.Shape.Cube);
					Color[] array = new Color[6]
					{
						Color.green,
						Color.red,
						Color.cyan,
						Color.blue,
						Color.yellow,
						Color.magenta
					};
					int num = 0;
					pb_Face[] faces = pb_Object2.faces;
					foreach (pb_Face face in faces)
					{
						pb_Object2.SetFaceColor(face, array[num++]);
					}

					gameObject = pb_Object2.gameObject;
					gameObject.gameObject.AddComponent<BoxCollider>();
					break;
				}

				case ObjectSelectionOptions.Cylinder:
					gameObject = pb_Shape.CylinderGenerator(12, 0.7f, 0.5f, 0).gameObject;
					gameObject.gameObject.AddComponent<MeshCollider>().convex = true;
					break;
				case ObjectSelectionOptions.Pipe:
					gameObject = pb_Shape.PipeGenerator(1f, 1f, 0.3f, 8, 0).gameObject;
					gameObject.gameObject.AddComponent<MeshCollider>().convex = true;
					break;
			}

			gameObject.transform.position = position;
			gameObject.transform.localRotation = Quaternion.Euler(Random.Range(0f, 360f), Random.Range(0f, 360f), Random.Range(0f, 360f));
			gameObject.AddComponent<Rigidbody>();
			generatedObjects.Add(gameObject);
		}
	}
}
