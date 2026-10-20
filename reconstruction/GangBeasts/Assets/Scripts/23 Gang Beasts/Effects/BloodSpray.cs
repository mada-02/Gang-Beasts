using UnityEngine;

public class BloodSpray : MonoBehaviour
{
	public int totalBlood;

	public GameObject bloodPrefab;

	public float power;

	private void Start()
	{
	}

	private void Update()
	{
		if (Input.GetKey(KeyCode.B))
		{
			for (int i = 0; i < totalBlood; i++)
			{
				GameObject gameObject = (GameObject)Object.Instantiate(bloodPrefab, transform.position, Quaternion.identity);
				Vector3 zero = Vector3.zero;
				zero.x = Random.Range(-power, power);
				zero.y = Random.Range(-power, power);
				zero.z = Random.Range(-power, power);
				gameObject.rigidbody.AddForce(zero, ForceMode.Impulse);
			}
		}
		if (Input.GetKey(KeyCode.R))
		{
			Application.LoadLevel(Application.loadedLevel);
		}
	}
}
