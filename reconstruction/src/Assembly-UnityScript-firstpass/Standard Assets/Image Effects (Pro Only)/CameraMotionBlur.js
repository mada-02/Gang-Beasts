#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Camera/Camera Motion Blur")

class CameraMotionBlur extends PostEffectsBase {
	enum MotionBlurFilter {
		CameraMotion,
		LocalBlur,
		Reconstruction,
		ReconstructionDX11,
		ReconstructionDisc,
	}

	@System.NonSerialized
	static var MAX_RADIUS : int = 10.0;
	var filterType : MotionBlurFilter = MotionBlurFilter.Reconstruction;
	var preview : boolean;
	var previewScale : Vector3 = Vector3.one;
	var movementScale : float;
	var rotationScale : float = 1.0;
	var maxVelocity : float = 8.0;
	var minVelocity : float = 0.1;
	var velocityScale : float = 0.375;
	var softZDistance : float = 0.005;
	var velocityDownsample : int = 1;
	var excludeLayers : LayerMask;
	private var tmpCam : GameObject;
	var shader : Shader;
	var dx11MotionBlurShader : Shader;
	var replacementClear : Shader;
	private var motionBlurMaterial : Material;
	private var dx11MotionBlurMaterial : Material;
	var noiseTexture : Texture2D;
	var jitter : float = 0.05;
	var showVelocity : boolean;
	var showVelocityScale : float = 1.0;
	private var currentViewProjMat : Matrix4x4;
	private var prevViewProjMat : Matrix4x4;
	private var prevFrameCount : int;
	private var wasActive : boolean;
	private var prevFrameForward : Vector3 = Vector3.forward;
	private var prevFrameRight : Vector3 = Vector3.right;
	private var prevFrameUp : Vector3 = Vector3.up;
	private var prevFramePos : Vector3 = Vector3.zero;
	private final function CalculateViewProjection () {
		var worldToCameraMatrix : Matrix4x4 = camera.worldToCameraMatrix;
		var gPUProjectionMatrix : Matrix4x4 = GL.GetGPUProjectionMatrix(camera.projectionMatrix, true);
		currentViewProjMat = gPUProjectionMatrix * worldToCameraMatrix;
	}

	function Start () {
		CheckResources();
		wasActive = gameObject.activeInHierarchy;
		CalculateViewProjection();
		Remember();
		wasActive = false;
	}

	function OnEnable () {
		camera.depthTextureMode |= DepthTextureMode.Depth;
	}

	function OnDisable () {
		if (null != motionBlurMaterial) {
			UnityEngine.Object.DestroyImmediate(motionBlurMaterial);
			motionBlurMaterial = null;
		}
		if (null != dx11MotionBlurMaterial) {
			UnityEngine.Object.DestroyImmediate(dx11MotionBlurMaterial);
			dx11MotionBlurMaterial = null;
		}
		if (null != tmpCam) {
			UnityEngine.Object.DestroyImmediate(tmpCam);
			tmpCam = null;
		}
	}

	function CheckResources () : boolean {
		CheckSupport(true, true);
		motionBlurMaterial = CheckShaderAndCreateMaterial(shader, motionBlurMaterial);
		if (supportDX11 && filterType == MotionBlurFilter.ReconstructionDX11) {
			dx11MotionBlurMaterial = CheckShaderAndCreateMaterial(dx11MotionBlurShader, dx11MotionBlurMaterial);
		}
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
		if (filterType == MotionBlurFilter.CameraMotion) {
			StartFrame();
		}
		var format : RenderTextureFormat = (SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.RGHalf) ? RenderTextureFormat.RGHalf : RenderTextureFormat.ARGBHalf);
		var temporary : RenderTexture = RenderTexture.GetTemporary(divRoundUp(source.width, velocityDownsample), divRoundUp(source.height, velocityDownsample), 0, format);
		var num : int = 1;
		var num2 : int = 1;
		maxVelocity = Mathf.Max(2.0, maxVelocity);
		var num3 : float = maxVelocity;
		var flag : boolean = false;
		if (filterType == MotionBlurFilter.ReconstructionDX11 && dx11MotionBlurMaterial == null) {
			flag = true;
		}
		if (filterType == MotionBlurFilter.Reconstruction || flag || filterType == MotionBlurFilter.ReconstructionDisc) {
			maxVelocity = Mathf.Min(maxVelocity, MAX_RADIUS);
			num = divRoundUp(temporary.width, maxVelocity);
			num2 = divRoundUp(temporary.height, maxVelocity);
			num3 = temporary.width / num;
		} else {
			num = divRoundUp(temporary.width, maxVelocity);
			num2 = divRoundUp(temporary.height, maxVelocity);
			num3 = temporary.width / num;
		}
		var temporary2 : RenderTexture = RenderTexture.GetTemporary(num, num2, 0, format);
		var temporary3 : RenderTexture = RenderTexture.GetTemporary(num, num2, 0, format);
		temporary.filterMode = FilterMode.Point;
		temporary2.filterMode = FilterMode.Point;
		temporary3.filterMode = FilterMode.Point;
		if (noiseTexture) {
			noiseTexture.filterMode = FilterMode.Point;
		}
		source.wrapMode = TextureWrapMode.Clamp;
		temporary.wrapMode = TextureWrapMode.Clamp;
		temporary3.wrapMode = TextureWrapMode.Clamp;
		temporary2.wrapMode = TextureWrapMode.Clamp;
		CalculateViewProjection();
		if (gameObject.activeInHierarchy && !wasActive) {
			Remember();
		}
		wasActive = gameObject.activeInHierarchy;
		var matrix4x : Matrix4x4 = Matrix4x4.Inverse(currentViewProjMat);
		motionBlurMaterial.SetMatrix("_InvViewProj", matrix4x);
		motionBlurMaterial.SetMatrix("_PrevViewProj", prevViewProjMat);
		motionBlurMaterial.SetMatrix("_ToPrevViewProjCombined", prevViewProjMat * matrix4x);
		motionBlurMaterial.SetFloat("_MaxVelocity", num3);
		motionBlurMaterial.SetFloat("_MaxRadiusOrKInPaper", num3);
		motionBlurMaterial.SetFloat("_MinVelocity", minVelocity);
		motionBlurMaterial.SetFloat("_VelocityScale", velocityScale);
		motionBlurMaterial.SetFloat("_Jitter", jitter);
		motionBlurMaterial.SetTexture("_NoiseTex", noiseTexture);
		motionBlurMaterial.SetTexture("_VelTex", temporary);
		motionBlurMaterial.SetTexture("_NeighbourMaxTex", temporary3);
		motionBlurMaterial.SetTexture("_TileTexDebug", temporary2);
		if (preview) {
			var worldToCameraMatrix : Matrix4x4 = this.camera.worldToCameraMatrix;
			var identity : Matrix4x4 = Matrix4x4.identity;
			identity.SetTRS(previewScale * 0.3333, Quaternion.identity, Vector3.one);
			var gPUProjectionMatrix : Matrix4x4 = GL.GetGPUProjectionMatrix(this.camera.projectionMatrix, true);
			prevViewProjMat = gPUProjectionMatrix * identity * worldToCameraMatrix;
			motionBlurMaterial.SetMatrix("_PrevViewProj", prevViewProjMat);
			motionBlurMaterial.SetMatrix("_ToPrevViewProjCombined", prevViewProjMat * matrix4x);
		}
		if (filterType == MotionBlurFilter.CameraMotion) {
			var zero : Vector4 = Vector4.zero;
			var num4 : float = Vector3.Dot(transform.up, Vector3.up);
			var rhs : Vector3 = prevFramePos - transform.position;
			var magnitude : float = rhs.magnitude;
			var num5 : float = 1.0;
			num5 = Vector3.Angle(transform.up, prevFrameUp) / this.camera.fieldOfView * (source.width * 0.75);
			zero.x = rotationScale * num5;
			num5 = Vector3.Angle(transform.forward, prevFrameForward) / this.camera.fieldOfView * (source.width * 0.75);
			zero.y = rotationScale * num4 * num5;
			num5 = Vector3.Angle(transform.forward, prevFrameForward) / this.camera.fieldOfView * (source.width * 0.75);
			zero.z = rotationScale * (1.0 - num4) * num5;
			if (!(magnitude <= float.Epsilon) && !(movementScale <= float.Epsilon)) {
				zero.w = movementScale * Vector3.Dot(transform.forward, rhs) * (source.width * 0.5);
				zero.x += movementScale * Vector3.Dot(transform.up, rhs) * (source.width * 0.5);
				zero.y += movementScale * Vector3.Dot(transform.right, rhs) * (source.width * 0.5);
			}
			if (preview) {
				motionBlurMaterial.SetVector("_BlurDirectionPacked", Vector4(previewScale.y, previewScale.x, 0.0, previewScale.z) * 0.5 * this.camera.fieldOfView);
			} else {
				motionBlurMaterial.SetVector("_BlurDirectionPacked", zero);
			}
		} else {
			Graphics.Blit(source, temporary, motionBlurMaterial, 0);
			var camera : Camera = null;
			if (excludeLayers.value != 0) {
				camera = GetTmpCam();
			}
			if (camera && excludeLayers.value != 0 && replacementClear && replacementClear.isSupported) {
				camera.targetTexture = temporary;
				camera.cullingMask = excludeLayers;
				camera.RenderWithShader(replacementClear, String.Empty);
			}
		}
		if (!preview && Time.frameCount != prevFrameCount) {
			prevFrameCount = Time.frameCount;
			Remember();
		}
		source.filterMode = FilterMode.Bilinear;
		if (showVelocity) {
			motionBlurMaterial.SetFloat("_DisplayVelocityScale", showVelocityScale);
			Graphics.Blit(temporary, destination, motionBlurMaterial, 1);
		} else if (filterType == MotionBlurFilter.ReconstructionDX11 && !flag) {
			dx11MotionBlurMaterial.SetFloat("_MinVelocity", minVelocity);
			dx11MotionBlurMaterial.SetFloat("_VelocityScale", velocityScale);
			dx11MotionBlurMaterial.SetFloat("_Jitter", jitter);
			dx11MotionBlurMaterial.SetTexture("_NoiseTex", noiseTexture);
			dx11MotionBlurMaterial.SetTexture("_VelTex", temporary);
			dx11MotionBlurMaterial.SetTexture("_NeighbourMaxTex", temporary3);
			dx11MotionBlurMaterial.SetFloat("_SoftZDistance", Mathf.Max(0.00025, softZDistance));
			dx11MotionBlurMaterial.SetFloat("_MaxRadiusOrKInPaper", num3);
			Graphics.Blit(temporary, temporary2, dx11MotionBlurMaterial, 0);
			Graphics.Blit(temporary2, temporary3, dx11MotionBlurMaterial, 1);
			Graphics.Blit(source, destination, dx11MotionBlurMaterial, 2);
		} else if (filterType == MotionBlurFilter.Reconstruction || flag) {
			motionBlurMaterial.SetFloat("_SoftZDistance", Mathf.Max(0.00025, softZDistance));
			Graphics.Blit(temporary, temporary2, motionBlurMaterial, 2);
			Graphics.Blit(temporary2, temporary3, motionBlurMaterial, 3);
			Graphics.Blit(source, destination, motionBlurMaterial, 4);
		} else if (filterType == MotionBlurFilter.CameraMotion) {
			Graphics.Blit(source, destination, motionBlurMaterial, 6);
		} else if (filterType == MotionBlurFilter.ReconstructionDisc) {
			motionBlurMaterial.SetFloat("_SoftZDistance", Mathf.Max(0.00025, softZDistance));
			Graphics.Blit(temporary, temporary2, motionBlurMaterial, 2);
			Graphics.Blit(temporary2, temporary3, motionBlurMaterial, 3);
			Graphics.Blit(source, destination, motionBlurMaterial, 7);
		} else {
			Graphics.Blit(source, destination, motionBlurMaterial, 5);
		}
		RenderTexture.ReleaseTemporary(temporary);
		RenderTexture.ReleaseTemporary(temporary2);
		RenderTexture.ReleaseTemporary(temporary3);
	}

	function Remember () {
		prevViewProjMat = currentViewProjMat;
		prevFrameForward = transform.forward;
		prevFrameRight = transform.right;
		prevFrameUp = transform.up;
		prevFramePos = transform.position;
	}

	function GetTmpCam () : Camera {
		if (tmpCam == null) {
			var text : String = "_" + camera.name + "_MotionBlurTmpCam";
			var gameObject : GameObject = GameObject.Find(text);
			if (null == gameObject) {
				tmpCam = GameObject(text, Camera);
			} else {
				tmpCam = gameObject;
			}
		}
		tmpCam.hideFlags = HideFlags.DontSave;
		tmpCam.transform.position = camera.transform.position;
		tmpCam.transform.rotation = camera.transform.rotation;
		tmpCam.transform.localScale = camera.transform.localScale;
		tmpCam.camera.CopyFrom(camera);
		tmpCam.camera.enabled = false;
		tmpCam.camera.depthTextureMode = DepthTextureMode.None;
		tmpCam.camera.clearFlags = CameraClearFlags.Nothing;
		return tmpCam.camera;
	}

	function StartFrame () {
		prevFramePos = Vector3.Slerp(prevFramePos, transform.position, 0.75);
	}

	function divRoundUp (x : int, d : int) : int {
		return (x + d - 1) / d;
	}

}

