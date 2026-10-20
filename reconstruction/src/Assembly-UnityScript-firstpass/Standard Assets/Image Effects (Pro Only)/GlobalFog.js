#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Rendering/Global Fog")

class GlobalFog extends PostEffectsBase {
	enum FogMode {
		AbsoluteYAndDistance,
		AbsoluteY,
		Distance,
		RelativeYAndDistance,
	}

	var fogMode : FogMode = FogMode.AbsoluteYAndDistance;
	private var CAMERA_NEAR : float = 0.5;
	private var CAMERA_FAR : float = 50.0;
	private var CAMERA_FOV : float = 60.0;
	private var CAMERA_ASPECT_RATIO : float = 1.333333;
	var startDistance : float = 200.0;
	var globalDensity : float = 1.0;
	var heightScale : float = 100.0;
	var height : float;
	var globalFogColor : Color = Color.grey;
	var fogShader : Shader;
	private var fogMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(true);
		fogMaterial = CheckShaderAndCreateMaterial(fogShader, fogMaterial);
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
		CAMERA_NEAR = camera.nearClipPlane;
		CAMERA_FAR = camera.farClipPlane;
		CAMERA_FOV = camera.fieldOfView;
		CAMERA_ASPECT_RATIO = camera.aspect;
		var identity : Matrix4x4 = Matrix4x4.identity;
		var vector : Vector4;
		var vector2 : Vector3;
		var num : float = CAMERA_FOV * 0.5;
		var vector3 : Vector3 = camera.transform.right * CAMERA_NEAR * Mathf.Tan(num * (Mathf.PI / 180.0)) * CAMERA_ASPECT_RATIO;
		var vector4 : Vector3 = camera.transform.up * CAMERA_NEAR * Mathf.Tan(num * (Mathf.PI / 180.0));
		var vector5 : Vector3 = camera.transform.forward * CAMERA_NEAR - vector3 + vector4;
		var num2 : float = vector5.magnitude * CAMERA_FAR / CAMERA_NEAR;
		vector5.Normalize();
		vector5 *= num2;
		var vector6 : Vector3 = camera.transform.forward * CAMERA_NEAR + vector3 + vector4;
		vector6.Normalize();
		vector6 *= num2;
		var vector7 : Vector3 = camera.transform.forward * CAMERA_NEAR + vector3 - vector4;
		vector7.Normalize();
		vector7 *= num2;
		var vector8 : Vector3 = camera.transform.forward * CAMERA_NEAR - vector3 - vector4;
		vector8.Normalize();
		vector8 *= num2;
		identity.SetRow(0, vector5);
		identity.SetRow(1, vector6);
		identity.SetRow(2, vector7);
		identity.SetRow(3, vector8);
		fogMaterial.SetMatrix("_FrustumCornersWS", identity);
		fogMaterial.SetVector("_CameraWS", camera.transform.position);
		fogMaterial.SetVector("_StartDistance", Vector4(1.0 / startDistance, num2 - startDistance));
		fogMaterial.SetVector("_Y", Vector4(height, 1.0 / heightScale));
		fogMaterial.SetFloat("_GlobalDensity", globalDensity * 0.01);
		fogMaterial.SetColor("_FogColor", globalFogColor);
		CustomGraphicsBlit(source, destination, fogMaterial, fogMode);
	}

	static function CustomGraphicsBlit (source : RenderTexture, dest : RenderTexture, fxMaterial : Material, passNr : int) {
		RenderTexture.active = dest;
		fxMaterial.SetTexture("_MainTex", source);
		GL.PushMatrix();
		GL.LoadOrtho();
		fxMaterial.SetPass(passNr);
		GL.Begin(7);
		GL.MultiTexCoord2(0, 0.0, 0.0);
		GL.Vertex3(0.0, 0.0, 3.0);
		GL.MultiTexCoord2(0, 1.0, 0.0);
		GL.Vertex3(1.0, 0.0, 2.0);
		GL.MultiTexCoord2(0, 1.0, 1.0);
		GL.Vertex3(1.0, 1.0, 1.0);
		GL.MultiTexCoord2(0, 0.0, 1.0);
		GL.Vertex3(0.0, 1.0, 0.0);
		GL.End();
		GL.PopMatrix();
	}

}

