using UnityEngine;

public class ScrollUVs : MonoBehaviour
{
	public float scrollSpeedX;

	public float scrollSpeedY;

	public bool random;

	private void Start()
	{
		if (random)
		{
			scrollSpeedX = Random.Range(-scrollSpeedX, scrollSpeedX);
			scrollSpeedY = Random.Range(-scrollSpeedY, scrollSpeedY);
		}
	}

	private void Update()
	{
		float x = Time.time * scrollSpeedX;
		float y = Time.time * scrollSpeedY;
		renderer.material.SetTextureOffset("_MainTex", new Vector2(x, y));
	}
}
