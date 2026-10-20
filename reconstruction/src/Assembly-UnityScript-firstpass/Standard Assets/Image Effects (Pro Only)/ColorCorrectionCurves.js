#pragma strict
#pragma implicit
#pragma downcast

enum ColorCorrectionMode {
	Simple,
	Advanced,
}

@script ExecuteInEditMode
@script AddComponentMenu ("Image Effects/Color Adjustments/Color Correction (Curves, Saturation)")

class ColorCorrectionCurves extends PostEffectsBase {
	var redChannel : AnimationCurve;
	var greenChannel : AnimationCurve;
	var blueChannel : AnimationCurve;
	var useDepthCorrection : boolean;
	var zCurve : AnimationCurve;
	var depthRedChannel : AnimationCurve;
	var depthGreenChannel : AnimationCurve;
	var depthBlueChannel : AnimationCurve;
	private var ccMaterial : Material;
	private var ccDepthMaterial : Material;
	private var selectiveCcMaterial : Material;
	private var rgbChannelTex : Texture2D;
	private var rgbDepthChannelTex : Texture2D;
	private var zCurveTex : Texture2D;
	var saturation : float = 1.0;
	var selectiveCc : boolean;
	var selectiveFromColor : Color = Color.white;
	var selectiveToColor : Color = Color.white;
	var mode : ColorCorrectionMode;
	var updateTextures : boolean = true;
	var colorCorrectionCurvesShader : Shader;
	var simpleColorCorrectionCurvesShader : Shader;
	var colorCorrectionSelectiveShader : Shader;
	private var updateTexturesOnStartup : boolean = true;
	function Start () {
		super.Start();
		updateTexturesOnStartup = true;
	}

	function Awake () {
	}

	function CheckResources () : boolean {
		CheckSupport(mode == ColorCorrectionMode.Advanced);
		ccMaterial = CheckShaderAndCreateMaterial(simpleColorCorrectionCurvesShader, ccMaterial);
		ccDepthMaterial = CheckShaderAndCreateMaterial(colorCorrectionCurvesShader, ccDepthMaterial);
		selectiveCcMaterial = CheckShaderAndCreateMaterial(colorCorrectionSelectiveShader, selectiveCcMaterial);
		if (!rgbChannelTex) {
			rgbChannelTex = Texture2D(256, 4, TextureFormat.ARGB32, false, true);
		}
		if (!rgbDepthChannelTex) {
			rgbDepthChannelTex = Texture2D(256, 4, TextureFormat.ARGB32, false, true);
		}
		if (!zCurveTex) {
			zCurveTex = Texture2D(256, 1, TextureFormat.ARGB32, false, true);
		}
		rgbChannelTex.hideFlags = HideFlags.DontSave;
		rgbDepthChannelTex.hideFlags = HideFlags.DontSave;
		zCurveTex.hideFlags = HideFlags.DontSave;
		rgbChannelTex.wrapMode = TextureWrapMode.Clamp;
		rgbDepthChannelTex.wrapMode = TextureWrapMode.Clamp;
		zCurveTex.wrapMode = TextureWrapMode.Clamp;
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function UpdateParameters () {
		CheckResources();
		if (redChannel && greenChannel && blueChannel) {
			for (var num : float = 0.0; num <= 1.0; num += 1.0 / 255.0) {
				var num2 : float = Mathf.Clamp(redChannel.Evaluate(num), 0.0, 1.0);
				var num3 : float = Mathf.Clamp(greenChannel.Evaluate(num), 0.0, 1.0);
				var num4 : float = Mathf.Clamp(blueChannel.Evaluate(num), 0.0, 1.0);
				rgbChannelTex.SetPixel(Mathf.Floor(num * 255.0), 0, Color(num2, num2, num2));
				rgbChannelTex.SetPixel(Mathf.Floor(num * 255.0), 1, Color(num3, num3, num3));
				rgbChannelTex.SetPixel(Mathf.Floor(num * 255.0), 2, Color(num4, num4, num4));
				var num5 : float = Mathf.Clamp(zCurve.Evaluate(num), 0.0, 1.0);
				zCurveTex.SetPixel(Mathf.Floor(num * 255.0), 0, Color(num5, num5, num5));
				num2 = Mathf.Clamp(depthRedChannel.Evaluate(num), 0.0, 1.0);
				num3 = Mathf.Clamp(depthGreenChannel.Evaluate(num), 0.0, 1.0);
				num4 = Mathf.Clamp(depthBlueChannel.Evaluate(num), 0.0, 1.0);
				rgbDepthChannelTex.SetPixel(Mathf.Floor(num * 255.0), 0, Color(num2, num2, num2));
				rgbDepthChannelTex.SetPixel(Mathf.Floor(num * 255.0), 1, Color(num3, num3, num3));
				rgbDepthChannelTex.SetPixel(Mathf.Floor(num * 255.0), 2, Color(num4, num4, num4));
			}
			rgbChannelTex.Apply();
			rgbDepthChannelTex.Apply();
			zCurveTex.Apply();
		}
	}

	function UpdateTextures () {
		UpdateParameters();
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		if (updateTexturesOnStartup) {
			UpdateParameters();
			updateTexturesOnStartup = false;
		}
		if (useDepthCorrection) {
			camera.depthTextureMode |= DepthTextureMode.Depth;
		}
		var renderTexture : RenderTexture = destination;
		if (selectiveCc) {
			renderTexture = RenderTexture.GetTemporary(source.width, source.height);
		}
		if (useDepthCorrection) {
			ccDepthMaterial.SetTexture("_RgbTex", rgbChannelTex);
			ccDepthMaterial.SetTexture("_ZCurve", zCurveTex);
			ccDepthMaterial.SetTexture("_RgbDepthTex", rgbDepthChannelTex);
			ccDepthMaterial.SetFloat("_Saturation", saturation);
			Graphics.Blit(source, renderTexture, ccDepthMaterial);
		} else {
			ccMaterial.SetTexture("_RgbTex", rgbChannelTex);
			ccMaterial.SetFloat("_Saturation", saturation);
			Graphics.Blit(source, renderTexture, ccMaterial);
		}
		if (selectiveCc) {
			selectiveCcMaterial.SetColor("selColor", selectiveFromColor);
			selectiveCcMaterial.SetColor("targetColor", selectiveToColor);
			Graphics.Blit(renderTexture, destination, selectiveCcMaterial);
			RenderTexture.ReleaseTemporary(renderTexture);
		}
	}

}

