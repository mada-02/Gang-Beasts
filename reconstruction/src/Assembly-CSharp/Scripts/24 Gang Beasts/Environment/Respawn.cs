using UnityEngine;

public class Respawn : MonoBehaviour
{
	public GameObject p1;

	public GameObject p2;

	public Transform spawnPointA;

	public Transform spawnPointB;

	private bool p1Spawned;

	private bool p2Spawned;

	private float p1Timer;

	private float p2Timer;

	private void Update()
	{
		if (p1Spawned)
		{
			p1Timer -= Time.deltaTime;
			if (p1Timer <= 0f)
			{
				p1Spawned = false;
			}
		}
		if (p2Spawned)
		{
			p2Timer -= Time.deltaTime;
			if (p2Timer <= 0f)
			{
				p2Spawned = false;
			}
		}
	}

	private void OnTriggerEnter(Collider collision)
	{
		if ((collision.transform.root.name == "Player 1" && !p1Spawned) || (collision.transform.root.name == "Player 1(Clone)" && !p1Spawned))
		{
			p1Spawned = true;
			p1Timer = 1f;
			Object.Destroy(collision.transform.root.gameObject);
			Object.Instantiate(p1, spawnPointA.position, Quaternion.identity);
		}
		if ((collision.transform.root.name == "Player 2" && !p2Spawned) || (collision.transform.root.name == "Player 2(Clone)" && !p2Spawned))
		{
			p2Spawned = true;
			p2Timer = 1f;
			Object.Destroy(collision.transform.root.gameObject);
			Object.Instantiate(p2, spawnPointB.position, Quaternion.identity);
		}
	}
}
