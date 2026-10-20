using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Tools
{
		[AddComponentMenu("Destruction/Sticky Zone")]
		public class StickyZone : MonoBehaviour
		{
			private readonly Dictionary<Collider, Vector3> shardsStuckToMe = new Dictionary<Collider, Vector3>();

			private void Update()
			{
				if (shardsStuckToMe == null)
				{
					return;
				}
				foreach (KeyValuePair<Collider, Vector3> item in shardsStuckToMe)
				{
					item.Key.transform.position = transform.TransformPoint(item.Value);
				}
			}

			private void OnDisable()
			{
				foreach (KeyValuePair<Collider, Vector3> item in shardsStuckToMe)
				{
					UnstickObject(item.Key);
				}
			}

			private void StickObject(Collider shard)
			{
				if (shard == null)
				{
					return;
				}

				Object.Destroy(shard.rigidbody);
			}

			private void UnstickObject(Collider shard)
			{
				if (shard == null)
				{
					return;
				}
				if (shard.attachedRigidbody == null)
				{
					shard.gameObject.AddComponent<Rigidbody>();
				}
			}

			private static bool BoxIntersect(Bounds a, Bounds b)
			{
				return (b.min.x >= a.min.x && b.max.x <= a.max.x && b.min.y >= a.min.y && b.max.y <= a.max.y && b.min.z >= a.min.z && b.max.z <= a.max.z) || (a.max.x >= b.min.x && a.min.x <= b.max.x && a.max.y >= b.min.y && a.min.y <= b.max.y && a.max.z >= b.min.z && a.min.z <= b.max.z);
			}

			internal void DrawGizmos()
			{
				transform.rotation = Quaternion.identity;
				Matrix4x4 matrix = Matrix4x4.TRS(transform.position, transform.rotation, transform.lossyScale);
				Gizmos.matrix = matrix;
				Gizmos.color = new Color(0f, 1f, 0f, 0.3f);
				Gizmos.DrawCube(Vector3.zero, Vector3.one);
				Gizmos.color = new Color(0f, 1f, 0f, 1f);
				Gizmos.DrawWireCube(Vector3.zero, Vector3.one);
				Gizmos.matrix = Matrix4x4.identity;
			}

			internal void PerformStick(List<Collider> brokenPieces)
			{
				Bounds a = new Bounds(transform.position, transform.lossyScale);
				foreach (Collider brokenPiece in brokenPieces)
				{
					if (BoxIntersect(a, brokenPiece.collider.bounds))
					{
						StickObject(brokenPiece);
						shardsStuckToMe.Add(brokenPiece, transform.InverseTransformPoint(brokenPiece.transform.position));
					}
				}
			}
		}
}
