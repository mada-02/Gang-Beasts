using System.Collections.Generic;
using System;
using UltimateFracturing;
using UnityEngine;

[Serializable]
[ExecuteInEditMode]
public class FracturedChunk : MonoBehaviour
{
	[Serializable]
	public class AdjacencyInfo
	{
		public FracturedChunk chunk;

		public float fArea;

		public AdjacencyInfo(FracturedChunk chunk, float fArea)
		{
			this.chunk = chunk;
			this.fArea = fArea;
		}
	}

	public class CollisionInfo
	{
		public FracturedChunk chunk;

		public Collision collisionInfo;

		public bool bIsMain;

		public bool bCancelCollisionEvent;

		public CollisionInfo(FracturedChunk chunk, Collision collisionInfo, bool bIsMain)
		{
			this.chunk = chunk;
			this.collisionInfo = collisionInfo;
			this.bIsMain = bIsMain;
			bCancelCollisionEvent = false;
		}
	}

	public FracturedObject FracturedObjectSource;

	public int SplitSubMeshIndex = -1;

	public bool DontDeleteAfterBroken;

	public bool IsSupportChunk;

	public bool IsNonSupportedChunk;

	public bool IsDetachedChunk;

	public float RelativeVolume = 0.01f;

	public float Volume;

	public bool HasConcaveCollider;

	public float PreviewDecompositionValue;

	public Color RandomMaterialColor = Color.white;

	public bool Visited;

	public List<AdjacencyInfo> ListAdjacentChunks = new List<AdjacencyInfo>();

	[SerializeField]
	private Vector3 m_v3InitialLocalPosition;

	[SerializeField]
	private Quaternion m_qInitialLocalRotation;

	[SerializeField]
	private Vector3 m_v3InitialLocalScale;

	[SerializeField]
	private bool m_bInitialLocalRotScaleInitialized;

	private List<AdjacencyInfo> ListAdjacentChunksCopy;

	private float m_fInvisibleTimer;

	private bool m_bNonSupportedChunkStored;

	private void Awake()
	{
		if (Application.isPlaying)
		{
			IsDetachedChunk = false;
			transform.localPosition = m_v3InitialLocalPosition;
			if (m_bInitialLocalRotScaleInitialized)
			{
				transform.localRotation = m_qInitialLocalRotation;
				transform.localScale = m_v3InitialLocalScale;
			}
			ListAdjacentChunksCopy = new List<AdjacencyInfo>(ListAdjacentChunks);
			m_fInvisibleTimer = 0f;
		}
		m_bNonSupportedChunkStored = IsNonSupportedChunk;
	}

	private void Update()
	{
		if (Application.isPlaying)
		{
			if (!renderer.isVisible && IsDetachedChunk)
			{
				m_fInvisibleTimer += Time.deltaTime;
				if (FracturedObjectSource != null && m_fInvisibleTimer > FracturedObjectSource.EventDetachedOffscreenLifeTime)
				{
					UnityEngine.Object.Destroy(gameObject);
				}
			}
			else
			{
				m_fInvisibleTimer = 0f;
			}
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (FracturedObjectSource == null || collision == null || collision.contacts == null || collision.contacts.Length == 0)
		{
			return;
		}
		if ((bool)collision.gameObject)
		{
			FracturedChunk component = collision.gameObject.GetComponent<FracturedChunk>();
			if ((bool)component && component.rigidbody.isKinematic && !IsDetachedChunk)
			{
				return;
			}
		}
		float num = float.PositiveInfinity;
		if ((bool)collision.rigidbody)
		{
			num = collision.rigidbody.mass;
		}
		if (!IsDetachedChunk)
		{
			bool flag = false;
			FracturedChunk component2 = collision.gameObject.GetComponent<FracturedChunk>();
			if (component2 != null && component2.IsDetachedChunk && component2.FracturedObjectSource == FracturedObjectSource)
			{
				flag = true;
			}
			if (flag || !(collision.relativeVelocity.magnitude > FracturedObjectSource.EventDetachMinVelocity) || !(num > FracturedObjectSource.EventDetachMinMass) || !(rigidbody != null) || !IsDestructibleChunk())
			{
				return;
			}
			CollisionInfo collisionInfo = new CollisionInfo(this, collision, true);
			FracturedObjectSource.NotifyDetachChunkCollision(collisionInfo);
			if (collisionInfo.bCancelCollisionEvent)
			{
				return;
			}
			List<FracturedChunk> list = new List<FracturedChunk>();
			list = ComputeRandomConnectionBreaks();
			list.Add(this);
			DetachFromObject(true);
			{
				foreach (FracturedChunk item in list)
				{
					FracturedChunk fracturedChunk = (collisionInfo.chunk = item);
					collisionInfo.bIsMain = false;
					collisionInfo.bCancelCollisionEvent = false;
					if (fracturedChunk != this)
					{
						FracturedObjectSource.NotifyDetachChunkCollision(collisionInfo);
					}
					if (!collisionInfo.bCancelCollisionEvent)
					{
						fracturedChunk.DetachFromObject(true);
						fracturedChunk.rigidbody.AddExplosionForce(collision.relativeVelocity.magnitude * FracturedObjectSource.EventDetachExitForce, collision.contacts[0].point, 0f, FracturedObjectSource.EventDetachUpwardsModifier);
					}
				}
				return;
			}
		}
		if (collision.relativeVelocity.magnitude > FracturedObjectSource.EventDetachedMinVelocity && num > FracturedObjectSource.EventDetachedMinMass)
		{
			FracturedObjectSource.NotifyFreeChunkCollision(new CollisionInfo(this, collision, true));
		}
	}

	public bool IsDestructibleChunk()
	{
		if (FracturedObjectSource != null)
		{
			if (FracturedObjectSource.SupportChunksAreIndestructible)
			{
				return !IsSupportChunk;
			}
			if (!FracturedObjectSource.SupportChunksAreIndestructible)
			{
				return true;
			}
		}
		return !IsSupportChunk;
	}

	public void ResetChunk(FracturedObject fracturedObjectSource)
	{
		transform.parent = fracturedObjectSource.transform;
		rigidbody.isKinematic = true;
		IsNonSupportedChunk = m_bNonSupportedChunkStored;
		FracturedObjectSource = fracturedObjectSource;
		IsDetachedChunk = false;
		transform.localPosition = m_v3InitialLocalPosition;
		if (m_bInitialLocalRotScaleInitialized)
		{
			transform.localRotation = m_qInitialLocalRotation;
			transform.localScale = m_v3InitialLocalScale;
		}
		ListAdjacentChunks = new List<AdjacencyInfo>(ListAdjacentChunksCopy);
		m_fInvisibleTimer = 0f;
	}

	public void Impact(Vector3 v3Position, float fExplosionForce, float fRadius, bool bAlsoImpactFreeChunks)
	{
		if (rigidbody != null && IsDestructibleChunk())
		{
			List<FracturedChunk> list = new List<FracturedChunk>();
			if (!IsDetachedChunk)
			{
				list = ComputeRandomConnectionBreaks();
				list.Add(this);
				DetachFromObject(true);
				foreach (FracturedChunk item in list)
				{
					item.DetachFromObject(true);
					item.rigidbody.AddExplosionForce(fExplosionForce, v3Position, 0f, 0f);
				}
			}
			List<FracturedChunk> destructibleChunksInRadius = FracturedObjectSource.GetDestructibleChunksInRadius(v3Position, fRadius, bAlsoImpactFreeChunks);
			foreach (FracturedChunk item2 in destructibleChunksInRadius)
			{
				item2.DetachFromObject(true);
				item2.rigidbody.AddExplosionForce(fExplosionForce, v3Position, 0f, FracturedObjectSource.EventDetachUpwardsModifier);
			}
		}
		FracturedObjectSource.NotifyImpact(v3Position);
	}

	public void OnCreateFromFracturedObject(FracturedObject fracturedComponent, int nSplitSubMeshIndex)
	{
		FracturedObjectSource = fracturedComponent;
		SplitSubMeshIndex = nSplitSubMeshIndex;
		RandomMaterialColor = new Color(UnityEngine.Random.value, UnityEngine.Random.value, UnityEngine.Random.value, 0.7f);
		m_v3InitialLocalPosition = transform.localPosition;
		m_qInitialLocalRotation = transform.localRotation;
		m_v3InitialLocalScale = transform.localScale;
		m_bInitialLocalRotScaleInitialized = true;
	}

	public void UpdatePreviewDecompositionPosition()
	{
		float num = 5f;
		float num2 = 1f;
		if (FracturedObjectSource != null)
		{
			num2 = m_v3InitialLocalPosition.magnitude / FracturedObjectSource.DecomposeRadius;
		}
		Vector3 normalized = m_v3InitialLocalPosition.normalized;
		transform.localPosition = m_v3InitialLocalPosition + normalized * (PreviewDecompositionValue * num2 * num);
	}

	public void ConnectTo(FracturedChunk chunk, float fArea)
	{
		if ((bool)chunk)
		{
			if (chunk.IsConnectedTo(this))
			{
				return;
			}
			ListAdjacentChunks.Add(new AdjacencyInfo(chunk, fArea));
			chunk.ListAdjacentChunks.Add(new AdjacencyInfo(this, fArea));
		}
	}

	public void DisconnectFrom(FracturedChunk chunk)
	{
		if (!(!chunk || !chunk.IsConnectedTo(this)))
		{
			for (int i = 0; i < ListAdjacentChunks.Count; i++)
			{
				if (ListAdjacentChunks[i].chunk == chunk)
				{
					ListAdjacentChunks.RemoveAt(i);
					break;
				}
			}

			for (int j = 0; j < chunk.ListAdjacentChunks.Count; j++)
			{
				if (chunk.ListAdjacentChunks[j].chunk == this)
				{
					chunk.ListAdjacentChunks.RemoveAt(j);
					break;
				}
			}
		}
	}

	public bool IsConnectedTo(FracturedChunk chunk)
	{
		foreach (AdjacencyInfo listAdjacentChunk in ListAdjacentChunks)
		{
			bool result = true;
			if ((bool)listAdjacentChunk.chunk.FracturedObjectSource)
			{
				result = listAdjacentChunk.fArea > listAdjacentChunk.chunk.FracturedObjectSource.ChunkConnectionMinArea;
			}
			if (listAdjacentChunk.chunk == chunk)
			{
				return result;
			}
		}
		return false;
	}

	public void DetachFromObject(bool bCheckStructureIntegrity = true)
	{
		if (!(!IsDestructibleChunk() || IsDetachedChunk || !rigidbody))
		{
			m_bNonSupportedChunkStored = IsNonSupportedChunk;
			transform.parent = null;
			rigidbody.isKinematic = false;
			IsDetachedChunk = true;
			IsNonSupportedChunk = true;
			RemoveConnectionInfo();
			if ((bool)FracturedObjectSource)
			{
				FracturedObjectSource.NotifyChunkDetach(this);
				if (bCheckStructureIntegrity)
				{
					FracturedObjectSource.CheckDetachNonSupportedChunks(false);
				}
			}

			if (!DontDeleteAfterBroken && FracturedObjectSource != null)
			{
				DieTimer dieTimer = gameObject.AddComponent<DieTimer>();
				dieTimer.SecondsToDie = UnityEngine.Random.Range(FracturedObjectSource.EventDetachedMinLifeTime, FracturedObjectSource.EventDetachedMaxLifeTime);
			}
		}
	}

	private void RemoveConnectionInfo()
	{
		foreach (AdjacencyInfo listAdjacentChunk in ListAdjacentChunks)
		{
			if (listAdjacentChunk.chunk)
			{
				foreach (AdjacencyInfo listAdjacentChunk2 in listAdjacentChunk.chunk.ListAdjacentChunks)
				{
					if (listAdjacentChunk2.chunk == this)
					{
						listAdjacentChunk.chunk.ListAdjacentChunks.Remove(listAdjacentChunk2);
						break;
					}
				}
			}
		}

		ListAdjacentChunks.Clear();
	}

	public List<FracturedChunk> ComputeRandomConnectionBreaks()
	{
		List<FracturedChunk> list = new List<FracturedChunk>();
		if (FracturedObjectSource == null)
		{
			return list;
		}
		FracturedObjectSource.ResetAllChunkVisitedFlags();
		ComputeRandomConnectionBreaksRecursive(this, list, 1);
		return list;
	}

	private static void ComputeRandomConnectionBreaksRecursive(FracturedChunk chunk, List<FracturedChunk> listBreaksOut, int nLevel)
	{
		if (chunk.Visited)
		{
			return;
		}
		chunk.Visited = true;
		foreach (AdjacencyInfo listAdjacentChunk in chunk.ListAdjacentChunks)
		{
			if ((bool)listAdjacentChunk.chunk && chunk.FracturedObjectSource != null && !listAdjacentChunk.chunk.Visited && listAdjacentChunk.chunk.IsDestructibleChunk() && listAdjacentChunk.fArea > chunk.FracturedObjectSource.ChunkConnectionMinArea)
			{
				float value = UnityEngine.Random.value;
				if (value > chunk.FracturedObjectSource.ChunkConnectionStrength * (float)nLevel)
				{
					ComputeRandomConnectionBreaksRecursive(listAdjacentChunk.chunk, listBreaksOut, nLevel + 1);
					listBreaksOut.Add(listAdjacentChunk.chunk);
				}
			}
		}
	}

	public static FracturedChunk ChunkRaycast(Vector3 v3Pos, Vector3 v3Forward, out RaycastHit hitInfo)
	{
		FracturedChunk fracturedChunk = null;
		if (Physics.Raycast(v3Pos, v3Forward, out hitInfo))
		{
			fracturedChunk = hitInfo.collider.GetComponent<FracturedChunk>();
			if (fracturedChunk == null && hitInfo.collider.transform.parent != null)
			{
				fracturedChunk = hitInfo.collider.transform.parent.GetComponent<FracturedChunk>();
			}
		}
		return fracturedChunk;
	}
}
