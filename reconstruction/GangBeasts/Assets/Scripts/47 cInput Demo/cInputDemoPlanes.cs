using UnityEngine;

public class cInputDemoPlanes : MonoBehaviour
{
	public GUIText guiSpeed;

	public GUIText pauseText;

	public GUIText resetText;

	public GameObject bulletPrefab;

	private float speed;

	private float steer;

	private float shootTimer;

	private bool pause;

	private bool menu;

	private void Update()
	{
		if (Input.GetKeyDown(KeyCode.Escape) && !cInput.scanning)
		{
			cGUI.ToggleGUI();
		}
		if (!cGUI.showingAnyGUI)
		{
			if (cInput.GetKeyDown("Pause"))
			{
				pause = !pause;
			}
			if (!pause)
			{
				if (cInput.GetButton("Shoot") && Time.time > shootTimer + 0.25f)
				{
					Vector3 position = new Vector3(transform.position.x - 1f, transform.position.y, transform.position.z);
					Vector3 position2 = new Vector3(transform.position.x + 1f, transform.position.y, transform.position.z);
					GameObject gameObject = (GameObject)Object.Instantiate(bulletPrefab, position, Quaternion.identity);
					gameObject.tag = "Player";
					GameObject gameObject2 = (GameObject)Object.Instantiate(bulletPrefab, position2, Quaternion.identity);
					gameObject2.tag = "Player";
					shootTimer = Time.time;
				}
				if (cInput.GetKey("Up"))
				{
					speed += 0.15f;
				}
				if (cInput.GetKey("Down"))
				{
					speed -= 0.15f;
				}
				float axis = cInput.GetAxis("Horizontal");
				steer = (-axis) * 45f;
				transform.localEulerAngles = new Vector3(transform.localEulerAngles.x, transform.localEulerAngles.y, steer);
				transform.Translate(Vector3.right * axis * 30f * Time.deltaTime);
				steer = Mathf.Clamp(steer, -45f, 45f);
				speed = Mathf.Clamp(speed, 5f, 10f);
				float x = Mathf.Clamp(transform.position.x, -24f, 24f);
				transform.position = new Vector3(x, 5f, transform.position.z);
				transform.Translate(Vector3.forward * speed * Time.deltaTime);
				int num = (int)(speed * 10f);
				guiSpeed.text = "Speed: " + num;
			}
		}
		if (pause)
		{
			Time.timeScale = 0f;
			pauseText.enabled = true;
		}
		else
		{
			Time.timeScale = 1f;
			pauseText.enabled = false;
		}
	}

	private void OnEnable()
	{
		cGUI.OnGUIToggled += TogglePause;
	}

	private void OnDisable()
	{
		cGUI.OnGUIToggled -= TogglePause;
		if ((bool)resetText)
		{
			resetText.enabled = true;
		}
	}

	private void TogglePause()
	{
		pause = cGUI.showingAnyGUI;
	}
}
