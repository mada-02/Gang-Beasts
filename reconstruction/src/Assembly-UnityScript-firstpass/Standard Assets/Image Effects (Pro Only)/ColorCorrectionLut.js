#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script AddComponentMenu ("Image Effects/Color Adjustments/Color Correction (3D Lookup Texture)")

class ColorCorrectionLut extends PostEffectsBase {
	var shader : Shader;
	private var material : Material;
	var converted3DLut : Texture3D;
	var basedOnTempTex : String = String.Empty;
	function CheckResources () : boolean {
		CheckSupport(false);
		material = CheckShaderAndCreateMaterial(shader, material);
		if (!isSupported || !SystemInfo.supports3DTextures) {
			ReportAutoDisable();
		}
		return isSupported;
	}

	function OnDisable () {
		if (material) {
			UnityEngine.Object.DestroyImmediate(material);
			material = null;
		}
	}

	function OnDestroy () {
		if (converted3DLut) {
			UnityEngine.Object.DestroyImmediate(converted3DLut);
		}
		converted3DLut = null;
	}

	function SetIdentityLut () {
		var num : int = 16;
		var array : Color[] = new Color[num * num * num];
		var num2 : float = 1.0 / (1.0 * num - 1.0);
		for (var i : int = 0; i < num; i++) {
			for (var j : int = 0; j < num; j++) {
				for (var k : int = 0; k < num; k++) {
					array[i + j * num + k * num * num] = Color(i * 1.0 * num2, j * 1.0 * num2, k * 1.0 * num2, 1.0);
				}
			}
		}
		if (converted3DLut) {
			UnityEngine.Object.DestroyImmediate(converted3DLut);
		}
		converted3DLut = Texture3D(num, num, num, TextureFormat.ARGB32, false);
		converted3DLut.SetPixels(array);
		converted3DLut.Apply();
		basedOnTempTex = String.Empty;
	}

	function ValidDimensions (tex2d : Texture2D) : boolean {
		if (!tex2d) return false;
		var h : int = tex2d.height;
		if (h != Mathf.FloorToInt(Mathf.Sqrt(tex2d.width))) {
			return false;
		}
		return true;
	}

	function Convert (temp2DTex : Texture2D, path : String) {
		if (temp2DTex) {
			var num : int = temp2DTex.width * temp2DTex.height;
			num = temp2DTex.height;
			if (!ValidDimensions(temp2DTex)) {
				Debug.LogWarning("The given 2D texture " + temp2DTex.name + " cannot be used as a 3D LUT.");
				basedOnTempTex = String.Empty;
				return;
			}
			var pixels : Color[] = temp2DTex.GetPixels();
			var array : Color[] = new Color[pixels.Length];
			for (var i : int = 0; i < num; i++) {
				for (var j : int = 0; j < num; j++) {
					for (var k : int = 0; k < num; k++) {
						var num2 : int = num - j - 1;
						array[i + j * num + k * num * num] = pixels[k * num + i + num2 * num * num];
					}
				}
			}
			if (converted3DLut) {
				UnityEngine.Object.DestroyImmediate(converted3DLut);
			}
			converted3DLut = Texture3D(num, num, num, TextureFormat.ARGB32, false);
			converted3DLut.SetPixels(array);
			converted3DLut.Apply();
			basedOnTempTex = path;
		} else {
			Debug.LogError("Couldn't color correct with 3D LUT texture. Image Effect will be disabled.");
		}
	}

	function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
		if (!CheckResources() || !SystemInfo.supports3DTextures) {
			Graphics.Blit(source, destination);
			return;
		}
		if (converted3DLut == null) {
			SetIdentityLut();
		}
		var width : int = converted3DLut.width;
		converted3DLut.wrapMode = TextureWrapMode.Clamp;
		material.SetFloat("_Scale", (width - 1) / (1.0 * width));
		material.SetFloat("_Offset", 1.0 / (2.0 * width));
		material.SetTexture("_ClutTex", converted3DLut);
		Graphics.Blit(source, destination, material, (QualitySettings.activeColorSpace == ColorSpace.Linear) ? 1 : 0);
	}

}

