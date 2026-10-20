using UnityEngine;

namespace Destruction.Utilities.FloodFiller
{
		public class FloodFiller3 : BaseFloodFiller<int3>
		{
			protected readonly bool[,,] visitedSet;

			public FloodFiller3(FloodFillCancelled OnCancelledCallback, FloodFillFinished finishedCallback, Vector3 startingPoint, Vector3 bottomLeft, Vector3 bounds, float errorRadius)
				: this(OnCancelledCallback, null, finishedCallback, startingPoint, bottomLeft, bounds, errorRadius)
			{
			}

			public FloodFiller3(FloodFillCancelled OnCancelledCallback, IsStepSatisfied SatisfiedContraint, FloodFillFinished finishedCallback, Vector3 startingPoint, Vector3 bottomLeft, Vector3 bounds, float errorRadius)
				: base(OnCancelledCallback, SatisfiedContraint, bottomLeft, errorRadius)
			{
				OnFinishedCallback += finishedCallback;
				int3 item = Point2XYZ(startingPoint);
				visitedSet = new bool[(int)(Mathf.Abs(bounds.x) / MoveDistance) + 1, (int)(Mathf.Abs(bounds.y) / MoveDistance) + 1, (int)(Mathf.Abs(bounds.z) / MoveDistance) + 1];
				openSet.Enqueue(item);
				WorkerThread();
			}

			protected override float maxIter
			{
				get
				{
					return visitedSet.GetUpperBound(0) * visitedSet.GetUpperBound(1) * visitedSet.GetUpperBound(2);
				}
			}

			private Vector3 XYZ2Point(int x, int y, int z)
			{
				return new Vector3((float)x * MoveDistance, (float)y * MoveDistance, (float)z * MoveDistance) + bottomLeft;
			}

			private int3 Point2XYZ(Vector3 point)
			{
				Vector3 vector = point - bottomLeft;
				vector /= MoveDistance;
				return new int3((int)vector.x, (int)vector.y, (int)vector.z);
			}

			protected override void FloodFill(int3 coord)
			{
				int x = coord.x;
				int y = coord.y;
				int z = coord.z;
				if (x < 0 || x >= visitedSet.GetUpperBound(0) || y < 0 || y >= visitedSet.GetUpperBound(1) || z < 0 || z >= visitedSet.GetUpperBound(2))
				{
					return;
				}

				if (visitedSet[x, y, z])
				{
					return;
				}

				Vector3 position = XYZ2Point(x, y, z);
				visitedSet[x, y, z] = true;
				currentIterationCounter++;
				Collider[] array = Physics.OverlapSphere(position, errorRadius);
				collidersFound.AddRange(array);
				if (SatisfiedContraint(array))
				{
					return;
				}

				for (int i = -1; i <= 1; i++)
				{
					for (int j = -1; j <= 1; j++)
					{
						for (int k = -1; k <= 1; k++)
						{
							if (!(i != 0 || j != 0 || k != 0))
							{
								continue;
							}

							openSet.Enqueue(new int3(x + i, y + j, z + k));
						}
					}
				}
			}
		}
}
