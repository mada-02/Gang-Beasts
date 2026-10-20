using UnityEngine;

public class cInputDemoTurret : MonoBehaviour
{
	public GameObject rocketPrefab;

	public Transform shootPoint;

	public Transform target;

	private float damping = 20f;

	private float shootDelay = 3f;

	private float shootTime;

	private void Start()
	{
		shootDelay = Random.Range(3, 7);
		shootTime = shootDelay;
	}

	private void Update()
	{
		if ((bool)target && transform.FindChild("Box10").renderer.isVisible)
		{
			Quaternion to = Quaternion.LookRotation(target.position - transform.position);
			transform.rotation = Quaternion.Slerp(transform.rotation, to, Time.deltaTime * damping);
			transform.eulerAngles = new Vector3(0f, transform.eulerAngles.y, 0f);
			if (Time.time > shootTime)
			{
				Shoot();
				shootTime = Time.time + shootDelay;
			}
		}
	}

	private void Shoot()
	{
		GameObject gameObject = (GameObject)Object.Instantiate(rocketPrefab, shootPoint.position, Quaternion.identity);
		gameObject.transform.LookAt(target);
		gameObject.tag = "Enemy";
	}
}
