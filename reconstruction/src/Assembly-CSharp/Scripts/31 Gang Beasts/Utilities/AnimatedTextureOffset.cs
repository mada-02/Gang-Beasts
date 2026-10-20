using UnityEngine;

public class AnimatedTextureOffset : MonoBehaviour
{
	public float scrollSpeedX;

	public float scrollSpeedY;

	private void Update()
	{
		float x = Time.time * scrollSpeedX;
		float y = Time.time * scrollSpeedY;
		renderer.material.mainTextureOffset = new Vector2(x, y);
	}
}
