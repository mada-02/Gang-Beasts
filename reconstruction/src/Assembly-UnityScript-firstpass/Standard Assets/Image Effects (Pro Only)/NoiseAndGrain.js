#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Noise/Noise And Grain (Filmic)")

class NoiseAndGrain extends PostEffectsBase {
	var intensityMultiplier : float = 0.25;
	var generalIntensity : float = 0.5;
	var blackIntensity : float = 1.0;
	var whiteIntensity : float = 1.0;
	var midGrey : float = 0.2;
	var dx11Grain : boolean;
	var softness : float;
	var monochrome : boolean;
	var intensities : Vector3 = Vector3(1.0, 1.0, 1.0);
	var tiling : Vector3 = Vector3(64.0, 64.0, 64.0);
	var monochromeTiling : float = 64.0;
	var filterMode : FilterMode = FilterMode.Bilinear;
	var noiseTexture : Texture2D;
	var noiseShader : Shader;
	private var noiseMaterial : Material;
	var dx11NoiseShader : Shader;
	private var dx11NoiseMaterial : Material;
	@System.NonSerialized
	private static var TILE_AMOUNT : float = 64.0;
	function CheckResources () : boolean {
		CheckSupport(false);
		noiseMaterial = CheckShaderAndCreateMaterial(noiseShader, noiseMaterial);
		if (dx11Grain && supportDX11) {
			dx11NoiseMaterial = CheckShaderAndCreateMaterial(dx11NoiseShader, dx11NoiseMaterial);
		}
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources() || null == noiseTexture) {
			Graphics.Blit(source, destination);
			if (null == noiseTexture) {
				Debug.LogWarning("Noise & Grain effect failing as noise texture is not assigned. please assign.", transform);
			}
			return;
		}
		softness = Mathf.Clamp(softness, 0.0, 0.99);
		if (dx11Grain && supportDX11) {
			dx11NoiseMaterial.SetFloat("_DX11NoiseTime", Time.frameCount);
			dx11NoiseMaterial.SetTexture("_NoiseTex", noiseTexture);
			dx11NoiseMaterial.SetVector("_NoisePerChannel", monochrome ? Vector3.one : intensities);
			dx11NoiseMaterial.SetVector("_MidGrey", Vector3(midGrey, 1.0 / (1.0 - midGrey), -1.0 / midGrey));
			dx11NoiseMaterial.SetVector("_NoiseAmount", Vector3(generalIntensity, blackIntensity, whiteIntensity) * intensityMultiplier);
			if (!(softness <= float.Epsilon)) {
				var temporary : RenderTexture = RenderTexture.GetTemporary((source.width * (1.0 - softness)), (source.height * (1.0 - softness)));
				DrawNoiseQuadGrid(source, temporary, dx11NoiseMaterial, noiseTexture, monochrome ? 3 : 2);
				dx11NoiseMaterial.SetTexture("_NoiseTex", temporary);
				Graphics.Blit(source, destination, dx11NoiseMaterial, 4);
				RenderTexture.ReleaseTemporary(temporary);
			} else {
				DrawNoiseQuadGrid(source, destination, dx11NoiseMaterial, noiseTexture, monochrome ? 1 : 0);
			}
			return;
		}
		if (noiseTexture) {
			noiseTexture.wrapMode = TextureWrapMode.Repeat;
			noiseTexture.filterMode = filterMode;
		}
		noiseMaterial.SetTexture("_NoiseTex", noiseTexture);
		noiseMaterial.SetVector("_NoisePerChannel", monochrome ? Vector3.one : intensities);
		noiseMaterial.SetVector("_NoiseTilingPerChannel", monochrome ? (Vector3.one * monochromeTiling) : tiling);
		noiseMaterial.SetVector("_MidGrey", Vector3(midGrey, 1.0 / (1.0 - midGrey), -1.0 / midGrey));
		noiseMaterial.SetVector("_NoiseAmount", Vector3(generalIntensity, blackIntensity, whiteIntensity) * intensityMultiplier);
		if (!(softness <= float.Epsilon)) {
			var temporary2 : RenderTexture = RenderTexture.GetTemporary((source.width * (1.0 - softness)), (source.height * (1.0 - softness)));
			DrawNoiseQuadGrid(source, temporary2, noiseMaterial, noiseTexture, 2);
			noiseMaterial.SetTexture("_NoiseTex", temporary2);
			Graphics.Blit(source, destination, noiseMaterial, 1);
			RenderTexture.ReleaseTemporary(temporary2);
		} else {
			DrawNoiseQuadGrid(source, destination, noiseMaterial, noiseTexture, 0);
		}
	}

	static function DrawNoiseQuadGrid (source : RenderTexture, dest : RenderTexture, fxMaterial : Material, noise : Texture2D, passNr : int) {
		RenderTexture.active = dest;
		var num : float = noise.width * 1.0;
		var num2 : float = 1.0 * source.width / TILE_AMOUNT;
		fxMaterial.SetTexture("_MainTex", source);
		GL.PushMatrix();
		GL.LoadOrtho();
		var num3 : float = 1.0 * source.width / (1.0 * source.height);
		var num4 : float = 1.0 / num2;
		var num5 : float = num4 * num3;
		var num6 : float = num / (noise.width * 1.0);
		fxMaterial.SetPass(passNr);
		GL.Begin(7);
		for (var num7 : float = 0.0; num7 < 1.0; num7 += num4) {
			for (var num8 : float = 0.0; num8 < 1.0; num8 += num5) {
				var num9 : float = UnityEngine.Random.Range(0.0, 1.0);
				var num10 : float = UnityEngine.Random.Range(0.0, 1.0);
				num9 = Mathf.Floor(num9 * num) / num;
				num10 = Mathf.Floor(num10 * num) / num;
				var num11 : float = 1.0 / num;
				GL.MultiTexCoord2(0, num9, num10);
				GL.MultiTexCoord2(1, 0.0, 0.0);
				GL.Vertex3(num7, num8, 0.1);
				GL.MultiTexCoord2(0, num9 + num6 * num11, num10);
				GL.MultiTexCoord2(1, 1.0, 0.0);
				GL.Vertex3(num7 + num4, num8, 0.1);
				GL.MultiTexCoord2(0, num9 + num6 * num11, num10 + num6 * num11);
				GL.MultiTexCoord2(1, 1.0, 1.0);
				GL.Vertex3(num7 + num4, num8 + num5, 0.1);
				GL.MultiTexCoord2(0, num9, num10 + num6 * num11);
				GL.MultiTexCoord2(1, 0.0, 1.0);
				GL.Vertex3(num7, num8 + num5, 0.1);
			}
		}
		GL.End();
		GL.PopMatrix();
	}

}

