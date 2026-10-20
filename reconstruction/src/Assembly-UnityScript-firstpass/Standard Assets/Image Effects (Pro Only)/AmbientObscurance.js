#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Rendering/Screen Space Ambient Obscurance")

class AmbientObscurance extends PostEffectsBase {
	@Range (0.0, 3.0)
	var intensity : float = 0.5;
	@Range (0.1, 3.0)
	var radius : float = 0.2;
	@Range (0.0, 3.0)
	var blurIterations : int = 1;
	@Range (0.0, 5.0)
	var blurFilterDistance : float = 1.25;
	@Range (0.0, 1.0)
	var downsample : int;
	var rand : Texture2D;
	var aoShader : Shader;
	private var aoMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(true);
		aoMaterial = CheckShaderAndCreateMaterial(aoShader, aoMaterial);
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnDisable () {
		if (aoMaterial) {
			UnityEngine.Object.DestroyImmediate(aoMaterial);
		}
		aoMaterial = null;
	}

	@ImageEffectOpaque
	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		var projectionMatrix : Matrix4x4 = camera.projectionMatrix;
		var inverse : Matrix4x4 = projectionMatrix.inverse;
		var vector : Vector4 = Vector4(-2.0 / (Screen.width * projectionMatrix[0]), -2.0 / (Screen.height * projectionMatrix[5]), (1.0 - projectionMatrix[2]) / projectionMatrix[0], (1.0 + projectionMatrix[6]) / projectionMatrix[5]);
		aoMaterial.SetVector("_ProjInfo", vector);
		aoMaterial.SetMatrix("_ProjectionInv", inverse);
		aoMaterial.SetTexture("_Rand", rand);
		aoMaterial.SetFloat("_Radius", radius);
		aoMaterial.SetFloat("_Radius2", radius * radius);
		aoMaterial.SetFloat("_Intensity", intensity);
		aoMaterial.SetFloat("_BlurFilterDistance", blurFilterDistance);
		var width : int = source.width;
		var height : int = source.height;
		var renderTexture : RenderTexture = RenderTexture.GetTemporary(width >> downsample, height >> downsample);
		var renderTexture2 : RenderTexture = null;
		Graphics.Blit(source, renderTexture, aoMaterial, 0);
		if (downsample > 0) {
			renderTexture2 = RenderTexture.GetTemporary(width, height);
			Graphics.Blit(renderTexture, renderTexture2, aoMaterial, 4);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = renderTexture2;
		}
		for (var i : int = 0; i < blurIterations; i++) {
			aoMaterial.SetVector("_Axis", Vector2(1.0, 0.0));
			renderTexture2 = RenderTexture.GetTemporary(width, height);
			Graphics.Blit(renderTexture, renderTexture2, aoMaterial, 1);
			RenderTexture.ReleaseTemporary(renderTexture);
			aoMaterial.SetVector("_Axis", Vector2(0.0, 1.0));
			renderTexture = RenderTexture.GetTemporary(width, height);
			Graphics.Blit(renderTexture2, renderTexture, aoMaterial, 1);
			RenderTexture.ReleaseTemporary(renderTexture2);
		}
		aoMaterial.SetTexture("_AOTex", renderTexture);
		Graphics.Blit(source, destination, aoMaterial, 2);
		RenderTexture.ReleaseTemporary(renderTexture);
	}

}

