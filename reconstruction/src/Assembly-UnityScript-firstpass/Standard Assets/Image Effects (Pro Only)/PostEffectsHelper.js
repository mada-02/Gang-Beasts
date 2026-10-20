#pragma strict

@script ExecuteInEditMode
@script RequireComponent (Camera)

function Start () {
}

function OnRenderImage (source : RenderTexture, destination : RenderTexture) {
	Debug.Log("OnRenderImage in Helper called ...");
}

static function DrawLowLevelPlaneAlignedWithCamera (dist : float, source : RenderTexture, dest : RenderTexture, material : Material, cameraForProjectionMatrix : Camera) {
	RenderTexture.active = dest;
	material.SetTexture("_MainTex", source);
	var flag : boolean = true;
	GL.PushMatrix();
	GL.LoadIdentity();
	GL.LoadProjectionMatrix(cameraForProjectionMatrix.projectionMatrix);
	var f : float = cameraForProjectionMatrix.fieldOfView * 0.5 * (Mathf.PI / 180.0);
	var num : float = Mathf.Cos(f) / Mathf.Sin(f);
	var aspect : float = cameraForProjectionMatrix.aspect;
	var num2 : float = aspect / (-num);
	var num3 : float = aspect / num;
	var num4 : float = 1.0 / (-num);
	var num5 : float = 1.0 / num;
	var num6 : float = 1.0;
	num2 *= dist * num6;
	num3 *= dist * num6;
	num4 *= dist * num6;
	num5 *= dist * num6;
	var z : float = -dist;
	for (var i : int = 0; i < material.passCount; i++) {
		material.SetPass(i);
		GL.Begin(7);
		var num7 : float;
		var num8 : float;
		if (flag) {
			num7 = 1.0;
			num8 = 0.0;
		} else {
			num7 = 0.0;
			num8 = 1.0;
		}
		GL.TexCoord2(0.0, num7);
		GL.Vertex3(num2, num4, z);
		GL.TexCoord2(1.0, num7);
		GL.Vertex3(num3, num4, z);
		GL.TexCoord2(1.0, num8);
		GL.Vertex3(num3, num5, z);
		GL.TexCoord2(0.0, num8);
		GL.Vertex3(num2, num5, z);
		GL.End();
	}
	GL.PopMatrix();
}

static function DrawBorder (dest : RenderTexture, material : Material) {
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

static function DrawLowLevelQuad (x1 : float, x2 : float, y1 : float, y2 : float, source : RenderTexture, dest : RenderTexture, material : Material) {
	RenderTexture.active = dest;
	material.SetTexture("_MainTex", source);
	var flag : boolean = true;
	GL.PushMatrix();
	GL.LoadOrtho();
	for (var i : int = 0; i < material.passCount; i++) {
		material.SetPass(i);
		GL.Begin(7);
		var num : float;
		var num2 : float;
		if (flag) {
			num = 1.0;
			num2 = 0.0;
		} else {
			num = 0.0;
			num2 = 1.0;
		}
		GL.TexCoord2(0.0, num);
		GL.Vertex3(x1, y1, 0.1);
		GL.TexCoord2(1.0, num);
		GL.Vertex3(x2, y1, 0.1);
		GL.TexCoord2(1.0, num2);
		GL.Vertex3(x2, y2, 0.1);
		GL.TexCoord2(0.0, num2);
		GL.Vertex3(x1, y2, 0.1);
		GL.End();
	}
	GL.PopMatrix();
}

