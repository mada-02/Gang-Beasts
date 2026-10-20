using UnityEngine;

[AddComponentMenu("Colorful/LED")]
[ExecuteInEditMode]
public class CC_Led : CC_Base
{
	public float scale = 80f;

	public bool automaticRatio;

	public float ratio = 1f;

	public float brightness = 1f;

	public int mode;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		switch (mode)
		{
		case 0:
			material.SetFloat("_scale", scale);
			break;
		case 1:
		default:
			material.SetFloat("_scale", camera.pixelWidth / scale);
			break;
		}

		material.SetFloat("_ratio", automaticRatio ? (camera.pixelWidth / camera.pixelHeight) : ratio);
		material.SetFloat("_brightness", brightness);
		Graphics.Blit(source, destination, material);
	}
}
