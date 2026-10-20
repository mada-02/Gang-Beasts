using UnityEngine;

public class SceneCamera : MonoBehaviour
{
	public GameObject[] players;

	public Player[] player;

	public Vector3 offset;

	public Vector3 currentOffset;

	public Vector3 targetPosition;

	private Vector3 velocity1 = Vector3.zero;

	private Vector3 velocity2 = Vector3.zero;

	public float smoothTime = 1f;

	public float zoom;

	private Vector3 lookAtPosition;

	private Vector3 lastLookAtPosition;

	private Vector3 targetCameraPosition;

	private Vector3 cameraPosition;

	private Vector3 lastOffset;

	private GameObject cameraTarget;

	public bool rotateCam;

	private void Start()
	{
		lastOffset = offset;
		cameraTarget = new GameObject();
		cameraTarget.tag = "Camera Target";
		cameraTarget.name = "Camera Target";
		SphereCollider sphereCollider = cameraTarget.AddComponent<SphereCollider>();
		sphereCollider.isTrigger = true;
		sphereCollider.radius = 0.1f;
		cameraTarget.AddComponent<Rigidbody>();
		cameraTarget.rigidbody.isKinematic = true;
	}

	private void FixedUpdate()
	{
		if (cInput.GetButtonDown("Restart Level"))
		{
			CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
			{
				Application.LoadLevel(Application.loadedLevel);
			});
		}
		if (Input.GetKey(KeyCode.Escape))
		{
			CameraFade.StartAlphaFade(Color.black, false, 1f, 0f, () =>
			{
				Application.LoadLevel("Menu");
			});
		}
		FindPlayers();
		UpdatePosition();
	}

	private void UpdatePosition()
	{
		if (!(player.Length <= 0 || players.Length <= 0))
		{
			currentOffset = Vector3.Lerp(lastOffset, offset, Time.deltaTime / 2f);
			targetPosition = Vector3.zero;
			int num = 0;
			for (int i = 0; i < player.Length; i++)
			{
				if (!player[i].mob)
				{
					targetPosition += player[i].part["chest"].position;
					num++;
				}
			}

			if (num > 0)
			{
				targetPosition /= (float)num;
				GetPlayerDistance();
				targetCameraPosition = targetPosition + currentOffset * zoom;
				lookAtPosition = Vector3.SmoothDamp(lastLookAtPosition, targetPosition, ref velocity1, smoothTime);
				cameraPosition = Vector3.SmoothDamp(transform.position, targetCameraPosition, ref velocity2, smoothTime);
				if (!rotateCam)
				{
					transform.position = cameraPosition;
				}
				else
				{
					transform.RotateAround(lookAtPosition, Vector3.up, 6f * Time.deltaTime);
					Vector3 position = new Vector3(transform.position.x, cameraPosition.y, transform.position.z);
					transform.position = position;
				}

				cameraTarget.rigidbody.MovePosition(lookAtPosition);
				transform.LookAt(cameraTarget.transform.position);
				lastLookAtPosition = lookAtPosition;
				lastOffset = currentOffset;
			}
		}
	}

	private void FindPlayers()
	{
		players = GameObject.FindGameObjectsWithTag("Player");
		if (players.Length > 0)
		{
			player = new Player[players.Length];
			for (int i = 0; i < players.Length; i++)
			{
				player[i] = players[i].GetComponent<Player>();
			}
		}
	}

	private void GetPlayerDistance()
	{
		float num = float.PositiveInfinity;
		if (players.Length > 1)
		{
			for (int i = 0; i < players.Length; i++)
			{
				if (!player[i].mob)
				{
					float num2 = Vector3.Distance(player[i].part["chest"].position, targetPosition);
					if (num2 > num)
					{
						zoom = num2 / 6f;
						if (zoom < 0.5f)
						{
							zoom = 0.5f;
						}
					}

					num = num2;
				}
			}
		}
		else
		{
			zoom = 0.5f;
		}
	}
}
