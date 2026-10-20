using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/Grayscale")]
public class CC_Grayscale : CC_Base
{
	public float redLuminance = 0.3f;

	public float greenLuminance = 0.59f;

	public float blueLuminance = 0.11f;

	public float amount = 1f;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (amount == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetVector("_data", new Vector4(redLuminance, greenLuminance, blueLuminance, amount));
		Graphics.Blit(source, destination, material);
	}
}
