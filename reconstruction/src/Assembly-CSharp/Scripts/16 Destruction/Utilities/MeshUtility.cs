using System.Collections.Generic;
using System;
using UnityEngine;

namespace Destruction.Utilities
{
		public static class MeshUtility
		{
			private static List<Face> validFaces;

			private static List<Face> visibleFaces;

			private static List<Face> tmpFaces;

			public static Vector4[] RecalculateTangents(Vector3[] vertices, Vector2[] uv, Vector3[] normals, int[] triangles)
			{
				int num = triangles.Length;
				int num2 = vertices.Length;
				Vector3[] array = new Vector3[num2];
				Vector3[] array2 = new Vector3[num2];
				Vector4[] array3 = new Vector4[num2];
				for (long num3 = 0L; num3 < num; num3 += 3)
				{
					long num4 = triangles[num3];
					long num5 = triangles[num3 + 1];
					long num6 = triangles[num3 + 2];
					Vector3 vector = vertices[num4];
					Vector3 vector2 = vertices[num5];
					Vector3 vector3 = vertices[num6];
					Vector2 vector4 = uv[num4];
					Vector2 vector5 = uv[num5];
					Vector2 vector6 = uv[num6];
					float num7 = vector2.x - vector.x;
					float num8 = vector3.x - vector.x;
					float num9 = vector2.y - vector.y;
					float num10 = vector3.y - vector.y;
					float num11 = vector2.z - vector.z;
					float num12 = vector3.z - vector.z;
					float num13 = vector5.x - vector4.x;
					float num14 = vector6.x - vector4.x;
					float num15 = vector5.y - vector4.y;
					float num16 = vector6.y - vector4.y;
					float num17 = num13 * num16 - num14 * num15;
					float num18 = (Math.Abs(num17) < float.Epsilon ? 0f : (1f / num17));
					Vector3 vector7 = new Vector3((num16 * num7 - num15 * num8) * num18, (num16 * num9 - num15 * num10) * num18, (num16 * num11 - num15 * num12) * num18);
					Vector3 vector8 = new Vector3((num13 * num8 - num14 * num7) * num18, (num13 * num10 - num14 * num9) * num18, (num13 * num12 - num14 * num11) * num18);
					array[num4] += vector7;
					array[num5] += vector7;
					array[num6] += vector7;
					array2[num4] += vector8;
					array2[num5] += vector8;
					array2[num6] += vector8;
				}

				for (long num19 = 0L; num19 < num2; num19++)
				{
					Vector3 normal = normals[num19];
					Vector3 tangent = array[num19];
					Vector3.OrthoNormalize(ref normal, ref tangent);
					array3[num19].x = tangent.x;
					array3[num19].y = tangent.y;
					array3[num19].z = tangent.z;
					array3[num19].w = (Vector3.Dot(Vector3.Cross(normal, tangent), array2[num19]) < 0f ? (-1f) : 1f);
				}

				return array3;
			}

			public static void RecalculateTangents(this Mesh mesh)
			{
				int[] triangles = mesh.triangles;
				Vector3[] vertices = mesh.vertices;
				Vector2[] uv = mesh.uv;
				Vector3[] normals = mesh.normals;
				mesh.tangents = RecalculateTangents(vertices, uv, normals, triangles);
			}

			public static int[] ComputeHull(Vector3[] points)
			{
				if (points.Length < 3)
				{
					return null;
				}
				Face.points = points;
				Face face = new Face(0, 1, 2);
				Vector3 p = Centroid(points, 3, face);
				if (face.IsVisible(p))
				{
					face.Flip();
				}
				Face face2 = new Face(3, face.i0, face.i1);
				if (face2.IsVisible(p))
				{
					face2.Flip();
				}
				Face face3 = new Face(3, face.i1, face.i2);
				if (face3.IsVisible(p))
				{
					face3.Flip();
				}
				Face face4 = new Face(3, face.i2, face.i0);
				if (face4.IsVisible(p))
				{
					face4.Flip();
				}
				List<Face> list = new List<Face>();
				list.Add(face);
				list.Add(face2);
				list.Add(face3);
				list.Add(face4);
				validFaces = list;
				visibleFaces = new List<Face>(points.Length);
				tmpFaces = new List<Face>(points.Length);
				for (int i = 4; i < points.Length; i++)
				{
					p = points[i];
					visibleFaces.Clear();
					for (int j = 0; j < validFaces.Count; j++)
					{
						if (validFaces[j].IsVisible(p))
						{
							visibleFaces.Add(validFaces[j]);
						}
					}
					if (visibleFaces.Count == 0)
					{
						continue;
					}
					for (int k = 0; k < visibleFaces.Count; k++)
					{
						validFaces.Remove(visibleFaces[k]);
					}
					if (visibleFaces.Count == 1)
					{
						face = visibleFaces[0];
						validFaces.Add(new Face(i, face.i0, face.i1));
						validFaces.Add(new Face(i, face.i1, face.i2));
						validFaces.Add(new Face(i, face.i2, face.i0));
						continue;
					}
					if (visibleFaces.Count > 2000)
					{
						Debug.LogWarning("Visible faces is too big, " + visibleFaces.Count + " cancelling operation.");
						return new int[0];
					}
					tmpFaces.Clear();
					for (int l = 0; l < visibleFaces.Count; l++)
					{
						tmpFaces.Add(new Face(i, visibleFaces[l].i0, visibleFaces[l].i1));
						tmpFaces.Add(new Face(i, visibleFaces[l].i1, visibleFaces[l].i2));
						tmpFaces.Add(new Face(i, visibleFaces[l].i2, visibleFaces[l].i0));
					}
					if (tmpFaces.Count > 8000)
					{
						Debug.LogWarning("Temp faces is too big, " + tmpFaces.Count + " cancelling operation.");
						return new int[0];
					}
					for (int m = 0; m < tmpFaces.Count; m++)
					{
						Face face5 = tmpFaces[m];
						for (int n = 0; n < tmpFaces.Count; n++)
						{
							if (face5 != tmpFaces[n] && face5.IsVisible(tmpFaces[n].Centroid))
							{
								face5 = null;
								break;
							}
						}
						if (face5 != null)
						{
							validFaces.Add(face5);
						}
					}
				}
				int[] array = new int[validFaces.Count * 3];
				int num = 0;
				for (int num2 = 0; num2 < validFaces.Count; num2++)
				{
					array[num++] = validFaces[num2].i0;
					array[num++] = validFaces[num2].i1;
					array[num++] = validFaces[num2].i2;
				}
				return array;
			}

			private static Vector3 Centroid(Vector3[] points, int index, Face face)
			{
				Vector3 vector = points[index];
				vector += points[face.i0];
				vector += points[face.i1];
				vector += points[face.i2];
				return vector / 4f;
			}
		}
}
