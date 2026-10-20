namespace Poly2Tri
{
		public class DTSweepContext : TriangulationContext
		{
			private readonly float ALPHA = 0.3f;

			public AdvancingFront Front;

			public DTSweepBasin Basin = new DTSweepBasin();

			public DTSweepEdgeEvent EdgeEvent = new DTSweepEdgeEvent();

			private DTSweepPointComparator _comparator = new DTSweepPointComparator();

			public DTSweepContext()
			{
				Clear();
			}

			public TriangulationPoint Head { get; set; }

			public TriangulationPoint Tail { get; set; }

			public override TriangulationAlgorithm Algorithm
			{
				get
				{
					return TriangulationAlgorithm.DTSweep;
				}
			}

			public override bool IsDebugEnabled
			{
				get
				{
					return base.IsDebugEnabled;
				}
				protected set
				{
					if (value && DebugContext == null)
					{
						DebugContext = new DTSweepDebugContext(this);
					}
					base.IsDebugEnabled = value;
				}
			}

			public void RemoveFromList(DelaunayTriangle triangle)
			{
				Triangles.Remove(triangle);
			}

			public void MeshClean(DelaunayTriangle triangle)
			{
				MeshCleanReq(triangle);
			}

			private void MeshCleanReq(DelaunayTriangle triangle)
			{
				if (!(triangle == null || triangle.IsInterior))
				{
					triangle.IsInterior = true;
					Triangulatable.AddTriangle(triangle);
					for (int i = 0; i < 3; i++)
					{
						if (!triangle.EdgeIsConstrained[i])
						{
							MeshCleanReq(triangle.Neighbors[i]);
						}
					}
				}
			}

			public override void Clear()
			{
				base.Clear();
				Triangles.Clear();
			}

			public void AddNode(AdvancingFrontNode node)
			{
				Front.AddNode(node);
			}

			public void RemoveNode(AdvancingFrontNode node)
			{
				Front.RemoveNode(node);
			}

			public AdvancingFrontNode LocateNode(TriangulationPoint point)
			{
				return Front.LocateNode(point);
			}

			public void CreateAdvancingFront()
			{
				DelaunayTriangle delaunayTriangle = new DelaunayTriangle(Points[0], Tail, Head);
				Triangles.Add(delaunayTriangle);
				AdvancingFrontNode advancingFrontNode = new AdvancingFrontNode(delaunayTriangle.Points[1]);
				advancingFrontNode.Triangle = delaunayTriangle;
				AdvancingFrontNode advancingFrontNode2 = new AdvancingFrontNode(delaunayTriangle.Points[0]);
				advancingFrontNode2.Triangle = delaunayTriangle;
				AdvancingFrontNode tail = new AdvancingFrontNode(delaunayTriangle.Points[2]);
				Front = new AdvancingFront(advancingFrontNode, tail);
				Front.AddNode(advancingFrontNode2);
				Front.Head.Next = advancingFrontNode2;
				advancingFrontNode2.Next = Front.Tail;
				advancingFrontNode2.Prev = Front.Head;
				Front.Tail.Prev = advancingFrontNode2;
			}

			public void MapTriangleToNodes(DelaunayTriangle t)
			{
				for (int i = 0; i < 3; i++)
				{
					if (t.Neighbors[i] == null)
					{
						AdvancingFrontNode advancingFrontNode = Front.LocatePoint(t.PointCWFrom(t.Points[i]));
						if (advancingFrontNode != null)
						{
							advancingFrontNode.Triangle = t;
						}
					}
				}
			}

			public override void PrepareTriangulation(ITriangulatable t)
			{
				base.PrepareTriangulation(t);
				double x;
				double num = (x = Points[0].X);
				double y;
				double num2 = (y = Points[0].Y);
				foreach (TriangulationPoint point in Points)
				{
					if (point.X > num)
					{
						num = point.X;
					}
					if (point.X < x)
					{
						x = point.X;
					}
					if (point.Y > num2)
					{
						num2 = point.Y;
					}
					if (point.Y < y)
					{
						y = point.Y;
					}
				}
				double num3 = (double)ALPHA * (num - x);
				double num4 = (double)ALPHA * (num2 - y);
				TriangulationPoint head = new TriangulationPoint(num + num3, y - num4);
				TriangulationPoint tail = new TriangulationPoint(x - num3, y - num4);
				Head = head;
				Tail = tail;
				Points.Sort(_comparator);
			}

			public void FinalizeTriangulation()
			{
				Triangulatable.AddTriangles(Triangles);
				Triangles.Clear();
			}

			public override TriangulationConstraint NewConstraint(TriangulationPoint a, TriangulationPoint b)
			{
				return new DTSweepConstraint(a, b);
			}
		}
}
