#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Camera/Depth of Field (Lens Blur, Scatter, DX11)")

class DepthOfFieldScatter extends PostEffectsBase {
	enum BlurType {
		DiscBlur,
		DX11,
	}

	enum BlurSampleCount {
		Low,
		Medium,
		High,
	}

	var visualizeFocus : boolean;
	var focalLength : float = 10.0;
	var focalSize : float = 0.05;
	var aperture : float = 11.5;
	var focalTransform : Transform;
	var maxBlurSize : float = 2.0;
	var highResolution : boolean;
	var blurType : BlurType = BlurType.DiscBlur;
	var blurSampleCount : BlurSampleCount = BlurSampleCount.High;
	var nearBlur : boolean;
	var foregroundOverlap : float = 1.0;
	var dofHdrShader : Shader;
	private var dofHdrMaterial : Material;
	var dx11BokehShader : Shader;
	private var dx11bokehMaterial : Material;
	var dx11BokehThreshhold : float = 0.5;
	var dx11SpawnHeuristic : float = 0.0875;
	var dx11BokehTexture : Texture2D;
	var dx11BokehScale : float = 1.2;
	var dx11BokehIntensity : float = 2.5;
	private var focalDistance01 : float = 10.0;
	private var cbDrawArgs : ComputeBuffer;
	private var cbPoints : ComputeBuffer;
	private var internalBlurWidth : float = 1.0;
	function CheckResources () : boolean {
		CheckSupport(true);
		dofHdrMaterial = CheckShaderAndCreateMaterial(dofHdrShader, dofHdrMaterial);
		if (supportDX11 && blurType == BlurType.DX11) {
			dx11bokehMaterial = CheckShaderAndCreateMaterial(dx11BokehShader, dx11bokehMaterial);
			CreateComputeResources();
		}
		if (!isSupported) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnEnable () {
		camera.depthTextureMode |= DepthTextureMode.Depth;
	}

	function OnDisable () {
		ReleaseComputeResources();
		if (dofHdrMaterial) {
			UnityEngine.Object.DestroyImmediate(dofHdrMaterial);
		}
		dofHdrMaterial = null;
		if (dx11bokehMaterial) {
			UnityEngine.Object.DestroyImmediate(dx11bokehMaterial);
		}
		dx11bokehMaterial = null;
	}

	function ReleaseComputeResources () {
		if (cbDrawArgs) {
			cbDrawArgs.Release();
		}
		cbDrawArgs = null;
		if (cbPoints) {
			cbPoints.Release();
		}
		cbPoints = null;
	}

	function CreateComputeResources () {
		if (cbDrawArgs == null) {
			cbDrawArgs = ComputeBuffer(1, 16, ComputeBufferType.DrawIndirect);
			var args = new int[4];
			args[0] = 0;
			args[1] = 1;
			args[2] = 0;
			args[3] = 0;
			cbDrawArgs.SetData (args);
		}
		if (cbPoints == null) {
			cbPoints = ComputeBuffer(90000, 28, ComputeBufferType.Append);
		}
	}

	function FocalDistance01 (worldDist : float) : float {
		return camera.WorldToViewportPoint((worldDist - camera.nearClipPlane) * camera.transform.forward + camera.transform.position).z / (camera.farClipPlane - camera.nearClipPlane);
	}

	private final function WriteCoc (fromTo : RenderTexture, fgDilate : boolean) {
		dofHdrMaterial.SetTexture("_FgOverlap", null);
		if (nearBlur && fgDilate) {
			var width : int = fromTo.width / 2;
			var height : int = fromTo.height / 2;
			var temporary : RenderTexture = RenderTexture.GetTemporary(width, height, 0, fromTo.format);
			Graphics.Blit(fromTo, temporary, dofHdrMaterial, 4);
			var num : float = internalBlurWidth * foregroundOverlap;
			dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, num, 0.0, num));
			var temporary2 : RenderTexture = RenderTexture.GetTemporary(width, height, 0, fromTo.format);
			Graphics.Blit(temporary, temporary2, dofHdrMaterial, 2);
			RenderTexture.ReleaseTemporary(temporary);
			dofHdrMaterial.SetVector("_Offsets", Vector4(num, 0.0, 0.0, num));
			temporary = RenderTexture.GetTemporary(width, height, 0, fromTo.format);
			Graphics.Blit(temporary2, temporary, dofHdrMaterial, 2);
			RenderTexture.ReleaseTemporary(temporary2);
			dofHdrMaterial.SetTexture("_FgOverlap", temporary);
			fromTo.MarkRestoreExpected();
			Graphics.Blit(fromTo, fromTo, dofHdrMaterial, 13);
			RenderTexture.ReleaseTemporary(temporary);
		} else {
			Graphics.Blit(fromTo, fromTo, dofHdrMaterial, 0);
		}
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources()) {
			Graphics.Blit(source, destination);
			return;
		}
		if (!(aperture >= 0.0)) {
			aperture = 0.0;
		}
		if (!(maxBlurSize >= 0.1)) {
			maxBlurSize = 0.1;
		}
		focalSize = Mathf.Clamp(focalSize, 0.0, 2.0);
		internalBlurWidth = Mathf.Max(maxBlurSize, 0.0);
		focalDistance01 = (focalTransform ? (camera.WorldToViewportPoint(focalTransform.position).z / camera.farClipPlane) : FocalDistance01(focalLength));
		dofHdrMaterial.SetVector("_CurveParams", Vector4(1.0, focalSize, aperture / 10.0, focalDistance01));
		var renderTexture : RenderTexture = null;
		var renderTexture2 : RenderTexture = null;
		var renderTexture3 : RenderTexture = null;
		var renderTexture4 : RenderTexture = null;
		var num : float = internalBlurWidth * foregroundOverlap;
		if (visualizeFocus) {
			WriteCoc(source, true);
			Graphics.Blit(source, destination, dofHdrMaterial, 16);
		} else if (blurType == BlurType.DX11 && dx11bokehMaterial) {
			if (highResolution) {
				internalBlurWidth = (!(internalBlurWidth >= 0.1) ? 0.1 : internalBlurWidth);
				num = internalBlurWidth * foregroundOverlap;
				renderTexture = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
				var temporary : RenderTexture = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
				WriteCoc(source, false);
				renderTexture3 = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
				renderTexture4 = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
				Graphics.Blit(source, renderTexture3, dofHdrMaterial, 15);
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, 1.5, 0.0, 1.5));
				Graphics.Blit(renderTexture3, renderTexture4, dofHdrMaterial, 19);
				dofHdrMaterial.SetVector("_Offsets", Vector4(1.5, 0.0, 0.0, 1.5));
				Graphics.Blit(renderTexture4, renderTexture3, dofHdrMaterial, 19);
				if (nearBlur) {
					Graphics.Blit(source, renderTexture4, dofHdrMaterial, 4);
				}
				dx11bokehMaterial.SetTexture("_BlurredColor", renderTexture3);
				dx11bokehMaterial.SetFloat("_SpawnHeuristic", dx11SpawnHeuristic);
				dx11bokehMaterial.SetVector("_BokehParams", Vector4(dx11BokehScale, dx11BokehIntensity, Mathf.Clamp(dx11BokehThreshhold, 0.005, 4.0), internalBlurWidth));
				dx11bokehMaterial.SetTexture("_FgCocMask", nearBlur ? renderTexture4 : null);
				Graphics.SetRandomWriteTarget(1, cbPoints);
				Graphics.Blit(source, renderTexture, dx11bokehMaterial, 0);
				Graphics.ClearRandomWriteTargets();
				if (nearBlur) {
					dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, num, 0.0, num));
					Graphics.Blit(renderTexture4, renderTexture3, dofHdrMaterial, 2);
					dofHdrMaterial.SetVector("_Offsets", Vector4(num, 0.0, 0.0, num));
					Graphics.Blit(renderTexture3, renderTexture4, dofHdrMaterial, 2);
					Graphics.Blit(renderTexture4, renderTexture, dofHdrMaterial, 3);
				}
				Graphics.Blit(renderTexture, temporary, dofHdrMaterial, 20);
				dofHdrMaterial.SetVector("_Offsets", Vector4(internalBlurWidth, 0.0, 0.0, internalBlurWidth));
				Graphics.Blit(renderTexture, source, dofHdrMaterial, 5);
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, internalBlurWidth, 0.0, internalBlurWidth));
				Graphics.Blit(source, temporary, dofHdrMaterial, 21);
				Graphics.SetRenderTarget(temporary);
				ComputeBuffer.CopyCount(cbPoints, cbDrawArgs, 0);
				dx11bokehMaterial.SetBuffer("pointBuffer", cbPoints);
				dx11bokehMaterial.SetTexture("_MainTex", dx11BokehTexture);
				dx11bokehMaterial.SetVector("_Screen", Vector3(1.0 / (1.0 * source.width), 1.0 / (1.0 * source.height), internalBlurWidth));
				dx11bokehMaterial.SetPass(2);
				Graphics.DrawProceduralIndirect(MeshTopology.Points, cbDrawArgs, 0);
				Graphics.Blit(temporary, destination);
				RenderTexture.ReleaseTemporary(temporary);
				RenderTexture.ReleaseTemporary(renderTexture3);
				RenderTexture.ReleaseTemporary(renderTexture4);
			} else {
				renderTexture = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
				renderTexture2 = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
				num = internalBlurWidth * foregroundOverlap;
				WriteCoc(source, false);
				source.filterMode = FilterMode.Bilinear;
				Graphics.Blit(source, renderTexture, dofHdrMaterial, 6);
				renderTexture3 = RenderTexture.GetTemporary(renderTexture.width >> 1, renderTexture.height >> 1, 0, renderTexture.format);
				renderTexture4 = RenderTexture.GetTemporary(renderTexture.width >> 1, renderTexture.height >> 1, 0, renderTexture.format);
				Graphics.Blit(renderTexture, renderTexture3, dofHdrMaterial, 15);
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, 1.5, 0.0, 1.5));
				Graphics.Blit(renderTexture3, renderTexture4, dofHdrMaterial, 19);
				dofHdrMaterial.SetVector("_Offsets", Vector4(1.5, 0.0, 0.0, 1.5));
				Graphics.Blit(renderTexture4, renderTexture3, dofHdrMaterial, 19);
				var renderTexture5 : RenderTexture = null;
				if (nearBlur) {
					renderTexture5 = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
					Graphics.Blit(source, renderTexture5, dofHdrMaterial, 4);
				}
				dx11bokehMaterial.SetTexture("_BlurredColor", renderTexture3);
				dx11bokehMaterial.SetFloat("_SpawnHeuristic", dx11SpawnHeuristic);
				dx11bokehMaterial.SetVector("_BokehParams", Vector4(dx11BokehScale, dx11BokehIntensity, Mathf.Clamp(dx11BokehThreshhold, 0.005, 4.0), internalBlurWidth));
				dx11bokehMaterial.SetTexture("_FgCocMask", renderTexture5);
				Graphics.SetRandomWriteTarget(1, cbPoints);
				Graphics.Blit(renderTexture, renderTexture2, dx11bokehMaterial, 0);
				Graphics.ClearRandomWriteTargets();
				RenderTexture.ReleaseTemporary(renderTexture3);
				RenderTexture.ReleaseTemporary(renderTexture4);
				if (nearBlur) {
					dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, num, 0.0, num));
					Graphics.Blit(renderTexture5, renderTexture, dofHdrMaterial, 2);
					dofHdrMaterial.SetVector("_Offsets", Vector4(num, 0.0, 0.0, num));
					Graphics.Blit(renderTexture, renderTexture5, dofHdrMaterial, 2);
					Graphics.Blit(renderTexture5, renderTexture2, dofHdrMaterial, 3);
				}
				dofHdrMaterial.SetVector("_Offsets", Vector4(internalBlurWidth, 0.0, 0.0, internalBlurWidth));
				Graphics.Blit(renderTexture2, renderTexture, dofHdrMaterial, 5);
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, internalBlurWidth, 0.0, internalBlurWidth));
				Graphics.Blit(renderTexture, renderTexture2, dofHdrMaterial, 5);
				Graphics.SetRenderTarget(renderTexture2);
				ComputeBuffer.CopyCount(cbPoints, cbDrawArgs, 0);
				dx11bokehMaterial.SetBuffer("pointBuffer", cbPoints);
				dx11bokehMaterial.SetTexture("_MainTex", dx11BokehTexture);
				dx11bokehMaterial.SetVector("_Screen", Vector3(1.0 / (1.0 * renderTexture2.width), 1.0 / (1.0 * renderTexture2.height), internalBlurWidth));
				dx11bokehMaterial.SetPass(1);
				Graphics.DrawProceduralIndirect(MeshTopology.Points, cbDrawArgs, 0);
				dofHdrMaterial.SetTexture("_LowRez", renderTexture2);
				dofHdrMaterial.SetTexture("_FgOverlap", renderTexture5);
				dofHdrMaterial.SetVector("_Offsets", 1.0 * source.width / (1.0 * renderTexture2.width) * internalBlurWidth * Vector4.one);
				Graphics.Blit(source, destination, dofHdrMaterial, 9);
				if (renderTexture5) {
					RenderTexture.ReleaseTemporary(renderTexture5);
				}
			}
		} else {
			source.filterMode = FilterMode.Bilinear;
			if (highResolution) {
				internalBlurWidth *= 2.0;
			}
			WriteCoc(source, true);
			renderTexture = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
			renderTexture2 = RenderTexture.GetTemporary(source.width >> 1, source.height >> 1, 0, source.format);
			var pass : int = (!(blurSampleCount != BlurSampleCount.High && blurSampleCount != BlurSampleCount.Medium) ? 17 : 11);
			if (highResolution) {
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, internalBlurWidth, 0.025, internalBlurWidth));
				Graphics.Blit(source, destination, dofHdrMaterial, pass);
			} else {
				dofHdrMaterial.SetVector("_Offsets", Vector4(0.0, internalBlurWidth, 0.1, internalBlurWidth));
				Graphics.Blit(source, renderTexture, dofHdrMaterial, 6);
				Graphics.Blit(renderTexture, renderTexture2, dofHdrMaterial, pass);
				dofHdrMaterial.SetTexture("_LowRez", renderTexture2);
				dofHdrMaterial.SetTexture("_FgOverlap", null);
				dofHdrMaterial.SetVector("_Offsets", Vector4.one * (1.0 * source.width / (1.0 * renderTexture2.width)) * internalBlurWidth);
				Graphics.Blit(source, destination, dofHdrMaterial, blurSampleCount == BlurSampleCount.High ? 18 : 12);
			}
		}
		if (renderTexture) {
			RenderTexture.ReleaseTemporary(renderTexture);
		}
		if (renderTexture2) {
			RenderTexture.ReleaseTemporary(renderTexture2);
		}
	}

}

