using System.Collections.Generic;
using System;
using UnityEngine;

namespace UltimateFracturing
{
		public class VertexData
		{
			public int nVertexHash;

			public Vector3 v3Vertex;

			public Vector3 v3Normal;

			public Vector4 v4Tangent;

			public Color32 color32;

			public Vector2 v2Mapping1;

			public Vector2 v2Mapping2;

			public bool bHasNormal;

			public bool bHasTangent;

			public bool bHasColor32;

			public bool bHasMapping1;

			public bool bHasMapping2;

			public VertexData(int nVertexHash)
			{
				this.nVertexHash = nVertexHash;
				v3Vertex = Vector3.zero;
				v3Normal = Vector3.zero;
				v4Tangent = Vector4.zero;
				color32.r = (color32.g = (color32.b = (color32.a = byte.MaxValue)));
				v2Mapping1 = Vector2.zero;
				v2Mapping2 = Vector2.zero;
				bHasNormal = false;
				bHasTangent = false;
				bHasColor32 = false;
				bHasMapping1 = false;
				bHasMapping2 = false;
			}

			public VertexData(int nVertexHash, Vector3 v3Vertex, Vector3 v3Normal, Vector3 v4Tangent, Color32 color32, Vector2 v2Mapping1, Vector2 v2Mapping2, bool bHasNormal, bool bHasTangent, bool bHasColor32, bool bHasMapping1, bool bHasMapping2)
			{
				this.nVertexHash = nVertexHash;
				this.v3Vertex = v3Vertex;
				this.v3Normal = v3Normal;
				this.v4Tangent = v4Tangent;
				this.color32 = color32;
				this.v2Mapping1 = v2Mapping1;
				this.v2Mapping2 = v2Mapping2;
				this.bHasNormal = bHasNormal;
				this.bHasTangent = bHasTangent;
				this.bHasColor32 = bHasColor32;
				this.bHasMapping1 = bHasMapping1;
				this.bHasMapping2 = bHasMapping2;
			}

			public VertexData Copy()
			{
				VertexData vertexData = new VertexData(nVertexHash);
				vertexData.v3Vertex = v3Vertex;
				vertexData.v3Normal = v3Normal;
				vertexData.v4Tangent = v4Tangent;
				vertexData.color32 = color32;
				vertexData.v2Mapping1 = v2Mapping1;
				vertexData.v2Mapping2 = v2Mapping2;
				vertexData.bHasNormal = bHasNormal;
				vertexData.bHasTangent = bHasTangent;
				vertexData.bHasColor32 = bHasColor32;
				vertexData.bHasMapping1 = bHasMapping1;
				vertexData.bHasMapping2 = bHasMapping2;
				return vertexData;
			}

			public static VertexData Lerp(int nVertexHash, VertexData vd1, VertexData vd2, float fT)
			{
				VertexData vertexData = new VertexData(nVertexHash);
				vertexData.bHasNormal = vd1.bHasNormal;
				vertexData.bHasTangent = vd1.bHasTangent;
				vertexData.bHasColor32 = vd1.bHasColor32;
				vertexData.bHasMapping1 = vd1.bHasMapping1;
				vertexData.bHasMapping2 = vd1.bHasMapping2;
				Vector3 vector = Vector3.Lerp(vd1.v4Tangent, vd2.v4Tangent, fT);
				vertexData.v3Vertex = Vector3.Lerp(vd1.v3Vertex, vd2.v3Vertex, fT);
				if (vd1.bHasNormal)
				{
					vertexData.v3Normal = Vector3.Lerp(vd1.v3Normal, vd2.v3Normal, fT);
				}
				if (vd1.bHasColor32)
				{
					vertexData.color32 = Color32.Lerp(vd1.color32, vd2.color32, fT);
				}
				if (vd1.bHasMapping1)
				{
					vertexData.v2Mapping1 = Vector2.Lerp(vd1.v2Mapping1, vd2.v2Mapping1, fT);
				}
				if (vd1.bHasMapping2)
				{
					vertexData.v2Mapping2 = Vector2.Lerp(vd1.v2Mapping2, vd2.v2Mapping2, fT);
				}
				if (vd1.bHasTangent)
				{
					vertexData.v4Tangent = new Vector4(vector.x, vector.y, vector.z, vd1.v4Tangent.w);
				}
				return vertexData;
			}

			public static bool ClipAgainstPlane(VertexData[] aVertexDataInput, int nIndexA, int nIndexB, Vector3 v3A, Vector3 v3B, Plane planeSplit, ref VertexData clippedVertexDataOut)
			{
				Vector3 normalized = (v3B - v3A).normalized;
				Ray ray = new Ray(v3A, normalized);
				float enter;
				if (!planeSplit.Raycast(ray, out enter))
				{
					Debug.LogWarning("Raycast returned false");
					clippedVertexDataOut = new VertexData(clippedVertexDataOut.nVertexHash);
					return false;
				}
				float fT = enter / (v3B - v3A).magnitude;
				clippedVertexDataOut = Lerp(clippedVertexDataOut.nVertexHash, aVertexDataInput[nIndexA], aVertexDataInput[nIndexB], fT);
				return true;
			}

			public static VertexData[] BuildVertexDataArray(Mesh mesh, Matrix4x4 mtxLocalToWorld, bool bTransformVerticesToWorld)
			{
				VertexData[] array = new VertexData[mesh.vertexCount];
				Vector3[] vertices = mesh.vertices;
				Vector3[] normals = mesh.normals;
				Vector4[] tangents = mesh.tangents;
				Vector2[] uv = mesh.uv;
				Vector2[] uv2 = mesh.uv2;
				Color[] colors = mesh.colors;
				Color32[] colors2 = mesh.colors32;
				for (int i = 0; i < mesh.vertexCount; i++)
				{
					array[i] = new VertexData(-1);
					if (bTransformVerticesToWorld)
					{
						array[i].v3Vertex = mtxLocalToWorld.MultiplyPoint3x4(vertices[i]);
						if (normals != null)
						{
							if (normals.Length > i)
							{
								array[i].v3Normal = mtxLocalToWorld.MultiplyVector(normals[i]);
								array[i].bHasNormal = true;
							}
						}
						else
						{
							array[i].bHasNormal = false;
						}
						if (tangents != null)
						{
							if (tangents.Length > i)
							{
								float w = tangents[i].w;
								array[i].v4Tangent = mtxLocalToWorld.MultiplyVector(tangents[i]);
								array[i].v4Tangent.w = w;
								array[i].bHasTangent = true;
							}
						}
						else
						{
							array[i].bHasTangent = false;
						}
					}
					else
					{
						array[i].v3Vertex = vertices[i];
						if (normals != null)
						{
							if (normals.Length > i)
							{
								array[i].v3Normal = normals[i];
								array[i].bHasNormal = true;
							}
						}
						else
						{
							array[i].bHasNormal = false;
						}
						if (tangents != null)
						{
							if (tangents.Length > i)
							{
								array[i].v4Tangent = tangents[i];
								array[i].bHasTangent = true;
							}
						}
						else
						{
							array[i].bHasTangent = false;
						}
					}
					if (colors2 != null)
					{
						if (colors2.Length > i)
						{
							array[i].color32 = colors2[i];
							array[i].bHasColor32 = true;
						}
					}
					else if (colors != null && colors.Length > i)
					{
						array[i].color32 = colors[i];
						array[i].bHasColor32 = true;
					}
					array[i].bHasColor32 = false;
					if (uv != null)
					{
						if (uv.Length > i)
						{
							array[i].v2Mapping1 = uv[i];
							array[i].bHasMapping1 = true;
						}
					}
					else
					{
						array[i].bHasMapping1 = false;
					}
					if (uv2 != null)
					{
						if (uv2.Length > i)
						{
							array[i].v2Mapping2 = uv2[i];
							array[i].bHasMapping2 = true;
						}
					}
					else
					{
						array[i].bHasMapping2 = false;
					}
				}
				return array;
			}

			public static void SetMeshDataFromVertexDataArray(MeshFilter meshFilter, MeshData meshData, bool bTransformVertexToLocal)
			{
				VertexData[] aVertexData = meshData.aVertexData;
				Vector3[] array = new Vector3[aVertexData.Length];
				Vector3[] array2 = (aVertexData[0].bHasNormal ? new Vector3[aVertexData.Length] : null);
				Vector4[] array3 = (aVertexData[0].bHasTangent ? new Vector4[aVertexData.Length] : null);
				Color32[] array4 = (aVertexData[0].bHasColor32 ? new Color32[aVertexData.Length] : null);
				Vector2[] array5 = (aVertexData[0].bHasMapping1 ? new Vector2[aVertexData.Length] : null);
				Vector2[] array6 = (aVertexData[0].bHasMapping2 ? new Vector2[aVertexData.Length] : null);
				Matrix4x4 worldToLocalMatrix = meshFilter.transform.worldToLocalMatrix;
				for (int i = 0; i < aVertexData.Length; i++)
				{
					if (bTransformVertexToLocal)
					{
						array[i] = worldToLocalMatrix.MultiplyPoint(aVertexData[i].v3Vertex);
						if (array2 != null)
						{
							array2[i] = worldToLocalMatrix.MultiplyVector(aVertexData[i].v3Normal);
						}

						if (array3 != null)
						{
							float w = aVertexData[i].v4Tangent.w;
							array3[i] = worldToLocalMatrix.MultiplyVector(aVertexData[i].v4Tangent);
							array3[i].w = w;
						}
					}
					else
					{
						array[i] = aVertexData[i].v3Vertex;
						if (array2 != null)
						{
							array2[i] = aVertexData[i].v3Normal;
						}

						if (array3 != null)
						{
							array3[i] = aVertexData[i].v4Tangent;
						}
					}

					if (array4 != null)
					{
						array4[i] = aVertexData[i].color32;
					}

					if (array5 != null)
					{
						array5[i] = aVertexData[i].v2Mapping1;
					}

					if (array6 != null)
					{
						array6[i] = aVertexData[i].v2Mapping2;
					}
				}

				meshFilter.sharedMesh.vertices = array;
				meshFilter.sharedMesh.normals = array2;
				meshFilter.sharedMesh.tangents = array3;
				meshFilter.sharedMesh.colors32 = array4;
				meshFilter.sharedMesh.uv = array5;
				meshFilter.sharedMesh.uv2 = array6;
			}
		}

		public struct EdgeKeyByIndex
		{
			public class EqualityComparer : IEqualityComparer<EdgeKeyByIndex>
			{
				public bool Equals(EdgeKeyByIndex x, EdgeKeyByIndex y)
				{
					return x.CompareTo(y.nIndexA, y.nIndexB);
				}

				public int GetHashCode(EdgeKeyByIndex x)
				{
					return x.nIndexA.GetHashCode() + x.nIndexB.GetHashCode();
				}
			}

			public int nIndexA;

			public int nIndexB;

			public EdgeKeyByIndex(int nIndexA, int nIndexB)
			{
				this.nIndexA = nIndexA;
				this.nIndexB = nIndexB;
			}

			public void Set(int nIndexA, int nIndexB)
			{
				this.nIndexA = nIndexA;
				this.nIndexB = nIndexB;
			}

			public bool CompareTo(int nIndexA, int nIndexB)
			{
				if (this.nIndexA == nIndexA && this.nIndexB == nIndexB)
				{
					return true;
				}
				if (this.nIndexA == nIndexB && this.nIndexB == nIndexA)
				{
					return true;
				}
				return false;
			}
		}

		public struct EdgeKeyByHash
		{
			public class EqualityComparer : IEqualityComparer<EdgeKeyByHash>
			{
				public bool Equals(EdgeKeyByHash x, EdgeKeyByHash y)
				{
					return x.CompareTo(y.nHashA, y.nHashB);
				}

				public int GetHashCode(EdgeKeyByHash x)
				{
					return x.nHashA.GetHashCode() + x.nHashB.GetHashCode();
				}
			}

			public int nHashA;

			public int nHashB;

			public EdgeKeyByHash(int nHashA, int nHashB)
			{
				this.nHashA = nHashA;
				this.nHashB = nHashB;
			}

			public void Set(int nHashA, int nHashB)
			{
				this.nHashA = nHashA;
				this.nHashB = nHashB;
			}

			public bool CompareTo(int nHashA, int nHashB)
			{
				if (this.nHashA == nHashA && this.nHashB == nHashB)
				{
					return true;
				}
				if (this.nHashA == nHashB && this.nHashB == nHashA)
				{
					return true;
				}
				return false;
			}
		}

		public struct ClippedEdge
		{
			public int nOldIndexA;

			public int nOldIndexB;

			public int nNewIndexA;

			public int nNewIndexB;

			public int nClippedIndex;

			public ClippedEdge(int nOldIndexA, int nOldIndexB, int nNewIndexA, int nNewIndexB, int nClippedIndex)
			{
				this.nOldIndexA = nOldIndexA;
				this.nOldIndexB = nOldIndexB;
				this.nNewIndexA = nNewIndexA;
				this.nNewIndexB = nNewIndexB;
				this.nClippedIndex = nClippedIndex;
			}

			public int GetFirstIndex(int nOldIndexA)
			{
				if (this.nOldIndexA == nOldIndexA)
				{
					return nNewIndexA;
				}
				return nNewIndexB;
			}

			public int GetSecondIndex(int nOldIndexB)
			{
				if (this.nOldIndexB == nOldIndexB)
				{
					return nNewIndexB;
				}
				return nNewIndexA;
			}
		}

		public struct CapEdge
		{
			public Vector3 v1;

			public Vector3 v2;

			public int nHash1;

			public int nHash2;

			public float fLength;

			public CapEdge(int nHash1, int nHash2, Vector3 v1, Vector3 v2, float fLength)
			{
				this.nHash1 = nHash1;
				this.nHash2 = nHash2;
				this.v1 = v1;
				this.v2 = v2;
				this.fLength = fLength;
			}

			public int SharesVertex1Of(CapEdge edge)
			{
				if (nHash1 == edge.nHash1)
				{
					return 1;
				}
				if (nHash2 == edge.nHash1)
				{
					return 2;
				}
				return 0;
			}

			public int SharesVertex2Of(CapEdge edge)
			{
				if (nHash1 == edge.nHash2)
				{
					return 1;
				}
				if (nHash2 == edge.nHash2)
				{
					return 2;
				}
				return 0;
			}
		}

		public class MeshFaceConnectivity
		{
			public struct EdgeData
			{
				public struct SideData
				{
					public int nFace;

					public int nSubMesh;

					public int nSubMeshFace;

					public int nEdgePos;

					public int nVertexDataV1;

					public int nVertexDataV2;

					public SideData(int nFace, int nSubMesh, int nSubMeshFace, int nEdgePos, int nVertexDataV1, int nVertexDataV2)
					{
						this.nFace = nFace;
						this.nSubMesh = nSubMesh;
						this.nSubMeshFace = nSubMeshFace;
						this.nEdgePos = nEdgePos;
						this.nVertexDataV1 = nVertexDataV1;
						this.nVertexDataV2 = nVertexDataV2;
					}
				}

				public int nEdgeIndex;

				private int nVertex1Hash;

				private int nVertex2Hash;

				public Vector3 v1;

				public Vector3 v2;

				public List<SideData> listSides;

				public EdgeData(int nEdgeIndex, int nFace, int nSubMesh, int nSubMeshFace, int nEdgePos, Vector3 v1, Vector3 v2, int nVertex1Hash, int nVertex2Hash, int nVertexDataV1, int nVertexDataV2)
				{
					this.nEdgeIndex = nEdgeIndex;
					this.v1 = v1;
					this.v2 = v2;
					this.nVertex1Hash = nVertex1Hash;
					this.nVertex2Hash = nVertex2Hash;
					listSides = new List<SideData>();
					listSides.Add(new SideData(nFace, nSubMesh, nSubMeshFace, nEdgePos, nVertexDataV1, nVertexDataV2));
				}

				public bool Compare(int nVertex1Hash, int nVertex2Hash)
				{
					if (this.nVertex1Hash == nVertex1Hash && this.nVertex2Hash == nVertex2Hash)
					{
						return true;
					}
					if (this.nVertex1Hash == nVertex2Hash && this.nVertex2Hash == nVertex1Hash)
					{
						return true;
					}
					return false;
				}

				public void AddSideData(int nFace, int nSubMesh, int nSubMeshFace, int nEdgePos, int nVertexDataV1, int nVertexDataV2)
				{
					if (listSides == null)
					{
						listSides = new List<SideData>();
					}
					listSides.Add(new SideData(nFace, nSubMesh, nSubMeshFace, nEdgePos, nVertexDataV1, nVertexDataV2));
				}

				public bool HasMoreThanOneSide()
				{
					if (listSides == null)
					{
						return false;
					}
					return listSides.Count > 1;
				}
			}

			public class TriangleData
			{
				public int nSubMesh;

				public int nTriangle;

				public int[] anEdges;

				public List<int>[] alistNeighborSubMeshes;

				public List<int>[] alistNeighborTriangles;

				public bool bVisited;

				public TriangleData(int nSubMesh, int nTriangle)
				{
					this.nSubMesh = nSubMesh;
					this.nTriangle = nTriangle;
					anEdges = new int[3];
					alistNeighborSubMeshes = new List<int>[3];
					alistNeighborTriangles = new List<int>[3];
					for (int i = 0; i < 3; i++)
					{
						anEdges[i] = -1;
						alistNeighborSubMeshes[i] = new List<int>();
						alistNeighborTriangles[i] = new List<int>();
					}
					bVisited = false;
				}
			}

			public List<TriangleData> listTriangles;

			private List<EdgeData> listEdges;

			private List<int> listEdgeIndices;

			private Dictionary<EdgeKeyByHash, EdgeData> dicEdges;

			private int nEdgeCount;

			private Dictionary<int, int> dicSubMeshTriangleCount;

			public MeshFaceConnectivity()
			{
				listTriangles = new List<TriangleData>();
				listEdges = new List<EdgeData>();
				listEdgeIndices = new List<int>();
				dicEdges = new Dictionary<EdgeKeyByHash, EdgeData>(new EdgeKeyByHash.EqualityComparer());
				dicSubMeshTriangleCount = new Dictionary<int, int>();
				nEdgeCount = 0;
			}

			public void Clear()
			{
				listTriangles.Clear();
				listEdges.Clear();
				listEdgeIndices.Clear();
				dicEdges.Clear();
				dicSubMeshTriangleCount.Clear();
				nEdgeCount = 0;
			}

			public void ResetVisited()
			{
				for (int i = 0; i < listTriangles.Count; i++)
				{
					listTriangles[i].bVisited = false;
				}
			}

			public void AddEdge(int nSubMesh, Vector3 v1, Vector3 v2, int nVertex1Hash, int nVertex2Hash, int nVertexDataIndex1, int nVertexDataIndex2)
			{
				int nEdgePos = nEdgeCount % 3;
				int num = nEdgeCount / 3;
				if (!dicSubMeshTriangleCount.ContainsKey(nSubMesh))
				{
					dicSubMeshTriangleCount.Add(nSubMesh, 0);
				}

				int num2 = dicSubMeshTriangleCount[nSubMesh];
				int num3 = -1;
				EdgeKeyByHash key = new EdgeKeyByHash(nVertex1Hash, nVertex2Hash);
				if (dicEdges.ContainsKey(key))
				{
					EdgeData edgeData = dicEdges[key];
					edgeData.AddSideData(num, nSubMesh, num2, nEdgePos, nVertexDataIndex1, nVertexDataIndex2);
					num3 = edgeData.nEdgeIndex;
				}
				else
				{
					num3 = listEdges.Count;
					EdgeData edgeData2 = new EdgeData(num3, num, nSubMesh, num2, nEdgePos, v1, v2, nVertex1Hash, nVertex2Hash, nVertexDataIndex1, nVertexDataIndex2);
					listEdges.Add(edgeData2);
					dicEdges.Add(key, edgeData2);
				}

				listEdgeIndices.Add(num3);
				nEdgeCount++;
				if (!(nEdgeCount % 3 != 0))
				{
					TriangleData triangleData = new TriangleData(nSubMesh, num2);
					EdgeData edgeData3 = listEdges[listEdgeIndices[listEdgeIndices.Count - 3]];
					EdgeData edgeData4 = listEdges[listEdgeIndices[listEdgeIndices.Count - 2]];
					EdgeData edgeData5 = listEdges[listEdgeIndices[listEdgeIndices.Count - 1]];
					triangleData.anEdges[0] = edgeData3.nEdgeIndex;
					triangleData.anEdges[1] = edgeData4.nEdgeIndex;
					triangleData.anEdges[2] = edgeData5.nEdgeIndex;
					foreach (EdgeData.SideData listSide in edgeData3.listSides)
					{
						if (listSide.nFace != num)
						{
							listTriangles[listSide.nFace].alistNeighborSubMeshes[listSide.nEdgePos].Add(nSubMesh);
							listTriangles[listSide.nFace].alistNeighborTriangles[listSide.nEdgePos].Add(num2);
							triangleData.alistNeighborSubMeshes[0].Add(listSide.nSubMesh);
							triangleData.alistNeighborTriangles[0].Add(listSide.nSubMeshFace);
						}
					}

					foreach (EdgeData.SideData listSide2 in edgeData4.listSides)
					{
						if (listSide2.nFace != num)
						{
							listTriangles[listSide2.nFace].alistNeighborSubMeshes[listSide2.nEdgePos].Add(nSubMesh);
							listTriangles[listSide2.nFace].alistNeighborTriangles[listSide2.nEdgePos].Add(num2);
							triangleData.alistNeighborSubMeshes[1].Add(listSide2.nSubMesh);
							triangleData.alistNeighborTriangles[1].Add(listSide2.nSubMeshFace);
						}
					}

					foreach (EdgeData.SideData listSide3 in edgeData5.listSides)
					{
						if (listSide3.nFace != num)
						{
							listTriangles[listSide3.nFace].alistNeighborSubMeshes[listSide3.nEdgePos].Add(nSubMesh);
							listTriangles[listSide3.nFace].alistNeighborTriangles[listSide3.nEdgePos].Add(num2);
							triangleData.alistNeighborSubMeshes[2].Add(listSide3.nSubMesh);
							triangleData.alistNeighborTriangles[2].Add(listSide3.nSubMeshFace);
						}
					}

					listTriangles.Add(triangleData);
					dicSubMeshTriangleCount[nSubMesh]++;
				}
			}
		}

		public class MeshDataConnectivity
		{
			public struct Face
			{
				public class EqualityComparer : IEqualityComparer<Face>
				{
					public bool Equals(Face x, Face y)
					{
						return x.nSubMesh == y.nSubMesh && x.nFaceIndex == y.nFaceIndex;
					}

					public int GetHashCode(Face x)
					{
						return x.nSubMesh.GetHashCode() + x.nFaceIndex.GetHashCode();
					}
				}

				public int nSubMesh;

				public int nFaceIndex;

				public Face(int nSubMesh, int nFaceIndex)
				{
					this.nSubMesh = nSubMesh;
					this.nFaceIndex = nFaceIndex;
				}
			}

			public static int s_CurrentSharedFaceHash;

			public Dictionary<int, List<Face>> dicHash2FaceList;

			public Dictionary<Face, List<int>> dicFace2HashList;

			public Dictionary<Face, bool> dicFace2IsClipped;

			public MeshDataConnectivity()
			{
				dicHash2FaceList = new Dictionary<int, List<Face>>();
				dicFace2HashList = new Dictionary<Face, List<int>>(new Face.EqualityComparer());
				dicFace2IsClipped = new Dictionary<Face, bool>(new Face.EqualityComparer());
			}

			public MeshDataConnectivity GetDeepCopy()
			{
				MeshDataConnectivity meshDataConnectivity = new MeshDataConnectivity();
				foreach (KeyValuePair<int, List<Face>> dicHash2Face in dicHash2FaceList)
				{
					meshDataConnectivity.dicHash2FaceList.Add(dicHash2Face.Key, new List<Face>());
					foreach (Face item in dicHash2Face.Value)
					{
						meshDataConnectivity.dicHash2FaceList[dicHash2Face.Key].Add(item);
					}
				}
				foreach (KeyValuePair<Face, List<int>> dicFace2Hash in dicFace2HashList)
				{
					meshDataConnectivity.dicFace2HashList.Add(dicFace2Hash.Key, new List<int>());
					foreach (int item2 in dicFace2Hash.Value)
					{
						meshDataConnectivity.dicFace2HashList[dicFace2Hash.Key].Add(item2);
					}
				}
				foreach (KeyValuePair<Face, bool> item3 in dicFace2IsClipped)
				{
					meshDataConnectivity.dicFace2IsClipped.Add(item3.Key, item3.Value);
				}
				return meshDataConnectivity;
			}

			public void NotifyNewClippedFace(MeshData meshDataSource, int nSourceSubMesh, int nSourceFaceIndex, int nDestSubMesh, int nDestFaceIndex)
			{
				Face key = new Face(nSourceSubMesh, nSourceFaceIndex);
				Face face = new Face(nDestSubMesh, nDestFaceIndex);
				if (meshDataSource.meshDataConnectivity.dicFace2HashList.ContainsKey(key))
				{
					foreach (int item in meshDataSource.meshDataConnectivity.dicFace2HashList[key])
					{
						if (!dicHash2FaceList.ContainsKey(item))
						{
							dicHash2FaceList.Add(item, new List<Face>());
						}

						if (!dicFace2HashList.ContainsKey(face))
						{
							dicFace2HashList.Add(face, new List<int>());
						}

						dicHash2FaceList[item].Add(face);
						dicFace2HashList[face].Add(item);
						if (!dicFace2IsClipped.ContainsKey(face))
						{
							dicFace2IsClipped.Add(face, true);
						}
						else
						{
							dicFace2IsClipped[face] = true;
						}
					}
				}
			}

			public static int GetNewHash()
			{
				int num = 0;
				lock (typeof(MeshDataConnectivity))
				{
					num = s_CurrentSharedFaceHash;
					s_CurrentSharedFaceHash++;
				}
				return num;
			}

			public void NotifyNewCapFace(int nHash, int nSubMesh, int nFaceIndex)
			{
				Face face = new Face(nSubMesh, nFaceIndex);
				if (!dicHash2FaceList.ContainsKey(nHash))
				{
					dicHash2FaceList.Add(nHash, new List<Face>());
				}
				dicHash2FaceList[nHash].Add(face);
				if (!dicFace2HashList.ContainsKey(face))
				{
					dicFace2HashList.Add(face, new List<int>());
				}
				dicFace2HashList[face].Add(nHash);
			}

			public void NotifyRemappedFace(MeshDataConnectivity source, int nSourceSubMesh, int nSourceFaceIndex, int nDestSubMesh, int nDestFaceIndex)
			{
				Face key = new Face(nSourceSubMesh, nSourceFaceIndex);
				Face face = new Face(nDestSubMesh, nDestFaceIndex);
				if (source.dicFace2HashList.ContainsKey(key))
				{
					foreach (int item in source.dicFace2HashList[key])
					{
						if (!dicHash2FaceList.ContainsKey(item))
						{
							dicHash2FaceList.Add(item, new List<Face>());
						}

						if (!dicFace2HashList.ContainsKey(face))
						{
							dicFace2HashList.Add(face, new List<int>());
						}

						dicHash2FaceList[item].Add(face);
						dicFace2HashList[face].Add(item);
						if (source.dicFace2IsClipped.ContainsKey(key))
						{
							if (!dicFace2IsClipped.ContainsKey(face))
							{
								dicFace2IsClipped.Add(face, true);
							}
							else
							{
								dicFace2IsClipped[face] = true;
							}
						}
					}
				}
			}
		}

		public class MeshData
		{
			public class IncreasingSizeComparer : IComparer<MeshData>
			{
				private int nSplitAxis;

				public IncreasingSizeComparer(int nSplitAxis)
				{
					this.nSplitAxis = nSplitAxis;
				}

				public int Compare(MeshData a, MeshData b)
				{
					Vector3 v3Min = a.v3Min;
					Vector3 v3Max = a.v3Max;
					Vector3 v3Min2 = b.v3Min;
					Vector3 v3Max2 = b.v3Max;
					if (nSplitAxis == 0)
					{
						return v3Max.x - v3Min.x - (v3Max2.x - v3Min2.x) < 0f ? (-1) : 1;
					}

					if (nSplitAxis == 1)
					{
						return v3Max.y - v3Min.y - (v3Max2.y - v3Min2.y) < 0f ? (-1) : 1;
					}

					if (nSplitAxis == 2)
					{
						return v3Max.z - v3Min.z - (v3Max2.z - v3Min2.z) < 0f ? (-1) : 1;
					}

					return Mathf.Max(v3Max.x - v3Min.x, v3Max.y - v3Min.y, v3Max.z - v3Min.z) - Mathf.Max(v3Max2.x - v3Min2.x, v3Max2.y - v3Min2.y, v3Max2.z - v3Min2.z) < 0f ? (-1) : 1;
				}
			}

			public class DecreasingSizeComparer : IComparer<MeshData>
			{
				private int nSplitAxis;

				public DecreasingSizeComparer(int nSplitAxis)
				{
					this.nSplitAxis = nSplitAxis;
				}

				public int Compare(MeshData a, MeshData b)
				{
					Vector3 v3Min = a.v3Min;
					Vector3 v3Max = a.v3Max;
					Vector3 v3Min2 = b.v3Min;
					Vector3 v3Max2 = b.v3Max;
					if (nSplitAxis == 0)
					{
						return (v3Max.x - v3Min.x - (v3Max2.x - v3Min2.x) < 0f) ? 1 : (-1);
					}
					if (nSplitAxis == 1)
					{
						return (v3Max.y - v3Min.y - (v3Max2.y - v3Min2.y) < 0f) ? 1 : (-1);
					}
					if (nSplitAxis == 2)
					{
						return (v3Max.z - v3Min.z - (v3Max2.z - v3Min2.z) < 0f) ? 1 : (-1);
					}
					return (Mathf.Max(v3Max.x - v3Min.x, v3Max.y - v3Min.y, v3Max.z - v3Min.z) - Mathf.Max(v3Max2.x - v3Min2.x, v3Max2.y - v3Min2.y, v3Max2.z - v3Min2.z) < 0f) ? 1 : (-1);
				}
			}

			public int nSubMeshCount;

			public int[][] aaIndices;

			public int nSplitCloseSubMesh;

			public VertexData[] aVertexData;

			public Vector3 v3Position;

			public Quaternion qRotation;

			public Vector3 v3Scale;

			public Vector3 v3Min;

			public Vector3 v3Max;

			public int nCurrentVertexHash;

			public Material[] aMaterials;

			public MeshDataConnectivity meshDataConnectivity;

			private MeshData()
			{
				meshDataConnectivity = new MeshDataConnectivity();
				aMaterials = new Material[1];
				aMaterials[0] = null;
			}

			public MeshData(Material[] aMaterials, List<int>[] alistIndices, List<VertexData> listVertexData, int nSplitCloseSubMesh, Vector3 v3Position, Quaternion qRotation, Vector3 v3Scale, Matrix4x4 mtxTransformVertices, bool bUseTransform, bool bBuildVertexHashData)
			{
				nSubMeshCount = alistIndices.Length;
				aaIndices = new int[nSubMeshCount][];
				for (int i = 0; i < nSubMeshCount; i++)
				{
					aaIndices[i] = alistIndices[i].ToArray();
				}
				this.nSplitCloseSubMesh = nSplitCloseSubMesh;
				aVertexData = listVertexData.ToArray();
				if (bUseTransform)
				{
					for (int j = 0; j < aVertexData.Length; j++)
					{
						aVertexData[j].v3Vertex = mtxTransformVertices.MultiplyPoint3x4(aVertexData[j].v3Vertex);
					}
				}
				ComputeMinMax(aVertexData, ref v3Min, ref v3Max);
				this.v3Position = v3Position;
				this.qRotation = qRotation;
				this.v3Scale = v3Scale;
				meshDataConnectivity = new MeshDataConnectivity();
				if (bBuildVertexHashData)
				{
					BuildVertexHashData();
				}
				if (aMaterials != null)
				{
					this.aMaterials = new Material[aMaterials.Length];
					aMaterials.CopyTo(this.aMaterials, 0);
				}
				else
				{
					this.aMaterials = new Material[1];
					this.aMaterials[0] = null;
				}
			}

			public MeshData(Transform transform, Mesh mesh, Material[] aMaterials, Matrix4x4 mtxLocalToWorld, bool bTransformVerticesToWorld, int nSplitCloseSubMesh, bool bBuildVertexHashData)
				: this(transform.position, transform.rotation, transform.localScale, mesh, aMaterials, mtxLocalToWorld, bTransformVerticesToWorld, nSplitCloseSubMesh, bBuildVertexHashData)
			{
			}

			public MeshData(Vector3 v3Position, Quaternion qRotation, Vector3 v3Scale, Mesh mesh, Material[] aMaterials, Matrix4x4 mtxLocalToWorld, bool bTransformVerticesToWorld, int nSplitCloseSubMesh, bool bBuildVertexHashData)
			{
				nSubMeshCount = mesh.subMeshCount;
				aaIndices = new int[nSubMeshCount][];
				for (int i = 0; i < nSubMeshCount; i++)
				{
					aaIndices[i] = mesh.GetTriangles(i);
				}
				this.nSplitCloseSubMesh = nSplitCloseSubMesh;
				aVertexData = VertexData.BuildVertexDataArray(mesh, mtxLocalToWorld, bTransformVerticesToWorld);
				ComputeMinMax(aVertexData, ref v3Min, ref v3Max);
				this.v3Position = v3Position;
				this.qRotation = qRotation;
				this.v3Scale = v3Scale;
				if (bTransformVerticesToWorld)
				{
					v3Scale = Vector3.one;
				}
				meshDataConnectivity = new MeshDataConnectivity();
				if (bBuildVertexHashData)
				{
					BuildVertexHashData();
				}
				if (aMaterials != null)
				{
					this.aMaterials = new Material[aMaterials.Length];
					aMaterials.CopyTo(this.aMaterials, 0);
				}
				else
				{
					this.aMaterials = new Material[1];
					this.aMaterials[0] = null;
				}
			}

			public static MeshData CreateBoxMeshData(Vector3 v3Pos, Quaternion qRot, Vector3 v3Scale, Vector3 v3Min, Vector3 v3Max)
			{
				MeshData meshData = new MeshData();
				meshData.nSubMeshCount = 1;
				meshData.aaIndices = new int[1][];
				meshData.aaIndices[0] = new int[36]
				{
					1, 0, 3, 1, 3, 2, 4, 5, 7, 5,
					6, 7, 0, 4, 3, 4, 7, 3, 7, 2,
					3, 7, 6, 2, 5, 0, 1, 5, 4, 0,
					6, 1, 2, 6, 5, 1
				};
				meshData.nSplitCloseSubMesh = 0;
				Vector3[] array = new Vector3[8]
				{
					new Vector3(v3Min.x, v3Min.y, v3Min.z),
					new Vector3(v3Min.x, v3Min.y, v3Max.z),
					new Vector3(v3Max.x, v3Min.y, v3Max.z),
					new Vector3(v3Max.x, v3Min.y, v3Min.z),
					new Vector3(v3Min.x, v3Max.y, v3Min.z),
					new Vector3(v3Min.x, v3Max.y, v3Max.z),
					new Vector3(v3Max.x, v3Max.y, v3Max.z),
					new Vector3(v3Max.x, v3Max.y, v3Min.z)
				};
				meshData.aVertexData = new VertexData[array.Length];
				for (int i = 0; i < array.Length; i++)
				{
					meshData.aVertexData[i] = new VertexData(i);
					meshData.aVertexData[i].v3Vertex = array[i];
				}
				meshData.v3Position = v3Pos;
				meshData.qRotation = qRot;
				meshData.v3Scale = v3Scale;
				meshData.v3Min = v3Min;
				meshData.v3Max = v3Max;
				meshData.nCurrentVertexHash = 8;
				return meshData;
			}

			public MeshData GetDeepCopy()
			{
				MeshData meshData = new MeshData();
				meshData.nSubMeshCount = nSubMeshCount;
				meshData.aaIndices = new int[nSubMeshCount][];
				for (int i = 0; i < nSubMeshCount; i++)
				{
					meshData.aaIndices[i] = new int[aaIndices[i].Length];
					aaIndices[i].CopyTo(meshData.aaIndices[i], 0);
				}
				meshData.nSplitCloseSubMesh = nSplitCloseSubMesh;
				meshData.aVertexData = new VertexData[aVertexData.Length];
				aVertexData.CopyTo(meshData.aVertexData, 0);
				meshData.v3Position = v3Position;
				meshData.qRotation = qRotation;
				meshData.v3Scale = v3Scale;
				meshData.v3Min = v3Min;
				meshData.v3Max = v3Max;
				meshData.nCurrentVertexHash = nCurrentVertexHash;
				meshData.meshDataConnectivity = meshDataConnectivity.GetDeepCopy();
				meshData.aMaterials = new Material[aMaterials.Length];
				aMaterials.CopyTo(meshData.aMaterials, 0);
				return meshData;
			}

			public bool FillMeshFilter(MeshFilter meshFilter, bool bTransformVerticesToLocal)
			{
				meshFilter.transform.position = v3Position;
				meshFilter.transform.rotation = qRotation;
				meshFilter.transform.localScale = v3Scale;
				meshFilter.sharedMesh = new Mesh();
				Mesh sharedMesh = meshFilter.sharedMesh;
				VertexData.SetMeshDataFromVertexDataArray(meshFilter, this, bTransformVerticesToLocal);
				sharedMesh.subMeshCount = nSubMeshCount;
				for (int i = 0; i < nSubMeshCount; i++)
				{
					sharedMesh.SetTriangles(aaIndices[i], i);
				}
				sharedMesh.RecalculateBounds();
				sharedMesh.Optimize();
				return true;
			}

			public static void ComputeMinMax(IEnumerable<VertexData> VertexData, ref Vector3 v3Min, ref Vector3 v3Max)
			{
				v3Min = new Vector3(float.MaxValue, float.MaxValue, float.MaxValue);
				v3Max = new Vector3(float.MinValue, float.MinValue, float.MinValue);
				foreach (VertexData VertexDatum in VertexData)
				{
					if (VertexDatum.v3Vertex.x < v3Min.x)
					{
						v3Min.x = VertexDatum.v3Vertex.x;
					}
					if (VertexDatum.v3Vertex.y < v3Min.y)
					{
						v3Min.y = VertexDatum.v3Vertex.y;
					}
					if (VertexDatum.v3Vertex.z < v3Min.z)
					{
						v3Min.z = VertexDatum.v3Vertex.z;
					}
					if (VertexDatum.v3Vertex.x > v3Max.x)
					{
						v3Max.x = VertexDatum.v3Vertex.x;
					}
					if (VertexDatum.v3Vertex.y > v3Max.y)
					{
						v3Max.y = VertexDatum.v3Vertex.y;
					}
					if (VertexDatum.v3Vertex.z > v3Max.z)
					{
						v3Max.z = VertexDatum.v3Vertex.z;
					}
				}
			}

			private void BuildVertexHashData()
			{
				List<Dictionary<int, Vector3>> list = new List<Dictionary<int, Vector3>>();
				List<float> list2 = new List<float>();
				int num = aVertexData.Length / Parameters.VERTICESSPACESUBDIVISION + 1;
				for (int i = 0; i < num; i++)
				{
					float item = v3Min.y + (float)(i + 1) / (float)num * (v3Max.y - v3Min.y);
					list.Add(new Dictionary<int, Vector3>());
					list2.Add(item);
				}

				int[] array = new int[3];
				nCurrentVertexHash = 0;
				int num2 = 0;
				for (int j = 0; j < aVertexData.Length; j++)
				{
					Vector3 v3Vertex = aVertexData[j].v3Vertex;
					int num3 = Mathf.FloorToInt((v3Vertex.y - v3Min.y) / (v3Max.y - v3Min.y) * (float)list2.Count);
					if (num3 < 0)
					{
						num3 = 0;
					}

					if (num3 >= list2.Count)
					{
						num3 = list2.Count - 1;
					}

					array[0] = num3;
					array[1] = -1;
					array[2] = -1;
					int num4 = 1;
					if (Mathf.Abs(list2[num3] - v3Vertex.y) < Parameters.EPSILONDISTANCEPLANE && num3 < list2.Count - 1)
					{
						array[num4++] = num3 + 1;
					}

					if (num3 > 0 && Mathf.Abs(list2[num3 - 1] - v3Vertex.y) < Parameters.EPSILONDISTANCEPLANE)
					{
						array[num4++] = num3 - 1;
					}

					int num5 = -1;
					foreach (int num6 in array)
					{
						if (num6 != -1)
						{
							foreach (KeyValuePair<int, Vector3> item2 in list[num6])
							{
								if (Vector3.Distance(item2.Value, v3Vertex) < Parameters.EPSILONDISTANCEVERTEX)
								{
									num5 = item2.Key;
									break;
								}
							}
						}
					}

					if (num5 == -1)
					{
						int num7 = nCurrentVertexHash++;
						list[num3].Add(num7, v3Vertex);
						aVertexData[j].nVertexHash = num7;
						num2++;
					}
					else
					{
						aVertexData[j].nVertexHash = num5;
					}
				}
			}

			public bool GetSharedFacesArea(FracturedObject fracturedComponent, MeshData meshData2, out float fSharedArea)
			{
				fSharedArea = 0f;
				bool result = false;
				foreach (int key in meshDataConnectivity.dicHash2FaceList.Keys)
				{
					if (meshData2.meshDataConnectivity.dicHash2FaceList.ContainsKey(key))
					{
						foreach (MeshDataConnectivity.Face item in meshDataConnectivity.dicHash2FaceList[key])
						{
							Vector3 v3Vertex = aVertexData[aaIndices[item.nSubMesh][item.nFaceIndex * 3]].v3Vertex;
							Vector3 v3Vertex2 = aVertexData[aaIndices[item.nSubMesh][item.nFaceIndex * 3 + 1]].v3Vertex;
							Vector3 v3Vertex3 = aVertexData[aaIndices[item.nSubMesh][item.nFaceIndex * 3 + 2]].v3Vertex;
							float magnitude = Vector3.Cross(v3Vertex3 - v3Vertex, v3Vertex2 - v3Vertex).magnitude;
							foreach (MeshDataConnectivity.Face item2 in meshData2.meshDataConnectivity.dicHash2FaceList[key])
							{
								Vector3 v3Vertex4 = meshData2.aVertexData[meshData2.aaIndices[item2.nSubMesh][item2.nFaceIndex * 3]].v3Vertex;
								Vector3 v3Vertex5 = meshData2.aVertexData[meshData2.aaIndices[item2.nSubMesh][item2.nFaceIndex * 3 + 1]].v3Vertex;
								Vector3 v3Vertex6 = meshData2.aVertexData[meshData2.aaIndices[item2.nSubMesh][item2.nFaceIndex * 3 + 2]].v3Vertex;
								float magnitude2 = Vector3.Cross(v3Vertex6 - v3Vertex4, v3Vertex5 - v3Vertex4).magnitude;
								bool flag = false;
								if (Face2InsideFace1(fracturedComponent, this, meshData2, item, item2))
								{
									flag = true;
								}
								else if (Face2InsideFace1(fracturedComponent, meshData2, this, item2, item))
								{
									flag = true;
								}

								if (flag)
								{
									fSharedArea += Mathf.Min(magnitude, magnitude2);
									result = true;
								}
							}
						}
					}
				}

				return result;
			}

			private static bool Face2InsideFace1(FracturedObject fracturedComponent, MeshData meshData1, MeshData meshData2, MeshDataConnectivity.Face face1, MeshDataConnectivity.Face face2)
			{
				if (fracturedComponent.FracturePattern == FracturedObject.EFracturePattern.BSP && !meshData1.meshDataConnectivity.dicFace2IsClipped.ContainsKey(face1) && !meshData2.meshDataConnectivity.dicFace2IsClipped.ContainsKey(face2))
				{
					return true;
				}
				Vector3 v3Vertex = meshData1.aVertexData[meshData1.aaIndices[face1.nSubMesh][face1.nFaceIndex * 3]].v3Vertex;
				Vector3 v3Vertex2 = meshData1.aVertexData[meshData1.aaIndices[face1.nSubMesh][face1.nFaceIndex * 3 + 1]].v3Vertex;
				Vector3 v3Vertex3 = meshData1.aVertexData[meshData1.aaIndices[face1.nSubMesh][face1.nFaceIndex * 3 + 2]].v3Vertex;
				Vector3 vector = -Vector3.Cross(v3Vertex2 - v3Vertex, v3Vertex3 - v3Vertex);
				float magnitude = vector.magnitude;
				if (magnitude < Parameters.EPSILONCROSSPRODUCT)
				{
					return false;
				}
				Quaternion q = Quaternion.LookRotation(vector.normalized, (v3Vertex2 - v3Vertex).normalized);
				Matrix4x4 inverse = Matrix4x4.TRS(v3Vertex, q, Vector3.one).inverse;
				Vector3 v3Vertex4 = meshData2.aVertexData[meshData2.aaIndices[face2.nSubMesh][face2.nFaceIndex * 3]].v3Vertex;
				Vector3 v3Vertex5 = meshData2.aVertexData[meshData2.aaIndices[face2.nSubMesh][face2.nFaceIndex * 3 + 1]].v3Vertex;
				Vector3 v3Vertex6 = meshData2.aVertexData[meshData2.aaIndices[face2.nSubMesh][face2.nFaceIndex * 3 + 2]].v3Vertex;
				Vector3 v = (v3Vertex4 + v3Vertex5 + v3Vertex6) / 3f;
				v = inverse.MultiplyPoint3x4(v);
				Vector3 vector2 = inverse.MultiplyPoint3x4(v3Vertex);
				Vector3 vector3 = inverse.MultiplyPoint3x4(v3Vertex2);
				Vector3 vector4 = inverse.MultiplyPoint3x4(v3Vertex3);
				Vector3 lhs = vector4 - vector3;
				Vector3 lhs2 = vector2 - vector4;
				bool flag = false;
				if (v.x >= 0f && Vector3.Cross(lhs, v - vector3).z <= 0f && Vector3.Cross(lhs2, v - vector4).z <= 0f)
				{
					flag = true;
				}
				if (!flag)
				{
					Vector3 vector5 = inverse.MultiplyPoint3x4(v3Vertex4);
					Vector3 vector6 = inverse.MultiplyPoint3x4(v3Vertex5);
					Vector3 vector7 = inverse.MultiplyPoint3x4(v3Vertex6);
					if (!flag && Fracturer.IntersectEdges2D(vector5.x, vector5.y, vector6.x, vector6.y, vector2.x, vector2.y, vector3.x, vector3.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector5.x, vector5.y, vector6.x, vector6.y, vector3.x, vector3.y, vector4.x, vector4.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector5.x, vector5.y, vector6.x, vector6.y, vector4.x, vector4.y, vector2.x, vector2.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector6.x, vector6.y, vector7.x, vector7.y, vector2.x, vector2.y, vector3.x, vector3.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector6.x, vector6.y, vector7.x, vector7.y, vector3.x, vector3.y, vector4.x, vector4.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector6.x, vector6.y, vector7.x, vector7.y, vector4.x, vector4.y, vector2.x, vector2.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector7.x, vector7.y, vector5.x, vector5.y, vector2.x, vector2.y, vector3.x, vector3.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector7.x, vector7.y, vector5.x, vector5.y, vector3.x, vector3.y, vector4.x, vector4.y))
					{
						flag = true;
					}
					if (!flag && Fracturer.IntersectEdges2D(vector7.x, vector7.y, vector5.x, vector5.y, vector4.x, vector4.y, vector2.x, vector2.y))
					{
						flag = true;
					}
				}
				return flag;
			}

			public static List<MeshData> PostProcessConnectivity(MeshData meshDataSource, MeshFaceConnectivity connectivity, MeshDataConnectivity meshConnectivity, List<int>[] alistIndices, List<VertexData> listVertexData, int nSplitCloseSubMesh, int nCurrentVertexHash, bool bTransformToLocal)
			{
				List<MeshData> list = new List<MeshData>();
				List<int>[] array = new List<int>[alistIndices.Length];
				int[] array2 = new int[alistIndices.Length];
				int num = 0;
				List<int>[] array3 = new List<int>[alistIndices.Length];
				List<VertexData> list2 = new List<VertexData>();
				Dictionary<int, int> dictionary = new Dictionary<int, int>();
				for (int i = 0; i < alistIndices.Length; i++)
				{
					array[i] = new List<int>();
					for (int j = 0; j < alistIndices[i].Count / 3; j++)
					{
						array[i].Add(j);
					}
					array2[i] = num;
					num += alistIndices[i].Count / 3;
					array3[i] = new List<int>();
				}
				while (StillHasFacesToProcess(array))
				{
					for (int k = 0; k < array.Length; k++)
					{
						if (array[k].Count > 0)
						{
							dictionary.Clear();
							list2.Clear();
							MeshDataConnectivity meshConnectivityOut = new MeshDataConnectivity();
							for (int l = 0; l < alistIndices.Length; l++)
							{
								array3[l].Clear();
							}
							LookForClosedObjectRecursive(connectivity, meshConnectivity, k, array[k][0], alistIndices, listVertexData, array, array2, array3, list2, dictionary, meshConnectivityOut);
							Vector3 zero = Vector3.zero;
							Vector3 zero2 = Vector3.zero;
							ComputeMinMax(list2, ref zero, ref zero2);
							Vector3 pos = (zero + zero2) * 0.5f;
							Matrix4x4 mtxTransformVertices = Matrix4x4.TRS(pos, meshDataSource.qRotation, meshDataSource.v3Scale);
							MeshData meshData = new MeshData(meshDataSource.aMaterials, array3, list2, nSplitCloseSubMesh, pos, meshDataSource.qRotation, meshDataSource.v3Scale, mtxTransformVertices, bTransformToLocal, false);
							meshData.meshDataConnectivity = meshConnectivityOut;
							meshData.nCurrentVertexHash = nCurrentVertexHash;
							list.Add(meshData);
						}
					}
				}
				return list;
			}

			private static bool StillHasFacesToProcess(List<int>[] alistFacesRemaining)
			{
				foreach (List<int> list in alistFacesRemaining)
				{
					if (list.Count > 0)
					{
						return true;
					}
				}
				return false;
			}

			private static void LookForClosedObjectRecursive(MeshFaceConnectivity connectivity, MeshDataConnectivity meshConnectivity, int nSubMeshStart, int nFaceSubMeshStart, List<int>[] alistIndicesIn, List<VertexData> listVertexDataIn, List<int>[] alistFacesRemainingInOut, int[] aLinearFaceIndexStart, List<int>[] alistIndicesOut, List<VertexData> listVertexDataOut, Dictionary<int, int> dicVertexRemap, MeshDataConnectivity meshConnectivityOut)
			{
				MeshFaceConnectivity.TriangleData triangleData = connectivity.listTriangles[aLinearFaceIndexStart[nSubMeshStart] + nFaceSubMeshStart];
				if (triangleData.bVisited)
				{
					return;
				}
				meshConnectivityOut.NotifyRemappedFace(meshConnectivity, nSubMeshStart, nFaceSubMeshStart, nSubMeshStart, alistIndicesOut[nSubMeshStart].Count / 3);
				for (int i = 0; i < 3; i++)
				{
					int num = alistIndicesIn[nSubMeshStart][nFaceSubMeshStart * 3 + i];
					if (dicVertexRemap.ContainsKey(num))
					{
						alistIndicesOut[nSubMeshStart].Add(dicVertexRemap[num]);
						continue;
					}
					int count = listVertexDataOut.Count;
					alistIndicesOut[nSubMeshStart].Add(count);
					listVertexDataOut.Add(listVertexDataIn[num].Copy());
					dicVertexRemap.Add(num, count);
				}
				alistFacesRemainingInOut[nSubMeshStart].Remove(nFaceSubMeshStart);
				triangleData.bVisited = true;
				for (int j = 0; j < 3; j++)
				{
					MeshFaceConnectivity.TriangleData triangleData2 = null;
					for (int k = 0; k < triangleData.alistNeighborSubMeshes[j].Count; k++)
					{
						if (triangleData.alistNeighborSubMeshes[j][k] != -1 && triangleData.alistNeighborTriangles[j][k] != -1)
						{
							triangleData2 = connectivity.listTriangles[aLinearFaceIndexStart[triangleData.alistNeighborSubMeshes[j][k]] + triangleData.alistNeighborTriangles[j][k]];
						}
						if (triangleData2 != null && !triangleData2.bVisited)
						{
							LookForClosedObjectRecursive(connectivity, meshConnectivity, triangleData2.nSubMesh, triangleData2.nTriangle, alistIndicesIn, listVertexDataIn, alistFacesRemainingInOut, aLinearFaceIndexStart, alistIndicesOut, listVertexDataOut, dicVertexRemap, meshConnectivityOut);
						}
					}
				}
			}
		}

		[Serializable]
		public class SupportPlane
		{
			public bool GUIExpanded;

			public string GUIName;

			public bool GUIShowInScene;

			public Vector3 v3PlanePosition;

			public Quaternion qPlaneRotation;

			public Vector3 v3PlaneScale;

			public Mesh planeMesh;

			public FracturedObject fracturedObject;

			public SupportPlane(FracturedObject fracturedObject)
			{
				GUIExpanded = true;
				GUIName = "New Support Plane";
				GUIShowInScene = true;
				this.fracturedObject = fracturedObject;
				planeMesh = new Mesh();
				Vector3[] array = new Vector3[4];
				Vector3[] array2 = new Vector3[4];
				Vector2[] uv = new Vector2[4];
				int[] triangles = new int[6] { 0, 1, 2, 0, 2, 3 };
				array[0] = new Vector3(-1f, 0f, -1f);
				array[1] = new Vector3(-1f, 0f, 1f);
				array[2] = new Vector3(1f, 0f, 1f);
				array[3] = new Vector3(1f, 0f, -1f);
				array2[0] = new Vector3(0f, 1f, 0f);
				array2[1] = new Vector3(0f, 1f, 0f);
				array2[2] = new Vector3(0f, 1f, 0f);
				array2[3] = new Vector3(0f, 1f, 0f);
				bool flag = false;
				float num = 1f;
				if ((bool)fracturedObject.SourceObject && (bool)fracturedObject.SourceObject.renderer)
				{
					flag = true;
				}
				if (flag)
				{
					Bounds bounds = fracturedObject.SourceObject.renderer.bounds;
					num = bounds.extents.y;
					for (int i = 0; i < array.Length; i++)
					{
						float num2 = 1.3f;
						float num3 = Mathf.Max(bounds.extents.z * num2, bounds.extents.x * num2);
						array[i] = Vector3.Scale(array[i], new Vector3(num3, num3, num3)) + fracturedObject.transform.position;
						array[i] = fracturedObject.transform.InverseTransformPoint(array[i]);
					}
					v3PlanePosition = fracturedObject.transform.position - new Vector3(0f, num - 0.05f, 0f);
					v3PlanePosition = fracturedObject.transform.InverseTransformPoint(v3PlanePosition);
					qPlaneRotation = Quaternion.identity;
				}
				else
				{
					for (int j = 0; j < array.Length; j++)
					{
						array[j] += fracturedObject.transform.position;
						array[j] = fracturedObject.transform.InverseTransformPoint(array[j]);
					}
					v3PlanePosition = new Vector3(0f, (-num) * 0.5f + 0.05f, 0f);
					qPlaneRotation = Quaternion.identity;
				}
				v3PlaneScale = Vector3.one;
				planeMesh.vertices = array;
				planeMesh.normals = array2;
				planeMesh.uv = uv;
				planeMesh.triangles = triangles;
			}

			public Matrix4x4 GetLocalMatrix()
			{
				return Matrix4x4.TRS(v3PlanePosition, qPlaneRotation, v3PlaneScale);
			}

			public Vector3[] GetBoundingBoxSegments(Bounds bounds)
			{
				Vector3 min = bounds.min;
				Vector3 max = bounds.max;
				Vector3[] array = new Vector3[8]
				{
					new Vector3(min.x, min.y, min.z),
					new Vector3(min.x, min.y, max.z),
					new Vector3(max.x, min.y, max.z),
					new Vector3(max.x, min.y, min.z),
					new Vector3(min.x, max.y, min.z),
					new Vector3(min.x, max.y, max.z),
					new Vector3(max.x, max.y, max.z),
					new Vector3(max.x, max.y, min.z)
				};
				Vector3[] array2 = new Vector3[24];
				for (int i = 0; i < 4; i++)
				{
					array2[i * 2] = array[i % 4];
					array2[i * 2 + 1] = array[(i + 1) % 4];
				}
				for (int j = 4; j < 8; j++)
				{
					array2[j * 2] = array[j % 4 + 4];
					array2[j * 2 + 1] = array[(j + 1) % 4 + 4];
				}
				for (int k = 8; k < 12; k++)
				{
					array2[k * 2] = array[k % 4];
					array2[k * 2 + 1] = array[k % 4 + 4];
				}
				return array2;
			}

			public bool IntersectsWith(GameObject otherGameObject, bool bBelowIsAlsoValid = false)
			{
				MeshFilter component = otherGameObject.GetComponent<MeshFilter>();
				if (planeMesh == null || component == null)
				{
					return false;
				}
				Vector3[] vertices = planeMesh.vertices;
				Matrix4x4 matrix4x = fracturedObject.transform.localToWorldMatrix * GetLocalMatrix();
				for (int i = 0; i < 4; i++)
				{
					vertices[i] = matrix4x.MultiplyPoint3x4(vertices[i]);
					vertices[i] = otherGameObject.transform.InverseTransformPoint(vertices[i]);
				}
				Plane plane = new Plane(vertices[0], vertices[1], vertices[2]);
				Vector3 normalized = (vertices[1] - vertices[0]).normalized;
				Vector3 normalized2 = (vertices[2] - vertices[1]).normalized;
				Matrix4x4 inverse = Matrix4x4.TRS(vertices[0], Quaternion.LookRotation(normalized, Vector3.Cross(normalized, normalized2)), Vector3.one).inverse;
				float magnitude = (vertices[2] - vertices[1]).magnitude;
				float fLimitUp = component.sharedMesh.bounds.max.y - component.sharedMesh.bounds.min.y;
				float magnitude2 = (vertices[1] - vertices[0]).magnitude;
				Vector3[] boundingBoxSegments = GetBoundingBoxSegments(component.sharedMesh.bounds);
				for (int j = 0; j < 12; j++)
				{
					if (TestSegmentVsPlane(boundingBoxSegments[j * 2], boundingBoxSegments[j * 2 + 1], plane, inverse, magnitude, fLimitUp, magnitude2))
					{
						return true;
					}
				}
				if (bBelowIsAlsoValid)
				{
					float distanceToPoint = plane.GetDistanceToPoint(component.sharedMesh.bounds.center);
					if (distanceToPoint < 0f)
					{
						for (int k = 0; k < 24; k++)
						{
							boundingBoxSegments[k] += plane.normal * (-distanceToPoint);
						}
						for (int l = 0; l < 12; l++)
						{
							if (TestSegmentVsPlane(boundingBoxSegments[l * 2], boundingBoxSegments[l * 2 + 1], plane, inverse, magnitude, fLimitUp, magnitude2))
							{
								return true;
							}
						}
					}
				}
				return false;
			}

			private static bool TestSegmentVsPlane(Vector3 v1, Vector3 v2, Plane plane, Matrix4x4 mtxToPlaneLocal, float fLimitRight, float fLimitUp, float fLimitForward)
			{
				float num = v1.x * plane.normal.x + v1.y * plane.normal.y + v1.z * plane.normal.z + plane.distance;
				float num2 = v2.x * plane.normal.x + v2.y * plane.normal.y + v2.z * plane.normal.z + plane.distance;
				if (num * num2 > 0f)
				{
					return false;
				}
				float enter = 0f;
				Ray ray = new Ray(v1, (v2 - v1).normalized);
				if (plane.Raycast(ray, out enter))
				{
					Vector3 v3 = v1 + (v2 - v1).normalized * enter;
					Vector3 vector = mtxToPlaneLocal.MultiplyPoint3x4(v3);
					if (enter <= fLimitUp && vector.x >= 0f && vector.x <= fLimitRight && vector.z >= 0f && vector.z <= fLimitForward)
					{
						return true;
					}
				}
				return false;
			}
		}
}
