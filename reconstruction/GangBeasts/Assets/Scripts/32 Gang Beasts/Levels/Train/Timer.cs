using UnityEngine;

public class Timer : MonoBehaviour
{
	private float timer;

	private bool stopClock;

	private bool startClock;

	public GUIText text;

	private void Start()
	{
	}

	private void Update()
	{
		if (!stopClock && startClock)
		{
			timer += Time.deltaTime;
		}
		text.text = timer.ToString();
	}

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.transform.root.tag == "Player")
		{
			stopClock = true;
			MonoBehaviour.print("Stop");
		}
	}

	private void OnTriggerExit(Collider collider)
	{
		if (collider.transform.root.tag == "Player")
		{
			startClock = true;
			MonoBehaviour.print("Start");
		}
	}
}
