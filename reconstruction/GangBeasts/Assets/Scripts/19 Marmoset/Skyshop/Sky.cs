using System;
using UnityEngine;

namespace mset
{
		[Serializable]
		public class Sky : MonoBehaviour
		{
			public static Sky activeSky;

			public Cubemap diffuseCube;

			public Cubemap specularCube;

			public Cubemap skyboxCube;

			public float masterIntensity = 1f;

			public float skyIntensity = 1f;

			public float specIntensity = 1f;

			public float diffIntensity = 1f;

			public float camExposure = 1f;

			public float specIntensityLM = 1f;

			public float diffIntensityLM = 1f;

			public bool hdrSky;

			public bool hdrSpec;

			public bool hdrDiff;

			public bool showSkybox = true;

			public bool linearSpace = true;

			public bool autoDetectColorSpace = true;

			public bool hasDimensions;

			public bool autoApply = true;

			public SHEncoding SH;

			private Matrix4x4 skyMatrix = Matrix4x4.identity;

			private Matrix4x4 invMatrix = Matrix4x4.identity;

			private Vector4 exposures = Vector4.one;

			private Vector2 exposuresLM = Vector2.one;

			private float exposureSH = 1f;

			[SerializeField]
			private float skyID;

			private Material _skyboxMaterial;

			private Cubemap _blackCube;

			private static float skyIDCounter = 1f;

			private Material skyboxMaterial
			{
				get
				{
					if (_skyboxMaterial == null)
					{
						Shader shader = Shader.Find("Hidden/Marmoset/Skybox IBL");
						if ((bool)shader)
						{
							_skyboxMaterial = new Material(shader);
							_skyboxMaterial.name = "Internal IBL Skybox";
						}
						else
						{
							Debug.LogError("Failed to create IBL Skybox material. Missing shader?");
						}
					}
					return _skyboxMaterial;
				}
			}

			private Cubemap blackCube
			{
				get
				{
					if (_blackCube == null)
					{
						_blackCube = new Cubemap(16, TextureFormat.ARGB32, true);
						for (int i = 0; i < 6; i++)
						{
							for (int j = 0; j < 16; j++)
							{
								for (int k = 0; k < 16; k++)
								{
									_blackCube.SetPixel((CubemapFace)i, j, k, Color.black);
								}
							}
						}
						_blackCube.Apply(true);
					}
					return _blackCube;
				}
			}

			private static Material getTargetMaterial(Renderer target)
			{
				return target.material;
			}

			public void Apply()
			{
				Apply(null);
			}

			public void Apply(Renderer target)
			{
				if (!(!enabled || !gameObject.activeInHierarchy))
				{
					if (target == null)
					{
						if (activeSky != null)
						{
							activeSky.UnApply();
						}

						activeSky = this;
						ToggleChildLights(true);
						Shader.SetGlobalFloat("_SkyID", skyID);
						ApplySkybox();
						Shader.DisableKeyword("MARMO_GAMMA");
						Shader.DisableKeyword("MARMO_LINEAR");
						if (linearSpace)
						{
							Shader.EnableKeyword("MARMO_LINEAR");
						}
						else
						{
							Shader.EnableKeyword("MARMO_GAMMA");
						}

						Shader.DisableKeyword("MARMO_BOX_PROJECTION_OFF");
						Shader.DisableKeyword("MARMO_BOX_PROJECTION");
						if (hasDimensions)
						{
							Shader.EnableKeyword("MARMO_BOX_PROJECTION");
						}
						else
						{
							Shader.EnableKeyword("MARMO_BOX_PROJECTION_OFF");
						}
					}
					else
					{
						Material targetMaterial = getTargetMaterial(target);
						targetMaterial.SetFloat("_SkyID", skyID);
						targetMaterial.DisableKeyword("MARMO_BOX_PROJECTION_OFF");
						targetMaterial.DisableKeyword("MARMO_BOX_PROJECTION");
						if (hasDimensions)
						{
							targetMaterial.EnableKeyword("MARMO_BOX_PROJECTION");
						}
						else
						{
							targetMaterial.EnableKeyword("MARMO_BOX_PROJECTION_OFF");
						}
					}

					ApplySkyTransform(target);
					ApplyExposures(target);
					ApplyIBL(target);
				}
			}

			public void ApplySkyTransform()
			{
				ApplySkyTransform(null);
			}

			public void ApplySkyTransform(Renderer target)
			{
				if (enabled && gameObject.activeInHierarchy)
				{
					UpdateSkyTransform();
					if (target == null)
					{
						Shader.SetGlobalMatrix("SkyMatrix", skyMatrix);
						Shader.SetGlobalMatrix("InvSkyMatrix", invMatrix);
						Shader.SetGlobalVector("_SkySize", 0.5f * transform.localScale);
					}
					else
					{
						Material targetMaterial = getTargetMaterial(target);
						targetMaterial.SetMatrix("SkyMatrix", skyMatrix);
						targetMaterial.SetMatrix("InvSkyMatrix", invMatrix);
						targetMaterial.SetVector("_SkySize", 0.5f * transform.localScale);
					}
				}
			}

			public static void SetUniformOcclusion(Renderer target, float diffuse, float specular)
			{
				Vector4 one = Vector4.one;
				one.x = diffuse;
				one.y = specular;
				getTargetMaterial(target).SetVector("UniformOcclusion", one);
			}

			public void SetCustomExposure(Renderer target, float diffInt, float specInt, float skyInt, float camExpo)
			{
				Vector4 result = Vector4.one;
				ComputeExposureVector(ref result, diffInt, specInt, skyInt, camExpo);
				Material targetMaterial = getTargetMaterial(target);
				targetMaterial.SetVector("ExposureIBL", result);
			}

			public void ToggleChildLights(bool enable)
			{
				Light[] componentsInChildren = GetComponentsInChildren<Light>();
				for (int i = 0; i < componentsInChildren.Length; i++)
				{
					componentsInChildren[i].enabled = enable;
				}
			}

			private void UnApply()
			{
				UnApply(null);
			}

			private void UnApply(Renderer target)
			{
				ToggleChildLights(false);
				if (target)
				{
					Material targetMaterial = getTargetMaterial(target);
					float num = targetMaterial.GetFloat("_SkyID");
					if (num > 0f && num == skyID)
					{
						if ((bool)activeSky)
						{
							activeSky.ApplySkyTransform(target);
							activeSky.ApplyExposures(target);
							activeSky.ApplyIBL(target);
						}

						targetMaterial.SetTexture("_DiffCubeIBL", null);
						targetMaterial.SetTexture("_SpecCubeIBL", null);
					}
				}
			}

			private void UpdateSkyTransform()
			{
				skyMatrix.SetTRS(transform.position, transform.rotation, Vector3.one);
				invMatrix = skyMatrix.inverse;
			}

			private void ComputeExposureVector(ref Vector4 result, float diffInt, float specInt, float skyInt, float camExpo)
			{
				result.x = masterIntensity * diffInt;
				result.y = masterIntensity * specInt;
				result.z = masterIntensity * skyInt * camExpo;
				result.w = camExpo;
				float num = 2.2f;
				float p = 1f / num;
				float num2 = 6f;
				if (linearSpace)
				{
					num2 = Mathf.Pow(6f, num);
				}
				else
				{
					result.x = Mathf.Pow(result.x, p);
					result.y = Mathf.Pow(result.y, p);
					result.z = Mathf.Pow(result.z, p);
					result.w = Mathf.Pow(result.w, p);
				}
				if (hdrDiff)
				{
					result.x *= num2;
				}
				if (hdrSpec)
				{
					result.y *= num2;
				}
				if (hdrSky)
				{
					result.z *= num2;
				}
			}

			private void UpdateExposures()
			{
				float num = 6f;
				float p = 2.2f;
				if (linearSpace)
				{
					num = Mathf.Pow(6f, p);
				}
				exposureSH = 1f / num;
				ComputeExposureVector(ref exposures, diffIntensity, specIntensity, skyIntensity, camExposure);
				exposuresLM.x = diffIntensityLM;
				exposuresLM.y = specIntensityLM;
			}

			private void ApplyExposures(Renderer target)
			{
				UpdateExposures();
				if (target == null)
				{
					Shader.SetGlobalVector("ExposureIBL", exposures);
					Shader.SetGlobalVector("ExposureLM", exposuresLM);
					Shader.SetGlobalFloat("_EmissionLM", 1f);
					Shader.SetGlobalVector("UniformOcclusion", Vector4.one);
					Shader.SetGlobalFloat("_SHScale", exposureSH);
				}
				else
				{
					Material targetMaterial = getTargetMaterial(target);
					targetMaterial.SetVector("ExposureIBL", exposures);
					targetMaterial.SetVector("ExposureLM", exposuresLM);
					targetMaterial.SetFloat("_SHScale", exposureSH);
				}
			}

			private void ApplyIBL(Renderer target)
			{
				if (target == null)
				{
					if ((bool)diffuseCube)
					{
						Shader.SetGlobalTexture("_DiffCubeIBL", diffuseCube);
					}
					else
					{
						Shader.SetGlobalTexture("_DiffCubeIBL", blackCube);
					}

					if ((bool)specularCube)
					{
						Shader.SetGlobalTexture("_SpecCubeIBL", specularCube);
					}
					else
					{
						Shader.SetGlobalTexture("_SpecCubeIBL", blackCube);
					}

					if ((bool)skyboxCube)
					{
						Shader.SetGlobalTexture("_SkyCubeIBL", skyboxCube);
					}
					else
					{
						Shader.SetGlobalTexture("_SkyCubeIBL", blackCube);
					}

					if (SH != null)
					{
						for (uint num = 0u; num < 9; num++)
						{
							Shader.SetGlobalVector("_SH" + num, SH.cBuffer[num]);
						}
					}
				}
				else
				{
					Material targetMaterial = getTargetMaterial(target);
					if ((bool)diffuseCube)
					{
						targetMaterial.SetTexture("_DiffCubeIBL", diffuseCube);
					}
					else
					{
						targetMaterial.SetTexture("_DiffCubeIBL", blackCube);
					}

					if ((bool)specularCube)
					{
						targetMaterial.SetTexture("_SpecCubeIBL", specularCube);
					}
					else
					{
						targetMaterial.SetTexture("_SpecCubeIBL", blackCube);
					}

					if ((bool)skyboxCube)
					{
						targetMaterial.SetTexture("_SkyCubeIBL", skyboxCube);
					}
					else
					{
						targetMaterial.SetTexture("_SkyCubeIBL", blackCube);
					}

					if (SH != null)
					{
						for (int i = 0; i < 9; i++)
						{
							targetMaterial.SetVector("_SH" + i, SH.cBuffer[i]);
						}
					}
				}
			}

			private void ApplySkybox()
			{
				Shader.DisableKeyword("MARMO_RGBM");
				Shader.EnableKeyword("MARMO_RGBA");
				if (showSkybox)
				{
					if (RenderSettings.skybox != skyboxMaterial)
					{
						RenderSettings.skybox = skyboxMaterial;
					}
				}
				else if ((bool)RenderSettings.skybox && RenderSettings.skybox.name == "Internal IBL Skybox")
				{
					RenderSettings.skybox = null;
				}
			}

			private void Reset()
			{
				skyMatrix = (invMatrix = Matrix4x4.identity);
				exposures = Vector4.one;
				exposuresLM = Vector2.one;
				exposureSH = 1f;
				diffuseCube = (specularCube = (skyboxCube = null));
				masterIntensity = (skyIntensity = (specIntensity = (diffIntensity = 1f)));
				hdrSky = (hdrSpec = (hdrDiff = false));
			}

			private void OnEnable()
			{
				if (SH == null)
				{
					SH = new SHEncoding();
				}
				SH.copyToBuffer();
			}

			private void OnLevelWasLoaded(int level)
			{
				UpdateExposures();
				UpdateSkyTransform();
				if (autoApply)
				{
					Apply();
				}
			}

			private void Start()
			{
				skyID = skyIDCounter;
				skyIDCounter++;
				UpdateExposures();
				UpdateSkyTransform();
				if (autoApply)
				{
					Apply();
				}
			}

			private void Update()
			{
				if (transform.hasChanged)
				{
					UpdateSkyTransform();
					if (activeSky == this)
					{
						ApplySkyTransform();
					}
				}
			}

			private void OnDestroy()
			{
				UnityEngine.Object.DestroyImmediate(_skyboxMaterial, false);
				SH = null;
				_skyboxMaterial = null;
				_blackCube = null;
				diffuseCube = null;
				specularCube = null;
				skyboxCube = null;
			}

			private void OnDrawGizmos()
			{
				if (autoApply && activeSky == null)
				{
					Apply();
				}
				Gizmos.DrawIcon(transform.position, "cubelight.tga", true);
				if (hasDimensions)
				{
					Color color = new Color(0.4f, 0.7f, 1f, 0.333f);
					Gizmos.matrix = transform.localToWorldMatrix;
					Gizmos.color = color;
					Gizmos.DrawWireCube(Vector3.zero, Vector3.one);
				}
			}

			private void OnDrawGizmosSelected()
			{
				if (autoApply)
				{
					Apply();
				}
				if (hasDimensions)
				{
					Color color = new Color(0.4f, 0.7f, 1f, 1f);
					Gizmos.matrix = transform.localToWorldMatrix;
					Gizmos.color = color;
					Gizmos.DrawWireCube(Vector3.zero, Vector3.one);
				}
			}

			private void OnTriggerEnter(Collider other)
			{
				if ((bool)other.renderer)
				{
					Apply(other.renderer);
				}
			}

			private void OnTriggerExit(Collider other)
			{
				if ((bool)other.renderer && (bool)activeSky)
				{
					UnApply(other.renderer);
				}
			}
		}
}
