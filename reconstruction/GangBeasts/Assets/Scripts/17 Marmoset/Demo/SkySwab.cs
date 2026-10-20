using UnityEngine;
using mset;

public class SkySwab : MonoBehaviour
{
	public mset.Sky targetSky;

	private Vector3 scale = new Vector3(1f, 1.01f, 1f);

	private Quaternion baseRot = Quaternion.identity;

	public Vector3 bigScale = new Vector3(1.2f, 1.21f, 1.2f);

	public Vector3 hoverScale = new Vector3(1f, 1f, 1f);

	public Vector3 littleScale = new Vector3(0.75f, 0.76f, 0.75f);

	private void Start()
	{
		baseRot = transform.localRotation;
		scale = littleScale;
	}

	private void OnMouseDown()
	{
		if ((bool)targetSky)
		{
			targetSky.Apply();
		}
	}

	private void OnMouseOver()
	{
		scale = hoverScale;
	}

	private void OnMouseExit()
	{
		scale = littleScale;
	}

	private void Update()
	{
		if (mset.Sky.activeSky == targetSky)
		{
			transform.Rotate(0f, 200f * Time.deltaTime, 0f);
			transform.localScale = bigScale;
		}
		else
		{
			transform.localRotation = baseRot;
			transform.localScale = scale;
		}
	}
}
