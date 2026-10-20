using System.Collections;
using System.IO;
using System;
using UnityEngine;

public enum IMGFormat
{
	Tga,
	Jpg
}

public class MegaGrab : MonoBehaviour
{
	public Camera SrcCamera;

	public KeyCode GrabKey = KeyCode.S;

	public int ResUpscale = 1;

	public float Blur = 1f;

	public int AASamples = 8;

	public AnisotropicFiltering FilterMode = AnisotropicFiltering.ForceEnable;

	public bool UseJitter;

	public string SaveName = "Grab";

	public string Format = "dddd MMM dd yyyy HH_mm_ss";

	public string Enviro = string.Empty;

	public string Path = string.Empty;

	public bool UseDOF;

	public float focalDistance = 8f;

	public int totalSegments = 8;

	public float sampleRadius = 1f;

	public bool CalcFromSize;

	public int Dpi = 300;

	public float Width = 24f;

	public int NumberOfGrabs;

	public float EstimatedTime;

	public int GrabWidthWillBe;

	public int GrabHeightWillBe;

	public bool UseCoroutine = true;

	private float mleft;

	private float mright;

	private float mtop;

	private float mbottom;

	private int sampcount;

	private Vector2[] poisson;

	private Texture2D grabtex;

	private Color[,] accbuf;

	private Color[,] blendbuf;

	private byte[] output1;

	private Color[] outputjpg;

	private AnisotropicFiltering filtering;

	private MGBlendTable blendtable;

	private int DOFSamples;

	private Vector3 camfor;

	private Vector3 campos;

	private Matrix4x4 camtm;

	public IMGFormat OutputFormat = IMGFormat.Jpg;

	public float Quality = 75f;

	public bool uploadGrabs;

	public string m_URL = string.Empty;

	public bool sequenceGrab;

	public int framerate = 30;

	public float grabTime = 5f;

	public KeyCode CancelKey = KeyCode.C;

	private bool doingSeqGrab;

	private int framenumber;

	private float gtime;

	private void CalcDOFInfo(Camera camera)
	{
		camtm = camera.transform.localToWorldMatrix;
		campos = camera.transform.position;
		camfor = camera.transform.forward;
	}

	private void ChangeDOFPos(int segment)
	{
		float f = (float)segment / (float)totalSegments * (float)Math.PI * 2f;
		float num = sampleRadius;
		float x = num * Mathf.Cos(f);
		float y = num * Mathf.Sin(f);
		Vector3 v = new Vector3(x, y, 0f);
		Vector3 vector = camfor * focalDistance;
		Vector3 worldPosition = vector + campos;
		SrcCamera.transform.position = camtm.MultiplyPoint3x4(v);
		SrcCamera.transform.LookAt(worldPosition);
	}

	private static Matrix4x4 PerspectiveOffCenter(float left, float right, float bottom, float top, float near, float far)
	{
		Matrix4x4 identity = Matrix4x4.identity;
		identity[0, 0] = 2f * near / (right - left);
		identity[1, 1] = 2f * near / (top - bottom);
		identity[0, 2] = (right + left) / (right - left);
		identity[1, 2] = (top + bottom) / (top - bottom);
		identity[2, 2] = (-(far + near)) / (far - near);
		identity[2, 3] = (-(2f * far * near)) / (far - near);
		identity[3, 2] = -1f;
		identity[3, 3] = 0f;
		return identity;
	}

	private Matrix4x4 CalcProjectionMatrix(float left, float right, float bottom, float top, float near, float far, float xoff, float yoff)
	{
		float num = (right - left) / (float)Screen.width;
		float num2 = (top - bottom) / (float)Screen.height;
		return PerspectiveOffCenter(left - xoff * num, right - xoff * num, bottom - yoff * num2, top - yoff * num2, near, far);
	}

	private void Cleanup()
	{
		QualitySettings.anisotropicFiltering = filtering;
		output1 = null;
		outputjpg = null;
		blendtable = null;
		accbuf = null;
		blendbuf = null;
		GC.Collect();
	}

	private bool InitGrab(int width, int height, int aasamples)
	{
		blendtable = new MGBlendTable(32, 32, totalSegments, 0.4f, true);
		if (ResUpscale < 1)
		{
			ResUpscale = 1;
		}
		if (AASamples < 1)
		{
			AASamples = 1;
		}
		if (SrcCamera == null)
		{
			SrcCamera = Camera.main;
		}
		if (SrcCamera == null)
		{
			Debug.Log("No Camera set as source and no main camera found in the scene");
			return false;
		}
		CalcDOFInfo(SrcCamera);
		if (OutputFormat == IMGFormat.Tga)
		{
			output1 = new byte[width * ResUpscale * (height * ResUpscale) * 3];
		}
		else
		{
			outputjpg = new Color[width * ResUpscale * (height * ResUpscale)];
		}
		if (output1 != null || outputjpg != null)
		{
			filtering = QualitySettings.anisotropicFiltering;
			QualitySettings.anisotropicFiltering = FilterMode;
			grabtex = new Texture2D(width, height, TextureFormat.RGB24, false);
			if (grabtex != null)
			{
				accbuf = new Color[width, height];
				blendbuf = new Color[width, height];
				if (accbuf != null)
				{
					float num = (1f - Blur) * 0.5f;
					float to = 1f + (Blur - 1f) * 0.5f;
					if (UseJitter)
					{
						poisson = new Vector2[aasamples];
						sampcount = aasamples;
						for (int i = 0; i < aasamples; i++)
						{
							Vector2 vector = new Vector2
							{
								x = Mathf.Lerp(num, to, UnityEngine.Random.value),
								y = Mathf.Lerp(num, to, UnityEngine.Random.value)
							};
							poisson[i] = vector;
						}
					}
					else
					{
						int num2 = (int)Mathf.Sqrt(aasamples);
						if (num2 < 1)
						{
							num2 = 1;
						}
						sampcount = num2 * num2;
						poisson = new Vector2[num2 * num2];
						int num3 = 0;
						for (int j = 0; j < num2; j++)
						{
							for (int k = 0; k < num2; k++)
							{
								float t = (float)k / (float)num2;
								float t2 = (float)j / (float)num2;
								Vector2 vector2 = new Vector2
								{
									x = Mathf.Lerp(num, to, t),
									y = Mathf.Lerp(num, to, t2)
								};
								poisson[num3++] = vector2;
							}
						}
					}
					return true;
				}
			}
		}
		Debug.Log("Cant create a large enough texture, Try lower ResUpscale value");
		return false;
	}

	private Texture2D GrabImage(int samples, float x, float y)
	{
		float num = 1f / (float)ResUpscale;
		for (int i = 0; i < sampcount; i++)
		{
			float num2 = poisson[i].x * num;
			float num3 = poisson[i].y * num;
			float xoff = x + num2;
			float yoff = y + num3;
			SrcCamera.projectionMatrix = CalcProjectionMatrix(mleft, mright, mbottom, mtop, SrcCamera.nearClipPlane, SrcCamera.farClipPlane, xoff, yoff);
			SrcCamera.Render();
			grabtex.ReadPixels(new Rect(0f, 0f, Screen.width, Screen.height), 0, 0);
			grabtex.Apply();
			if (i == 0)
			{
				for (int j = 0; j < Screen.height; j++)
				{
					for (int k = 0; k < Screen.width; k++)
					{
						accbuf[k, j] = grabtex.GetPixel(k, j);
					}
				}
				continue;
			}
			for (int l = 0; l < Screen.height; l++)
			{
				for (int m = 0; m < Screen.width; m++)
				{
					accbuf[m, l] += grabtex.GetPixel(m, l);
				}
			}
		}
		for (int n = 0; n < Screen.height; n++)
		{
			for (int num4 = 0; num4 < Screen.width; num4++)
			{
				grabtex.SetPixel(num4, n, accbuf[num4, n] / sampcount);
			}
		}
		grabtex.Apply();
		return grabtex;
	}

	private void GrabAA(float x, float y)
	{
		float num = 1f / (float)ResUpscale;
		for (int i = 0; i < Screen.height; i++)
		{
			for (int j = 0; j < Screen.width; j++)
			{
				accbuf[j, i] = Color.black;
			}
		}
		for (int k = 0; k < sampcount; k++)
		{
			float num2 = poisson[k].x * num;
			float num3 = poisson[k].y * num;
			float xoff = x + num2;
			float yoff = y + num3;
			SrcCamera.projectionMatrix = CalcProjectionMatrix(mleft, mright, mbottom, mtop, SrcCamera.nearClipPlane, SrcCamera.farClipPlane, xoff, yoff);
			SrcCamera.Render();
			grabtex.ReadPixels(new Rect(0f, 0f, Screen.width, Screen.height), 0, 0);
			grabtex.Apply();
			for (int l = 0; l < Screen.height; l++)
			{
				for (int m = 0; m < Screen.width; m++)
				{
					accbuf[m, l] += grabtex.GetPixel(m, l);
				}
			}
		}
		for (int n = 0; n < Screen.height; n++)
		{
			for (int num4 = 0; num4 < Screen.width; num4++)
			{
				accbuf[num4, n] /= sampcount;
			}
		}
	}

	private Texture2D GrabImageDOF(int samples, float x, float y)
	{
		for (int i = 0; i < Screen.height; i++)
		{
			for (int j = 0; j < Screen.width; j++)
			{
				blendbuf[j, i] = Color.black;
			}
		}
		for (int k = 0; k < totalSegments; k++)
		{
			ChangeDOFPos(k);
			GrabAA(x, y);
			blendtable.BlendImages(blendbuf, accbuf, Screen.width, Screen.height, k);
		}
		return grabtex;
	}

	private void DoGrabTGA()
	{
		if (InitGrab(Screen.width, Screen.height, AASamples))
		{
			mtop = SrcCamera.nearClipPlane * Mathf.Tan(SrcCamera.fieldOfView * 0.5f * ((float)Math.PI / 180f));
			mbottom = -mtop;
			mleft = mbottom * SrcCamera.aspect;
			mright = mtop * SrcCamera.aspect;
			int width = Screen.width;
			int height = Screen.height;
			if (AASamples < 1)
			{
				AASamples = 1;
			}

			int num = 0;
			for (int i = 0; i < ResUpscale; i++)
			{
				float y = (float)i / (float)ResUpscale;
				for (int j = 0; j < ResUpscale; j++)
				{
					num++;
					float x = (float)j / (float)ResUpscale;
					if (UseDOF)
					{
						GrabImageDOF(AASamples, x, y);
						for (int k = 0; k < Screen.height; k++)
						{
							int num2 = (ResUpscale - i + k * ResUpscale - 1) * (width * ResUpscale);
							for (int l = 0; l < Screen.width; l++)
							{
								Color color = blendbuf[l, k];
								int num3 = (num2 + (ResUpscale - j + l * ResUpscale - 1)) * 3;
								output1[num3] = (byte)(color.b * 255f);
								output1[num3 + 1] = (byte)(color.g * 255f);
								output1[num3 + 2] = (byte)(color.r * 255f);
							}
						}

						continue;
					}

					GrabImage(AASamples, x, y);
					for (int m = 0; m < Screen.height; m++)
					{
						int num4 = (ResUpscale - i + m * ResUpscale - 1) * (width * ResUpscale);
						for (int n = 0; n < Screen.width; n++)
						{
							Color pixel = grabtex.GetPixel(n, m);
							int num5 = (num4 + (ResUpscale - j + n * ResUpscale - 1)) * 3;
							output1[num5] = (byte)(pixel.b * 255f);
							output1[num5 + 1] = (byte)(pixel.g * 255f);
							output1[num5 + 2] = (byte)(pixel.r * 255f);
						}
					}
				}
			}

			UnityEngine.Object.Destroy(grabtex);
			grabtex = null;
			string text = string.Empty;
			if (Enviro != null && Enviro.Length > 0)
			{
				text = Environment.GetEnvironmentVariable(Enviro);
			}

			string empty = string.Empty;
			if (doingSeqGrab)
			{
				empty = text + Path + SaveName + " " + framenumber;
			}
			else
			{
				empty = text + Path + SaveName + " " + width * ResUpscale + "x" + height * ResUpscale + " " + DateTime.Now.ToString(Format);
			}
			SaveTGA(empty + ".tga", width * ResUpscale, height * ResUpscale, output1);
			SrcCamera.ResetProjectionMatrix();
			Cleanup();
		}
	}

	private void DoGrabJPG()
	{
		if (InitGrab(Screen.width, Screen.height, AASamples))
		{
			mtop = SrcCamera.nearClipPlane * Mathf.Tan(SrcCamera.fieldOfView * 0.5f * ((float)Math.PI / 180f));
			mbottom = -mtop;
			mleft = mbottom * SrcCamera.aspect;
			mright = mtop * SrcCamera.aspect;
			int width = Screen.width;
			int height = Screen.height;
			if (AASamples < 1)
			{
				AASamples = 1;
			}

			int num = 0;
			for (int i = 0; i < ResUpscale; i++)
			{
				float y = (float)i / (float)ResUpscale;
				for (int j = 0; j < ResUpscale; j++)
				{
					num++;
					float x = (float)j / (float)ResUpscale;
					if (UseDOF)
					{
						GrabImageDOF(AASamples, x, y);
						for (int k = 0; k < Screen.height; k++)
						{
							int num2 = (ResUpscale - i + k * ResUpscale - 1) * (width * ResUpscale);
							for (int l = 0; l < Screen.width; l++)
							{
								Color color = blendbuf[l, k];
								int num3 = num2 + (ResUpscale - j + l * ResUpscale - 1);
								outputjpg[num3] = color;
							}
						}

						continue;
					}

					GrabImage(AASamples, x, y);
					for (int m = 0; m < Screen.height; m++)
					{
						int num4 = (ResUpscale - i + m * ResUpscale - 1) * (width * ResUpscale);
						for (int n = 0; n < Screen.width; n++)
						{
							Color pixel = grabtex.GetPixel(n, m);
							int num5 = num4 + (ResUpscale - j + n * ResUpscale - 1);
							outputjpg[num5] = pixel;
						}
					}
				}
			}

			UnityEngine.Object.Destroy(grabtex);
			grabtex = null;
			string text = string.Empty;
			if (Enviro != null && Enviro.Length > 0)
			{
				text = Environment.GetEnvironmentVariable(Enviro);
			}

			if (uploadGrabs)
			{
				string text2 = SaveName + " " + width * ResUpscale + "x" + height * ResUpscale + " " + DateTime.Now.ToString(Format);
				UploadJPG(text2 + ".jpg", width * ResUpscale, height * ResUpscale, outputjpg);
			}
			else
			{
				string empty = string.Empty;
				if (doingSeqGrab)
				{
					empty = text + Path + SaveName + " " + framenumber;
				}
				else
				{
					empty = text + Path + SaveName + " " + width * ResUpscale + "x" + height * ResUpscale + " " + DateTime.Now.ToString(Format);
				}
				Debug.Log("Saving jpg to \"" + empty + ".jpg\"");
				SaveJPG(empty + ".jpg", width * ResUpscale, height * ResUpscale, outputjpg);
			}

			SrcCamera.ResetProjectionMatrix();
			Cleanup();
		}
	}

	private void SaveJPG(string filename, int width, int height, Color[] pixels)
	{
		FileStream fileStream = new FileStream(filename, FileMode.Create);
		if (fileStream != null)
		{
			BinaryWriter binaryWriter = new BinaryWriter(fileStream);
			if (binaryWriter != null)
			{
				Quality = Mathf.Clamp(Quality, 0f, 100f);
				JPGEncoder jPGEncoder = new JPGEncoder(pixels, width, height, Quality);
				jPGEncoder.doEncoding();
				byte[] bytes = jPGEncoder.GetBytes();
				binaryWriter.Write(bytes);
				binaryWriter.Close();
			}
			fileStream.Close();
		}
	}

	private void UploadJPG(string filename, int width, int height, Color[] pixels)
	{
		Quality = Mathf.Clamp(Quality, 0f, 100f);
		JPGEncoder jPGEncoder = new JPGEncoder(pixels, width, height, Quality);
		jPGEncoder.doEncoding();
		byte[] bytes = jPGEncoder.GetBytes();
		UploadFile(bytes, m_URL, filename);
	}

	private void SaveTGA(string filename, int width, int height, byte[] pixels)
	{
		FileStream fileStream = new FileStream(filename, FileMode.Create);
		if (fileStream != null)
		{
			BinaryWriter binaryWriter = new BinaryWriter(fileStream);
			if (binaryWriter != null)
			{
				binaryWriter.Write((short)0);
				binaryWriter.Write((byte)2);
				binaryWriter.Write(0);
				binaryWriter.Write(0);
				binaryWriter.Write((byte)0);
				binaryWriter.Write((short)width);
				binaryWriter.Write((short)height);
				binaryWriter.Write((byte)24);
				binaryWriter.Write((byte)0);
				for (int i = 0; i < pixels.Length; i++)
				{
					binaryWriter.Write(pixels[i]);
				}

				binaryWriter.Close();
			}

			fileStream.Close();
		}
	}

	public void CalcUpscale()
	{
		float num = Width / ((float)Screen.width / (float)Dpi);
		ResUpscale = (int)num;
		GrabWidthWillBe = Screen.width * ResUpscale;
		GrabHeightWillBe = Screen.height * ResUpscale;
	}

	public void CalcUpscale(int width, int height)
	{
		float num = Width / ((float)width / (float)Dpi);
		ResUpscale = (int)num;
		GrabWidthWillBe = width * ResUpscale;
		GrabHeightWillBe = height * ResUpscale;
	}

	public void CalcEstimate()
	{
		NumberOfGrabs = ResUpscale * ResUpscale * AASamples;
		if (UseDOF)
		{
			NumberOfGrabs *= totalSegments;
		}
		EstimatedTime = (float)NumberOfGrabs * 0.41f;
	}

	private IEnumerator GrabCoroutine()
	{
		yield return new WaitForEndOfFrame();
		if (OutputFormat == IMGFormat.Tga)
		{
			DoGrabTGA();
		}
		else
		{
			DoGrabJPG();
		}
		if (doingSeqGrab)
		{
			gtime += 1f / (float)framerate;
			if (gtime > grabTime)
			{
				doingSeqGrab = false;
				Debug.Log("Sequence complete");
			}
			framenumber++;
			Debug.Log("seq grab " + framenumber + " " + gtime);
		}
		yield return null;
	}

	private void LateUpdate()
	{
		if (doingSeqGrab && Input.GetKeyDown(CancelKey))
		{
			doingSeqGrab = false;
		}

		if (Input.GetKeyDown(GrabKey) || doingSeqGrab)
		{
			if (sequenceGrab && !doingSeqGrab)
			{
				Time.captureFramerate = framerate;
				doingSeqGrab = true;
				framenumber = 0;
				gtime = 0f;
			}

			if (CalcFromSize)
			{
				CalcUpscale();
			}

			CalcEstimate();
			if (UseCoroutine)
			{
				StartCoroutine(GrabCoroutine());
			}
			else
			{
				if (OutputFormat == IMGFormat.Tga)
				{
					DoGrabTGA();
				}
				else
				{
					DoGrabJPG();
				}

				if (doingSeqGrab)
				{
					gtime += 1f / (float)framerate;
					if (gtime > grabTime)
					{
						doingSeqGrab = false;
						Debug.Log("Sequence complete");
					}

					framenumber++;
					Debug.Log("seq grab " + framenumber + " " + gtime);
				}
			}
		}
	}

	private void OnDrawGizmos()
	{
		if (CalcFromSize)
		{
			CalcUpscale();
		}
		CalcEstimate();
	}

	private IEnumerator UploadFileCo(byte[] data, string uploadURL, string filename)
	{
		WWWForm postForm = new WWWForm();
		Debug.Log("uploading " + filename);
		postForm.AddField("action", "Upload Image");
		postForm.AddBinaryData("theFile", data, filename, "images/jpg");
		Debug.Log("url " + uploadURL);
		WWW upload = new WWW(uploadURL, postForm);
		yield return upload;
		Debug.Log("upload done :" + upload.text);
		Debug.Log("Error during upload: " + upload.error);
	}

	private void UploadFile(byte[] data, string uploadURL, string filename)
	{
		Debug.Log("Start upload");
		StartCoroutine(UploadLevel(data, uploadURL, filename));
		Debug.Log("len " + data.Length);
	}

	private IEnumerator UploadLevel(byte[] data, string uploadURL, string filename)
	{
		WWWForm form = new WWWForm();
		form.AddField("action", "level upload");
		form.AddField("file", "file");
		form.AddBinaryData("file", data, filename, "images/jpg");
		Debug.Log("url " + uploadURL);
		WWW w = new WWW(uploadURL, form);
		yield return w;
		if (w.error != null)
		{
			MonoBehaviour.print("error");
			MonoBehaviour.print(w.error);
		}
		else if (w.uploadProgress == 1f && w.isDone)
		{
			yield return new WaitForSeconds(5f);
		}
	}
}
