namespace Poly2Tri
{
		public class DTSweepConstraint : TriangulationConstraint
		{
			public DTSweepConstraint(TriangulationPoint p1, TriangulationPoint p2)
				: base(p1, p2)
			{
				Q.AddEdge(this);
			}
		}
}
