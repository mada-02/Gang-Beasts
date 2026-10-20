using UnityEngine;

[AddComponentMenu("Colorful/Wiggle")]
[ExecuteInEditMode]
public class CC_Wiggle : CC_Base
{
	public float timer;

	public float speed = 1f;

	public float scale = 12f;

	private void Update()
	{
		timer += speed * Time.deltaTime;
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_timer", timer);
		material.SetFloat("_scale", scale);
		Graphics.Blit(source, destination, material);
	}
}
