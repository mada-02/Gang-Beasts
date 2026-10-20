#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Color Adjustments/Contrast Enhance (Unsharp Mask)")

class ContrastEnhance extends PostEffectsBase {
	var intensity : float = 0.5;
	var threshhold : float;
	private var separableBlurMaterial : Material;
	private var contrastCompositeMaterial : Material;
	var blurSpread : float = 1.0;
	var separableBlurShader : Shader;
	var contrastCompositeShader : Shader;
	function CheckResources () : boolean {
		CheckSupport(false);
		contrastCompositeMaterial = CheckShaderAndCreateMaterial(contrastCompositeShader, contrastCompositeMaterial);
		separableBlurMaterial = CheckShaderAndCreateMaterial(separableBlurShader, separableBlurMaterial);
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		var width : int = source.width;
		var height : int = source.height;
		var temporary : RenderTexture = RenderTexture.GetTemporary(width / 2, height / 2, 0);
		Graphics.Blit(source, temporary);
		var temporary2 : RenderTexture = RenderTexture.GetTemporary(width / 4, height / 4, 0);
		Graphics.Blit(temporary, temporary2);
		RenderTexture.ReleaseTemporary(temporary);
		separableBlurMaterial.SetVector("offsets", Vector4(0.0, blurSpread * 1.0 / temporary2.height, 0.0, 0.0));
		var temporary3 : RenderTexture = RenderTexture.GetTemporary(width / 4, height / 4, 0);
		Graphics.Blit(temporary2, temporary3, separableBlurMaterial);
		RenderTexture.ReleaseTemporary(temporary2);
		separableBlurMaterial.SetVector("offsets", Vector4(blurSpread * 1.0 / temporary2.width, 0.0, 0.0, 0.0));
		temporary2 = RenderTexture.GetTemporary(width / 4, height / 4, 0);
		Graphics.Blit(temporary3, temporary2, separableBlurMaterial);
		RenderTexture.ReleaseTemporary(temporary3);
		contrastCompositeMaterial.SetTexture("_MainTexBlurred", temporary2);
		contrastCompositeMaterial.SetFloat("intensity", intensity);
		contrastCompositeMaterial.SetFloat("threshhold", threshhold);
		Graphics.Blit(source, destination, contrastCompositeMaterial);
		RenderTexture.ReleaseTemporary(temporary2);
	}

}

