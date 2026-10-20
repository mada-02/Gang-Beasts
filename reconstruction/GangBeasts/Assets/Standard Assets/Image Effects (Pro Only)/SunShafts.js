#pragma strict
#pragma implicit
#pragma downcast

enum SunShaftsResolution {
	Low,
	Normal,
	High,
}

enum ShaftsScreenBlendMode {
	Screen,
	Add,
}

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Rendering/Sun Shafts")

class SunShafts extends PostEffectsBase {
	var resolution : SunShaftsResolution = SunShaftsResolution.Normal;
	var screenBlendMode : ShaftsScreenBlendMode = ShaftsScreenBlendMode.Screen;
	var sunTransform : Transform;
	var radialBlurIterations : int = 2;
	var sunColor : Color = Color.white;
	var sunShaftBlurRadius : float = 2.5;
	var sunShaftIntensity : float = 1.15;
	var useSkyBoxAlpha : float = 0.75;
	var maxRadius : float = 0.75;
	var useDepthTexture : boolean = true;
	var sunShaftsShader : Shader;
	private var sunShaftsMaterial : Material;
	var simpleClearShader : Shader;
	private var simpleClearMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(useDepthTexture);
		sunShaftsMaterial = CheckShaderAndCreateMaterial(sunShaftsShader, sunShaftsMaterial);
		simpleClearMaterial = CheckShaderAndCreateMaterial(simpleClearShader, simpleClearMaterial);
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
		if (useDepthTexture) {
			camera.depthTextureMode |= DepthTextureMode.Depth;
		}
		var num : int = 4;
		if (resolution == SunShaftsResolution.Normal) {
			num = 2;
		} else if (resolution == SunShaftsResolution.High) {
			num = 1;
		}
		var vector : Vector3 = Vector3.one * 0.5;
		if (sunTransform) {
			vector = camera.WorldToViewportPoint(sunTransform.position);
		} else {
			vector = Vector3(0.5, 0.5, 0.0);
		}
		var width : int = source.width / num;
		var height : int = source.height / num;
		var renderTexture : RenderTexture = null;
		var temporary : RenderTexture = RenderTexture.GetTemporary(width, height, 0);
		sunShaftsMaterial.SetVector("_BlurRadius4", Vector4(1.0, 1.0, 0.0, 0.0) * sunShaftBlurRadius);
		sunShaftsMaterial.SetVector("_SunPosition", Vector4(vector.x, vector.y, vector.z, maxRadius));
		sunShaftsMaterial.SetFloat("_NoSkyBoxMask", 1.0 - useSkyBoxAlpha);
		if (!useDepthTexture) {
			var renderTexture2 : RenderTexture = RenderTexture.GetTemporary(source.width, source.height, 0);
			RenderTexture.active = renderTexture2;
			GL.ClearWithSkybox(false, camera);
			sunShaftsMaterial.SetTexture("_Skybox", renderTexture2);
			Graphics.Blit(source, temporary, sunShaftsMaterial, 3);
			RenderTexture.ReleaseTemporary(renderTexture2);
		} else {
			Graphics.Blit(source, temporary, sunShaftsMaterial, 2);
		}
		DrawBorder(temporary, simpleClearMaterial);
		radialBlurIterations = Mathf.Clamp(radialBlurIterations, 1, 4);
		var num2 : float = sunShaftBlurRadius * 0.0013020834;
		sunShaftsMaterial.SetVector("_BlurRadius4", Vector4(num2, num2, 0.0, 0.0));
		sunShaftsMaterial.SetVector("_SunPosition", Vector4(vector.x, vector.y, vector.z, maxRadius));
		for (var i : int = 0; i < radialBlurIterations; i++) {
			renderTexture = RenderTexture.GetTemporary(width, height, 0);
			Graphics.Blit(temporary, renderTexture, sunShaftsMaterial, 1);
			RenderTexture.ReleaseTemporary(temporary);
			num2 = sunShaftBlurRadius * ((i * 2.0 + 1.0) * 6.0) / 768.0;
			sunShaftsMaterial.SetVector("_BlurRadius4", Vector4(num2, num2, 0.0, 0.0));
			temporary = RenderTexture.GetTemporary(width, height, 0);
			Graphics.Blit(renderTexture, temporary, sunShaftsMaterial, 1);
			RenderTexture.ReleaseTemporary(renderTexture);
			num2 = sunShaftBlurRadius * ((i * 2.0 + 2.0) * 6.0) / 768.0;
			sunShaftsMaterial.SetVector("_BlurRadius4", Vector4(num2, num2, 0.0, 0.0));
		}
		if (!(vector.z < 0.0)) {
			sunShaftsMaterial.SetVector("_SunColor", Vector4(sunColor.r, sunColor.g, sunColor.b, sunColor.a) * sunShaftIntensity);
		} else {
			sunShaftsMaterial.SetVector("_SunColor", Vector4.zero);
		}
		sunShaftsMaterial.SetTexture("_ColorBuffer", temporary);
		Graphics.Blit(source, destination, sunShaftsMaterial, screenBlendMode == ShaftsScreenBlendMode.Screen ? 0 : 4);
		RenderTexture.ReleaseTemporary(temporary);
	}

}

