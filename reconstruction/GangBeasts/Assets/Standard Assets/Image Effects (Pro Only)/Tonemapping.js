#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Color Adjustments/Tonemapping")

class Tonemapping extends PostEffectsBase {
	enum TonemapperType {
		SimpleReinhard,
		UserCurve,
		Hable,
		Photographic,
		OptimizedHejiDawson,
		AdaptiveReinhard,
		AdaptiveReinhardAutoWhite,
	}

	enum AdaptiveTexSize {
		Square16 = 0x10,
		Square32 = 0x20,
		Square64 = 0x40,
		Square128 = 0x80,
		Square256 = 0x100,
		Square512 = 0x200,
		Square1024 = 0x400,
	}

	var type : TonemapperType = TonemapperType.Photographic;
	var adaptiveTextureSize : AdaptiveTexSize = AdaptiveTexSize.Square256;
	var remapCurve : AnimationCurve;
	private var curveTex : Texture2D;
	var exposureAdjustment : float = 1.5;
	var middleGrey : float = 0.4;
	var white : float = 2.0;
	var adaptionSpeed : float = 1.5;
	var tonemapper : Shader;
	var validRenderTextureFormat : boolean = true;
	private var tonemapMaterial : Material;
	private var rt : RenderTexture;
	private var rtFormat : RenderTextureFormat = RenderTextureFormat.ARGBHalf;
	function CheckResources () : boolean {
		CheckSupport(false, true);
		tonemapMaterial = CheckShaderAndCreateMaterial(tonemapper, tonemapMaterial);
		if (!curveTex && type == TonemapperType.UserCurve) {
			curveTex = Texture2D(256, 1, TextureFormat.ARGB32, false, true);
			curveTex.filterMode = FilterMode.Bilinear;
			curveTex.wrapMode = TextureWrapMode.Clamp;
			curveTex.hideFlags = HideFlags.DontSave;
		}
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function UpdateCurve () : float {
		var num : float = 1.0;
		if (remapCurve.keys.length < 1) {
			remapCurve = AnimationCurve(Keyframe(0.0, 0.0), Keyframe(2, 1));
		}
		if (remapCurve) {
			if (remapCurve.length != 0) {
				num = remapCurve[remapCurve.length - 1].time;
			}
			for (var num2 : float = 0.0; num2 <= 1.0; num2 += 1.0 / 255.0) {
				var num3 : float = remapCurve.Evaluate(num2 * 1.0 * num);
				curveTex.SetPixel(Mathf.Floor(num2 * 255.0), 0, Color(num3, num3, num3));
			}
			curveTex.Apply();
		}
		return 1.0 / num;
	}

	function OnDisable () {
		if (rt) {
			UnityEngine.Object.DestroyImmediate(rt);
			rt = null;
		}
		if (tonemapMaterial) {
			UnityEngine.Object.DestroyImmediate(tonemapMaterial);
			tonemapMaterial = null;
		}
		if (curveTex) {
			UnityEngine.Object.DestroyImmediate(curveTex);
			curveTex = null;
		}
	}

	function CreateInternalRenderTexture () : boolean {
		if (rt) {
			return false;
		}
		rtFormat = SystemInfo.SupportsRenderTextureFormat (RenderTextureFormat.RGHalf) ? RenderTextureFormat.RGHalf : RenderTextureFormat.ARGBHalf;
		rt = new RenderTexture(1, 1, 0, rtFormat);
		rt.hideFlags = HideFlags.DontSave;
		return true;
	}

	@ImageEffectTransformsToLDR
	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		exposureAdjustment = (!(exposureAdjustment >= 0.001) ? 0.001 : exposureAdjustment);
		if (type == TonemapperType.UserCurve) {
			var value : float = UpdateCurve();
			tonemapMaterial.SetFloat("_RangeScale", value);
			tonemapMaterial.SetTexture("_Curve", curveTex);
			Graphics.Blit(source, destination, tonemapMaterial, 4);
			return;
		}
		if (type == TonemapperType.SimpleReinhard) {
			tonemapMaterial.SetFloat("_ExposureAdjustment", exposureAdjustment);
			Graphics.Blit(source, destination, tonemapMaterial, 6);
			return;
		}
		if (type == TonemapperType.Hable) {
			tonemapMaterial.SetFloat("_ExposureAdjustment", exposureAdjustment);
			Graphics.Blit(source, destination, tonemapMaterial, 5);
			return;
		}
		if (type == TonemapperType.Photographic) {
			tonemapMaterial.SetFloat("_ExposureAdjustment", exposureAdjustment);
			Graphics.Blit(source, destination, tonemapMaterial, 8);
			return;
		}
		if (type == TonemapperType.OptimizedHejiDawson) {
			tonemapMaterial.SetFloat("_ExposureAdjustment", 0.5 * exposureAdjustment);
			Graphics.Blit(source, destination, tonemapMaterial, 7);
			return;
		}
		var flag : boolean = CreateInternalRenderTexture();
		var temporary : RenderTexture = RenderTexture.GetTemporary(adaptiveTextureSize, adaptiveTextureSize, 0, rtFormat);
		Graphics.Blit(source, temporary);
		var num : int = Mathf.Log(temporary.width * 1.0, 2);
		var num2 : int = 2;
		var array : RenderTexture[] = new RenderTexture[num];
		for (var i : int = 0; i < num; i++) {
			array[i] = RenderTexture.GetTemporary(temporary.width / num2, temporary.width / num2, 0, rtFormat);
			num2 *= 2;
		}
		var num3 : float = source.width * 1.0 / (source.height * 1.0);
		var source2 : RenderTexture = array[num - 1];
		Graphics.Blit(temporary, array[0], tonemapMaterial, 1);
		if (type == TonemapperType.AdaptiveReinhardAutoWhite) {
			for (i = 0; i < num - 1; i++) {
				Graphics.Blit(array[i], array[i + 1], tonemapMaterial, 9);
				source2 = array[i + 1];
			}
		} else if (type == TonemapperType.AdaptiveReinhard) {
			for (i = 0; i < num - 1; i++) {
				Graphics.Blit(array[i], array[i + 1]);
				source2 = array[i + 1];
			}
		}
		adaptionSpeed = (!(adaptionSpeed >= 0.001) ? 0.001 : adaptionSpeed);
		tonemapMaterial.SetFloat("_AdaptionSpeed", adaptionSpeed);
		rt.MarkRestoreExpected();
		Graphics.Blit(source2, rt, tonemapMaterial, flag ? 3 : 2);
		middleGrey = (!(middleGrey >= 0.001) ? 0.001 : middleGrey);
		tonemapMaterial.SetVector("_HdrParams", Vector4(middleGrey, middleGrey, middleGrey, white * white));
		tonemapMaterial.SetTexture("_SmallTex", rt);
		if (type == TonemapperType.AdaptiveReinhard) {
			Graphics.Blit(source, destination, tonemapMaterial, 0);
		} else if (type == TonemapperType.AdaptiveReinhardAutoWhite) {
			Graphics.Blit(source, destination, tonemapMaterial, 10);
		} else {
			Debug.LogError("No valid adaptive tonemapper type found!");
			Graphics.Blit(source, destination);
		}
		for (i = 0; i < num; i++) {
			RenderTexture.ReleaseTemporary(array[i]);
		}
		RenderTexture.ReleaseTemporary(temporary);
	}

}

