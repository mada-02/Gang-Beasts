using UnityEngine;

[AddComponentMenu("Colorful/Analog TV")]
[ExecuteInEditMode]
public class CC_AnalogTV : CC_Base
{
	public float phase = 0.5f;

	public bool grayscale;

	public float noiseIntensity = 0.5f;

	public float scanlinesIntensity = 2f;

	public float scanlinesCount = 768f;

	public float distortion = 0.2f;

	public float cubicDistortion = 0.6f;

	public float scale = 0.8f;

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		material.SetFloat("_phase", phase);
		material.SetFloat("_noiseIntensity", noiseIntensity);
		material.SetFloat("_scanlinesIntensity", scanlinesIntensity);
		material.SetFloat("_scanlinesCount", (int)scanlinesCount);
		material.SetFloat("_distortion", distortion);
		material.SetFloat("_cubicDistortion", cubicDistortion);
		material.SetFloat("_scale", scale);
		Graphics.Blit(source, destination, material, grayscale ? 1 : 0);
	}
}
