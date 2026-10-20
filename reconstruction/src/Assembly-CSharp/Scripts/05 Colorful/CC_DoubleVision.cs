using UnityEngine;

[ExecuteInEditMode]
[AddComponentMenu("Colorful/Double Vision")]
public class CC_DoubleVision : CC_Base
{
	public Vector2 displace = new Vector2(0.7f, 0f);

	public float amount = 1f;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (amount == 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		material.SetVector("_displace", new Vector2(displace.x / (float)Screen.width, displace.y / (float)Screen.height));
		material.SetFloat("_amount", amount);
		Graphics.Blit(source, destination, material);
	}
}
