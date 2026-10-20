using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/Pixelate")]
public class CC_Pixelate : CC_Base
{
	public float scale = 80f;

	public bool automaticRatio;

	public float ratio = 1f;

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
		Graphics.Blit(source, destination, material);
	}
}
