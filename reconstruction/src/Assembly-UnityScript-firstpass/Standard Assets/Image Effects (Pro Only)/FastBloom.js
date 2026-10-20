#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Bloom and Glow/Bloom (Optimized)")

class FastBloom extends PostEffectsBase {
	enum Resolution {
		Low,
		High,
	}

	enum BlurType {
		Standard,
		Sgx,
	}

	@Range (0.0, 1.5)
	var threshhold : float = 0.25;
	@Range (0.0, 2.5)
	var intensity : float = 0.75;
	@Range (0.25, 5.5)
	var blurSize : float = 1.0;
	var resolution : Resolution = Resolution.Low;
	@Range (1.0, 4.0)
	var blurIterations : int = 1;
	var blurType : BlurType = BlurType.Standard;
	var fastBloomShader : Shader;
	private var fastBloomMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		fastBloomMaterial = CheckShaderAndCreateMaterial(fastBloomShader, fastBloomMaterial);
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnDisable () {
		if (fastBloomMaterial) {
			UnityEngine.Object.DestroyImmediate(fastBloomMaterial);
		}
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		var num : int = (resolution == Resolution.Low ? 4 : 2);
		var num2 : float = (resolution == Resolution.Low ? 0.5 : 1.0);
		fastBloomMaterial.SetVector("_Parameter", Vector4(blurSize * num2, 0.0, threshhold, intensity));
		source.filterMode = FilterMode.Bilinear;
		var width : int = source.width / num;
		var height : int = source.height / num;
		var renderTexture : RenderTexture = RenderTexture.GetTemporary(width, height, 0, source.format);
		renderTexture.filterMode = FilterMode.Bilinear;
		Graphics.Blit(source, renderTexture, fastBloomMaterial, 1);
		var num3 : int = (blurType == BlurType.Standard ? 0 : 2);
		for (var i : int = 0; i < blurIterations; i++) {
			fastBloomMaterial.SetVector("_Parameter", Vector4(blurSize * num2 + i * 1.0, 0.0, threshhold, intensity));
			var temporary : RenderTexture = RenderTexture.GetTemporary(width, height, 0, source.format);
			temporary.filterMode = FilterMode.Bilinear;
			Graphics.Blit(renderTexture, temporary, fastBloomMaterial, 2 + num3);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary;
			temporary = RenderTexture.GetTemporary(width, height, 0, source.format);
			temporary.filterMode = FilterMode.Bilinear;
			Graphics.Blit(renderTexture, temporary, fastBloomMaterial, 3 + num3);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary;
		}
		fastBloomMaterial.SetTexture("_Bloom", renderTexture);
		Graphics.Blit(source, destination, fastBloomMaterial, 0);
		RenderTexture.ReleaseTemporary(renderTexture);
	}

}

