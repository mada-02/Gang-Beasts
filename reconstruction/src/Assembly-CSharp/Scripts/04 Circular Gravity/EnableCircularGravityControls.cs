using UnityEngine;

public class EnableCircularGravityControls : MonoBehaviour
{
	public string inputCircularGravity = "Jump";

	private void Start()
	{
		EnableCircularGravity(false);
	}

	private void Update()
	{
		if (Input.GetButton(inputCircularGravity))
		{
			EnableCircularGravity(true);
		}
		else
		{
			EnableCircularGravity(false);
		}
	}

	private void EnableCircularGravity(bool enable)
	{
		CircularGravity component = GetComponent<CircularGravity>();
		component.enable = enable;
	}
}
