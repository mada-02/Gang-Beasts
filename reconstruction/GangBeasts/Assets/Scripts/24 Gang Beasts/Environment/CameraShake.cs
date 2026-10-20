using UnityEngine;

public class CameraShake : MonoBehaviour
{
	public bool Shaking;

	private float ShakeDecay;

	private float ShakeIntensity;

	private Vector3 OriginalPos;

	private Quaternion OriginalRot;

	private void Start()
	{
		Shaking = false;
	}

	private void Update()
	{
		if (ShakeIntensity > 0f)
		{
			transform.position = OriginalPos + Random.insideUnitSphere * ShakeIntensity;
			transform.rotation = new Quaternion(OriginalRot.x + Random.Range(-ShakeIntensity, ShakeIntensity) * 0.1f, OriginalRot.y + Random.Range(-ShakeIntensity, ShakeIntensity) * 1f, OriginalRot.z + Random.Range(-ShakeIntensity, ShakeIntensity) * 0.1f, OriginalRot.w + Random.Range(-ShakeIntensity, ShakeIntensity) * 0.1f);
			ShakeIntensity -= ShakeDecay;
		}
		else if (Shaking)
		{
			Shaking = false;
		}
	}

	private void OnGUI()
	{
		if (GUI.Button(new Rect(10f, 200f, 50f, 30f), "Shake"))
		{
			DoShake();
		}
	}

	public void DoShake()
	{
		OriginalPos = transform.position;
		OriginalRot = transform.rotation;
		ShakeIntensity = 10f;
		ShakeDecay = 1E-05f;
		Shaking = true;
	}
}
