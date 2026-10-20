namespace Poly2Tri
{
		public static class P2T
		{
			private static TriangulationAlgorithm _defaultAlgorithm = TriangulationAlgorithm.DTSweep;

			public static void Triangulate(PolygonSet ps)
			{
				foreach (Polygon polygon in ps.Polygons)
				{
					Triangulate(polygon);
				}
			}

			public static void Triangulate(Polygon p)
			{
				Triangulate(_defaultAlgorithm, p);
			}

			public static void Triangulate(ConstrainedPointSet cps)
			{
				Triangulate(_defaultAlgorithm, cps);
			}

			public static void Triangulate(PointSet ps)
			{
				Triangulate(_defaultAlgorithm, ps);
			}

			public static TriangulationContext CreateContext(TriangulationAlgorithm algorithm)
			{
				switch (algorithm)
				{
				case TriangulationAlgorithm.DTSweep:
				default:
					return new DTSweepContext();
				}
			}

			public static void Triangulate(TriangulationAlgorithm algorithm, ITriangulatable t)
			{
				TriangulationContext triangulationContext = CreateContext(algorithm);
				triangulationContext.PrepareTriangulation(t);
				Triangulate(triangulationContext);
			}

			public static void Triangulate(TriangulationContext tcx)
			{
				switch (tcx.Algorithm)
				{
				case TriangulationAlgorithm.DTSweep:
				default:
					DTSweep.Triangulate((DTSweepContext)tcx);
					break;
				}
			}

			public static void Warmup()
			{
			}
		}
}
