using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/Blend")]
public class CC_Blend : CC_Base
{
	public Texture texture;

	public float amount = 1f;

	public int mode;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (texture == null || amount == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetTexture("_overlayTex", texture);
		material.SetFloat("_amount", amount);
		Graphics.Blit(source, destination, material, mode);
	}
}
