using UnityEngine;

public class RoadSpawnObject : MonoBehaviour
{
	public GameObject prefab;

	public float minSpawnDelay;

	public float maxSpawnDelay;

	private float timer;

	private void Start()
	{
		Vector3 position = transform.position;
		for (int i = 0; i < 2; i++)
		{
			position.x += Random.Range(100, 200);
			if (Random.Range(-1f, 1f) > 0f)
			{
				Object.Instantiate(prefab, position, Quaternion.Euler(0f, 0f, 0f));
			}
			else
			{
				Object.Instantiate(prefab, position, Quaternion.Euler(0f, 180f, 0f));
			}
		}
	}

	private void Update()
	{
		if (timer <= 0f)
		{
			timer = Random.Range(minSpawnDelay, maxSpawnDelay);
			Vector3 position = transform.position;
			if (Random.Range(-1f, 1f) > 0f)
			{
				Object.Instantiate(prefab, position, Quaternion.Euler(0f, 0f, 0f));
			}
			else
			{
				Object.Instantiate(prefab, position, Quaternion.Euler(0f, 180f, 0f));
			}
		}
		if (timer >= 0f)
		{
			timer -= Time.deltaTime;
		}
	}
}
