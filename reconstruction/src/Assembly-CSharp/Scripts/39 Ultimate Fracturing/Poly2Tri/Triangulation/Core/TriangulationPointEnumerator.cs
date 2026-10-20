using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public class TriangulationPointEnumerator : IDisposable, IEnumerator, IEnumerator<TriangulationPoint>
		{
			protected IList<Point2D> mPoints;

			protected int position = -1;

			public TriangulationPointEnumerator(IList<Point2D> points)
			{
				mPoints = points;
			}

			void IDisposable.Dispose()
			{
			}

			object IEnumerator.Current
			{
				get
				{
					return Current;
				}
			}

			public bool MoveNext()
			{
				position++;
				return position < mPoints.Count;
			}

			public void Reset()
			{
				position = -1;
			}

			public TriangulationPoint Current
			{
				get
				{
					if (position < 0 || position >= mPoints.Count)
					{
						return null;
					}
					return mPoints[position] as TriangulationPoint;
				}
			}
		}
}
