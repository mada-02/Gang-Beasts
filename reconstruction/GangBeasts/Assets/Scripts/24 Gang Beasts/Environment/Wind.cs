using UnityEngine;

public class Wind : MonoBehaviour
{
	public Vector3 windDirection;

	public float min;

	public float max;

	public float triggerDelay;

	private float timer;

	private void Update()
	{
		timer -= Time.deltaTime;
		if (timer <= 0f)
		{
			timer = triggerDelay;
		}
		Physics.gravity = windDirection * Random.Range(min, max) + new Vector3(0f, -10f, 0f);
	}

	private void OnTriggerStay(Collider collider)
	{
	}
}
