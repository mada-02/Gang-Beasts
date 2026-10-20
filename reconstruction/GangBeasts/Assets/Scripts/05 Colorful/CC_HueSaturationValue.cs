using UnityEngine;

[AddComponentMenu("Colorful/Hue, Saturation, Value")]
[ExecuteInEditMode]
public class CC_HueSaturationValue : CC_Base
{
	public float hue;

	public float saturation;

	public float value;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (hue == 0f && saturation == 0f && value == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetFloat("_hue", hue / 360f);
		material.SetFloat("_saturation", saturation * 0.01f);
		material.SetFloat("_value", value * 0.01f);
		Graphics.Blit(source, destination, material);
	}
}
