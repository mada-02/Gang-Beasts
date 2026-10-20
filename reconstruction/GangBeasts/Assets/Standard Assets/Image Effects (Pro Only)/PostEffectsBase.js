#pragma strict
#pragma implicit
#pragma downcast

@script ExecuteInEditMode
@script RequireComponent (Camera)

protected var supportHDRTextures : boolean = true;
protected var supportDX11 : boolean;
protected var isSupported : boolean = true;
function CheckShaderAndCreateMaterial (s : Shader, m2Create : Material) : Material {
	if (!s) {
		Debug.Log("Missing shader in " + this.ToString ());
		enabled = false;
		return null;
	}

	if (s.isSupported && m2Create && m2Create.shader == s)
		return m2Create;

	if (!s.isSupported) {
		NotSupported ();
		Debug.Log("The shader " + s.ToString() + " on effect "+this.ToString()+" is not supported on this platform!");
		return null;
	}
	else {
		m2Create = new Material (s);
		m2Create.hideFlags = HideFlags.DontSave;
		if (m2Create)
			return m2Create;
		else return null;
	}
}

function CreateMaterial (s : Shader, m2Create : Material) : Material {
	if (!s) {
		Debug.Log ("Missing shader in " + this.ToString ());
		return null;
	}

	if (m2Create && (m2Create.shader == s) && (s.isSupported))
		return m2Create;

	if (!s.isSupported) {
		return null;
	}
	else {
		m2Create = new Material (s);
		m2Create.hideFlags = HideFlags.DontSave;
		if (m2Create)
			return m2Create;
		else return null;
	}
}

function OnEnable () {
	isSupported = true;
}

function CheckSupport () : boolean {
	return CheckSupport(false);
}

function CheckResources () : boolean {
	Debug.LogWarning("CheckResources () for " + ToString() + " should be overwritten.");
	return isSupported;
}

function Start () {
	CheckResources();
}

function CheckSupport (needDepth : boolean) : boolean {
	isSupported = true;
	supportHDRTextures = SystemInfo.SupportsRenderTextureFormat(RenderTextureFormat.ARGBHalf);
	supportDX11 = SystemInfo.graphicsShaderLevel >= 50 && SystemInfo.supportsComputeShaders;

	if (!SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures) {
		NotSupported ();
		return false;
	}

	if(needDepth && !SystemInfo.SupportsRenderTextureFormat (RenderTextureFormat.Depth)) {
		NotSupported ();
		return false;
	}

	if(needDepth)
		camera.depthTextureMode |= DepthTextureMode.Depth;

	return true;
}

function CheckSupport (needDepth : boolean, needHdr : boolean) : boolean {
	if(!CheckSupport(needDepth))
		return false;

	if(needHdr && !supportHDRTextures) {
		NotSupported ();
		return false;
	}

	return true;
}

function Dx11Support () : boolean {
	return supportDX11;
}

function ReportAutoDisable () {
	Debug.LogWarning("The image effect " + ToString() + " has been disabled as it's not supported on the current platform.");
}

function CheckShader (s : Shader) : boolean {
	Debug.Log("The shader " + s.ToString () + " on effect "+ this.ToString () + " is not part of the Unity 3.2+ effects suite anymore. For best performance and quality, please ensure you are using the latest Standard Assets Image Effects (Pro only) package.");
	if (!s.isSupported) {
		NotSupported ();
		return false;
	}
	else {
		return false;
	}
}

function NotSupported () {
	enabled = false;
	isSupported = false;
}

function DrawBorder (dest : RenderTexture, material : Material) {
	var num : float;
	var num2 : float;
	var num3 : float;
	var num4 : float;
	RenderTexture.active = dest;
	var flag : boolean = true;
	GL.PushMatrix();
	GL.LoadOrtho();
	for (var i : int = 0; i < material.passCount; i++) {
		material.SetPass(i);
		var num5 : float;
		var num6 : float;
		if (flag) {
			num5 = 1.0;
			num6 = 0.0;
		} else {
			num5 = 0.0;
			num6 = 1.0;
		}
		num = 0.0;
		num2 = 0.0 + 1.0 / (dest.width * 1.0);
		num3 = 0.0;
		num4 = 1.0;
		GL.Begin(7);
		GL.TexCoord2(0.0, num5);
		GL.Vertex3(num, num3, 0.1);
		GL.TexCoord2(1.0, num5);
		GL.Vertex3(num2, num3, 0.1);
		GL.TexCoord2(1.0, num6);
		GL.Vertex3(num2, num4, 0.1);
		GL.TexCoord2(0.0, num6);
		GL.Vertex3(num, num4, 0.1);
		num = 1.0 - 1.0 / (dest.width * 1.0);
		num2 = 1.0;
		num3 = 0.0;
		num4 = 1.0;
		GL.TexCoord2(0.0, num5);
		GL.Vertex3(num, num3, 0.1);
		GL.TexCoord2(1.0, num5);
		GL.Vertex3(num2, num3, 0.1);
		GL.TexCoord2(1.0, num6);
		GL.Vertex3(num2, num4, 0.1);
		GL.TexCoord2(0.0, num6);
		GL.Vertex3(num, num4, 0.1);
		num = 0.0;
		num2 = 1.0;
		num3 = 0.0;
		num4 = 0.0 + 1.0 / (dest.height * 1.0);
		GL.TexCoord2(0.0, num5);
		GL.Vertex3(num, num3, 0.1);
		GL.TexCoord2(1.0, num5);
		GL.Vertex3(num2, num3, 0.1);
		GL.TexCoord2(1.0, num6);
		GL.Vertex3(num2, num4, 0.1);
		GL.TexCoord2(0.0, num6);
		GL.Vertex3(num, num4, 0.1);
		num = 0.0;
		num2 = 1.0;
		num3 = 1.0 - 1.0 / (dest.height * 1.0);
		num4 = 1.0;
		GL.TexCoord2(0.0, num5);
		GL.Vertex3(num, num3, 0.1);
		GL.TexCoord2(1.0, num5);
		GL.Vertex3(num2, num3, 0.1);
		GL.TexCoord2(1.0, num6);
		GL.Vertex3(num2, num4, 0.1);
		GL.TexCoord2(0.0, num6);
		GL.Vertex3(num, num4, 0.1);
		GL.End();
	}
	GL.PopMatrix();
}

