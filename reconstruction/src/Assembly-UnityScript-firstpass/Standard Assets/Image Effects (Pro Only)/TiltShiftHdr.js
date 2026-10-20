#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Camera/Tilt Shift (Lens Blur)")

class TiltShiftHdr extends PostEffectsBase {
	enum TiltShiftMode {
		TiltShiftMode,
		IrisMode,
	}

	enum TiltShiftQuality {
		Preview,
		Normal,
		High,
	}

	var mode : TiltShiftMode = TiltShiftMode.TiltShiftMode;
	var quality : TiltShiftQuality = TiltShiftQuality.Normal;
	@Range (0.0, 15.0)
	var blurArea : float = 1.0;
	@Range (0.0, 25.0)
	var maxBlurSize : float = 5.0;
	@Range (0.0, 1.0)
	var downsample : int;
	var tiltShiftShader : Shader;
	private var tiltShiftMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(true);
		tiltShiftMaterial = CheckShaderAndCreateMaterial(tiltShiftShader, tiltShiftMaterial);
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
		tiltShiftMaterial.SetFloat("_BlurSize", !(maxBlurSize >= 0.0) ? 0.0 : maxBlurSize);
		tiltShiftMaterial.SetFloat("_BlurArea", blurArea);
		source.filterMode = FilterMode.Bilinear;
		var renderTexture : RenderTexture = destination;
		if (downsample != 0) {
			renderTexture = RenderTexture.GetTemporary(source.width >> downsample, source.height >> downsample, 0, source.format);
			renderTexture.filterMode = FilterMode.Bilinear;
		}
		var num : int = quality;
		num *= 2;
		Graphics.Blit(source, renderTexture, tiltShiftMaterial, mode == TiltShiftMode.TiltShiftMode ? num : (num + 1));
		if (downsample != 0) {
			tiltShiftMaterial.SetTexture("_Blurred", renderTexture);
			Graphics.Blit(source, destination, tiltShiftMaterial, 6);
		}
		if (renderTexture != destination) {
			RenderTexture.ReleaseTemporary(renderTexture);
		}
	}

}

