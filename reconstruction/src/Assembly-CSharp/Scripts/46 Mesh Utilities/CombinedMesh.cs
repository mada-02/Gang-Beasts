using System.Collections.Generic;
using System;
using UnityEngine;

public class CombinedMesh : MonoBehaviour
{
	[Serializable]
	public class ObjectInfo
	{
		public Material[] aMaterials;

		public Mesh mesh;

		public Vector3 v3LocalPosition;

		public Quaternion qLocalRotation;

		public Vector3 v3LocalScale;

		public Matrix4x4 mtxLocal;

		public Matrix4x4 mtxWorld;

		public Vector3[] av3NormalsWorld;

		public Vector4[] av4TangentsWorld;

		public ObjectInfo(Material[] aMaterials, Mesh mesh, Transform transform, Matrix4x4 mtxLocal)
		{
			this.aMaterials = new Material[aMaterials.Length];
			aMaterials.CopyTo(this.aMaterials, 0);
			this.mesh = UnityEngine.Object.Instantiate(mesh) as Mesh;
			v3LocalPosition = transform.localPosition;
			qLocalRotation = transform.localRotation;
			v3LocalScale = transform.localScale;
			this.mtxLocal = mtxLocal;
			mtxWorld = transform.localToWorldMatrix;
			if (mesh.normals != null)
			{
				av3NormalsWorld = mesh.normals;
				for (int i = 0; i < av3NormalsWorld.Length; i++)
				{
					av3NormalsWorld[i] = mtxWorld.MultiplyVector(av3NormalsWorld[i]);
				}
			}
			if (mesh.tangents != null)
			{
				av4TangentsWorld = mesh.tangents;
				for (int j = 0; j < av4TangentsWorld.Length; j++)
				{
					Vector3 v = new Vector3(av4TangentsWorld[j].x, av4TangentsWorld[j].y, av4TangentsWorld[j].z);
					v = mtxWorld.MultiplyVector(v);
					av4TangentsWorld[j] = new Vector4(v.x, v.y, v.z, av4TangentsWorld[j].w);
				}
			}
		}
	}

	private class MaterialMeshInfo
	{
		public Transform transform;

		public Mesh mesh;

		public int nSubMesh;

		public MaterialMeshInfo(Transform transform, Mesh mesh, int nSubMesh)
		{
			this.transform = transform;
			this.mesh = mesh;
			this.nSubMesh = nSubMesh;
		}
	}

	public enum EPivotMode
	{
		Keep,
		Center,
		BottomCenter,
		TopCenter,
		Min,
		Max
	}

	public delegate void CombineProgressDelegate(string strMessage, float fT);

	public bool SaveMeshAsset;

	public bool KeepPosition = true;

	public EPivotMode PivotMode = EPivotMode.Center;

	public MeshFilter[] MeshObjects;

	public GameObject RootNode;

	private bool m_bCancelled;

	[SerializeField]
	private List<ObjectInfo> m_listObjectInfo = new List<ObjectInfo>();

	private Dictionary<Material, List<MaterialMeshInfo>> m_dicMeshEntries = new Dictionary<Material, List<MaterialMeshInfo>>();

	public void CancelCombining()
	{
		m_bCancelled = true;
	}

	public bool CombiningCancelled()
	{
		return m_bCancelled;
	}

	public void TransformObjInfoMeshVectorsToLocal(Transform newTransform)
	{
		foreach (ObjectInfo item in m_listObjectInfo)
		{
			if (item.mesh.normals != null && item.av3NormalsWorld != null)
			{
				Vector3[] array = new Vector3[item.av3NormalsWorld.Length];
				item.av3NormalsWorld.CopyTo(array, 0);
				for (int i = 0; i < array.Length; i++)
				{
					array[i] = newTransform.InverseTransformDirection(array[i]);
				}
				item.mesh.normals = array;
			}
			if (item.mesh.tangents != null)
			{
				Vector4[] array2 = new Vector4[item.av4TangentsWorld.Length];
				item.av4TangentsWorld.CopyTo(array2, 0);
				for (int j = 0; j < array2.Length; j++)
				{
					Vector3 direction = new Vector3(array2[j].x, array2[j].y, array2[j].z);
					direction = newTransform.InverseTransformDirection(direction);
					array2[j] = new Vector4(direction.x, direction.y, direction.z, array2[j].w);
				}
				item.mesh.tangents = array2;
			}
		}
	}

	public int GetObjectCount()
	{
		return m_listObjectInfo.Count;
	}

	public ObjectInfo GetObjectInfo(int nIndex)
	{
		return m_listObjectInfo[nIndex];
	}

	public void Combine(CombineProgressDelegate progress)
	{
		m_listObjectInfo.Clear();
		m_dicMeshEntries.Clear();
		m_bCancelled = false;
		bool flag = false;
		bool flag2 = false;
		bool flag3 = false;
		bool flag4 = false;
		bool flag5 = false;
		Vector3 vector = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue);
		Vector3 vector2 = new Vector3(float.MinValue, float.MinValue, float.MinValue);
		int num = 0;
		MeshFilter[] meshObjects = MeshObjects;
		foreach (MeshFilter meshFilter in meshObjects)
		{
			if (progress != null)
			{
				progress("Preprocessing object " + meshFilter.name + "...", (float)num / (float)MeshObjects.Length);
			}

			if (m_bCancelled)
			{
				return;
			}

			if (!(meshFilter == null))
			{
				if (meshFilter.renderer == null)
				{
					Debug.LogWarning(meshFilter.name + " has no mesh renderer available");
					continue;
				}

				Mesh sharedMesh = meshFilter.sharedMesh;
				Vector3[] vertices = sharedMesh.vertices;
				for (int j = 0; j < vertices.Length; j++)
				{
					Vector3 vector3 = meshFilter.transform.TransformPoint(vertices[j]);
					if (vector3.x < vector.x)
					{
						vector.x = vector3.x;
					}

					if (vector3.y < vector.y)
					{
						vector.y = vector3.y;
					}

					if (vector3.z < vector.z)
					{
						vector.z = vector3.z;
					}

					if (vector3.x > vector2.x)
					{
						vector2.x = vector3.x;
					}

					if (vector3.y > vector2.y)
					{
						vector2.y = vector3.y;
					}

					if (vector3.z > vector2.z)
					{
						vector2.z = vector3.z;
					}
				}

				if (sharedMesh.normals != null && sharedMesh.normals.Length > 0)
				{
					flag = true;
				}

				if (sharedMesh.tangents != null && sharedMesh.tangents.Length > 0)
				{
					flag2 = true;
				}

				if (sharedMesh.colors != null && sharedMesh.colors.Length > 0)
				{
					flag3 = true;
				}

				if (sharedMesh.colors32 != null && sharedMesh.colors32.Length > 0)
				{
					flag3 = true;
				}

				if (sharedMesh.uv != null && sharedMesh.uv.Length > 0)
				{
					flag4 = true;
				}

				if (sharedMesh.uv2 != null && sharedMesh.uv2.Length > 0)
				{
					flag5 = true;
				}

				for (int k = 0; k < sharedMesh.subMeshCount; k++)
				{
					MaterialMeshInfo item = new MaterialMeshInfo(meshFilter.transform, sharedMesh, k);
					Material key = meshFilter.renderer.sharedMaterials[k];
					if (!m_dicMeshEntries.ContainsKey(key))
					{
						m_dicMeshEntries.Add(key, new List<MaterialMeshInfo>());
					}

					m_dicMeshEntries[key].Add(item);
				}

				m_listObjectInfo.Add(new ObjectInfo(meshFilter.renderer.sharedMaterials, sharedMesh, meshFilter.transform, meshFilter.transform.localToWorldMatrix));
			}
		}

		if (m_dicMeshEntries.Count > 0)
		{
			Vector3 position = transform.position;
			switch (PivotMode)
			{
				case EPivotMode.Keep:
					position = transform.position;
					break;
				case EPivotMode.Center:
					position = (vector2 + vector) * 0.5f;
					break;
				case EPivotMode.BottomCenter:
					position = (vector2 + vector) * 0.5f;
					position.y = vector.y;
					break;
				case EPivotMode.TopCenter:
					position = (vector2 + vector) * 0.5f;
					position.y = vector2.y;
					break;
				case EPivotMode.Min:
					position = vector;
					break;
				case EPivotMode.Max:
					position = vector2;
					break;
			}

			Vector3 position2 = transform.position;
			Quaternion rotation = transform.rotation;
			Vector3 localScale = transform.localScale;
			transform.position = position;
			transform.rotation = Quaternion.identity;
			transform.localScale = Vector3.one;
			Matrix4x4 worldToLocalMatrix = transform.worldToLocalMatrix;
			if (KeepPosition)
			{
				transform.position = position2;
				transform.rotation = rotation;
				transform.localScale = localScale;
			}

			Material[] array = new Material[m_dicMeshEntries.Keys.Count];
			m_dicMeshEntries.Keys.CopyTo(array, 0);
			foreach (ObjectInfo item2 in m_listObjectInfo)
			{
				item2.mtxLocal = worldToLocalMatrix * item2.mtxLocal;
			}

			List<int>[] array2 = new List<int>[m_dicMeshEntries.Count];
			List<Vector3> list = new List<Vector3>();
			List<Vector3> list2 = new List<Vector3>();
			List<Vector4> list3 = new List<Vector4>();
			List<Color32> list4 = new List<Color32>();
			List<Vector2> list5 = new List<Vector2>();
			List<Vector2> list6 = new List<Vector2>();
			Dictionary<GameObject, int> dictionary = new Dictionary<GameObject, int>();
			int num2 = 0;
			foreach (List<MaterialMeshInfo> value in m_dicMeshEntries.Values)
			{
				array2[num2] = new List<int>();
				int num3 = 0;
				foreach (MaterialMeshInfo item3 in value)
				{
					if (progress != null)
					{
						progress("Combining submesh for material " + array[num2].name + "...", (float)num3 / (float)value.Count);
					}

					if (m_bCancelled)
					{
						return;
					}

					int num4 = list.Count;
					if (dictionary.ContainsKey(item3.transform.gameObject))
					{
						num4 = dictionary[item3.transform.gameObject];
					}
					else
					{
						Matrix4x4 localToWorldMatrix = item3.transform.localToWorldMatrix;
						Matrix4x4 matrix4x = worldToLocalMatrix * localToWorldMatrix;
						dictionary.Add(item3.transform.gameObject, num4);
						int vertexCount = item3.mesh.vertexCount;
						Vector3[] vertices2 = item3.mesh.vertices;
						for (int l = 0; l < vertices2.Length; l++)
						{
							vertices2[l] = matrix4x.MultiplyPoint3x4(vertices2[l]);
						}

						list.AddRange(vertices2);
						if (flag)
						{
							bool flag6 = true;
							if (item3.mesh.normals != null && item3.mesh.normals.Length > 0)
							{
								flag6 = false;
							}

							if (flag6)
							{
								Debug.LogWarning(string.Format("Object {0} has mesh with no vertex normals, and some other objects have them. Dummy normals have been added", item3.transform.name));
							}

							Vector3[] array3 = (flag6 ? new Vector3[vertexCount] : item3.mesh.normals);
							for (int m = 0; m < array3.Length; m++)
							{
								array3[m] = item3.transform.TransformDirection(array3[m]);
								array3[m] = transform.InverseTransformDirection(array3[m]);
							}

							list2.AddRange(array3);
						}

						if (flag2)
						{
							bool flag7 = true;
							if (item3.mesh.tangents != null && item3.mesh.tangents.Length > 0)
							{
								flag7 = false;
							}

							if (flag7)
							{
								Debug.LogWarning(string.Format("Object {0} has mesh with no vertex tangents, and some other objects have them. Dummy tangents have been added", item3.transform.name));
							}

							Vector4[] array4 = (flag7 ? new Vector4[vertexCount] : item3.mesh.tangents);
							for (int n = 0; n < array4.Length; n++)
							{
								Vector3 direction = new Vector3(array4[n].x, array4[n].y, array4[n].z);
								direction = item3.transform.TransformDirection(direction);
								direction = transform.InverseTransformDirection(direction);
								array4[n] = new Vector4(direction.x, direction.y, direction.z, (!flag7) ? array4[n].w : 1f);
							}

							list3.AddRange(array4);
						}

						if (flag3)
						{
							bool flag8 = false;
							bool flag9 = false;
							bool flag10 = true;
							if (item3.mesh.colors != null && item3.mesh.colors.Length > 0)
							{
								flag8 = true;
								flag10 = false;
							}

							if (item3.mesh.colors32 != null && item3.mesh.colors32.Length > 0)
							{
								flag9 = true;
								flag10 = false;
							}

							if (flag10)
							{
								Debug.LogWarning(string.Format("Object {0} has mesh with no vertex colors, and some other objects have them. Dummy colors have been added", item3.transform.name));
							}

							Color32[] array5 = null;
							if (flag10)
							{
								array5 = new Color32[vertexCount];
							}
							else if (flag8)
							{
								array5 = new Color32[vertexCount];
								Color[] colors = item3.mesh.colors;
								for (int num5 = 0; num5 < vertexCount; num5++)
								{
									array5[num5] = colors[num5];
								}
							}
							else if (flag9)
							{
								array5 = item3.mesh.colors32;
							}

							list4.AddRange(array5);
						}

						if (flag4)
						{
							bool flag11 = true;
							if (item3.mesh.uv != null && item3.mesh.uv.Length > 0)
							{
								flag11 = false;
							}

							if (flag11)
							{
								Debug.LogWarning(string.Format("Object {0} has mesh with no vertex mapping (uv), and some other objects have them. Dummy mapping has been added", item3.transform.name));
							}

							Vector2[] collection = (flag11 ? new Vector2[vertexCount] : item3.mesh.uv);
							list5.AddRange(collection);
						}

						if (flag5)
						{
							bool flag12 = true;
							if (item3.mesh.uv2 != null && item3.mesh.uv2.Length > 0)
							{
								flag12 = false;
							}

							if (flag12)
							{
								Debug.LogWarning(string.Format("Object {0} has mesh with no vertex mapping (uv2), and some other objects have them. Dummy mapping has been added", item3.transform.name));
							}

							Vector2[] collection2 = (flag12 ? new Vector2[vertexCount] : item3.mesh.uv2);
							list6.AddRange(collection2);
						}
					}

					int[] triangles = item3.mesh.GetTriangles(item3.nSubMesh);
					for (int num6 = 0; num6 < triangles.Length; num6++)
					{
						array2[num2].Add(triangles[num6] + num4);
					}

					num3++;
				}

				num2++;
			}

			if (!m_bCancelled)
			{
				if (progress != null)
				{
					progress("Building mesh...", 1f);
				}

				MeshFilter meshFilter2 = gameObject.GetComponent<MeshFilter>();
				if (meshFilter2 == null)
				{
					meshFilter2 = gameObject.AddComponent<MeshFilter>();
				}

				if (renderer == null)
				{
					gameObject.AddComponent<MeshRenderer>();
				}

				renderer.sharedMaterials = array;
				int num7 = 65000;
				if (list.Count > num7)
				{
					Debug.LogWarning("Warning! vertex count = " + list.Count + ". You may be hitting Unity's vertex count limit (" + num7 + "). Please try combining less objects.");
				}

				Mesh mesh = new Mesh();
				mesh.vertices = list.ToArray();
				if (flag)
				{
					mesh.normals = list2.ToArray();
				}

				if (flag2)
				{
					mesh.tangents = list3.ToArray();
				}

				if (flag3)
				{
					mesh.colors32 = list4.ToArray();
				}

				if (flag4)
				{
					mesh.uv = list5.ToArray();
				}

				if (flag5)
				{
					mesh.uv2 = list6.ToArray();
				}

				mesh.subMeshCount = array2.Length;
				for (int num8 = 0; num8 < array2.Length; num8++)
				{
					mesh.SetTriangles(array2[num8].ToArray(), num8);
				}

				meshFilter2.sharedMesh = mesh;
			}
		}
		else
		{
			Debug.LogWarning("No meshes were combined because none were found.");
		}
	}
}
