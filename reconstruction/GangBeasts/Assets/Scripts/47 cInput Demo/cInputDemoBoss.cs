using UnityEngine;

public class cInputDemoBoss : MonoBehaviour
{
	public GameObject bulletPrefab;

	public Renderer renderedMesh;

	public Transform playerTransform;

	private float bulletTimer;

	private void Start()
	{
		if ((bool)renderer)
		{
			renderedMesh = renderer;
		}
	}

	private void Update()
	{
		if (!renderedMesh)
		{
			Object.Destroy(base.gameObject);
			return;
		}
		transform.Translate(Vector3.forward * 5f * Time.deltaTime);
		if ((bool)playerTransform && renderedMesh.isVisible && Time.time > bulletTimer + 1.5f)
		{
			GameObject gameObject = (GameObject)Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity);
			gameObject.transform.LookAt(playerTransform);
			gameObject.tag = "Enemy";
			gameObject = (GameObject)Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity);
			Vector3 worldPosition = new Vector3(playerTransform.position.x - 10f, playerTransform.position.y, playerTransform.position.z);
			gameObject.transform.LookAt(worldPosition);
			gameObject.tag = "Enemy";
			gameObject = (GameObject)Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity);
			worldPosition = new Vector3(playerTransform.position.x + 10f, playerTransform.position.y, playerTransform.position.z);
			gameObject.transform.LookAt(worldPosition);
			gameObject.tag = "Enemy";
			bulletTimer = Time.time;
		}
	}
}
