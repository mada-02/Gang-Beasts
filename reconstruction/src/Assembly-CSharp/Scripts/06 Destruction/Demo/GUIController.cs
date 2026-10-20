using Destruction.Dynamic;
using Destruction.Tools;
using System.Collections;
using UnityEngine;

namespace Destruction
{
		public class GUIController : MonoBehaviour
		{
			public int controlWindowWidth = 250;

			public float sceneFadeLength = 0.5f;

			private bool showControls = true;

			private float fpsTimer;

			private int fpsCounter;

			private string fpsLabelText = string.Empty;

			private Color fpsColour;

			private Trigger[] fractureObjects;

			private void Start()
			{
				StartCoroutine(FadeIn());
				fractureObjects = Object.FindObjectsOfType(typeof(Trigger)) as Trigger[];
				StartCoroutine(FPS());
			}

			private IEnumerator FadeIn()
			{
				GameObject faderObject = new GameObject("Fader");
				GUITexture fader = faderObject.AddComponent<GUITexture>();
				fader.pixelInset = fader.GetScreenRect(Camera.main);
				Texture2D blackTexture = (Texture2D)(fader.texture = new Texture2D(1, 1));
				blackTexture.SetPixel(0, 0, Color.black);
				float timer = sceneFadeLength;
				while (timer > 0f)
				{
					fader.color = new Color(0f, 0f, 0f, timer / sceneFadeLength);
					GUI.color = new Color(1f, 1f, 1f, timer / sceneFadeLength);
					timer -= Time.deltaTime;
					yield return null;
				}
				Object.Destroy(faderObject);
			}

			private void Update()
			{
				fpsTimer += Time.timeScale / Time.deltaTime;
				fpsCounter++;
				if (Input.GetKeyDown(KeyCode.F1))
				{
					showControls = !showControls;
				}
				if (Input.GetKeyDown(KeyCode.Escape))
				{
					Application.Quit();
				}
			}

			private void OnGUI()
			{
				GUILayout.Window(2, new Rect(Screen.width - controlWindowWidth - 10, 10f, controlWindowWidth, 10f), SceneControls, "Controls", GUILayout.Width(controlWindowWidth));
			}

			private void SceneControls(int id)
			{
				Toggle(ref showControls, "Show");
				if (!showControls)
				{
					return;
				}

				GUILayout.Space(15f);
				GUILayout.BeginVertical("box");
				GUILayout.Label("Hold RMB to orbit scene.");
				GUILayout.Label("Press LMB over environment for destruction.");
				GUILayout.EndVertical();
				GUILayout.Space(15f);
				GUILayout.BeginVertical("box");
				GUILayout.Label("Shards : " + ShardPool.ShardsUsed);
				GUILayout.EndVertical();
				GUILayout.Space(15f);
				GUI.backgroundColor = new Color(0f, 1f, 0f, GUI.color.a);
				if (GUILayout.Button("Reset Scene", GUILayout.Width(controlWindowWidth - 20)))
				{
					Application.LoadLevel(Application.loadedLevel);
				}

				GUI.backgroundColor = new Color(1f, 1f, 1f, GUI.color.a);
			}

			private IEnumerator DestroyFoundations()
			{
				int i = 0;
				Trigger[] array = fractureObjects;
				foreach (Trigger obj in array)
				{
					if (!(obj == null))
					{
						if (obj.transform.localPosition.y < -7f)
						{
							obj.rigidbody.AddForce(Vector3.up * 10000000f);
							obj.TriggerDestruction(obj.transform.position, Random.value);
						}
						i++;
						if (i % 2 == 0)
						{
							yield return null;
						}
					}
				}
			}

			private IEnumerator DestroyAll()
			{
				int i = 0;
				Trigger[] array = fractureObjects;
				foreach (Trigger obj in array)
				{
					if (!(obj == null))
					{
						obj.TriggerDestruction(obj.transform.position, Random.value);
						i++;
						if (i % 2 == 0)
						{
							yield return null;
						}
					}
				}
			}

			private IEnumerator FPS()
			{
				while (enabled)
				{
					float fps = fpsTimer / (float)fpsCounter;
					fpsLabelText = fps.ToString("f2");
					if (fps < 10f)
					{
						fpsColour = Color.red;
					}
					else if (fps < 25f)
					{
						fpsColour = Color.yellow;
					}
					else
					{
						fpsColour = Color.green;
					}
					fpsTimer = 0f;
					fpsCounter = 0;
					yield return new WaitForSeconds(0.5f);
				}
			}

			private void FrameCounterWindow(int windowID)
			{
				GUILayout.BeginHorizontal();
				GUILayout.FlexibleSpace();
				GUILayout.Label(fpsLabelText);
				GUILayout.FlexibleSpace();
				GUILayout.EndHorizontal();
			}

			public static void Toggle(ref bool value, string name)
			{
				GUILayout.BeginHorizontal("box");
				GUILayout.Label(name + " : ");
				value = GUILayout.Toggle(value, string.Empty);
				GUILayout.EndHorizontal();
			}
		}
}
