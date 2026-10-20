using System.Runtime.InteropServices;
using System;
using UnityEngine;

namespace UltimateFracturing
{
		public static class ConcaveColliderInterface
		{
			private struct SConvexDecompositionInfoInOut
			{
				public uint uMaxHullVertices;

				public uint uMaxHulls;

				public float fPrecision;

				public float fBackFaceDistanceFactor;

				public uint uLegacyDepth;

				public uint uNormalizeInputMesh;

				public uint uUseFastVersion;

				public uint uTriangleCount;

				public uint uVertexCount;

				public int nHullsOut;
			}

			private struct SConvexDecompositionHullInfo
			{
				public int nVertexCount;

				public int nTriangleCount;
			}

			public delegate void LogDelegate([MarshalAs(UnmanagedType.LPStr)] string message);

			[DllImport("ConvexDecompositionDll")]
			private static extern void DllInit(bool bUseMultithreading);

			[DllImport("ConvexDecompositionDll")]
			private static extern void DllClose();

			[DllImport("ConvexDecompositionDll")]
			private static extern void SetLogFunctionPointer(IntPtr pfnUnity3DLog);

			[DllImport("ConvexDecompositionDll")]
			private static extern void SetProgressFunctionPointer(IntPtr pfnUnity3DProgress);

			[DllImport("ConvexDecompositionDll")]
			private static extern void CancelConvexDecomposition();

			[DllImport("ConvexDecompositionDll")]
			private static extern bool DoConvexDecomposition(ref SConvexDecompositionInfoInOut infoInOut, Vector3[] pfVertices, int[] puIndices);

			[DllImport("ConvexDecompositionDll")]
			private static extern bool GetHullInfo(uint uHullIndex, ref SConvexDecompositionHullInfo infoOut);

			[DllImport("ConvexDecompositionDll")]
			private static extern bool FillHullMeshData(uint uHullIndex, ref float pfVolumeOut, int[] pnIndicesOut, Vector3[] pfVerticesOut);

			public static int ComputeHull(GameObject gameObject, FracturedObject fracturedObject)
			{
				int nTotalTrianglesOut = 0;
				if (!ComputeHull(gameObject, fracturedObject.ConcaveColliderAlgorithm, fracturedObject.ConcaveColliderMaxHulls, fracturedObject.ConcaveColliderMaxHullVertices, fracturedObject.ConcaveColliderLegacySteps, fracturedObject.Verbose, out nTotalTrianglesOut) && fracturedObject.ConcaveColliderAlgorithm == FracturedObject.ECCAlgorithm.Fast)
				{
					if (fracturedObject.Verbose)
					{
						Debug.Log(gameObject.name + ": Falling back to normal convex decomposition algorithm");
					}
					if (!ComputeHull(gameObject, FracturedObject.ECCAlgorithm.Normal, fracturedObject.ConcaveColliderMaxHulls, fracturedObject.ConcaveColliderMaxHullVertices, fracturedObject.ConcaveColliderLegacySteps, fracturedObject.Verbose, out nTotalTrianglesOut) && fracturedObject.Verbose)
					{
						Debug.Log(gameObject.name + ": Falling back to box collider");
					}
				}
				return nTotalTrianglesOut;
			}

			private static bool ComputeHull(GameObject gameObject, FracturedObject.ECCAlgorithm eAlgorithm, int nMaxHulls, int nMaxHullVertices, int nLegacySteps, bool bVerbose, out int nTotalTrianglesOut)
			{
				MeshFilter component = gameObject.GetComponent<MeshFilter>();
				DllInit(true);
				SetLogFunctionPointer(Marshal.GetFunctionPointerForDelegate(new LogDelegate(Log)));
				SConvexDecompositionInfoInOut infoInOut = default(SConvexDecompositionInfoInOut);
				nTotalTrianglesOut = 0;
				if ((bool)component && (bool)component.sharedMesh)
				{
					uint num = (uint)Mathf.Max(1, nLegacySteps);
					infoInOut.uMaxHullVertices = (uint)Mathf.Max(3, nMaxHullVertices);
					infoInOut.uMaxHulls = (uint)nMaxHulls;
					infoInOut.fPrecision = 0.2f;
					infoInOut.fBackFaceDistanceFactor = 0.2f;
					infoInOut.uLegacyDepth = ((eAlgorithm == FracturedObject.ECCAlgorithm.Legacy) ? num : 0u);
					infoInOut.uNormalizeInputMesh = 0u;
					infoInOut.uUseFastVersion = ((eAlgorithm == FracturedObject.ECCAlgorithm.Fast) ? 1u : 0u);
					infoInOut.uTriangleCount = (uint)component.sharedMesh.triangles.Length / 3u;
					infoInOut.uVertexCount = (uint)component.sharedMesh.vertexCount;
					Vector3[] vertices = component.sharedMesh.vertices;
					if (DoConvexDecomposition(ref infoInOut, vertices, component.sharedMesh.triangles))
					{
						for (int i = 0; i < infoInOut.nHullsOut; i++)
						{
							SConvexDecompositionHullInfo infoOut = default(SConvexDecompositionHullInfo);
							GetHullInfo((uint)i, ref infoOut);
							if (infoOut.nTriangleCount > 0)
							{
								Vector3[] array = new Vector3[infoOut.nVertexCount];
								int[] array2 = new int[infoOut.nTriangleCount * 3];
								float pfVolumeOut = -1f;
								FillHullMeshData((uint)i, ref pfVolumeOut, array2, array);
								Mesh mesh = new Mesh();
								mesh.vertices = array;
								mesh.triangles = array2;
								mesh.uv = new Vector2[array.Length];
								mesh.RecalculateNormals();
								GameObject gameObject2 = new GameObject("Hull " + (i + 1));
								gameObject2.transform.position = gameObject.transform.position;
								gameObject2.transform.rotation = gameObject.transform.rotation;
								gameObject2.transform.localScale = gameObject.transform.localScale;
								gameObject2.transform.parent = gameObject.transform;
								gameObject2.layer = gameObject.layer;
								MeshCollider meshCollider = gameObject2.AddComponent<MeshCollider>();
								meshCollider.sharedMesh = null;
								meshCollider.sharedMesh = mesh;
								meshCollider.convex = true;
								nTotalTrianglesOut += infoOut.nTriangleCount;
							}
							else if (bVerbose)
							{
								Debug.LogWarning(gameObject.name + ": Error generating collider. ComputeHull() returned 0 triangles.");
							}
						}
						if (infoInOut.nHullsOut < 0 && bVerbose)
						{
							Debug.LogWarning(gameObject.name + ": Error generating collider. ComputeHull() returned no hulls.");
						}
					}
					else if (bVerbose)
					{
						Debug.LogWarning(gameObject.name + ": Error generating collider. ComputeHull() returned false.");
					}
				}
				DllClose();
				return nTotalTrianglesOut > 0;
			}

			private static void Log(string message)
			{
				Debug.Log(message);
			}
		}
}
