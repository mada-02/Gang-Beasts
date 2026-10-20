using UnityEngine;

public class cInputDemoEnemy : MonoBehaviour
{
	public GameObject bulletPrefab;

	public Transform playerTransform;

	private float bulletTimer;

	private Transform _mesh;

	private Transform _turret;

	private void Start()
	{
		_mesh = transform.FindChild("Mesh");
		_turret = transform.FindChild("Turret");
	}

	private void Update()
	{
		if (!_mesh.renderer.isVisible)
		{
			bulletTimer = Time.time - 1f;
		}
		transform.Translate(Vector3.forward * 5f * Time.deltaTime);
		if ((bool)playerTransform && _mesh.renderer.isVisible && Time.time > bulletTimer + 1.5f)
		{
			GameObject gameObject = (GameObject)Object.Instantiate(bulletPrefab, _turret.position, Quaternion.identity);
			gameObject.transform.LookAt(playerTransform);
			gameObject.tag = "Enemy";
			bulletTimer = Time.time;
		}
	}
}
