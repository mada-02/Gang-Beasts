using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/RGB Split")]
public class CC_RGBSplit : CC_Base
{
	public float amount;

	public float angle;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (amount == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetFloat("_rgbShiftAmount", amount * 0.001f);
		material.SetFloat("_rgbShiftAngleCos", Mathf.Cos(angle));
		material.SetFloat("_rgbShiftAngleSin", Mathf.Sin(angle));
		Graphics.Blit(source, destination, material);
	}
}
