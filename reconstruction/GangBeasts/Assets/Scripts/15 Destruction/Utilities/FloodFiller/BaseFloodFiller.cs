using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Utilities.FloodFiller
{
		public abstract class BaseFloodFiller<T> where T : struct
		{
			public delegate bool IsStepSatisfied(Collider[] colliders);

			public delegate void FloodFillFinished(Collider[] collidersFound);

			public delegate void FloodFillCancelled();

			protected const int maxIterationCounter = 2000000;

			protected IsStepSatisfied SatisfiedContraint;

			protected float errorRadius = 0.025f;

			protected readonly List<Collider> collidersFound = new List<Collider>();

			protected readonly Queue<T> openSet = new Queue<T>(256);

			protected readonly Vector3 bottomLeft;

			protected int currentIterationCounter;

			private bool shouldStop;

			protected BaseFloodFiller(FloodFillCancelled OnCancelledCallback, IsStepSatisfied SatisfiedContraint, Vector3 bottomLeft, float errorRadius)
			{
				this.errorRadius = errorRadius;
				this.bottomLeft = bottomLeft;
				this.SatisfiedContraint = SatisfiedContraint ?? new IsStepSatisfied(DefaultSatisfiedContraint);
				this.OnCancelledCallback = OnCancelledCallback;
			}

			protected event FloodFillFinished OnFinishedCallback;

			protected event FloodFillCancelled OnCancelledCallback;

			protected float MoveDistance
			{
				get
				{
					return errorRadius * 2f;
				}
			}

			protected abstract void FloodFill(T coord);

			public void Cancel()
			{
				shouldStop = true;
				OnCancelledCallback();
			}

			private bool DefaultSatisfiedContraint(Collider[] colliders)
			{
				return colliders.Length > 0;
			}

			protected void WorkerThread()
			{
				while (currentIterationCounter < 2000000 && openSet.Count > 0 && !shouldStop)
				{
					if (openSet.Count > 0)
					{
						FloodFill(openSet.Dequeue());
					}
				}
				OnFinishedCallback(DestructionHelper.DedupCollection(collidersFound).ToArray());
			}

			protected abstract float maxIter { get; }
		}
}
