using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/Brightness, Contrast, Gamma")]
public class CC_BrightnessContrastGamma : CC_Base
{
	public float redCoeff = 0.5f;

	public float greenCoeff = 0.5f;

	public float blueCoeff = 0.5f;

	public float brightness;

	public float contrast;

	public float gamma = 1f;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (brightness == 0f && contrast == 0f && gamma == 1f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetFloat("_rCoeff", redCoeff);
		material.SetFloat("_gCoeff", greenCoeff);
		material.SetFloat("_bCoeff", blueCoeff);
		material.SetFloat("_brightness", (brightness + 100f) * 0.01f);
		material.SetFloat("_contrast", (contrast + 100f) * 0.01f);
		material.SetFloat("_gamma", 1f / gamma);
		Graphics.Blit(source, destination, material);
	}
}
