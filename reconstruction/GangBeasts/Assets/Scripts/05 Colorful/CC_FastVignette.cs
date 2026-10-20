using UnityEngine;

[AddComponentMenu("Colorful/Fast Vignette")]
[ExecuteInEditMode]
public class CC_FastVignette : CC_Base
{
	public float sharpness = 10f;

	public float darkness = 30f;

	public bool desaturate;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_sharpness", sharpness * 0.01f);
		material.SetFloat("_darkness", darkness * 0.02f);
		Graphics.Blit(source, destination, material, desaturate ? 1 : 0);
	}
}
