using UnityEngine;

public class Blink : MonoBehaviour
{
	private Player player;

	private float stateTimer;

	public float eye = 1f;

	private void Start()
	{
		player = transform.root.GetComponent<Player>();
	}

	private void Update()
	{
		if (player.state != Player.State.Dead && player.state != Player.State.Stunned)
		{
			stateTimer = stateTimer - Time.deltaTime;
			if (stateTimer < 0f)
			{
				stateTimer = Random.Range(0.5f, 10f);
			}
			if (stateTimer <= 0.2f)
			{
				eye -= Time.deltaTime * 4f;
				if (eye < 0.1f)
				{
					eye = 0.1f;
				}
			}
			else
			{
				eye += Time.deltaTime * 4f;
				if (eye > 1f)
				{
					eye = 1f;
				}
			}
		}
		else
		{
			eye -= Time.deltaTime * 4f;
			if (eye < 0.1f)
			{
				eye = 0.1f;
			}
		}
		transform.localScale = new Vector3(1f, eye, 1f);
	}
}
