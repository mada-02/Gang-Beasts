#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Camera/Vignette and Chromatic Aberration")

class Vignetting extends PostEffectsBase {
	enum AberrationMode {
		Simple,
		Advanced,
	}

	var mode : AberrationMode = AberrationMode.Simple;
	var intensity : float = 0.375;
	var chromaticAberration : float = 0.2;
	var axialAberration : float = 0.5;
	var blur : float;
	var blurSpread : float = 0.75;
	var luminanceDependency : float = 0.25;
	var blurDistance : float = 2.5;
	var vignetteShader : Shader;
	private var vignetteMaterial : Material;
	var separableBlurShader : Shader;
	private var separableBlurMaterial : Material;
	var chromAberrationShader : Shader;
	private var chromAberrationMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		vignetteMaterial = CheckShaderAndCreateMaterial(vignetteShader, vignetteMaterial);
		separableBlurMaterial = CheckShaderAndCreateMaterial(separableBlurShader, separableBlurMaterial);
		chromAberrationMaterial = CheckShaderAndCreateMaterial(chromAberrationShader, chromAberrationMaterial);
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
		var flag2 : boolean = (Mathf.Abs(blur) > 0.0 || Mathf.Abs(intensity) > 0.0);
		var num : float = 1.0 * width / (1.0 * height);
		var num2 : float = 2.0 / 1024.0;
		var renderTexture : RenderTexture = null;
		var renderTexture2 : RenderTexture = null;
		var renderTexture3 : RenderTexture = null;
		if (flag2) {
			renderTexture = RenderTexture.GetTemporary(width, height, 0, source.format);
			if (!(Mathf.Abs(blur) <= 0.0)) {
				renderTexture2 = RenderTexture.GetTemporary(width / 2, height / 2, 0, source.format);
				Graphics.Blit(source, renderTexture2, chromAberrationMaterial, 0);
				for (var i : int = 0; i < 2; i++) {
					separableBlurMaterial.SetVector("offsets", Vector4(0.0, blurSpread * num2, 0.0, 0.0));
					renderTexture3 = RenderTexture.GetTemporary(width / 2, height / 2, 0, source.format);
					Graphics.Blit(renderTexture2, renderTexture3, separableBlurMaterial);
					RenderTexture.ReleaseTemporary(renderTexture2);
					separableBlurMaterial.SetVector("offsets", Vector4(blurSpread * num2 / num, 0.0, 0.0, 0.0));
					renderTexture2 = RenderTexture.GetTemporary(width / 2, height / 2, 0, source.format);
					Graphics.Blit(renderTexture3, renderTexture2, separableBlurMaterial);
					RenderTexture.ReleaseTemporary(renderTexture3);
				}
			}
			vignetteMaterial.SetFloat("_Intensity", intensity);
			vignetteMaterial.SetFloat("_Blur", blur);
			vignetteMaterial.SetTexture("_VignetteTex", renderTexture2);
			Graphics.Blit(source, renderTexture, vignetteMaterial, 0);
		}
		chromAberrationMaterial.SetFloat("_ChromaticAberration", chromaticAberration);
		chromAberrationMaterial.SetFloat("_AxialAberration", axialAberration);
		chromAberrationMaterial.SetVector("_BlurDistance", Vector2(-blurDistance, blurDistance));
		chromAberrationMaterial.SetFloat("_Luminance", 1.0 / Mathf.Max(float.Epsilon, luminanceDependency));
		if (flag2) {
			renderTexture.wrapMode = TextureWrapMode.Clamp;
		} else {
			source.wrapMode = TextureWrapMode.Clamp;
		}
		Graphics.Blit(flag2 ? renderTexture : source, destination, chromAberrationMaterial, mode == AberrationMode.Advanced ? 2 : 1);
		RenderTexture.ReleaseTemporary(renderTexture);
		RenderTexture.ReleaseTemporary(renderTexture2);
	}

}

