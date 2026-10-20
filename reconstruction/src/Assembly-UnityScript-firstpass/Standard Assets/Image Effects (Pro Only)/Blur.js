#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Blur/Blur (Optimized)")

class Blur extends PostEffectsBase {
	enum BlurType {
		StandardGauss,
		SgxGauss,
	}

	@Range (0.0, 2.0)
	var downsample : int = 1;
	@Range (0.0, 10.0)
	var blurSize : float = 3.0;
	@Range (1.0, 4.0)
	var blurIterations : int = 2;
	var blurType : BlurType = BlurType.StandardGauss;
	var blurShader : Shader;
	private var blurMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		blurMaterial = CheckShaderAndCreateMaterial(blurShader, blurMaterial);
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnDisable () {
		if (blurMaterial) {
			UnityEngine.Object.DestroyImmediate(blurMaterial);
		}
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		var num : float = 1.0 / (1.0 * (1 << downsample));
		blurMaterial.SetVector("_Parameter", Vector4(blurSize * num, (-blurSize) * num, 0.0, 0.0));
		source.filterMode = FilterMode.Bilinear;
		var width : int = source.width >> downsample;
		var height : int = source.height >> downsample;
		var renderTexture : RenderTexture = RenderTexture.GetTemporary(width, height, 0, source.format);
		renderTexture.filterMode = FilterMode.Bilinear;
		Graphics.Blit(source, renderTexture, blurMaterial, 0);
		var num2 : int = (blurType == BlurType.StandardGauss ? 0 : 2);
		for (var i : int = 0; i < blurIterations; i++) {
			var num3 : float = i * 1.0;
			blurMaterial.SetVector("_Parameter", Vector4(blurSize * num + num3, (-blurSize) * num - num3, 0.0, 0.0));
			var temporary : RenderTexture = RenderTexture.GetTemporary(width, height, 0, source.format);
			temporary.filterMode = FilterMode.Bilinear;
			Graphics.Blit(renderTexture, temporary, blurMaterial, 1 + num2);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary;
			temporary = RenderTexture.GetTemporary(width, height, 0, source.format);
			temporary.filterMode = FilterMode.Bilinear;
			Graphics.Blit(renderTexture, temporary, blurMaterial, 2 + num2);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary;
		}
		Graphics.Blit(renderTexture, destination);
		RenderTexture.ReleaseTemporary(renderTexture);
	}

}

