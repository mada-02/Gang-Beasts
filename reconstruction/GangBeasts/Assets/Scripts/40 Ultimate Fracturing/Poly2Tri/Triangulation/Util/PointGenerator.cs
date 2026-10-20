using System.Collections.Generic;
using System;

namespace Poly2Tri
{
		public class PointGenerator
		{
			private static readonly Random RNG = new Random();

			public static List<TriangulationPoint> UniformDistribution(int n, double scale)
			{
				List<TriangulationPoint> list = new List<TriangulationPoint>();
				for (int i = 0; i < n; i++)
				{
					list.Add(new TriangulationPoint(scale * (0.5 - RNG.NextDouble()), scale * (0.5 - RNG.NextDouble())));
				}
				return list;
			}

			public static List<TriangulationPoint> UniformGrid(int n, double scale)
			{
				double num = 0.0;
				double num2 = scale / (double)n;
				double num3 = 0.5 * scale;
				List<TriangulationPoint> list = new List<TriangulationPoint>();
				for (int i = 0; i < n + 1; i++)
				{
					num = num3 - (double)i * num2;
					for (int j = 0; j < n + 1; j++)
					{
						list.Add(new TriangulationPoint(num, num3 - (double)j * num2));
					}
				}
				return list;
			}
		}
}
