using System.Collections.Generic;
using System;

namespace Poly2Tri
{
		public class DelaunayTriangle
		{
			public FixedArray3<TriangulationPoint> Points;

			public FixedArray3<DelaunayTriangle> Neighbors;

			private FixedBitArray3 mEdgeIsConstrained;

			public FixedBitArray3 EdgeIsDelaunay;

			public DelaunayTriangle(TriangulationPoint p1, TriangulationPoint p2, TriangulationPoint p3)
			{
				Points[0] = p1;
				Points[1] = p2;
				Points[2] = p3;
			}

			public FixedBitArray3 EdgeIsConstrained
			{
				get
				{
					return mEdgeIsConstrained;
				}
			}

			public bool IsInterior { get; set; }

			public int IndexOf(TriangulationPoint p)
			{
				int num = Points.IndexOf(p);
				if (num == -1)
				{
					throw new Exception("Calling index with a point that doesn't exist in triangle");
				}
				return num;
			}

			public int IndexCWFrom(TriangulationPoint p)
			{
				return (IndexOf(p) + 2) % 3;
			}

			public int IndexCCWFrom(TriangulationPoint p)
			{
				return (IndexOf(p) + 1) % 3;
			}

			public bool Contains(TriangulationPoint p)
			{
				return Points.Contains(p);
			}

			private void MarkNeighbor(TriangulationPoint p1, TriangulationPoint p2, DelaunayTriangle t)
			{
				int num = EdgeIndex(p1, p2);
				if (num == -1)
				{
					throw new Exception("Error marking neighbors -- t doesn't contain edge p1-p2!");
				}
				Neighbors[num] = t;
			}

			public void MarkNeighbor(DelaunayTriangle t)
			{
				bool flag = t.Contains(Points[0]);
				bool flag2 = t.Contains(Points[1]);
				bool flag3 = t.Contains(Points[2]);
				if (flag2 && flag3)
				{
					Neighbors[0] = t;
					t.MarkNeighbor(Points[1], Points[2], this);
				}
				else
				{
					if (flag && flag3)
					{
						Neighbors[1] = t;
						t.MarkNeighbor(Points[0], Points[2], this);
					}
					else
					{
						if (flag && flag2)
						{
							Neighbors[2] = t;
							t.MarkNeighbor(Points[0], Points[1], this);
						}
						else
						{
							throw new Exception("Failed to mark neighbor, doesn't share an edge!");
						}
					}
				}
			}

			public void ClearNeighbors()
			{
				Neighbors[0] = Neighbors[1] = Neighbors[2] = null;
			}

			public void ClearNeighbor(DelaunayTriangle triangle)
			{
				if (Neighbors[0] == triangle)
				{
					Neighbors[0] = null;
				}
				else if (Neighbors[1] == triangle)
				{
					Neighbors[1] = null;
				}
				else if (Neighbors[2] == triangle)
				{
					Neighbors[2] = null;
				}
			}

			public void Clear()
			{
				for (int i = 0; i < 3; i++)
				{
					DelaunayTriangle delaunayTriangle = Neighbors[i];
					if (delaunayTriangle != null)
					{
						delaunayTriangle.ClearNeighbor(this);
					}
				}
				ClearNeighbors();
				TriangulationPoint triangulationPoint = null;
				Points[2] = triangulationPoint;
				triangulationPoint = triangulationPoint;
				Points[1] = triangulationPoint;
				Points[0] = triangulationPoint;
			}

			public TriangulationPoint OppositePoint(DelaunayTriangle t, TriangulationPoint p)
			{
				return PointCWFrom(t.PointCWFrom(p));
			}

			public DelaunayTriangle NeighborCWFrom(TriangulationPoint point)
			{
				return Neighbors[(Points.IndexOf(point) + 1) % 3];
			}

			public DelaunayTriangle NeighborCCWFrom(TriangulationPoint point)
			{
				return Neighbors[(Points.IndexOf(point) + 2) % 3];
			}

			public DelaunayTriangle NeighborAcrossFrom(TriangulationPoint point)
			{
				return Neighbors[Points.IndexOf(point)];
			}

			public TriangulationPoint PointCCWFrom(TriangulationPoint point)
			{
				return Points[(IndexOf(point) + 1) % 3];
			}

			public TriangulationPoint PointCWFrom(TriangulationPoint point)
			{
				return Points[(IndexOf(point) + 2) % 3];
			}

			private void RotateCW()
			{
				TriangulationPoint value = Points[2];
				Points[2] = Points[1];
				Points[1] = Points[0];
				Points[0] = value;
			}

			public void Legalize(TriangulationPoint oPoint, TriangulationPoint nPoint)
			{
				RotateCW();
				Points[IndexCCWFrom(oPoint)] = nPoint;
			}

			public override string ToString()
			{
				return string.Concat(Points[0], ",", Points[1], ",", Points[2]);
			}

			public void MarkNeighborEdges()
			{
				for (int i = 0; i < 3; i++)
				{
					if (EdgeIsConstrained[i] && Neighbors[i] != null)
					{
						Neighbors[i].MarkConstrainedEdge(Points[(i + 1) % 3], Points[(i + 2) % 3]);
					}
				}
			}

			public void MarkEdge(DelaunayTriangle triangle)
			{
				for (int i = 0; i < 3; i++)
				{
					if (EdgeIsConstrained[i])
					{
						triangle.MarkConstrainedEdge(Points[(i + 1) % 3], Points[(i + 2) % 3]);
					}
				}
			}

			public void MarkEdge(List<DelaunayTriangle> tList)
			{
				foreach (DelaunayTriangle t in tList)
				{
					for (int i = 0; i < 3; i++)
					{
						if (t.EdgeIsConstrained[i])
						{
							MarkConstrainedEdge(t.Points[(i + 1) % 3], t.Points[(i + 2) % 3]);
						}
					}
				}
			}

			public void MarkConstrainedEdge(int index)
			{
				mEdgeIsConstrained[index] = true;
			}

			public void MarkConstrainedEdge(DTSweepConstraint edge)
			{
				MarkConstrainedEdge(edge.P, edge.Q);
			}

			public void MarkConstrainedEdge(TriangulationPoint p, TriangulationPoint q)
			{
				int num = EdgeIndex(p, q);
				if (num != -1)
				{
					mEdgeIsConstrained[num] = true;
				}
			}

			public double Area()
			{
				double num = Points[0].X - Points[1].X;
				double num2 = Points[2].Y - Points[1].Y;
				return Math.Abs(num * num2 * 0.5);
			}

			public TriangulationPoint Centroid()
			{
				double x = (Points[0].X + Points[1].X + Points[2].X) / 3.0;
				double y = (Points[0].Y + Points[1].Y + Points[2].Y) / 3.0;
				return new TriangulationPoint(x, y);
			}

			public int EdgeIndex(TriangulationPoint p1, TriangulationPoint p2)
			{
				int num = Points.IndexOf(p1);
				int num2 = Points.IndexOf(p2);
				bool flag = num == 0 || num2 == 0;
				bool flag2 = num == 1 || num2 == 1;
				bool flag3 = num == 2 || num2 == 2;
				if (flag2 && flag3)
				{
					return 0;
				}
				if (flag && flag3)
				{
					return 1;
				}
				if (flag && flag2)
				{
					return 2;
				}
				return -1;
			}

			public bool GetConstrainedEdgeCCW(TriangulationPoint p)
			{
				return EdgeIsConstrained[(IndexOf(p) + 2) % 3];
			}

			public bool GetConstrainedEdgeCW(TriangulationPoint p)
			{
				return EdgeIsConstrained[(IndexOf(p) + 1) % 3];
			}

			public bool GetConstrainedEdgeAcross(TriangulationPoint p)
			{
				return EdgeIsConstrained[IndexOf(p)];
			}

			protected void SetConstrainedEdge(int idx, bool ce)
			{
				mEdgeIsConstrained[idx] = ce;
			}

			public void SetConstrainedEdgeCCW(TriangulationPoint p, bool ce)
			{
				int idx = (IndexOf(p) + 2) % 3;
				SetConstrainedEdge(idx, ce);
			}

			public void SetConstrainedEdgeCW(TriangulationPoint p, bool ce)
			{
				int idx = (IndexOf(p) + 1) % 3;
				SetConstrainedEdge(idx, ce);
			}

			public void SetConstrainedEdgeAcross(TriangulationPoint p, bool ce)
			{
				int idx = IndexOf(p);
				SetConstrainedEdge(idx, ce);
			}

			public bool GetDelaunayEdgeCCW(TriangulationPoint p)
			{
				return EdgeIsDelaunay[(IndexOf(p) + 2) % 3];
			}

			public bool GetDelaunayEdgeCW(TriangulationPoint p)
			{
				return EdgeIsDelaunay[(IndexOf(p) + 1) % 3];
			}

			public bool GetDelaunayEdgeAcross(TriangulationPoint p)
			{
				return EdgeIsDelaunay[IndexOf(p)];
			}

			public void SetDelaunayEdgeCCW(TriangulationPoint p, bool ce)
			{
				EdgeIsDelaunay[(IndexOf(p) + 2) % 3] = ce;
			}

			public void SetDelaunayEdgeCW(TriangulationPoint p, bool ce)
			{
				EdgeIsDelaunay[(IndexOf(p) + 1) % 3] = ce;
			}

			public void SetDelaunayEdgeAcross(TriangulationPoint p, bool ce)
			{
				EdgeIsDelaunay[IndexOf(p)] = ce;
			}

			public bool GetEdge(int idx, out DTSweepConstraint edge)
			{
				edge = null;
				if (idx < 0 || idx > 2)
				{
					return false;
				}
				TriangulationPoint triangulationPoint = Points[(idx + 1) % 3];
				TriangulationPoint triangulationPoint2 = Points[(idx + 2) % 3];
				if (triangulationPoint.GetEdge(triangulationPoint2, out edge))
				{
					return true;
				}
				if (triangulationPoint2.GetEdge(triangulationPoint, out edge))
				{
					return true;
				}
				return false;
			}

			public bool GetEdgeCCW(TriangulationPoint p, out DTSweepConstraint edge)
			{
				int num = IndexOf(p);
				int idx = (num + 2) % 3;
				return GetEdge(idx, out edge);
			}

			public bool GetEdgeCW(TriangulationPoint p, out DTSweepConstraint edge)
			{
				int num = IndexOf(p);
				int idx = (num + 1) % 3;
				return GetEdge(idx, out edge);
			}

			public bool GetEdgeAcross(TriangulationPoint p, out DTSweepConstraint edge)
			{
				int num = IndexOf(p);
				int idx = num;
				return GetEdge(idx, out edge);
			}
		}
}
