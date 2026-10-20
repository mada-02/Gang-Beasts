using System.Collections.Generic;
using System;
using UltimateFracturing;
using UnityEngine;

[ExecuteInEditMode]
public class FracturedObject : MonoBehaviour
{
	public enum EFracturePattern
	{
		BSP,
		Voronoi
	}

	[Serializable]
	public class PrefabInfo
	{
		public float MinLifeTime = float.PositiveInfinity;

		public float MaxLifeTime = float.PositiveInfinity;

		public GameObject GameObject;

		public PrefabInfo()
		{
			MinLifeTime = float.PositiveInfinity;
			MaxLifeTime = float.PositiveInfinity;
			GameObject = null;
		}
	}

	public enum ECCAlgorithm
	{
		Fast,
		Normal,
		Legacy
	}

	public bool GUIExpandMain = true;

	public GameObject SourceObject;

	public bool GenerateIslands = true;

	public bool GenerateChunkConnectionInfo = true;

	public bool StartStatic;

	public float ChunkConnectionMinArea;

	public float ChunkConnectionStrength = 0.8f;

	public float ChunkHorizontalRadiusSupportStrength = float.PositiveInfinity;

	public bool SupportChunksAreIndestructible = true;

	public float ChunkIslandConnectionMaxDistance = 0.02f;

	public float TotalMass = 10f;

	public PhysicMaterial ChunkPhysicMaterial;

	public float MinColliderVolumeForBox = 1E-05f;

	public float CapPrecisionFix;

	public bool InvertCapNormals;

	public bool GUIExpandSplits = true;

	public EFracturePattern FracturePattern;

	public bool VoronoiVolumeOptimization = true;

	public bool VoronoiProximityOptimization = true;

	public bool VoronoiMultithreading = true;

	public int VoronoiCellsXCount = 3;

	public int VoronoiCellsYCount = 3;

	public int VoronoiCellsZCount = 3;

	public float VoronoiCellsXSizeVariation = 0.5f;

	public float VoronoiCellsYSizeVariation = 0.5f;

	public float VoronoiCellsZSizeVariation = 0.5f;

	public int GenerateNumChunks = 20;

	public bool SplitsWorldSpace = true;

	public bool SplitRegularly;

	public float SplitXProbability = 0.3333f;

	public float SplitYProbability = 0.3333f;

	public float SplitZProbability = 0.3333f;

	public float SplitSizeVariation;

	public float SplitXVariation = 0.6f;

	public float SplitYVariation = 0.6f;

	public float SplitZVariation = 0.6f;

	public Material SplitMaterial;

	public float SplitMappingTileU = 1f;

	public float SplitMappingTileV = 1f;

	public bool GUIExpandEvents;

	public float EventDetachMinMass = 1f;

	public float EventDetachMinVelocity = 1f;

	public float EventDetachExitForce;

	public float EventDetachUpwardsModifier;

	public AudioClip EventDetachSound;

	public PrefabInfo[] EventDetachPrefabsArray;

	public string EventDetachCollisionCallMethod = string.Empty;

	public GameObject EventDetachCollisionCallGameObject;

	public float EventDetachedMinLifeTime = float.PositiveInfinity;

	public float EventDetachedMaxLifeTime = float.PositiveInfinity;

	public float EventDetachedOffscreenLifeTime = float.PositiveInfinity;

	public float EventDetachedMinMass = 1f;

	public float EventDetachedMinVelocity = 1f;

	public int EventDetachedMaxSounds = 5;

	public AudioClip[] EventDetachedSoundArray;

	public int EventDetachedMaxPrefabs = 5;

	public PrefabInfo[] EventDetachedPrefabsArray;

	public string EventDetachedCollisionCallMethod = string.Empty;

	public GameObject EventDetachedCollisionCallGameObject;

	public AudioClip EventExplosionSound;

	public int EventExplosionPrefabsInstanceCount = 10;

	public PrefabInfo[] EventExplosionPrefabsArray;

	public AudioClip EventImpactSound;

	public PrefabInfo[] EventImpactPrefabsArray;

	public string EventDetachedAnyCallMethod = string.Empty;

	public GameObject EventDetachedAnyCallGameObject;

	public bool GUIExpandSupportPlanes;

	public int RandomSeed;

	public float DecomposePreview;

	public bool AlwaysComputeColliders = true;

	public bool ShowChunkConnectionLines;

	public bool ShowChunkColoredState = true;

	public bool ShowChunkColoredRandomly;

	public bool SaveMeshDataToAsset;

	public string MeshAssetDataFile = string.Empty;

	public bool Verbose;

	public bool IntegrateWithConcaveCollider;

	public ECCAlgorithm ConcaveColliderAlgorithm;

	public int ConcaveColliderMaxHulls = 1;

	public int ConcaveColliderMaxHullVertices = 64;

	public int ConcaveColliderLegacySteps = 1;

	[HideInInspector]
	public List<SupportPlane> ListSupportPlanes = new List<SupportPlane>();

	[HideInInspector]
	public List<FracturedChunk> ListFracturedChunks = new List<FracturedChunk>();

	[HideInInspector]
	public GameObject SingleMeshObject;

	[HideInInspector]
	public bool IsUsingSingleMeshObjectDraw;

	[HideInInspector]
	public float DecomposeRadius = 1f;

	public static Color GizmoColorSupport = new Color(0f, 0f, 0.2f, 0.7f);

	public static Color GizmoColorNonSupport = new Color(0.3f, 0f, 0f, 0.7f);

	private bool m_bCheckDetachNonSupportedChunkds;

	private bool m_bExploded;

	private bool m_bDetached;

	private float[] m_afFreeChunkSoundTimers;

	private float[] m_afFreeChunkPrefabTimers;

	private Material m_GizmosMaterial;

	public Material GizmosMaterial
	{
		get
		{
			if (m_GizmosMaterial == null)
			{
				m_GizmosMaterial = new Material("Shader \"Alpha double sided\" {Properties { _Color (\"Main Color\", Color) = (1.0, 0.0, 0.0, 0.7) }SubShader {    Tags {\"RenderType\"=\"Transparent\" \"Queue\"=\"Transparent\"}    Pass {        Blend SrcAlpha OneMinusSrcAlpha ZWrite Off ColorMask RGB Cull off Color [_Color] Offset -1, -1        Material { Diffuse [_Color] Ambient [_Color] }        Lighting Off        SetTexture [_Dummy] { combine primary double, primary }    }}}");
			}
			return m_GizmosMaterial;
		}
		set
		{
			m_GizmosMaterial = value;
		}
	}

	private void Awake()
	{
	}

	private void Start()
	{
		m_bCheckDetachNonSupportedChunkds = false;
		m_bExploded = false;
		m_bDetached = false;
		if (Application.isPlaying)
		{
			SetSingleMeshVisibility(true);
			if (!StartStatic)
			{
				CheckDetachNonSupportedChunks(true);
			}
			m_afFreeChunkSoundTimers = new float[Mathf.Max(0, EventDetachedMaxSounds)];
			m_afFreeChunkPrefabTimers = new float[Mathf.Max(0, EventDetachedMaxPrefabs)];
		}
	}

	private void Update()
	{
		if (Application.isPlaying)
		{
			if (m_bCheckDetachNonSupportedChunkds)
			{
				CheckDetachNonSupportedChunksInternal(false);
				m_bCheckDetachNonSupportedChunkds = false;
			}

			if (m_afFreeChunkSoundTimers.Length != EventDetachedMaxSounds)
			{
				Array.Resize(ref m_afFreeChunkSoundTimers, EventDetachedMaxSounds);
			}

			if (m_afFreeChunkPrefabTimers.Length != EventDetachedMaxPrefabs)
			{
				Array.Resize(ref m_afFreeChunkPrefabTimers, EventDetachedMaxPrefabs);
			}

			for (int i = 0; i < m_afFreeChunkSoundTimers.Length; i++)
			{
				if (m_afFreeChunkSoundTimers[i] >= 0f)
				{
					m_afFreeChunkSoundTimers[i] -= Time.deltaTime;
				}
			}

			for (int j = 0; j < m_afFreeChunkPrefabTimers.Length; j++)
			{
				if (m_afFreeChunkPrefabTimers[j] >= 0f)
				{
					m_afFreeChunkPrefabTimers[j] -= Time.deltaTime;
				}
			}
		}
	}

	private void OnRenderObject()
	{
	}

	public void OnCreateFracturedObject()
	{
		m_bCheckDetachNonSupportedChunkds = false;
		m_bExploded = false;
		m_bDetached = false;
		IsUsingSingleMeshObjectDraw = true;
		if (Application.isPlaying)
		{
			if (!StartStatic)
			{
				CheckDetachNonSupportedChunks(true);
			}
			m_afFreeChunkSoundTimers = new float[Mathf.Max(0, EventDetachedMaxSounds)];
			m_afFreeChunkPrefabTimers = new float[Mathf.Max(0, EventDetachedMaxPrefabs)];
		}
	}

	public void SetSingleMeshVisibility(bool bEnabled)
	{
		if (SingleMeshObject == null)
		{
			return;
		}

		if (IsUsingSingleMeshObjectDraw == bEnabled)
		{
			return;
		}

		SingleMeshObject.renderer.enabled = bEnabled;
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.renderer.enabled = !bEnabled;
			}
		}

		IsUsingSingleMeshObjectDraw = bEnabled;
	}

	public bool ResetChunks()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if (listFracturedChunk == null)
			{
				return false;
			}
		}
		foreach (FracturedChunk listFracturedChunk2 in ListFracturedChunks)
		{
			listFracturedChunk2.ResetChunk(this);
		}
		if (!StartStatic)
		{
			CheckDetachNonSupportedChunks(true);
		}
		return true;
	}

	public List<FracturedChunk> GetDestructibleChunksInRadius(Vector3 v3Position, float fRadius, bool bAlsoIncludeFreeChunks)
	{
		List<FracturedChunk> list = new List<FracturedChunk>();
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk && (bAlsoIncludeFreeChunks || !listFracturedChunk.IsDetachedChunk) && listFracturedChunk.IsDestructibleChunk() && Vector3.Distance(listFracturedChunk.transform.position, v3Position) < fRadius)
			{
				list.Add(listFracturedChunk);
			}
		}
		return list;
	}

	public void Explode(Vector3 v3ExplosionPosition, float fExplosionForce)
	{
		if (m_bExploded)
		{
			return;
		}
		if ((bool)EventExplosionSound)
		{
			AudioSource.PlayClipAtPoint(EventExplosionSound, v3ExplosionPosition);
		}
		if (EventExplosionPrefabsArray.Length > 0 && EventExplosionPrefabsInstanceCount > 0 && ListFracturedChunks.Count > 0)
		{
			for (int i = 0; i < EventExplosionPrefabsInstanceCount; i++)
			{
				PrefabInfo prefabInfo = EventExplosionPrefabsArray[UnityEngine.Random.Range(0, EventExplosionPrefabsArray.Length)];
				if (prefabInfo != null)
				{
					FracturedChunk fracturedChunk = null;
					while (fracturedChunk == null)
					{
						fracturedChunk = ListFracturedChunks[UnityEngine.Random.Range(0, ListFracturedChunks.Count)];
					}
					GameObject gameObject = UnityEngine.Object.Instantiate(prefabInfo.GameObject, fracturedChunk.transform.position, prefabInfo.GameObject.transform.rotation) as GameObject;
					if (!Mathf.Approximately(prefabInfo.MinLifeTime, 0f) || !Mathf.Approximately(prefabInfo.MaxLifeTime, 0f))
					{
						DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
						dieTimer.SecondsToDie = UnityEngine.Random.Range(prefabInfo.MinLifeTime, prefabInfo.MaxLifeTime);
					}
				}
			}
		}
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.ListAdjacentChunks.Clear();
				if (listFracturedChunk.IsDestructibleChunk() && !listFracturedChunk.IsDetachedChunk)
				{
					listFracturedChunk.DetachFromObject(false);
					listFracturedChunk.rigidbody.AddExplosionForce(fExplosionForce, v3ExplosionPosition, 0f, 0f);
				}
			}
		}
		m_bExploded = true;
	}

	public void Explode(Vector3 v3ExplosionPosition, float fExplosionForce, float fRadius, bool bPlayExplosionSound, bool bInstanceExplosionPrefabs, bool bAlsoExplodeFree, bool bCheckStructureIntegrityAfter)
	{
		List<FracturedChunk> list = new List<FracturedChunk>();
		if ((bool)EventExplosionSound && bPlayExplosionSound)
		{
			AudioSource.PlayClipAtPoint(EventExplosionSound, v3ExplosionPosition);
		}
		foreach (FracturedChunk item in GetDestructibleChunksInRadius(v3ExplosionPosition, fRadius, bAlsoExplodeFree))
		{
			if ((bool)item)
			{
				item.DetachFromObject(false);
				item.rigidbody.AddExplosionForce(fExplosionForce, v3ExplosionPosition, 0f, 0f);
				list.Add(item);
			}
		}
		if (bInstanceExplosionPrefabs && EventExplosionPrefabsArray.Length > 0 && EventExplosionPrefabsInstanceCount > 0 && list.Count > 0)
		{
			for (int i = 0; i < Mathf.Max(EventExplosionPrefabsInstanceCount, list.Count); i++)
			{
				PrefabInfo prefabInfo = EventExplosionPrefabsArray[UnityEngine.Random.Range(0, EventExplosionPrefabsArray.Length)];
				if (prefabInfo != null)
				{
					GameObject gameObject = UnityEngine.Object.Instantiate(prefabInfo.GameObject, list[UnityEngine.Random.Range(0, list.Count)].transform.position, prefabInfo.GameObject.transform.rotation) as GameObject;
					if (!Mathf.Approximately(prefabInfo.MinLifeTime, 0f) || !Mathf.Approximately(prefabInfo.MaxLifeTime, 0f))
					{
						DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
						dieTimer.SecondsToDie = UnityEngine.Random.Range(prefabInfo.MinLifeTime, prefabInfo.MaxLifeTime);
					}
				}
			}
		}
		if (bCheckStructureIntegrityAfter)
		{
			CheckDetachNonSupportedChunks(false);
		}
	}

	public void DeleteChunks()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				UnityEngine.Object.DestroyImmediate(listFracturedChunk.gameObject);
			}
		}
		ListFracturedChunks.Clear();
		if ((bool)SingleMeshObject)
		{
			UnityEngine.Object.DestroyImmediate(SingleMeshObject);
		}
	}

	public void CollapseChunks()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.ListAdjacentChunks.Clear();
				if (listFracturedChunk.IsDestructibleChunk() && !listFracturedChunk.IsDetachedChunk)
				{
					listFracturedChunk.DetachFromObject(false);
				}
			}
		}
	}

	public void ExplodeChunks(float fExplosionForce, Vector3 v3ExplosionPosition, float fUpwardsModifier)
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.ListAdjacentChunks.Clear();
				if (listFracturedChunk.IsDestructibleChunk() && !listFracturedChunk.IsDetachedChunk)
				{
					listFracturedChunk.DetachFromObject(false);
					listFracturedChunk.rigidbody.AddExplosionForce(fExplosionForce, v3ExplosionPosition, 0f, fUpwardsModifier);
				}
			}
		}
	}

	public void ComputeChunksRelativeVolume()
	{
		float num = 0f;
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				MeshFilter component = listFracturedChunk.GetComponent<MeshFilter>();
				if ((bool)component)
				{
					num += component.sharedMesh.bounds.size.x * component.sharedMesh.bounds.size.y * component.sharedMesh.bounds.size.z;
				}
			}
		}
		foreach (FracturedChunk listFracturedChunk2 in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk2)
			{
				MeshFilter component2 = listFracturedChunk2.GetComponent<MeshFilter>();
				if ((bool)component2)
				{
					float num2 = component2.sharedMesh.bounds.size.x * component2.sharedMesh.bounds.size.y * component2.sharedMesh.bounds.size.z;
					listFracturedChunk2.RelativeVolume = num2 / num;
					listFracturedChunk2.Volume = num2;
				}
			}
		}
	}

	public void ComputeChunksMass(float fTotalMass)
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk && (bool)listFracturedChunk.rigidbody)
			{
				float num = fTotalMass * listFracturedChunk.RelativeVolume;
				if (num < 0.001f)
				{
					num = 0.001f;
				}
				listFracturedChunk.rigidbody.mass = num;
			}
		}
	}

	public bool HasDetachedChunks()
	{
		return m_bDetached;
	}

	public void NotifyChunkDetach(FracturedChunk chunk)
	{
		m_bDetached = true;
		SetSingleMeshVisibility(false);
		if (EventDetachedAnyCallMethod.Length > 0 && EventDetachedAnyCallGameObject != null)
		{
			EventDetachedAnyCallGameObject.SendMessage(EventDetachedAnyCallMethod);
		}
	}

	public void NotifyDetachChunkCollision(FracturedChunk.CollisionInfo collisionInfo)
	{
		if (EventDetachCollisionCallGameObject != null && EventDetachCollisionCallMethod.Length > 0)
		{
			EventDetachCollisionCallGameObject.SendMessage(EventDetachCollisionCallMethod, collisionInfo);
		}
		if (!collisionInfo.bCancelCollisionEvent)
		{
			NotifyDetachChunkCollision(collisionInfo.collisionInfo.contacts[0].point, collisionInfo.bIsMain);
		}
	}

	public void NotifyDetachChunkCollision(Vector3 v3Position, bool bIsMain)
	{
		if (EventDetachSound != null && bIsMain)
		{
			AudioSource.PlayClipAtPoint(EventDetachSound, v3Position);
		}
		if (EventDetachPrefabsArray != null && bIsMain && EventDetachPrefabsArray.Length > 0)
		{
			PrefabInfo prefabInfo = EventDetachPrefabsArray[UnityEngine.Random.Range(0, EventDetachPrefabsArray.Length)];
			GameObject gameObject = UnityEngine.Object.Instantiate(prefabInfo.GameObject, v3Position, prefabInfo.GameObject.transform.rotation) as GameObject;
			if (!Mathf.Approximately(prefabInfo.MinLifeTime, 0f) || !Mathf.Approximately(prefabInfo.MaxLifeTime, 0f))
			{
				DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
				dieTimer.SecondsToDie = UnityEngine.Random.Range(prefabInfo.MinLifeTime, prefabInfo.MaxLifeTime);
			}
		}
	}

	public void NotifyFreeChunkCollision(FracturedChunk.CollisionInfo collisionInfo)
	{
		if (EventDetachedCollisionCallGameObject != null && EventDetachedCollisionCallMethod.Length > 0)
		{
			EventDetachedCollisionCallGameObject.SendMessage(EventDetachedCollisionCallMethod, collisionInfo);
		}

		if (!collisionInfo.bCancelCollisionEvent)
		{
			if (EventDetachedSoundArray.Length > 0)
			{
				int num = -1;
				for (int i = 0; i < m_afFreeChunkSoundTimers.Length; i++)
				{
					if (m_afFreeChunkSoundTimers[i] <= 0f)
					{
						num = i;
						break;
					}
				}

				if (num != -1)
				{
					AudioClip audioClip = EventDetachedSoundArray[UnityEngine.Random.Range(0, EventDetachedSoundArray.Length)];
					if (audioClip != null)
					{
						AudioSource.PlayClipAtPoint(audioClip, collisionInfo.collisionInfo.contacts[0].point);
					}

					m_afFreeChunkSoundTimers[num] = audioClip.length;
				}
			}

			if (EventDetachedPrefabsArray.Length > 0)
			{
				PrefabInfo prefabInfo = EventDetachedPrefabsArray[UnityEngine.Random.Range(0, EventDetachedPrefabsArray.Length)];
				if (!(prefabInfo == null))
				{
					int num2 = -1;
					for (int j = 0; j < m_afFreeChunkPrefabTimers.Length; j++)
					{
						if (m_afFreeChunkPrefabTimers[j] <= 0f)
						{
							num2 = j;
							break;
						}
					}

					if (num2 != -1)
					{
						GameObject gameObject = UnityEngine.Object.Instantiate(prefabInfo.GameObject, collisionInfo.collisionInfo.contacts[0].point, prefabInfo.GameObject.transform.rotation) as GameObject;
						if (!Mathf.Approximately(prefabInfo.MinLifeTime, 0f) || !Mathf.Approximately(prefabInfo.MaxLifeTime, 0f))
						{
							DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
							dieTimer.SecondsToDie = UnityEngine.Random.Range(prefabInfo.MinLifeTime, prefabInfo.MaxLifeTime);
							m_afFreeChunkPrefabTimers[num2] = dieTimer.SecondsToDie;
						}
						else
						{
							m_afFreeChunkPrefabTimers[num2] = float.MaxValue;
						}
					}
				}
			}
		}
	}

	public void NotifyImpact(Vector3 v3Position)
	{
		if (EventImpactSound != null)
		{
			AudioSource.PlayClipAtPoint(EventImpactSound, v3Position);
		}
		if (EventImpactPrefabsArray != null && EventImpactPrefabsArray.Length > 0)
		{
			PrefabInfo prefabInfo = EventImpactPrefabsArray[UnityEngine.Random.Range(0, EventImpactPrefabsArray.Length)];
			GameObject gameObject = UnityEngine.Object.Instantiate(prefabInfo.GameObject, v3Position, prefabInfo.GameObject.transform.rotation) as GameObject;
			if (!Mathf.Approximately(prefabInfo.MinLifeTime, 0f) || !Mathf.Approximately(prefabInfo.MaxLifeTime, 0f))
			{
				DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
				dieTimer.SecondsToDie = UnityEngine.Random.Range(prefabInfo.MinLifeTime, prefabInfo.MaxLifeTime);
			}
		}
	}

	public void ResetAllChunkVisitedFlags()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.Visited = false;
			}
		}
	}

	public void CheckDetachNonSupportedChunks(bool bForceImmediate = false)
	{
		if (bForceImmediate)
		{
			CheckDetachNonSupportedChunksInternal(false);
		}
		else
		{
			m_bCheckDetachNonSupportedChunkds = true;
		}
	}

	public void MarkNonSupportedChunks()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk)
			{
				listFracturedChunk.IsNonSupportedChunk = false;
			}
		}
		CheckDetachNonSupportedChunksInternal(true);
	}

	private void CheckDetachNonSupportedChunksInternal(bool bOnlyMarkThem = false)
	{
		if (!GenerateChunkConnectionInfo)
		{
			return;
		}
		List<FracturedChunk> list = new List<FracturedChunk>();
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if ((bool)listFracturedChunk && !listFracturedChunk.IsDetachedChunk && !listFracturedChunk.IsSupportChunk)
			{
				list.Add(listFracturedChunk);
			}
		}
		ResetAllChunkVisitedFlags();
		while (list.Count > 0)
		{
			while (list.Count > 0 && list[0].IsDetachedChunk)
			{
				list[0].IsNonSupportedChunk = true;
				list.RemoveAt(0);
			}
			if (list.Count == 0)
			{
				break;
			}
			List<FracturedChunk> list2 = new List<FracturedChunk>();
			List<FracturedChunk> list3 = new List<FracturedChunk>();
			bool flag = AreSupportedChunksRecursive(list[0], list2, list3);
			foreach (FracturedChunk item in list2)
			{
				list.Remove(item);
			}
			if (!flag)
			{
				foreach (FracturedChunk item2 in list2)
				{
					if (!bOnlyMarkThem)
					{
						item2.DetachFromObject(false);
					}
					else
					{
						item2.IsNonSupportedChunk = true;
					}
				}
			}
			else
			{
				if (!((double)ChunkHorizontalRadiusSupportStrength < 10000000000000000.0))
				{
					continue;
				}
				foreach (FracturedChunk item3 in list2)
				{
					if (item3.IsSupportChunk)
					{
						continue;
					}
					float num = float.MaxValue;
					foreach (FracturedChunk item4 in list3)
					{
						if (item3 != item4)
						{
							Vector3 vector = item3.transform.position - item4.transform.position;
							vector = new Vector3(vector.x, 0f, vector.z);
							if (vector.magnitude < num)
							{
								num = vector.magnitude;
							}
						}
					}
					if (num > ChunkHorizontalRadiusSupportStrength)
					{
						if (!bOnlyMarkThem)
						{
							item3.DetachFromObject(false);
						}
						else
						{
							item3.IsNonSupportedChunk = true;
						}
					}
				}
			}
		}
	}

	private static bool AreSupportedChunksRecursive(FracturedChunk chunk, List<FracturedChunk> listChunksVisited, List<FracturedChunk> listChunksSupport)
	{
		if (chunk.Visited)
		{
			return false;
		}
		chunk.Visited = true;
		listChunksVisited.Add(chunk);
		if (chunk.IsSupportChunk)
		{
			listChunksSupport.Add(chunk);
		}
		bool flag = false;
		foreach (FracturedChunk.AdjacencyInfo listAdjacentChunk in chunk.ListAdjacentChunks)
		{
			if ((bool)listAdjacentChunk.chunk && (bool)listAdjacentChunk.chunk.FracturedObjectSource && listAdjacentChunk.fArea >= listAdjacentChunk.chunk.FracturedObjectSource.ChunkConnectionMinArea && AreSupportedChunksRecursive(listAdjacentChunk.chunk, listChunksVisited, listChunksSupport))
			{
				flag = true;
			}
		}
		return chunk.IsSupportChunk || flag;
	}

	public void AddSupportPlane()
	{
		if (ListSupportPlanes == null)
		{
			ListSupportPlanes = new List<SupportPlane>();
		}
		ListSupportPlanes.Add(new SupportPlane(this));
	}

	public void ComputeSupportPlaneIntersections()
	{
		foreach (FracturedChunk listFracturedChunk in ListFracturedChunks)
		{
			if (listFracturedChunk)
			{
				listFracturedChunk.IsSupportChunk = false;
				foreach (SupportPlane listSupportPlane in ListSupportPlanes)
				{
					if (listSupportPlane.IntersectsWith(listFracturedChunk.gameObject, true))
					{
						listFracturedChunk.IsSupportChunk = true;
					}
				}
			}
		}
	}
}
