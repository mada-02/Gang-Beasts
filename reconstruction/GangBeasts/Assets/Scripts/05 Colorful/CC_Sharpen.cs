using UnityEngine;

[AddComponentMenu("Colorful/Sharpen")]
[ExecuteInEditMode]
public class CC_Sharpen : CC_Base
{
	public float strength = 0.6f;

	public float clamp = 0.05f;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (strength == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetFloat("_px", 1f / (float)Screen.width);
		material.SetFloat("_py", 1f / (float)Screen.height);
		material.SetFloat("_strength", strength);
		material.SetFloat("_clamp", clamp);
		Graphics.Blit(source, destination, material);
	}
}
