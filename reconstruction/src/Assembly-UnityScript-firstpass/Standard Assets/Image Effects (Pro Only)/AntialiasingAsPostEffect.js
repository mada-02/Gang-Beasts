#pragma strict
#pragma implicit
#pragma downcast

enum AAMode {
	FXAA2,
	FXAA3Console,
	FXAA1PresetA,
	FXAA1PresetB,
	NFAA,
	SSAA,
	DLAA,
}

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Other/Antialiasing")

class AntialiasingAsPostEffect extends PostEffectsBase {
	var mode : AAMode = AAMode.FXAA3Console;
	var showGeneratedNormals : boolean;
	var offsetScale : float = 0.2;
	var blurRadius : float = 18.0;
	var edgeThresholdMin : float = 0.05;
	var edgeThreshold : float = 0.2;
	var edgeSharpness : float = 4.0;
	var dlaaSharp : boolean;
	var ssaaShader : Shader;
	private var ssaa : Material;
	var dlaaShader : Shader;
	private var dlaa : Material;
	var nfaaShader : Shader;
	private var nfaa : Material;
	var shaderFXAAPreset2 : Shader;
	private var materialFXAAPreset2 : Material;
	var shaderFXAAPreset3 : Shader;
	private var materialFXAAPreset3 : Material;
	var shaderFXAAII : Shader;
	private var materialFXAAII : Material;
	var shaderFXAAIII : Shader;
	private var materialFXAAIII : Material;
	function CurrentAAMaterial () : Material {
		var returnValue : Material = null;

		switch(mode) {
			case AAMode.FXAA3Console:
				returnValue = materialFXAAIII;
				break;
			case AAMode.FXAA2:
				returnValue = materialFXAAII;
				break;
			case AAMode.FXAA1PresetA:
				returnValue = materialFXAAPreset2;
				break;
			case AAMode.FXAA1PresetB:
				returnValue = materialFXAAPreset3;
				break;
			case AAMode.NFAA:
				returnValue = nfaa;
				break;
			case AAMode.SSAA:
				returnValue = ssaa;
				break;
			case AAMode.DLAA:
				returnValue = dlaa;
				break;
			default:
				returnValue = null;
				break;
		}
		return returnValue;
	}


	function CheckResources () : boolean {
		CheckSupport(false);
		materialFXAAPreset2 = CreateMaterial(shaderFXAAPreset2, materialFXAAPreset2);
		materialFXAAPreset3 = CreateMaterial(shaderFXAAPreset3, materialFXAAPreset3);
		materialFXAAII = CreateMaterial(shaderFXAAII, materialFXAAII);
		materialFXAAIII = CreateMaterial(shaderFXAAIII, materialFXAAIII);
		nfaa = CreateMaterial(nfaaShader, nfaa);
		ssaa = CreateMaterial(ssaaShader, ssaa);
		dlaa = CreateMaterial(dlaaShader, dlaa);
		if (!ssaaShader.isSupported) {
			NotSupported();
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
		} else if (mode == AAMode.FXAA3Console && materialFXAAIII != null) {
			materialFXAAIII.SetFloat("_EdgeThresholdMin", edgeThresholdMin);
			materialFXAAIII.SetFloat("_EdgeThreshold", edgeThreshold);
			materialFXAAIII.SetFloat("_EdgeSharpness", edgeSharpness);
			Graphics.Blit(source, destination, materialFXAAIII);
		} else if (mode == AAMode.FXAA1PresetB && materialFXAAPreset3 != null) {
			Graphics.Blit(source, destination, materialFXAAPreset3);
		} else if (mode == AAMode.FXAA1PresetA && materialFXAAPreset2 != null) {
			source.anisoLevel = 4;
			Graphics.Blit(source, destination, materialFXAAPreset2);
			source.anisoLevel = 0;
		} else if (mode == AAMode.FXAA2 && materialFXAAII != null) {
			Graphics.Blit(source, destination, materialFXAAII);
		} else if (mode == AAMode.SSAA && ssaa != null) {
			Graphics.Blit(source, destination, ssaa);
		} else if (mode == AAMode.DLAA && dlaa != null) {
			source.anisoLevel = 0;
			var temporary : RenderTexture = RenderTexture.GetTemporary(source.width, source.height);
			Graphics.Blit(source, temporary, dlaa, 0);
			Graphics.Blit(temporary, destination, dlaa, dlaaSharp ? 2 : 1);
			RenderTexture.ReleaseTemporary(temporary);
		} else if (mode == AAMode.NFAA && nfaa != null) {
			source.anisoLevel = 0;
			nfaa.SetFloat("_OffsetScale", offsetScale);
			nfaa.SetFloat("_BlurRadius", blurRadius);
			Graphics.Blit(source, destination, nfaa, showGeneratedNormals ? 1 : 0);
		} else {
			Graphics.Blit(source, destination);
		}
	}

}

