using Destruction.Common;
using System.Collections.Generic;
using System.Collections;
using System.Diagnostics;
using System;
using UnityEngine;

namespace Destruction.Dynamic
{
		public abstract class BaseFracture : BaseDestructable
		{
			[SerializeField]
			protected bool immediate = true;

			[SerializeField]
			protected RangedInt shards = new RangedInt(3, 9);

			[SerializeField]
			protected int shardsPerFrame = 2;

			protected Vector3[] sortedVoronoiPoints;

			protected Vector3[] newVertices;

			protected Vector3[] newNormals;

			protected Vector2[] newUVs;

			protected int[] newTriangles;

			protected Dictionary<int, List<Vector3>> vert = new Dictionary<int, List<Vector3>>(50);

			protected readonly List<Vector4> planes = new List<Vector4>(100);

			private void Update()
			{
				if (!Complete)
				{
					return;
				}

				for (int i = 0; i < finalizedBrokenPieces.Count; i++)
				{
					finalizedBrokenPieces[i].transform.position = transform.position;
					finalizedBrokenPieces[i].transform.rotation = transform.rotation;
				}
			}

			protected abstract void CreateMeshPlanes(Vector3 point);

			protected override void BeginFracture(Vector3 point, float size)
			{
				if (Complete)
				{
					return;
				}

				Complete = true;
				LastImpactPoint = point;
				Vector3[] array = new Vector3[shards.Random()];
				for (int i = 0; i < array.Length; i++)
				{
					array[i] = Vector3.Scale(transform.lossyScale, transform.InverseTransformPoint(point)) + UnityEngine.Random.insideUnitSphere * size;
				}

				Stopwatch stopwatch = new Stopwatch();
				stopwatch.Start();
				InitializeDestruction();
				sortedVoronoiPoints = new Vector3[array.Length];
				array.CopyTo(sortedVoronoiPoints, 0);
				if (immediate)
				{
					ImmediateFracture(array);
				}
				else
				{
					StartCoroutine(SpreadFracture(array));
				}

				stopwatch.Stop();
			}

			protected virtual void ImmediateFracture(Vector3[] points)
			{
				for (int i = 0; i < points.Length; i++)
				{
					CalculateShard(points[i]);
				}
				FinalizeDestruction();
			}

			protected virtual IEnumerator SpreadFracture(Vector3[] points)
			{
				int currentShard = 0;
				int remainingShards = points.Length;
				while (remainingShards > 0)
				{
					for (int i = 0; i < Mathf.Min(shardsPerFrame, remainingShards); i++)
					{
						remainingShards--;
						CalculateShard(points[currentShard]);
						currentShard++;
					}
					yield return null;
				}
				FinalizeDestruction();
			}

			private void CalculateShard(Vector3 point)
			{
				planes.Clear();
				int num = CalculateVerts(point);
				if (num <= 3)
				{
					return;
				}

				newVertices = new Vector3[num];
				newNormals = new Vector3[num];
				newUVs = new Vector2[num];
				newTriangles = new int[num * 3];
				int num2 = 0;
				int num3 = 0;
				foreach (KeyValuePair<int, List<Vector3>> item in vert)
				{
					if (item.Value.Count < 3)
					{
						continue;
					}

					Vector3 vector = planes[item.Key];
					item.Value.SortAntiClockwiseOnPlane(vector);
					CreateNewVertex(item.Value[0] + point, vector, num2);
					for (int i = 1; i < item.Value.Count - 1; i++)
					{
						CreateNewVertex(item.Value[i] + point, vector, num2 + i);
						newTriangles[num3++] = num2;
						newTriangles[num3++] = num2 + i;
						newTriangles[num3++] = num2 + i + 1;
					}

					CreateNewVertex(item.Value[item.Value.Count - 1] + point, vector, num2 + item.Value.Count - 1);
					num2 += item.Value.Count;
					item.Value.Clear();
				}

				CreateShardMesh(point, -1f);
			}

			private void CreateNewVertex(Vector3 vertex, Vector3 normal, int index)
			{
				newNormals[index] = normal;
				newVertices[index] = vertex;
			}

			protected virtual int CalculateVerts(Vector3 point)
			{
				Array.Sort(sortedVoronoiPoints, (Vector3 p1, Vector3 p2) => (p1 - point).sqrMagnitude.CompareTo((p2 - point).sqrMagnitude));
				for (int num = 1; num < sortedVoronoiPoints.Length; num++)
				{
					Vector3 vector = sortedVoronoiPoints[num] - point;
					float sqrMagnitude = vector.sqrMagnitude;
					Vector4 item = vector.normalized;
					item.w = (-Mathf.Sqrt(sqrMagnitude)) / 2f;
					planes.Add(item);
				}
				CreateMeshPlanes(point);
				return GetVerticesInPlane();
			}

			protected virtual void InitializeDestruction()
			{
				SendMessage("OnPreDestruction", this, SendMessageOptions.DontRequireReceiver);
				if (immediate)
				{
					collider.enabled = false;
					if (rigidbody != null)
					{
						rigidbody.isKinematic = true;
					}
				}
			}

			protected void FinalizeDestruction()
			{
				foreach (Collider finalizedBrokenPiece in finalizedBrokenPieces)
				{
					finalizedBrokenPiece.rigidbody.isKinematic = false;
					if (!immediate && rigidbody != null && !rigidbody.isKinematic)
					{
						finalizedBrokenPiece.rigidbody.velocity = rigidbody.velocity;
						finalizedBrokenPiece.rigidbody.angularVelocity = rigidbody.angularVelocity;
					}
				}
				SendMessage("OnPostDestruction", finalizedBrokenPieces, SendMessageOptions.DontRequireReceiver);
				transform.DetachChildren();
				UnityEngine.Object.Destroy(gameObject);
			}

			protected virtual int GetVerticesInPlane()
			{
				int num = 0;
				vert.Clear();
				for (int i = 0; i < planes.Count; i++)
				{
					for (int j = i + 1; j < planes.Count; j++)
					{
						Vector3 vector = Vector3.Cross(planes[i], planes[j]);
						if (vector.sqrMagnitude <= 0.001f)
						{
							continue;
						}

						for (int k = j + 1; k < planes.Count; k++)
						{
							Vector3 vector2 = Vector3.Cross(planes[j], planes[k]);
							Vector3 vector3 = Vector3.Cross(planes[k], planes[i]);
							if (vector2.sqrMagnitude <= 0.001f || vector3.sqrMagnitude <= 0.001f)
							{
								continue;
							}

							float num2 = Vector3.Dot(planes[i], vector2);
							if (Mathf.Abs(num2) <= 0.001f)
							{
								continue;
							}

							Vector3 vector4 = (vector2 * planes[i].w + vector3 * planes[j].w + vector * planes[k].w) * (-1f / num2);
							int l;
							for (l = 0; l < planes.Count; l++)
							{
								Vector4 vector5 = planes[l];
								if (Vector3.Dot(vector5, vector4) + vector5.w > 0.001f)
								{
									break;
								}
							}

							if (l != planes.Count)
							{
								continue;
							}

							num += 3;
							AddVertex(vector4, i);
							AddVertex(vector4, j);
							AddVertex(vector4, k);
						}
					}
				}

				return num;
			}

			protected virtual void AddVertex(Vector3 potentialVertex, int planeIndex)
			{
				if (!vert.ContainsKey(planeIndex))
				{
					vert.Add(planeIndex, new List<Vector3>(50));
				}
				vert[planeIndex].Add(potentialVertex);
			}

			protected Shard CreateShardMesh(Vector3 point, float mass = -1f)
			{
				Shard shard = Shard.CreateShard(gameObject, newVertices, newNormals, newTriangles, newUVs);
				if (shard == null)
				{
					return null;
				}
				shard.transform.position = transform.position;
				shard.transform.rotation = transform.rotation;
				shard.renderer.sharedMaterial = new Material(renderer.material);
				shard.rigidbody.isKinematic = true;
				if (rigidbody != null)
				{
					Vector3 size = shard.renderer.bounds.size;
					float num = size.x * size.y * size.z;
					Vector3 size2 = renderer.bounds.size;
					float num2 = size2.x * size2.y * size2.z;
					shard.rigidbody.mass = rigidbody.mass * (num / num2);
				}
				if (!immediate && gameObject.activeInHierarchy && collider.enabled && shard.gameObject.activeInHierarchy && shard.collider.enabled)
				{
					Physics.IgnoreCollision(collider, shard.collider);
				}
				finalizedBrokenPieces.Add(shard.collider);
				return shard;
			}
		}
}
