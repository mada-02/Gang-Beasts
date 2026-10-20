using Destruction.Utilities;
using UnityEngine;

namespace Destruction.Dynamic
{
		public class Shard : MonoBehaviour
		{
			private MeshFilter meshFilter;

			private MeshCollider meshCollider;

			public Mesh Mesh
			{
				get
				{
					return meshFilter != null ? meshFilter.sharedMesh : GetComponent<MeshFilter>().sharedMesh;
				}
			}

			private void Awake()
			{
				if (renderer == null)
				{
					gameObject.AddComponent<MeshRenderer>();
				}
				if (rigidbody == null)
				{
					gameObject.AddComponent<Rigidbody>();
				}
				meshFilter = GetComponent<MeshFilter>() ?? gameObject.AddComponent<MeshFilter>();
				meshCollider = GetComponent<MeshCollider>() ?? gameObject.AddComponent<MeshCollider>();
				meshCollider.convex = true;
				meshFilter.sharedMesh = new Mesh();
				gameObject.SetActive(false);
			}

			internal void FinalizeShard()
			{
				transform.parent = null;
				gameObject.SetActive(true);
			}

			internal static Shard CreateShard(GameObject parent, Vector3[] newVertices, Vector3[] newNormals, int[] newTriangles, Vector2[] newUVs)
			{
				Shard nextShard = ShardPool.NextShard;
				if (nextShard == null)
				{
					Debug.LogError("Not enough shards left in pool.");
					return null;
				}
				nextShard.name = "Fractured shard";
				nextShard.Mesh.vertices = newVertices;
				nextShard.Mesh.normals = newNormals;
				nextShard.Mesh.uv = newUVs;
				nextShard.Mesh.triangles = newTriangles;
				nextShard.Mesh.tangents = MeshUtility.RecalculateTangents(newVertices, newUVs, newNormals, newTriangles);
				nextShard.meshCollider.sharedMesh = nextShard.Mesh;
				nextShard.FinalizeShard();
				nextShard.renderer.material = parent.renderer.material;
				if ((bool)parent.rigidbody)
				{
					nextShard.rigidbody.mass = parent.rigidbody.mass;
					nextShard.rigidbody.velocity = parent.rigidbody.velocity;
				}
				return nextShard;
			}
		}
}
