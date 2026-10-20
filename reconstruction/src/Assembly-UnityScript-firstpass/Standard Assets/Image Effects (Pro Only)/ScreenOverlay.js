#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Other/Screen Overlay")

class ScreenOverlay extends PostEffectsBase {
	enum OverlayBlendMode {
		Additive,
		ScreenBlend,
		Multiply,
		Overlay,
		AlphaBlend,
	}

	var blendMode : OverlayBlendMode = OverlayBlendMode.Overlay;
	var intensity : float = 1.0;
	var texture : Texture2D;
	var overlayShader : Shader;
	private var overlayMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		overlayMaterial = CheckShaderAndCreateMaterial(overlayShader, overlayMaterial);
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
		overlayMaterial.SetFloat("_Intensity", intensity);
		overlayMaterial.SetTexture("_Overlay", texture);
		Graphics.Blit(source, destination, overlayMaterial, blendMode);
	}

}

