using Destruction.Tools;
using UnityEngine;

namespace Destruction.Dynamic
{
		[RequireComponent(typeof(BoxCollider))]
		[RequireComponent(typeof(Trigger))]
		[AddComponentMenu("Destruction/Box Fracture")]
		[RequireComponent(typeof(Rigidbody))]
		public sealed class BoxFracture : BaseFracture
		{
			private Vector3 maxBounds;

			private Vector3 minBounds;

			private static readonly Vector4[] initPlanes = new Vector4[6]
			{
				Vector3.right,
				Vector3.up,
				Vector3.forward,
				Vector3.left,
				Vector3.down,
				Vector3.back
			};

			protected override void CreateMeshPlanes(Vector3 point)
			{
				Vector3 vector = point - maxBounds;
				Vector3 vector2 = minBounds - point;
				initPlanes[0].w = vector.x;
				initPlanes[1].w = vector.y;
				initPlanes[2].w = vector.z;
				initPlanes[3].w = vector2.x;
				initPlanes[4].w = vector2.y;
				initPlanes[5].w = vector2.z;
				planes.AddRange(initPlanes);
			}

			protected override void InitializeDestruction()
			{
				base.InitializeDestruction();
				maxBounds = transform.lossyScale * 0.5f;
				minBounds = -maxBounds;
			}
		}
}
