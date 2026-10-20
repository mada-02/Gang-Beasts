using UnityEngine;

public class cInputDemoRocket : MonoBehaviour
{
	public GameObject explosionPrefab;

	private GameObject target;

	private float _startTime;

	private float _speed;

	private void Start()
	{
		_startTime = Time.time;
		target = GameObject.FindWithTag("Player");
		gameObject.name = "Missile";
		Object.Destroy(gameObject, 5f);
	}

	private void OnTriggerEnter(Collider col)
	{
		if (col.tag == "Player")
		{
			Object.Destroy(gameObject);
			Object.Destroy(target.gameObject);
			Object.Instantiate(explosionPrefab, target.transform.position, Quaternion.identity);
		}
	}

	private void Update()
	{
		if ((bool)target)
		{
			_speed = Mathf.Clamp(_speed, Time.time - _startTime + 6f, 10f);
			transform.LookAt(target.transform);
			transform.Translate(Vector3.forward * _speed * Time.deltaTime);
			transform.eulerAngles = new Vector3(0f, transform.eulerAngles.y, 0f);
		}
		else
		{
			Object.Destroy(gameObject);
		}
	}
}
