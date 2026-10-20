using System.Collections.Generic;

namespace Poly2Tri
{
		public interface ITriangulatable
		{
			IList<DelaunayTriangle> Triangles { get; }

			TriangulationMode TriangulationMode { get; }

			string FileName { get; set; }

			bool DisplayFlipX { get; set; }

			bool DisplayFlipY { get; set; }

			float DisplayRotate { get; set; }

			double Precision { get; set; }

			double MinX { get; }

			double MaxX { get; }

			double MinY { get; }

			double MaxY { get; }

			Rect2D Bounds { get; }

			void Prepare(TriangulationContext tcx);

			void AddTriangle(DelaunayTriangle t);

			void AddTriangles(IEnumerable<DelaunayTriangle> list);

			void ClearTriangles();
		}
}
