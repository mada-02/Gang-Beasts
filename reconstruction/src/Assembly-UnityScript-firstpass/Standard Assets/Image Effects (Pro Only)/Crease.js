#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Edge Detection/Crease Shading")

class Crease extends PostEffectsBase {
	var intensity : float = 0.5;
	var softness : int = 1;
	var spread : float = 1.0;
	var blurShader : Shader;
	private var blurMaterial : Material;
	var depthFetchShader : Shader;
	private var depthFetchMaterial : Material;
	var creaseApplyShader : Shader;
	private var creaseApplyMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(true);
		blurMaterial = CheckShaderAndCreateMaterial(blurShader, blurMaterial);
		depthFetchMaterial = CheckShaderAndCreateMaterial(depthFetchShader, depthFetchMaterial);
		creaseApplyMaterial = CheckShaderAndCreateMaterial(creaseApplyShader, creaseApplyMaterial);
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
		var num : float = 1.0 * width / (1.0 * height);
		var num2 : float = 2.0 / 1024.0;
		var temporary : RenderTexture = RenderTexture.GetTemporary(width, height, 0);
		var renderTexture : RenderTexture = RenderTexture.GetTemporary(width / 2, height / 2, 0);
		Graphics.Blit(source, temporary, depthFetchMaterial);
		Graphics.Blit(temporary, renderTexture);
		for (var i : int = 0; i < softness; i++) {
			var temporary2 : RenderTexture = RenderTexture.GetTemporary(width / 2, height / 2, 0);
			blurMaterial.SetVector("offsets", Vector4(0.0, spread * num2, 0.0, 0.0));
			Graphics.Blit(renderTexture, temporary2, blurMaterial);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary2;
			temporary2 = RenderTexture.GetTemporary(width / 2, height / 2, 0);
			blurMaterial.SetVector("offsets", Vector4(spread * num2 / num, 0.0, 0.0, 0.0));
			Graphics.Blit(renderTexture, temporary2, blurMaterial);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary2;
		}
		creaseApplyMaterial.SetTexture("_HrDepthTex", temporary);
		creaseApplyMaterial.SetTexture("_LrDepthTex", renderTexture);
		creaseApplyMaterial.SetFloat("intensity", intensity);
		Graphics.Blit(source, destination, creaseApplyMaterial);
		RenderTexture.ReleaseTemporary(temporary);
		RenderTexture.ReleaseTemporary(renderTexture);
	}

}

