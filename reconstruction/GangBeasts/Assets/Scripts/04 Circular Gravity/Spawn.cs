using UnityEngine;

public class Spawn : MonoBehaviour
{
	public string inputControl = "Jump";

	public GameObject spawnObject;

	public float spawnLife = 10f;

	private void Start()
	{
	}

	private void Update()
	{
	}

	private void FixedUpdate()
	{
		if (Input.GetButtonDown(inputControl))
		{
			GameObject obj = Object.Instantiate(spawnObject, transform.position, transform.rotation) as GameObject;
			Object.DestroyObject(obj, spawnLife);
		}
	}
}
