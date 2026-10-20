#pragma strict
#pragma implicit
#pragma downcast

enum EdgeDetectMode {
	TriangleDepthNormals,
	RobertsCrossDepthNormals,
	SobelDepth,
	SobelDepthThin,
	TriangleLuminance,
}

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Edge Detection/Edge Detection")

class EdgeDetectEffectNormals extends PostEffectsBase {
	var mode : EdgeDetectMode = EdgeDetectMode.SobelDepthThin;
	var sensitivityDepth : float = 1.0;
	var sensitivityNormals : float = 1.0;
	var lumThreshhold : float = 0.2;
	var edgeExp : float = 1.0;
	var sampleDist : float = 1.0;
	var edgesOnly : float;
	var edgesOnlyBgColor : Color = Color.white;
	var edgeDetectShader : Shader;
	private var edgeDetectMaterial : Material;
	private var oldMode : EdgeDetectMode = EdgeDetectMode.SobelDepthThin;
	function CheckResources () : boolean {
		CheckSupport(true);
		edgeDetectMaterial = CheckShaderAndCreateMaterial(edgeDetectShader, edgeDetectMaterial);
		if (mode != oldMode) {
			SetCameraFlag();
		}
		oldMode = mode;
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function Start () {
		oldMode = mode;
	}

	function SetCameraFlag () {
		if (mode > EdgeDetectMode.RobertsCrossDepthNormals) {
			camera.depthTextureMode |= DepthTextureMode.Depth;
		} else {
			camera.depthTextureMode |= DepthTextureMode.DepthNormals;
		}
	}

	function OnEnable () {
		SetCameraFlag();
	}

	@ImageEffectOpaque
	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		var vector : Vector2 = Vector2(sensitivityDepth, sensitivityNormals);
		edgeDetectMaterial.SetVector("_Sensitivity", Vector4(vector.x, vector.y, 1.0, vector.y));
		edgeDetectMaterial.SetFloat("_BgFade", edgesOnly);
		edgeDetectMaterial.SetFloat("_SampleDistance", sampleDist);
		edgeDetectMaterial.SetVector("_BgColor", edgesOnlyBgColor);
		edgeDetectMaterial.SetFloat("_Exponent", edgeExp);
		edgeDetectMaterial.SetFloat("_Threshold", lumThreshhold);
		Graphics.Blit(source, destination, edgeDetectMaterial, mode);
	}

}

