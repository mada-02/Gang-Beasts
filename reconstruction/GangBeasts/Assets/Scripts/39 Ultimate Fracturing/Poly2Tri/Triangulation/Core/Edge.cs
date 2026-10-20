namespace Poly2Tri
{
		public class Edge
		{
			protected Point2D mP;

			protected Point2D mQ;

			public Edge()
			{
				mP = null;
				mQ = null;
			}

			public Edge(Point2D edgeStart, Point2D edgeEnd)
			{
				mP = edgeStart;
				mQ = edgeEnd;
			}

			public Point2D EdgeStart
			{
				get
				{
					return mP;
				}
				set
				{
					mP = value;
				}
			}

			public Point2D EdgeEnd
			{
				get
				{
					return mQ;
				}
				set
				{
					mQ = value;
				}
			}
		}
}
