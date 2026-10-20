namespace Poly2Tri
{
		public class AdvancingFrontNode
		{
			public AdvancingFrontNode Next;

			public AdvancingFrontNode Prev;

			public double Value;

			public TriangulationPoint Point;

			public DelaunayTriangle Triangle;

			public AdvancingFrontNode(TriangulationPoint point)
			{
				Point = point;
				Value = point.X;
			}

			public bool HasNext
			{
				get
				{
					return Next != null;
				}
			}

			public bool HasPrev
			{
				get
				{
					return Prev != null;
				}
			}
		}
}
