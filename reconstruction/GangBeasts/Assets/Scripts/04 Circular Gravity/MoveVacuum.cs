using UnityEngine;

public class MoveVacuum : MonoBehaviour
{
	public float movementSpeed;

	private void Start()
	{
	}

	private void Update()
	{
		float num = movementSpeed * Input.GetAxis("Horizontal");
		float num2 = movementSpeed * Input.GetAxis("Vertical");
		if (num != 0f)
		{
			transform.Translate(new Vector3(num * Time.deltaTime, 0f, 0f));
		}
		if (num2 != 0f)
		{
			transform.Translate(new Vector3(0f, 0f, num2 * Time.deltaTime));
		}
	}
}
