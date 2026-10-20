using UnityEngine;

public class cInputDemoBullet : MonoBehaviour
{
	public GameObject explosionPrefab;

	public AudioClip pewpew;

	private void Start()
	{
		base.gameObject.name = "Bullet";
		GameObject gameObject;
		if (GameObject.Find("Bullets") == null)
		{
			gameObject = new GameObject();
			gameObject.name = "Bullets";
		}
		else
		{
			gameObject = GameObject.Find("Bullets");
		}
		transform.parent = gameObject.transform;
		Object.Destroy(base.gameObject, 3f);
	}

	private void Update()
	{
		transform.Translate(Vector3.forward * 20f * Time.deltaTime);
		RaycastHit hitInfo;
		if (Physics.Raycast(transform.position, Vector3.forward, out hitInfo, 0.5f))
		{
			string text = hitInfo.collider.tag;
			if (text != tag)
			{
				if (text == "Enemy")
				{
					Object.Destroy(base.gameObject);
					Transform parent;
					switch (hitInfo.transform.name)
					{
						case "Bullet":
							parent = hitInfo.collider.transform;
							break;
						case "Missile":
							parent = hitInfo.collider.transform;
							break;
						case "anti Air Block":
							parent = hitInfo.collider.transform;
							break;
						case "enemy boss":
							parent = hitInfo.collider.transform;
							break;
						default:
							parent = hitInfo.collider.transform.parent;
							break;
					}

					Object.Destroy(parent.gameObject);
					Object.Instantiate(explosionPrefab, parent.position, Quaternion.identity);
				}
				else if (text == "Player")
				{
					GameObject gameObject = GameObject.FindGameObjectWithTag("Player");
					Object.Destroy(base.gameObject);
					Object.Destroy(gameObject);
					Object.Instantiate(explosionPrefab, gameObject.transform.position, Quaternion.identity);
				}
			}
		}
	}

	private void OnBecameInvisible()
	{
		Object.Destroy(gameObject);
	}
}
