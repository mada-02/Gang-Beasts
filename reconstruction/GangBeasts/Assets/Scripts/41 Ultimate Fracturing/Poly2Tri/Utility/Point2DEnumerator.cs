using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public class Point2DEnumerator : IDisposable, IEnumerator, IEnumerator<Point2D>
		{
			protected IList<Point2D> mPoints;

			protected int position = -1;

			public Point2DEnumerator(IList<Point2D> points)
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

			public Point2D Current
			{
				get
				{
					if (position < 0 || position >= mPoints.Count)
					{
						return null;
					}
					return mPoints[position];
				}
			}
		}
}
