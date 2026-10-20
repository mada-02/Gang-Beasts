#pragma strict
#pragma implicit
#pragma downcast

enum LensflareStyle34 {
	Ghosting,
	Anamorphic,
	Combined,
}

enum TweakMode34 {
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

@script ExecuteInEditMode
@script RequireComponent (Camera)
@script AddComponentMenu ("Image Effects/Bloom and Glow/BloomAndFlares (3.5, Deprecated)")

class BloomAndLensFlares extends PostEffectsBase {
	var tweakMode : TweakMode34;
	var screenBlendMode : BloomScreenBlendMode = BloomScreenBlendMode.Add;
	var hdr : HDRBloomMode = HDRBloomMode.Auto;
	private var doHdr : boolean;
	var sepBlurSpread : float = 1.5;
	var useSrcAlphaAsMask : float = 0.5;
	var bloomIntensity : float = 1.0;
	var bloomThreshhold : float = 0.5;
	var bloomBlurIterations : int = 2;
	var lensflares : boolean;
	var hollywoodFlareBlurIterations : int = 2;
	var lensflareMode : LensflareStyle34 = LensflareStyle34.Anamorphic;
	var hollyStretchWidth : float = 3.5;
	var lensflareIntensity : float = 1.0;
	var lensflareThreshhold : float = 0.3;
	var flareColorA : Color = Color(0.4, 0.4, 0.8, 0.75);
	var flareColorB : Color = Color(0.4, 0.8, 0.8, 0.75);
	var flareColorC : Color = Color(0.8, 0.4, 0.8, 0.75);
	var flareColorD : Color = Color(0.8, 0.4, 0.0, 0.75);
	var blurWidth : float = 1.0;
	var lensFlareVignetteMask : Texture2D;
	var lensFlareShader : Shader;
	private var lensFlareMaterial : Material;
	var vignetteShader : Shader;
	private var vignetteMaterial : Material;
	var separableBlurShader : Shader;
	private var separableBlurMaterial : Material;
	var addBrightStuffOneOneShader : Shader;
	private var addBrightStuffBlendOneOneMaterial : Material;
	var screenBlendShader : Shader;
	private var screenBlend : Material;
	var hollywoodFlaresShader : Shader;
	private var hollywoodFlaresMaterial : Material;
	var brightPassFilterShader : Shader;
	private var brightPassFilterMaterial : Material;
	function CheckResources () : boolean {
		CheckSupport(false);
		screenBlend = CheckShaderAndCreateMaterial(screenBlendShader, screenBlend);
		lensFlareMaterial = CheckShaderAndCreateMaterial(lensFlareShader, lensFlareMaterial);
		vignetteMaterial = CheckShaderAndCreateMaterial(vignetteShader, vignetteMaterial);
		separableBlurMaterial = CheckShaderAndCreateMaterial(separableBlurShader, separableBlurMaterial);
		addBrightStuffBlendOneOneMaterial = CheckShaderAndCreateMaterial(addBrightStuffOneOneShader, addBrightStuffBlendOneOneMaterial);
		hollywoodFlaresMaterial = CheckShaderAndCreateMaterial(hollywoodFlaresShader, hollywoodFlaresMaterial);
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
		var pass : BloomScreenBlendMode = screenBlendMode;
		if (doHdr) {
			pass = BloomScreenBlendMode.Add;
		}
		var format : RenderTextureFormat = (doHdr ? RenderTextureFormat.ARGBHalf : RenderTextureFormat.Default);
		var temporary : RenderTexture = RenderTexture.GetTemporary(source.width / 2, source.height / 2, 0, format);
		var temporary2 : RenderTexture = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0, format);
		var temporary3 : RenderTexture = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0, format);
		var temporary4 : RenderTexture = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0, format);
		var num : float = 1.0 * source.width / (1.0 * source.height);
		var num2 : float = 2.0 / 1024.0;
		Graphics.Blit(source, temporary, screenBlend, 2);
		Graphics.Blit(temporary, temporary2, screenBlend, 2);
		RenderTexture.ReleaseTemporary(temporary);
		BrightFilter(bloomThreshhold, useSrcAlphaAsMask, temporary2, temporary3);
		temporary2.DiscardContents();
		if (bloomBlurIterations < 1) {
			bloomBlurIterations = 1;
		}
		for (var i : int = 0; i < bloomBlurIterations; i++) {
			var num3 : float = (1.0 + i * 0.5) * sepBlurSpread;
			separableBlurMaterial.SetVector("offsets", Vector4(0.0, num3 * num2, 0.0, 0.0));
			var renderTexture : RenderTexture = (i == 0 ? temporary3 : temporary2);
			Graphics.Blit(renderTexture, temporary4, separableBlurMaterial);
			renderTexture.DiscardContents();
			separableBlurMaterial.SetVector("offsets", Vector4(num3 / num * num2, 0.0, 0.0, 0.0));
			Graphics.Blit(temporary4, temporary2, separableBlurMaterial);
			temporary4.DiscardContents();
		}
		if (lensflares) {
			if (lensflareMode == 0) {
				BrightFilter(lensflareThreshhold, 0.0, temporary2, temporary4);
				temporary2.DiscardContents();
				Vignette(0.975, temporary4, temporary3);
				temporary4.DiscardContents();
				BlendFlares(temporary3, temporary2);
				temporary3.DiscardContents();
			} else {
				hollywoodFlaresMaterial.SetVector("_Threshhold", Vector4(lensflareThreshhold, 1.0 / (1.0 - lensflareThreshhold), 0.0, 0.0));
				hollywoodFlaresMaterial.SetVector("tintColor", Vector4(flareColorA.r, flareColorA.g, flareColorA.b, flareColorA.a) * flareColorA.a * lensflareIntensity);
				Graphics.Blit(temporary4, temporary3, hollywoodFlaresMaterial, 2);
				temporary4.DiscardContents();
				Graphics.Blit(temporary3, temporary4, hollywoodFlaresMaterial, 3);
				temporary3.DiscardContents();
				hollywoodFlaresMaterial.SetVector("offsets", Vector4(sepBlurSpread * 1.0 / num * num2, 0.0, 0.0, 0.0));
				hollywoodFlaresMaterial.SetFloat("stretchWidth", hollyStretchWidth);
				Graphics.Blit(temporary4, temporary3, hollywoodFlaresMaterial, 1);
				temporary4.DiscardContents();
				hollywoodFlaresMaterial.SetFloat("stretchWidth", hollyStretchWidth * 2.0);
				Graphics.Blit(temporary3, temporary4, hollywoodFlaresMaterial, 1);
				temporary3.DiscardContents();
				hollywoodFlaresMaterial.SetFloat("stretchWidth", hollyStretchWidth * 4.0);
				Graphics.Blit(temporary4, temporary3, hollywoodFlaresMaterial, 1);
				temporary4.DiscardContents();
				if (lensflareMode == LensflareStyle34.Anamorphic) {
					for (var j : int = 0; j < hollywoodFlareBlurIterations; j++) {
						separableBlurMaterial.SetVector("offsets", Vector4(hollyStretchWidth * 2.0 / num * num2, 0.0, 0.0, 0.0));
						Graphics.Blit(temporary3, temporary4, separableBlurMaterial);
						temporary3.DiscardContents();
						separableBlurMaterial.SetVector("offsets", Vector4(hollyStretchWidth * 2.0 / num * num2, 0.0, 0.0, 0.0));
						Graphics.Blit(temporary4, temporary3, separableBlurMaterial);
						temporary4.DiscardContents();
					}
					AddTo(1.0, temporary3, temporary2);
					temporary3.DiscardContents();
				} else {
					for (var k : int = 0; k < hollywoodFlareBlurIterations; k++) {
						separableBlurMaterial.SetVector("offsets", Vector4(hollyStretchWidth * 2.0 / num * num2, 0.0, 0.0, 0.0));
						Graphics.Blit(temporary3, temporary4, separableBlurMaterial);
						temporary3.DiscardContents();
						separableBlurMaterial.SetVector("offsets", Vector4(hollyStretchWidth * 2.0 / num * num2, 0.0, 0.0, 0.0));
						Graphics.Blit(temporary4, temporary3, separableBlurMaterial);
						temporary4.DiscardContents();
					}
					Vignette(1.0, temporary3, temporary4);
					temporary3.DiscardContents();
					BlendFlares(temporary4, temporary3);
					temporary4.DiscardContents();
					AddTo(1.0, temporary3, temporary2);
					temporary3.DiscardContents();
				}
			}
		}
		screenBlend.SetFloat("_Intensity", bloomIntensity);
		screenBlend.SetTexture("_ColorBuffer", source);
		Graphics.Blit(temporary2, destination, screenBlend, pass);
		RenderTexture.ReleaseTemporary(temporary2);
		RenderTexture.ReleaseTemporary(temporary3);
		RenderTexture.ReleaseTemporary(temporary4);
	}

	private final function AddTo (intensity_ : float, from : RenderTexture, to : RenderTexture) {
		addBrightStuffBlendOneOneMaterial.SetFloat("_Intensity", intensity_);
		Graphics.Blit(from, to, addBrightStuffBlendOneOneMaterial);
	}

	private final function BlendFlares (from : RenderTexture, to : RenderTexture) {
		lensFlareMaterial.SetVector("colorA", Vector4(flareColorA.r, flareColorA.g, flareColorA.b, flareColorA.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorB", Vector4(flareColorB.r, flareColorB.g, flareColorB.b, flareColorB.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorC", Vector4(flareColorC.r, flareColorC.g, flareColorC.b, flareColorC.a) * lensflareIntensity);
		lensFlareMaterial.SetVector("colorD", Vector4(flareColorD.r, flareColorD.g, flareColorD.b, flareColorD.a) * lensflareIntensity);
		Graphics.Blit(from, to, lensFlareMaterial);
	}

	private final function BrightFilter (thresh : float, useAlphaAsMask : float, from : RenderTexture, to : RenderTexture) {
		if (doHdr) {
			brightPassFilterMaterial.SetVector("threshhold", Vector4(thresh, 1.0, 0.0, 0.0));
		} else {
			brightPassFilterMaterial.SetVector("threshhold", Vector4(thresh, 1.0 / (1.0 - thresh), 0.0, 0.0));
		}
		brightPassFilterMaterial.SetFloat("useSrcAlphaAsMask", useAlphaAsMask);
		Graphics.Blit(from, to, brightPassFilterMaterial);
	}

	private final function Vignette (amount : float, from : RenderTexture, to : RenderTexture) {
		if (lensFlareVignetteMask) {
			screenBlend.SetTexture("_ColorBuffer", lensFlareVignetteMask);
			Graphics.Blit(from, to, screenBlend, 3);
		} else {
			vignetteMaterial.SetFloat("vignetteIntensity", amount);
			Graphics.Blit(from, to, vignetteMaterial);
		}
	}

}

