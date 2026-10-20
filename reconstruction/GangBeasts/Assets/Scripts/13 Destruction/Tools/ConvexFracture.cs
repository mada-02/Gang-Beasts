using Destruction.Tools;
using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Dynamic
{
		[RequireComponent(typeof(MeshCollider))]
		[RequireComponent(typeof(MeshFilter))]
		[RequireComponent(typeof(Trigger))]
		[AddComponentMenu("Destruction/Box Fracture")]
		[RequireComponent(typeof(Rigidbody))]
		public sealed class ConvexFracture : BaseFracture
		{
			private Vector4[] initPlanes;

			private Mesh mesh;

			private void Awake()
			{
				mesh = GetComponent<MeshFilter>().sharedMesh;
				HashSet<Vector4> hashSet = new HashSet<Vector4>();
				for (int i = 0; i < mesh.triangles.Length; i += 3)
				{
					Plane plane = new Plane(GetVertex(i), GetVertex(i + 1), GetVertex(i + 2));
					Vector4 item = new Vector4(plane.normal.x, plane.normal.y, plane.normal.z, plane.distance);
					if (!hashSet.Contains(item))
					{
						hashSet.Add(item);
					}
				}
				initPlanes = new Vector4[hashSet.Count];
				hashSet.CopyTo(initPlanes);
			}

			private Vector3 GetVertex(int i)
			{
				return Vector3.Scale(transform.lossyScale, mesh.vertices[mesh.triangles[i]]);
			}

			protected override void CreateMeshPlanes(Vector3 point)
			{
				for (int i = 0; i < initPlanes.Length; i++)
				{
					Vector4 vector = initPlanes[i];
					vector.w += Vector3.Dot(vector, point);
					planes.Add(vector);
				}
			}
		}
}
