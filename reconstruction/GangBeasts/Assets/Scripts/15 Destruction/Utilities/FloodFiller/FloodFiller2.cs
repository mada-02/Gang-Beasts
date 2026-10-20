using UnityEngine;

namespace Destruction.Utilities.FloodFiller
{
		public class FloodFiller2 : BaseFloodFiller<int2>
		{
			protected readonly bool[,] visitedSet;

			public FloodFiller2(FloodFillCancelled OnCancelledCallback, FloodFillFinished finishedCallback, Vector3 startingPoint, Vector3 bottomLeft, Vector3 bounds, float errorRadius)
				: this(OnCancelledCallback, null, finishedCallback, startingPoint, bottomLeft, bounds, errorRadius)
			{
			}

			public FloodFiller2(FloodFillCancelled OnCancelledCallback, IsStepSatisfied SatisfiedContraint, FloodFillFinished finishedCallback, Vector3 startingPoint, Vector3 bottomLeft, Vector3 bounds, float errorRadius)
				: base(OnCancelledCallback, SatisfiedContraint, bottomLeft, errorRadius)
			{
				OnFinishedCallback += finishedCallback;
				int2 item = Point2XY(startingPoint);
				visitedSet = new bool[(int)(Mathf.Abs(bounds.x) / MoveDistance) + 1, (int)(Mathf.Abs(bounds.y) / MoveDistance) + 1];
				openSet.Enqueue(item);
				WorkerThread();
			}

			protected override float maxIter
			{
				get
				{
					return visitedSet.GetUpperBound(0) * visitedSet.GetUpperBound(1);
				}
			}

			private Vector3 XY2Point(int x, int y)
			{
				return new Vector3((float)x * MoveDistance, (float)y * MoveDistance, 0f) + bottomLeft;
			}

			private int2 Point2XY(Vector3 point)
			{
				Vector3 vector = point - bottomLeft;
				vector /= MoveDistance;
				return new int2((int)vector.x, (int)vector.y);
			}

			protected override void FloodFill(int2 coord)
			{
				int x = coord.x;
				int y = coord.y;
				if (x < 0 || x >= visitedSet.GetUpperBound(0) || y < 0 || y >= visitedSet.GetUpperBound(1))
				{
					return;
				}

				if (visitedSet[x, y])
				{
					return;
				}

				Vector3 position = XY2Point(x, y);
				visitedSet[x, y] = true;
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
						if (!(i != 0 || j != 0))
						{
							continue;
						}

						openSet.Enqueue(new int2(x + i, y + j));
					}
				}
			}
		}
}
