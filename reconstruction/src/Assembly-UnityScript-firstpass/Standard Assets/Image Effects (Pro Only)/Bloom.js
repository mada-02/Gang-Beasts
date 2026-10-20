#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Bloom and Glow/Bloom")

class Bloom extends PostEffectsBase {
	enum LensFlareStyle {
		Ghosting,
		Anamorphic,
		Combined,
	}

	enum TweakMode {
		Basic,
		Complex,
	}

	enum HDRBloomMode {
		Auto,
		On,
		Off,
	}

	enum BloomScreenBlendMode {
		Screen,
		Add,
	}

	enum BloomQuality {
		Cheap,
		High,
	}

	var tweakMode : TweakMode;
	var screenBlendMode : BloomScreenBlendMode = BloomScreenBlendMode.Add;
	var hdr : HDRBloomMode = HDRBloomMode.Auto;
	private var doHdr : boolean;
	var sepBlurSpread : float = 2.5;
	var quality : BloomQuality = BloomQuality.High;
	var bloomIntensity : float = 0.5;
	var bloomThreshhold : float = 0.5;
	var bloomThreshholdColor : Color = Color.white;
	var bloomBlurIterations : int = 2;
	var hollywoodFlareBlurIterations : int = 2;
	var flareRotation : float;
	var lensflareMode : LensFlareStyle = LensFlareStyle.Anamorphic;
	var hollyStretchWidth : float = 2.5;
	var lensflareIntensity : float;
	var lensflareThreshhold : float = 0.3;
	var lensFlareSaturation : float = 0.75;
	var flareColorA : Color = Color(0.4, 0.4, 0.8, 0.75);
	var flareColorB : Color = Color(0.4, 0.8, 0.8, 0.75);
	var flareColorC : Color = Color(0.8, 0.4, 0.8, 0.75);
	var flareColorD : Color = Color(0.8, 0.4, 0.0, 0.75);
	var blurWidth : float = 1.0;
	var lensFlareVignetteMask : Texture2D;
	var lensFlareShader : Shader;
	private var lensFlareMaterial : Material;
	var screenBlendShader : Shader;
	private var screenBlend : Material;
	var blurAndFlaresShader : Shader;
	private var blurAndFlaresMaterial : Material;
	var brightPassFilterShader : Shader;
	private var brightPassFilterMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		screenBlend = CheckShaderAndCreateMaterial(screenBlendShader, screenBlend);
		lensFlareMaterial = CheckShaderAndCreateMaterial(lensFlareShader, lensFlareMaterial);
		blurAndFlaresMaterial = CheckShaderAndCreateMaterial(blurAndFlaresShader, blurAndFlaresMaterial);
		brightPassFilterMaterial = CheckShaderAndCreateMaterial(brightPassFilterShader, brightPassFilterMaterial);
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
		doHdr = false;
		if (hdr == HDRBloomMode.Auto) {
			doHdr = source.format == RenderTextureFormat.ARGBHalf && camera.hdr;
		} else {
			doHdr = hdr == HDRBloomMode.On;
		}
		doHdr = doHdr && supportHDRTextures;
		var bloomScreenBlendMode : BloomScreenBlendMode = screenBlendMode;
		if (doHdr) {
			bloomScreenBlendMode = BloomScreenBlendMode.Add;
		}
		var format : RenderTextureFormat = (doHdr ? RenderTextureFormat.ARGBHalf : RenderTextureFormat.Default);
		var width : int = source.width / 2;
		var height : int = source.height / 2;
		var width2 : int = source.width / 4;
		var height2 : int = source.height / 4;
		var num : float = 1.0 * source.width / (1.0 * source.height);
		var num2 : float = 2.0 / 1024.0;
		var temporary : RenderTexture = RenderTexture.GetTemporary(width2, height2, 0, format);
		var temporary2 : RenderTexture = RenderTexture.GetTemporary(width, height, 0, format);
		if (quality > BloomQuality.Cheap) {
			Graphics.Blit(source, temporary2, screenBlend, 2);
			var temporary3 : RenderTexture = RenderTexture.GetTemporary(width2, height2, 0, format);
			Graphics.Blit(temporary2, temporary3, screenBlend, 2);
			Graphics.Blit(temporary3, temporary, screenBlend, 6);
			RenderTexture.ReleaseTemporary(temporary3);
		} else {
			Graphics.Blit(source, temporary2);
			Graphics.Blit(temporary2, temporary, screenBlend, 6);
		}
		RenderTexture.ReleaseTemporary(temporary2);
		var renderTexture : RenderTexture = RenderTexture.GetTemporary(width2, height2, 0, format);
		BrightFilter(bloomThreshhold * bloomThreshholdColor, temporary, renderTexture);
		if (bloomBlurIterations < 1) {
			bloomBlurIterations = 1;
		} else if (bloomBlurIterations > 10) {
			bloomBlurIterations = 10;
		}
		for (var i : int = 0; i < bloomBlurIterations; i++) {
			var num3 : float = (1.0 + i * 0.25) * sepBlurSpread;
			var temporary4 : RenderTexture = RenderTexture.GetTemporary(width2, height2, 0, format);
			blurAndFlaresMaterial.SetVector("_Offsets", Vector4(0.0, num3 * num2, 0.0, 0.0));
			Graphics.Blit(renderTexture, temporary4, blurAndFlaresMaterial, 4);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary4;
			temporary4 = RenderTexture.GetTemporary(width2, height2, 0, format);
			blurAndFlaresMaterial.SetVector("_Offsets", Vector4(num3 / num * num2, 0.0, 0.0, 0.0));
			Graphics.Blit(renderTexture, temporary4, blurAndFlaresMaterial, 4);
			RenderTexture.ReleaseTemporary(renderTexture);
			renderTexture = temporary4;
			if (quality > BloomQuality.Cheap) {
				if (i == 0) {
					Graphics.SetRenderTarget(temporary);
					GL.Clear(false, true, Color.black);
					Graphics.Blit(renderTexture, temporary);
				} else {
					temporary.MarkRestoreExpected();
					Graphics.Blit(renderTexture, temporary, screenBlend, 10);
				}
			}
		}
		if (quality > BloomQuality.Cheap) {
			Graphics.SetRenderTarget(renderTexture);
			GL.Clear(false, true, Color.black);
			Graphics.Blit(temporary, renderTexture, screenBlend, 6);
		}
		if (!(lensflareIntensity <= float.Epsilon)) {
			var temporary5 : RenderTexture = RenderTexture.GetTemporary(width2, height2, 0, format);
			if (lensflareMode == 0) {
				BrightFilter(lensflareThreshhold, renderTexture, temporary5);
				if (quality > BloomQuality.Cheap) {
					blurAndFlaresMaterial.SetVector("_Offsets", Vector4(0.0, 1.5 / (1.0 * temporary.height), 0.0, 0.0));
					Graphics.SetRenderTarget(temporary);
					GL.Clear(false, true, Color.black);
					Graphics.Blit(temporary5, temporary, blurAndFlaresMaterial, 4);
					blurAndFlaresMaterial.SetVector("_Offsets", Vector4(1.5 / (1.0 * temporary.width), 0.0, 0.0, 0.0));
					Graphics.SetRenderTarget(temporary5);
					GL.Clear(false, true, Color.black);
					Graphics.Blit(temporary, temporary5, blurAndFlaresMaterial, 4);
				}
				Vignette(0.975, temporary5, temporary5);
				BlendFlares(temporary5, renderTexture);
			} else {
				var num4 : float = 1.0 * Mathf.Cos(flareRotation);
				var num5 : float = 1.0 * Mathf.Sin(flareRotation);
				var num6 : float = hollyStretchWidth * 1.0 / num * num2;
				var num7 : float = hollyStretchWidth * num2;
				blurAndFlaresMaterial.SetVector("_Offsets", Vector4(num4, num5, 0.0, 0.0));
				blurAndFlaresMaterial.SetVector("_Threshhold", Vector4(lensflareThreshhold, 1.0, 0.0, 0.0));
				blurAndFlaresMaterial.SetVector("_TintColor", Vector4(flareColorA.r, flareColorA.g, flareColorA.b, flareColorA.a) * flareColorA.a * lensflareIntensity);
				blurAndFlaresMaterial.SetFloat("_Saturation", lensFlareSaturation);
				temporary.DiscardContents();
				Graphics.Blit(temporary5, temporary, blurAndFlaresMaterial, 2);
				temporary5.DiscardContents();
				Graphics.Blit(temporary, temporary5, blurAndFlaresMaterial, 3);
				blurAndFlaresMaterial.SetVector("_Offsets", Vector4(num4 * num6, num5 * num6, 0.0, 0.0));
				blurAndFlaresMaterial.SetFloat("_StretchWidth", hollyStretchWidth);
				temporary.DiscardContents();
				Graphics.Blit(temporary5, temporary, blurAndFlaresMaterial, 1);
				blurAndFlaresMaterial.SetFloat("_StretchWidth", hollyStretchWidth * 2.0);
				temporary5.DiscardContents();
				Graphics.Blit(temporary, temporary5, blurAndFlaresMaterial, 1);
				blurAndFlaresMaterial.SetFloat("_StretchWidth", hollyStretchWidth * 4.0);
				temporary.DiscardContents();
				Graphics.Blit(temporary5, temporary, blurAndFlaresMaterial, 1);
				for (i = 0; i < hollywoodFlareBlurIterations; i++) {
					num6 = hollyStretchWidth * 2.0 / num * num2;
					blurAndFlaresMaterial.SetVector("_Offsets", Vector4(num6 * num4, num6 * num5, 0.0, 0.0));
					temporary5.DiscardContents();
					Graphics.Blit(temporary, temporary5, blurAndFlaresMaterial, 4);
					blurAndFlaresMaterial.SetVector("_Offsets", Vector4(num6 * num4, num6 * num5, 0.0, 0.0));
					temporary.DiscardContents();
					Graphics.Blit(temporary5, temporary, blurAndFlaresMaterial, 4);
				}
				if (lensflareMode == LensFlareStyle.Anamorphic) {
					AddTo(1.0, temporary, renderTexture);
				} else {
					Vignette(1.0, temporary, temporary5);
					BlendFlares(temporary5, temporary);
					AddTo(1.0, temporary, renderTexture);
				}
			}
			RenderTexture.ReleaseTemporary(temporary5);
		}
		var pass : int = bloomScreenBlendMode;
		screenBlend.SetFloat("_Intensity", bloomIntensity);
		screenBlend.SetTexture("_ColorBuffer", source);
		if (quality > BloomQuality.Cheap) {
			var temporary6 : RenderTexture = RenderTexture.GetTemporary(width, height, 0, format);
			Graphics.Blit(renderTexture, temporary6);
			Graphics.Blit(temporary6, destination, screenBlend, pass);
			RenderTexture.ReleaseTemporary(temporary6);
		} else {
			Graphics.Blit(renderTexture, destination, screenBlend, pass);
		}
		RenderTexture.ReleaseTemporary(temporary);
		RenderTexture.ReleaseTemporary(renderTexture);
	}

	private final function AddTo (intensity_ : float, from : RenderTexture, to : RenderTexture) {
		screenBlend.SetFloat("_Intensity", intensity_);
		to.MarkRestoreExpected();
		Graphics.Blit(from, to, screenBlend, 9);
	}

	private final function BlendFlares (from : RenderTexture, to : RenderTexture) {
		lensFlareMaterial.SetVector("colorA", Vector4(flareColorA.r, flareColorA.g, flareColorA.b, flareColorA.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorB", Vector4(flareColorB.r, flareColorB.g, flareColorB.b, flareColorB.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorC", Vector4(flareColorC.r, flareColorC.g, flareColorC.b, flareColorC.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorD", Vector4(flareColorD.r, flareColorD.g, flareColorD.b, flareColorD.a) * lensflareIntensity);
		to.MarkRestoreExpected();
		Graphics.Blit(from, to, lensFlareMaterial);
	}

	private final function BrightFilter (thresh : float, from : RenderTexture, to : RenderTexture) {
		brightPassFilterMaterial.SetVector("_Threshhold", Vector4(thresh, thresh, thresh, thresh));
		Graphics.Blit(from, to, brightPassFilterMaterial, 0);
	}

	private final function BrightFilter (threshColor : Color, from : RenderTexture, to : RenderTexture) {
		brightPassFilterMaterial.SetVector("_Threshhold", threshColor);
		Graphics.Blit(from, to, brightPassFilterMaterial, 1);
	}

	private final function Vignette (amount : float, from : RenderTexture, to : RenderTexture) {
		if (lensFlareVignetteMask) {
			screenBlend.SetTexture("_ColorBuffer", lensFlareVignetteMask);
			to.MarkRestoreExpected();
			Graphics.Blit((from == to) ? null : from, to, screenBlend, (from == to) ? 7 : 3);
		} else if (from != to) {
			Graphics.SetRenderTarget(to);
			GL.Clear(false, true, Color.black);
			Graphics.Blit(from, to);
		}
	}

}

