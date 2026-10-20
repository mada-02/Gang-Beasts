#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Displacement/Fisheye")

class Fisheye extends PostEffectsBase {
	var strengthX : float = 0.05;
	var strengthY : float = 0.05;
	var fishEyeShader : Shader;
	private var fisheyeMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		fisheyeMaterial = CheckShaderAndCreateMaterial(fishEyeShader, fisheyeMaterial);
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
		var num : float = 5.0 / 32.0;
		var num2 : float = source.width * 1.0 / (source.height * 1.0);
		fisheyeMaterial.SetVector("intensity", Vector4(strengthX * num2 * num, strengthY * num, strengthX * num2 * num, strengthY * num));
		Graphics.Blit(source, destination, fisheyeMaterial);
	}

}

