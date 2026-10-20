#pragma strict

enum Dof34QualitySetting {
	OnlyBackground = 1,
	BackgroundAndForeground,
}

enum DofResolution {
	High = 2,
	Medium,
	Low,
}

enum DofBlurriness {
	Low = 1,
	High = 2,
	VeryHigh = 4,
}

enum BokehDestination {
	Background = 1,
	Foreground,
	BackgroundAndForeground,
}

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Camera/Depth of Field (3.4)")

class DepthOfField34 extends PostEffectsBase {
	@System.NonSerialized
	private static var SMOOTH_DOWNSAMPLE_PASS : int = 6;
	@System.NonSerialized
	private static var BOKEH_EXTRA_BLUR : float = 2.0;
	var quality : Dof34QualitySetting = Dof34QualitySetting.OnlyBackground;
	var resolution : DofResolution = DofResolution.Low;
	var simpleTweakMode : boolean = true;
	var focalPoint : float = 1.0;
	var smoothness : float = 0.5;
	var focalZDistance : float;
	var focalZStartCurve : float = 1.0;
	var focalZEndCurve : float = 1.0;
	private var focalStartCurve : float = 2.0;
	private var focalEndCurve : float = 2.0;
	private var focalDistance01 : float = 0.1;
	var objectFocus : Transform;
	var focalSize : float;
	var bluriness : DofBlurriness = DofBlurriness.High;
	var maxBlurSpread : float = 1.75;
	var foregroundBlurExtrude : float = 1.15;
	var dofBlurShader : Shader;
	private var dofBlurMaterial : Material;
	var dofShader : Shader;
	private var dofMaterial : Material;
	var visualize : boolean;
	var bokehDestination : BokehDestination = BokehDestination.Background;
	private var widthOverHeight : float = 1.25;
	private var oneOverBaseSize : float = 2.0 / 1024.0;
	var bokeh : boolean;
	var bokehSupport : boolean = true;
	var bokehShader : Shader;
	var bokehTexture : Texture2D;
	var bokehScale : float = 2.4;
	var bokehIntensity : float = 0.15;
	var bokehThreshholdContrast : float = 0.1;
	var bokehThreshholdLuminance : float = 0.55;
	var bokehDownsample : int = 1;
	private var bokehMaterial : Material;
	private var foregroundTexture : RenderTexture;
	private var mediumRezWorkTexture : RenderTexture;
	private var finalDefocus : RenderTexture;
	private var lowRezWorkTexture : RenderTexture;
	private var bokehSource : RenderTexture;
	private var bokehSource2 : RenderTexture;
	function CreateMaterials () {
		dofBlurMaterial = CheckShaderAndCreateMaterial(dofBlurShader, dofBlurMaterial);
		dofMaterial = CheckShaderAndCreateMaterial(dofShader, dofMaterial);
		bokehSupport = bokehShader.isSupported;
		if (bokeh && bokehSupport && bokehShader) {
			bokehMaterial = CheckShaderAndCreateMaterial(bokehShader, bokehMaterial);
		}
	}

	function CheckResources () : boolean {
		CheckSupport(true);
		dofBlurMaterial = CheckShaderAndCreateMaterial(dofBlurShader, dofBlurMaterial);
		dofMaterial = CheckShaderAndCreateMaterial(dofShader, dofMaterial);
		bokehSupport = bokehShader.isSupported;
		if (bokeh && bokehSupport && bokehShader) {
			bokehMaterial = CheckShaderAndCreateMaterial(bokehShader, bokehMaterial);
		}
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnDisable () {
		Quads.Cleanup();
	}

	function OnEnable () {
		camera.depthTextureMode |= DepthTextureMode.Depth;
	}

	function FocalDistance01 (worldDist : float) : float {
		return camera.WorldToViewportPoint((worldDist - camera.nearClipPlane) * camera.transform.forward + camera.transform.position).z / (camera.farClipPlane - camera.nearClipPlane);
	}

	function GetDividerBasedOnQuality () : int {
		var divider : int = 1;
		if (resolution == DofResolution.Medium)
			divider = 2;
		else if (resolution == DofResolution.Low)
			divider = 2;
		return divider;
	}

	function GetLowResolutionDividerBasedOnQuality (baseDivider : int) : int {
		var num : int = baseDivider;
		if (resolution == DofResolution.High) {
			num *= 2;
		}
		if (resolution == DofResolution.Low) {
			num *= 2;
		}
		return num;
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		if (!(smoothness >= 0.1)) {
			smoothness = 0.1;
		}
		bokeh = bokeh && bokehSupport;
		var num : float = (bokeh ? BOKEH_EXTRA_BLUR : 1.0);
		var flag2 : boolean = quality > Dof34QualitySetting.OnlyBackground;
		var num2 : float = focalSize / (camera.farClipPlane - camera.nearClipPlane);
		if (simpleTweakMode) {
			focalDistance01 = (objectFocus ? (camera.WorldToViewportPoint(objectFocus.position).z / camera.farClipPlane) : FocalDistance01(focalPoint));
			focalStartCurve = focalDistance01 * smoothness;
			focalEndCurve = focalStartCurve;
			flag2 = flag2 && focalPoint > camera.nearClipPlane + float.Epsilon;
		} else {
			if (objectFocus) {
				var vector : Vector3 = camera.WorldToViewportPoint(objectFocus.position);
				vector.z /= camera.farClipPlane;
				focalDistance01 = vector.z;
			} else {
				focalDistance01 = FocalDistance01(focalZDistance);
			}
			focalStartCurve = focalZStartCurve;
			focalEndCurve = focalZEndCurve;
			flag2 = flag2 && focalPoint > camera.nearClipPlane + float.Epsilon;
		}
		widthOverHeight = 1.0 * source.width / (1.0 * source.height);
		oneOverBaseSize = 2.0 / 1024.0;
		dofMaterial.SetFloat("_ForegroundBlurExtrude", foregroundBlurExtrude);
		dofMaterial.SetVector("_CurveParams", Vector4(simpleTweakMode ? (1.0 / focalStartCurve) : focalStartCurve, simpleTweakMode ? (1.0 / focalEndCurve) : focalEndCurve, num2 * 0.5, focalDistance01));
		dofMaterial.SetVector("_InvRenderTargetSize", Vector4(1.0 / (1.0 * source.width), 1.0 / (1.0 * source.height), 0.0, 0.0));
		var dividerBasedOnQuality : int = GetDividerBasedOnQuality();
		var lowResolutionDividerBasedOnQuality : int = GetLowResolutionDividerBasedOnQuality(dividerBasedOnQuality);
		AllocateTextures(flag2, source, dividerBasedOnQuality, lowResolutionDividerBasedOnQuality);
		Graphics.Blit(source, source, dofMaterial, 3);
		Downsample(source, mediumRezWorkTexture);
		Blur(mediumRezWorkTexture, mediumRezWorkTexture, DofBlurriness.Low, 4, maxBlurSpread);
		if (bokeh && (bokehDestination & BokehDestination.Background) != 0) {
			dofMaterial.SetVector("_Threshhold", Vector4(bokehThreshholdContrast, bokehThreshholdLuminance, 0.95, 0.0));
			Graphics.Blit(mediumRezWorkTexture, bokehSource2, dofMaterial, 11);
			Graphics.Blit(mediumRezWorkTexture, lowRezWorkTexture);
			Blur(lowRezWorkTexture, lowRezWorkTexture, bluriness, 0, maxBlurSpread * num);
		} else {
			Downsample(mediumRezWorkTexture, lowRezWorkTexture);
			Blur(lowRezWorkTexture, lowRezWorkTexture, bluriness, 0, maxBlurSpread);
		}
		dofBlurMaterial.SetTexture("_TapLow", lowRezWorkTexture);
		dofBlurMaterial.SetTexture("_TapMedium", mediumRezWorkTexture);
		Graphics.Blit(null, finalDefocus, dofBlurMaterial, 3);
		if (bokeh && (bokehDestination & BokehDestination.Background) != 0) {
			AddBokeh(bokehSource2, bokehSource, finalDefocus);
		}
		dofMaterial.SetTexture("_TapLowBackground", finalDefocus);
		dofMaterial.SetTexture("_TapMedium", mediumRezWorkTexture);
		Graphics.Blit(source, flag2 ? foregroundTexture : destination, dofMaterial, visualize ? 2 : 0);
		if (flag2) {
			Graphics.Blit(foregroundTexture, source, dofMaterial, 5);
			Downsample(source, mediumRezWorkTexture);
			BlurFg(mediumRezWorkTexture, mediumRezWorkTexture, DofBlurriness.Low, 2, maxBlurSpread);
			if (bokeh && (bokehDestination & BokehDestination.Foreground) != 0) {
				dofMaterial.SetVector("_Threshhold", Vector4(bokehThreshholdContrast * 0.5, bokehThreshholdLuminance, 0.0, 0.0));
				Graphics.Blit(mediumRezWorkTexture, bokehSource2, dofMaterial, 11);
				Graphics.Blit(mediumRezWorkTexture, lowRezWorkTexture);
				BlurFg(lowRezWorkTexture, lowRezWorkTexture, bluriness, 1, maxBlurSpread * num);
			} else {
				BlurFg(mediumRezWorkTexture, lowRezWorkTexture, bluriness, 1, maxBlurSpread);
			}
			Graphics.Blit(lowRezWorkTexture, finalDefocus);
			dofMaterial.SetTexture("_TapLowForeground", finalDefocus);
			Graphics.Blit(source, destination, dofMaterial, visualize ? 1 : 4);
			if (bokeh && (bokehDestination & BokehDestination.Foreground) != 0) {
				AddBokeh(bokehSource2, bokehSource, destination);
			}
		}
		ReleaseTextures();
	}

	function Blur (from : RenderTexture, to : RenderTexture, iterations : DofBlurriness, blurPass : int, spread : float) {
		var temporary : RenderTexture = RenderTexture.GetTemporary(to.width, to.height);
		if (iterations > DofBlurriness.Low) {
			BlurHex(from, to, blurPass, spread, temporary);
			if (iterations > DofBlurriness.High) {
				dofBlurMaterial.SetVector("offsets", Vector4(0.0, spread * oneOverBaseSize, 0.0, 0.0));
				Graphics.Blit(to, temporary, dofBlurMaterial, blurPass);
				dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, 0.0, 0.0, 0.0));
				Graphics.Blit(temporary, to, dofBlurMaterial, blurPass);
			}
		} else {
			dofBlurMaterial.SetVector("offsets", Vector4(0.0, spread * oneOverBaseSize, 0.0, 0.0));
			Graphics.Blit(from, temporary, dofBlurMaterial, blurPass);
			dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, 0.0, 0.0, 0.0));
			Graphics.Blit(temporary, to, dofBlurMaterial, blurPass);
		}
		RenderTexture.ReleaseTemporary(temporary);
	}

	function BlurFg (from : RenderTexture, to : RenderTexture, iterations : DofBlurriness, blurPass : int, spread : float) {
		dofBlurMaterial.SetTexture("_TapHigh", from);
		var temporary : RenderTexture = RenderTexture.GetTemporary(to.width, to.height);
		if (iterations > DofBlurriness.Low) {
			BlurHex(from, to, blurPass, spread, temporary);
			if (iterations > DofBlurriness.High) {
				dofBlurMaterial.SetVector("offsets", Vector4(0.0, spread * oneOverBaseSize, 0.0, 0.0));
				Graphics.Blit(to, temporary, dofBlurMaterial, blurPass);
				dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, 0.0, 0.0, 0.0));
				Graphics.Blit(temporary, to, dofBlurMaterial, blurPass);
			}
		} else {
			dofBlurMaterial.SetVector("offsets", Vector4(0.0, spread * oneOverBaseSize, 0.0, 0.0));
			Graphics.Blit(from, temporary, dofBlurMaterial, blurPass);
			dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, 0.0, 0.0, 0.0));
			Graphics.Blit(temporary, to, dofBlurMaterial, blurPass);
		}
		RenderTexture.ReleaseTemporary(temporary);
	}

	function BlurHex (from : RenderTexture, to : RenderTexture, blurPass : int, spread : float, tmp : RenderTexture) {
		dofBlurMaterial.SetVector("offsets", Vector4(0.0, spread * oneOverBaseSize, 0.0, 0.0));
		Graphics.Blit(from, tmp, dofBlurMaterial, blurPass);
		dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, 0.0, 0.0, 0.0));
		Graphics.Blit(tmp, to, dofBlurMaterial, blurPass);
		dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, spread * oneOverBaseSize, 0.0, 0.0));
		Graphics.Blit(to, tmp, dofBlurMaterial, blurPass);
		dofBlurMaterial.SetVector("offsets", Vector4(spread / widthOverHeight * oneOverBaseSize, (-spread) * oneOverBaseSize, 0.0, 0.0));
		Graphics.Blit(tmp, to, dofBlurMaterial, blurPass);
	}

	function Downsample (from : RenderTexture, to : RenderTexture) {
		dofMaterial.SetVector("_InvRenderTargetSize", Vector4(1.0 / (1.0 * to.width), 1.0 / (1.0 * to.height), 0.0, 0.0));
		Graphics.Blit(from, to, dofMaterial, SMOOTH_DOWNSAMPLE_PASS);
	}

	function AddBokeh (bokehInfo : RenderTexture, tempTex : RenderTexture, finalTarget : RenderTexture) {
		if (bokehMaterial) {
			var meshes : Mesh[] = Quads.GetMeshes(tempTex.width, tempTex.height);
			RenderTexture.active = tempTex;
			GL.Clear(false, true, Color(0.0, 0.0, 0.0, 0.0));
			GL.PushMatrix();
			GL.LoadIdentity();
			bokehInfo.filterMode = FilterMode.Point;
			var num : float = bokehInfo.width * 1.0 / (bokehInfo.height * 1.0);
			var num2 : float = 2.0 / (1.0 * bokehInfo.width);
			num2 += bokehScale * maxBlurSpread * BOKEH_EXTRA_BLUR * oneOverBaseSize;
			bokehMaterial.SetTexture("_Source", bokehInfo);
			bokehMaterial.SetTexture("_MainTex", bokehTexture);
			bokehMaterial.SetVector("_ArScale", Vector4(num2, num2 * num, 0.5, 0.5 * num));
			bokehMaterial.SetFloat("_Intensity", bokehIntensity);
			bokehMaterial.SetPass(0);
			for (var m : Mesh in meshes) {
				if (m) {
					Graphics.DrawMeshNow(m, Matrix4x4.identity);
				}
			}
			GL.PopMatrix();
			Graphics.Blit(tempTex, finalTarget, dofMaterial, 8);
			bokehInfo.filterMode = FilterMode.Bilinear;
		}
	}

	function ReleaseTextures () {
		if (foregroundTexture) {
			RenderTexture.ReleaseTemporary(foregroundTexture);
		}
		if (finalDefocus) {
			RenderTexture.ReleaseTemporary(finalDefocus);
		}
		if (mediumRezWorkTexture) {
			RenderTexture.ReleaseTemporary(mediumRezWorkTexture);
		}
		if (lowRezWorkTexture) {
			RenderTexture.ReleaseTemporary(lowRezWorkTexture);
		}
		if (bokehSource) {
			RenderTexture.ReleaseTemporary(bokehSource);
		}
		if (bokehSource2) {
			RenderTexture.ReleaseTemporary(bokehSource2);
		}
	}

	function AllocateTextures (blurForeground : boolean, source : RenderTexture, divider : int, lowTexDivider : int) {
		foregroundTexture = null;
		if (blurForeground) {
			foregroundTexture = RenderTexture.GetTemporary(source.width, source.height, 0);
		}
		mediumRezWorkTexture = RenderTexture.GetTemporary(source.width / divider, source.height / divider, 0);
		finalDefocus = RenderTexture.GetTemporary(source.width / divider, source.height / divider, 0);
		lowRezWorkTexture = RenderTexture.GetTemporary(source.width / lowTexDivider, source.height / lowTexDivider, 0);
		bokehSource = null;
		bokehSource2 = null;
		if (bokeh) {
			bokehSource = RenderTexture.GetTemporary(source.width / (lowTexDivider * bokehDownsample), source.height / (lowTexDivider * bokehDownsample), 0, RenderTextureFormat.ARGBHalf);
			bokehSource2 = RenderTexture.GetTemporary(source.width / (lowTexDivider * bokehDownsample), source.height / (lowTexDivider * bokehDownsample), 0, RenderTextureFormat.ARGBHalf);
			bokehSource.filterMode = FilterMode.Bilinear;
			bokehSource2.filterMode = FilterMode.Bilinear;
			RenderTexture.active = bokehSource2;
			GL.Clear(false, true, Color(0.0, 0.0, 0.0, 0.0));
		}
		source.filterMode = FilterMode.Bilinear;
		finalDefocus.filterMode = FilterMode.Bilinear;
		mediumRezWorkTexture.filterMode = FilterMode.Bilinear;
		lowRezWorkTexture.filterMode = FilterMode.Bilinear;
		if (foregroundTexture) {
			foregroundTexture.filterMode = FilterMode.Bilinear;
		}
	}

}

