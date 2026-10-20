using System.Collections.Generic;
using System;

namespace Poly2Tri
{
		public static class DTSweep
		{
			private const double PI_div2 = Math.PI / 2.0;

			private const double PI_3div4 = Math.PI * 3.0 / 4.0;

			public static void Triangulate(DTSweepContext tcx)
			{
				tcx.CreateAdvancingFront();
				Sweep(tcx);
				FixupConstrainedEdges(tcx);
				if (tcx.TriangulationMode == TriangulationMode.Polygon)
				{
					FinalizationPolygon(tcx);
				}
				else
				{
					FinalizationConvexHull(tcx);
					if (tcx.TriangulationMode == TriangulationMode.Constrained)
					{
						tcx.FinalizeTriangulation();
					}
					else
					{
						tcx.FinalizeTriangulation();
					}
				}
				tcx.Done();
			}

			private static void Sweep(DTSweepContext tcx)
			{
				List<TriangulationPoint> points = tcx.Points;
				for (int i = 1; i < points.Count; i++)
				{
					TriangulationPoint triangulationPoint = points[i];
					AdvancingFrontNode advancingFrontNode = PointEvent(tcx, triangulationPoint);
					if (advancingFrontNode != null && triangulationPoint.HasEdges)
					{
						foreach (DTSweepConstraint edge in triangulationPoint.Edges)
						{
							if (tcx.IsDebugEnabled)
							{
								tcx.DTDebugContext.ActiveConstraint = edge;
							}
							EdgeEvent(tcx, edge, advancingFrontNode);
						}
					}
					tcx.Update(null);
				}
			}

			private static void FixupConstrainedEdges(DTSweepContext tcx)
			{
				foreach (DelaunayTriangle triangle in tcx.Triangles)
				{
					for (int i = 0; i < 3; i++)
					{
						if (!triangle.GetConstrainedEdgeCCW(triangle.Points[i]))
						{
							DTSweepConstraint edge = null;
							if (triangle.GetEdgeCCW(triangle.Points[i], out edge))
							{
								triangle.MarkConstrainedEdge((i + 2) % 3);
							}
						}
					}
				}
			}

			private static void FinalizationConvexHull(DTSweepContext tcx)
			{
				AdvancingFrontNode next = tcx.Front.Head.Next;
				AdvancingFrontNode next2 = next.Next;
				TriangulationPoint point = next.Point;
				TurnAdvancingFrontConvex(tcx, next, next2);
				next = tcx.Front.Tail.Prev;
				DelaunayTriangle delaunayTriangle;
				if (next.Triangle.Contains(next.Next.Point) && next.Triangle.Contains(next.Prev.Point))
				{
					delaunayTriangle = next.Triangle.NeighborAcrossFrom(next.Point);
					RotateTrianglePair(next.Triangle, next.Point, delaunayTriangle, delaunayTriangle.OppositePoint(next.Triangle, next.Point));
					tcx.MapTriangleToNodes(next.Triangle);
					tcx.MapTriangleToNodes(delaunayTriangle);
				}
				next = tcx.Front.Head.Next;
				if (next.Triangle.Contains(next.Prev.Point) && next.Triangle.Contains(next.Next.Point))
				{
					delaunayTriangle = next.Triangle.NeighborAcrossFrom(next.Point);
					RotateTrianglePair(next.Triangle, next.Point, delaunayTriangle, delaunayTriangle.OppositePoint(next.Triangle, next.Point));
					tcx.MapTriangleToNodes(next.Triangle);
					tcx.MapTriangleToNodes(delaunayTriangle);
				}
				point = tcx.Front.Head.Point;
				next2 = tcx.Front.Tail.Prev;
				delaunayTriangle = next2.Triangle;
				TriangulationPoint triangulationPoint = next2.Point;
				next2.Triangle = null;
				DelaunayTriangle delaunayTriangle2;
				while (true)
				{
					tcx.RemoveFromList(delaunayTriangle);
					triangulationPoint = delaunayTriangle.PointCCWFrom(triangulationPoint);
					if (triangulationPoint == point)
					{
						break;
					}
					delaunayTriangle2 = delaunayTriangle.NeighborCCWFrom(triangulationPoint);
					delaunayTriangle.Clear();
					delaunayTriangle = delaunayTriangle2;
				}
				point = tcx.Front.Head.Next.Point;
				triangulationPoint = delaunayTriangle.PointCWFrom(tcx.Front.Head.Point);
				delaunayTriangle2 = delaunayTriangle.NeighborCWFrom(tcx.Front.Head.Point);
				delaunayTriangle.Clear();
				delaunayTriangle = delaunayTriangle2;
				while (triangulationPoint != point)
				{
					tcx.RemoveFromList(delaunayTriangle);
					triangulationPoint = delaunayTriangle.PointCCWFrom(triangulationPoint);
					delaunayTriangle2 = delaunayTriangle.NeighborCCWFrom(triangulationPoint);
					delaunayTriangle.Clear();
					delaunayTriangle = delaunayTriangle2;
				}
				tcx.Front.Head = tcx.Front.Head.Next;
				tcx.Front.Head.Prev = null;
				tcx.Front.Tail = tcx.Front.Tail.Prev;
				tcx.Front.Tail.Next = null;
			}

			private static void TurnAdvancingFrontConvex(DTSweepContext tcx, AdvancingFrontNode b, AdvancingFrontNode c)
			{
				AdvancingFrontNode advancingFrontNode = b;
				while (c != tcx.Front.Tail)
				{
					if (tcx.IsDebugEnabled)
					{
						tcx.DTDebugContext.ActiveNode = c;
					}
					if (TriangulationUtil.Orient2d(b.Point, c.Point, c.Next.Point) == Orientation.CCW)
					{
						Fill(tcx, c);
						c = c.Next;
					}
					else if (b != advancingFrontNode && TriangulationUtil.Orient2d(b.Prev.Point, b.Point, c.Point) == Orientation.CCW)
					{
						Fill(tcx, b);
						b = b.Prev;
					}
					else
					{
						b = c;
						c = c.Next;
					}
				}
			}

			private static void FinalizationPolygon(DTSweepContext tcx)
			{
				DelaunayTriangle delaunayTriangle = tcx.Front.Head.Next.Triangle;
				TriangulationPoint point = tcx.Front.Head.Next.Point;
				while (!delaunayTriangle.GetConstrainedEdgeCW(point))
				{
					DelaunayTriangle delaunayTriangle2 = delaunayTriangle.NeighborCCWFrom(point);
					if (delaunayTriangle2 == null)
					{
						break;
					}
					delaunayTriangle = delaunayTriangle2;
				}
				tcx.MeshClean(delaunayTriangle);
			}

			private static void FinalizationConstraints(DTSweepContext tcx)
			{
				DelaunayTriangle delaunayTriangle = tcx.Front.Head.Triangle;
				TriangulationPoint point = tcx.Front.Head.Point;
				while (!delaunayTriangle.GetConstrainedEdgeCW(point))
				{
					DelaunayTriangle delaunayTriangle2 = delaunayTriangle.NeighborCCWFrom(point);
					if (delaunayTriangle2 == null)
					{
						break;
					}
					delaunayTriangle = delaunayTriangle2;
				}
				tcx.MeshClean(delaunayTriangle);
			}

			private static AdvancingFrontNode PointEvent(DTSweepContext tcx, TriangulationPoint point)
			{
				AdvancingFrontNode advancingFrontNode = tcx.LocateNode(point);
				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.ActiveNode = advancingFrontNode;
				}
				if (advancingFrontNode == null || point == null)
				{
					return null;
				}
				AdvancingFrontNode advancingFrontNode2 = NewFrontTriangle(tcx, point, advancingFrontNode);
				if (point.X <= advancingFrontNode.Point.X + MathUtil.EPSILON)
				{
					Fill(tcx, advancingFrontNode);
				}
				tcx.AddNode(advancingFrontNode2);
				FillAdvancingFront(tcx, advancingFrontNode2);
				return advancingFrontNode2;
			}

			private static AdvancingFrontNode NewFrontTriangle(DTSweepContext tcx, TriangulationPoint point, AdvancingFrontNode node)
			{
				DelaunayTriangle delaunayTriangle = new DelaunayTriangle(point, node.Point, node.Next.Point);
				delaunayTriangle.MarkNeighbor(node.Triangle);
				tcx.Triangles.Add(delaunayTriangle);
				AdvancingFrontNode advancingFrontNode = new AdvancingFrontNode(point);
				advancingFrontNode.Next = node.Next;
				advancingFrontNode.Prev = node;
				node.Next.Prev = advancingFrontNode;
				node.Next = advancingFrontNode;
				tcx.AddNode(advancingFrontNode);
				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.ActiveNode = advancingFrontNode;
				}
				if (!Legalize(tcx, delaunayTriangle))
				{
					tcx.MapTriangleToNodes(delaunayTriangle);
				}
				return advancingFrontNode;
			}

			private static void EdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				try
				{
					tcx.EdgeEvent.ConstrainedEdge = edge;
					tcx.EdgeEvent.Right = edge.P.X > edge.Q.X;
					if (tcx.IsDebugEnabled)
					{
						tcx.DTDebugContext.PrimaryTriangle = node.Triangle;
					}

					if (IsEdgeSideOfTriangle(node.Triangle, edge.P, edge.Q))
					{
						return;
					}

					// For now we will do all needed filling
					// TODO: integrate with flip process might give some better performance
					//       but for now this avoid the issue with cases that needs both flips and fills
					FillEdgeEvent(tcx, edge, node);
					EdgeEvent(tcx, edge.P, edge.Q, node.Triangle, edge.Q);
				}
				catch (PointOnEdgeException)
				{
					throw;
				}
			}

			private static void FillEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				if (tcx.EdgeEvent.Right)
				{
					FillRightAboveEdgeEvent(tcx, edge, node);
				}
				else
				{
					FillLeftAboveEdgeEvent(tcx, edge, node);
				}
			}

			private static void FillRightConcaveEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				Fill(tcx, node.Next);
				if (node.Next.Point != edge.P)
				{
					// Next above or below edge?
					if (TriangulationUtil.Orient2d(edge.Q, node.Next.Point, edge.P) == Orientation.CCW)
					{
						// Below
						if (TriangulationUtil.Orient2d(node.Point, node.Next.Point, node.Next.Next.Point) == Orientation.CCW)
						{
							// Next is concave
							FillRightConcaveEdgeEvent(tcx, edge, node);
						}
						else
						{
							// Next is convex
						}
					}
				}
			}

			private static void FillRightConvexEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				if (TriangulationUtil.Orient2d(node.Next.Point, node.Next.Next.Point, node.Next.Next.Next.Point) == Orientation.CCW)
				{
					FillRightConcaveEdgeEvent(tcx, edge, node.Next);
				}
				else if (TriangulationUtil.Orient2d(edge.Q, node.Next.Next.Point, edge.P) == Orientation.CCW)
				{
					FillRightConvexEdgeEvent(tcx, edge, node.Next);
				}
				else
				{
				}
			}

			private static void FillRightBelowEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.ActiveNode = node;
				}

				if (node.Point.X < edge.P.X)
				{
					if (TriangulationUtil.Orient2d(node.Point, node.Next.Point, node.Next.Next.Point) == Orientation.CCW)
					{
						FillRightConcaveEdgeEvent(tcx, edge, node);
					}
					else
					{
						FillRightConvexEdgeEvent(tcx, edge, node);
						FillRightBelowEdgeEvent(tcx, edge, node);
					}
				}
			}

			private static void FillRightAboveEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				while (node.Next.Point.X < edge.P.X)
				{
					if (tcx.IsDebugEnabled)
					{
						tcx.DTDebugContext.ActiveNode = node;
					}
					Orientation orientation = TriangulationUtil.Orient2d(edge.Q, node.Next.Point, edge.P);
					if (orientation == Orientation.CCW)
					{
						FillRightBelowEdgeEvent(tcx, edge, node);
					}
					else
					{
						node = node.Next;
					}
				}
			}

			private static void FillLeftConvexEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				if (TriangulationUtil.Orient2d(node.Prev.Point, node.Prev.Prev.Point, node.Prev.Prev.Prev.Point) == Orientation.CW)
				{
					FillLeftConcaveEdgeEvent(tcx, edge, node.Prev);
				}
				else if (TriangulationUtil.Orient2d(edge.Q, node.Prev.Prev.Point, edge.P) == Orientation.CW)
				{
					FillLeftConvexEdgeEvent(tcx, edge, node.Prev);
				}
				else
				{
				}
			}

			private static void FillLeftConcaveEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				Fill(tcx, node.Prev);
				if (node.Prev.Point != edge.P)
				{
					// Next above or below edge?
					if (TriangulationUtil.Orient2d(edge.Q, node.Prev.Point, edge.P) == Orientation.CW)
					{
						// Below
						if (TriangulationUtil.Orient2d(node.Point, node.Prev.Point, node.Prev.Prev.Point) == Orientation.CW)
						{
							// Next is concave
							FillLeftConcaveEdgeEvent(tcx, edge, node);
						}
						else
						{
							// Next is convex
						}
					}
				}
			}

			private static void FillLeftBelowEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.ActiveNode = node;
				}

				if (node.Point.X > edge.P.X)
				{
					if (TriangulationUtil.Orient2d(node.Point, node.Prev.Point, node.Prev.Prev.Point) == Orientation.CW)
					{
						FillLeftConcaveEdgeEvent(tcx, edge, node);
					}
					else
					{
						FillLeftConvexEdgeEvent(tcx, edge, node);
						FillLeftBelowEdgeEvent(tcx, edge, node);
					}
				}
			}

			private static void FillLeftAboveEdgeEvent(DTSweepContext tcx, DTSweepConstraint edge, AdvancingFrontNode node)
			{
				while (node.Prev.Point.X > edge.P.X)
				{
					if (tcx.IsDebugEnabled)
					{
						tcx.DTDebugContext.ActiveNode = node;
					}
					// Check if next node is below the edge
					Orientation o1 = TriangulationUtil.Orient2d(edge.Q, node.Prev.Point, edge.P);
					if (o1 == Orientation.CW)
					{
						FillLeftBelowEdgeEvent(tcx, edge, node);
					}
					else
					{
						node = node.Prev;
					}
				}
			}

			private static bool IsEdgeSideOfTriangle(DelaunayTriangle triangle, TriangulationPoint ep, TriangulationPoint eq)
			{
				int num = triangle.EdgeIndex(ep, eq);
				if (num == -1)
				{
					return false;
				}
				triangle.MarkConstrainedEdge(num);
				triangle = triangle.Neighbors[num];
				if (triangle != null)
				{
					triangle.MarkConstrainedEdge(ep, eq);
				}
				return true;
			}

			private static void EdgeEvent(DTSweepContext tcx, TriangulationPoint ep, TriangulationPoint eq, DelaunayTriangle triangle, TriangulationPoint point)
			{
				TriangulationPoint p1, p2;

				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.PrimaryTriangle = triangle;
				}

				if (IsEdgeSideOfTriangle(triangle, ep, eq))
				{
					return;
				}

				p1 = triangle.PointCCWFrom(point);
				Orientation o1 = TriangulationUtil.Orient2d(eq, p1, ep);
				if (o1 == Orientation.Collinear)
				{
					if (triangle.Contains(eq) && triangle.Contains(p1))
					{
						triangle.MarkConstrainedEdge(eq, p1);
						// We are modifying the constraint maybe it would be better to
						// not change the given constraint and just keep a variable for the new constraint
						tcx.EdgeEvent.ConstrainedEdge.Q = p1;
						triangle = triangle.NeighborAcrossFrom(point);
						EdgeEvent(tcx, ep, p1, triangle, p1);
					}
					else
					{
						throw new PointOnEdgeException("EdgeEvent - Point on constrained edge not supported yet", ep, eq, p1);
					}
					if (tcx.IsDebugEnabled)
					{
						Console.WriteLine("EdgeEvent - Point on constrained edge");
					}
					return;
				}

				p2 = triangle.PointCWFrom(point);
				Orientation o2 = TriangulationUtil.Orient2d(eq, p2, ep);
				if (o2 == Orientation.Collinear)
				{
					if (triangle.Contains(eq) && triangle.Contains(p2))
					{
						triangle.MarkConstrainedEdge(eq, p2);
						// We are modifying the constraint maybe it would be better to
						// not change the given constraint and just keep a variable for the new constraint
						tcx.EdgeEvent.ConstrainedEdge.Q = p2;
						triangle = triangle.NeighborAcrossFrom(point);
						EdgeEvent(tcx, ep, p2, triangle, p2);
					}
					else
					{
						throw new PointOnEdgeException("EdgeEvent - Point on constrained edge not supported yet", ep, eq, p2);
					}
					if (tcx.IsDebugEnabled)
					{
						Console.WriteLine("EdgeEvent - Point on constrained edge");
					}
					return;
				}

				if (o1 == o2)
				{
					// Need to decide if we are rotating CW or CCW to get to a triangle
					// that will cross edge
					if (o1 == Orientation.CW)
					{
						triangle = triangle.NeighborCCWFrom(point);
					}
					else
					{
						triangle = triangle.NeighborCWFrom(point);
					}
					EdgeEvent(tcx, ep, eq, triangle, point);
				}
				else
				{
					// This triangle crosses constraint so lets flippin start!
					FlipEdgeEvent(tcx, ep, eq, triangle, point);
				}
			}


			private static void FlipEdgeEvent(DTSweepContext tcx, TriangulationPoint ep, TriangulationPoint eq, DelaunayTriangle t, TriangulationPoint p)
			{
				DelaunayTriangle delaunayTriangle = t.NeighborAcrossFrom(p);
				TriangulationPoint triangulationPoint = delaunayTriangle.OppositePoint(t, p);
				if (delaunayTriangle == null)
				{
					throw new InvalidOperationException("[BUG:FIXME] FLIP failed due to missing triangle");
				}
				if (tcx.IsDebugEnabled)
				{
					tcx.DTDebugContext.PrimaryTriangle = t;
					tcx.DTDebugContext.SecondaryTriangle = delaunayTriangle;
				}
				if (TriangulationUtil.InScanArea(p, t.PointCCWFrom(p), t.PointCWFrom(p), triangulationPoint))
				{
					RotateTrianglePair(t, p, delaunayTriangle, triangulationPoint);
					tcx.MapTriangleToNodes(t);
					tcx.MapTriangleToNodes(delaunayTriangle);
					if (p == eq && triangulationPoint == ep)
					{
						if (eq == tcx.EdgeEvent.ConstrainedEdge.Q && ep == tcx.EdgeEvent.ConstrainedEdge.P)
						{
							if (tcx.IsDebugEnabled)
							{
								Console.WriteLine("[FLIP] - constrained edge done");
							}
							t.MarkConstrainedEdge(ep, eq);
							delaunayTriangle.MarkConstrainedEdge(ep, eq);
							Legalize(tcx, t);
							Legalize(tcx, delaunayTriangle);
						}
						else if (tcx.IsDebugEnabled)
						{
							Console.WriteLine("[FLIP] - subedge done");
						}
					}
					else
					{
						if (tcx.IsDebugEnabled)
						{
							Console.WriteLine("[FLIP] - flipping and continuing with triangle still crossing edge");
						}
						Orientation o = TriangulationUtil.Orient2d(eq, triangulationPoint, ep);
						t = NextFlipTriangle(tcx, o, t, delaunayTriangle, p, triangulationPoint);
						FlipEdgeEvent(tcx, ep, eq, t, p);
					}
				}
				else
				{
					TriangulationPoint newP = null;
					if (NextFlipPoint(ep, eq, delaunayTriangle, triangulationPoint, out newP))
					{
						FlipScanEdgeEvent(tcx, ep, eq, t, delaunayTriangle, newP);
						EdgeEvent(tcx, ep, eq, t, p);
					}
				}
			}

			private static bool NextFlipPoint(TriangulationPoint ep, TriangulationPoint eq, DelaunayTriangle ot, TriangulationPoint op, out TriangulationPoint newP)
			{
				newP = null;
				Orientation o2d = TriangulationUtil.Orient2d(eq, op, ep);
				switch (o2d)
				{
				case Orientation.CW:
					newP = ot.PointCCWFrom(op);
					return true;
				case Orientation.CCW:
					newP = ot.PointCWFrom(op);
					return true;
				case Orientation.Collinear:
					// TODO: implement support for point on constraint edge
					//throw new PointOnEdgeException("Point on constrained edge not supported yet", eq, op, ep);
					return false;
				default:
					throw new NotImplementedException("Orientation not handled");
				}
			}

			private static DelaunayTriangle NextFlipTriangle(DTSweepContext tcx, Orientation o, DelaunayTriangle t, DelaunayTriangle ot, TriangulationPoint p, TriangulationPoint op)
			{
				int index;
				if (o == Orientation.CCW)
				{
					index = ot.EdgeIndex(p, op);
					ot.EdgeIsDelaunay[index] = true;
					Legalize(tcx, ot);
					ot.EdgeIsDelaunay.Clear();
					return t;
				}
				index = t.EdgeIndex(p, op);
				t.EdgeIsDelaunay[index] = true;
				Legalize(tcx, t);
				t.EdgeIsDelaunay.Clear();
				return ot;
			}

			private static void FlipScanEdgeEvent(DTSweepContext tcx, TriangulationPoint ep, TriangulationPoint eq, DelaunayTriangle flipTriangle, DelaunayTriangle t, TriangulationPoint p)
			{
				DelaunayTriangle ot;
				TriangulationPoint op, newP;
				bool inScanArea;

				ot = t.NeighborAcrossFrom(p);
				if (ot == null)
				{
					// If we want to integrate the fillEdgeEvent do it here
					// With current implementation we should never get here
					throw new Exception("[BUG:FIXME] FLIP failed due to missing triangle");
				}
				op = ot.OppositePoint(t, p);
				if (tcx.IsDebugEnabled)
				{
					Console.WriteLine("[FLIP:SCAN] - scan next point"); // TODO: remove
					tcx.DTDebugContext.PrimaryTriangle = t;
					tcx.DTDebugContext.SecondaryTriangle = ot;
				}

				inScanArea = TriangulationUtil.InScanArea(eq, flipTriangle.PointCCWFrom(eq), flipTriangle.PointCWFrom(eq), op);
				if (inScanArea)
				{
					// flip with new edge op->eq
					FlipEdgeEvent(tcx, eq, op, ot, op);
				}
				else if (NextFlipPoint(ep, eq, ot, op, out newP))
				{
					FlipScanEdgeEvent(tcx, ep, eq, flipTriangle, ot, newP);
				}
			}

			private static void FillAdvancingFront(DTSweepContext tcx, AdvancingFrontNode n)
			{
				AdvancingFrontNode node;
				double angle;

				// Fill right holes
				node = n.Next;
				while (node.HasNext)
				{
					angle = HoleAngle(node);
					if (angle > PI_div2 || angle < -PI_div2)
					{
						break;
					}
					Fill(tcx, node);
					node = node.Next;
				}

				// Fill left holes
				node = n.Prev;
				while (node.HasPrev)
				{
					angle = HoleAngle(node);
					if (angle > PI_div2 || angle < -PI_div2)
					{
						break;
					}
					Fill(tcx, node);
					node = node.Prev;
				}

				// Fill right basins
				if (n.HasNext && n.Next.HasNext)
				{
					angle = BasinAngle(n);
					if (angle < PI_3div4)
					{
						FillBasin(tcx, n);
					}
				}
			}

			private static void FillBasin(DTSweepContext tcx, AdvancingFrontNode node)
			{
				if (TriangulationUtil.Orient2d(node.Point, node.Next.Point, node.Next.Next.Point) == Orientation.CCW)
				{
					tcx.Basin.leftNode = node;
				}
				else
				{
					tcx.Basin.leftNode = node.Next;
				}

				tcx.Basin.bottomNode = tcx.Basin.leftNode;
				while (tcx.Basin.bottomNode.HasNext && tcx.Basin.bottomNode.Point.Y >= tcx.Basin.bottomNode.Next.Point.Y)
				{
					tcx.Basin.bottomNode = tcx.Basin.bottomNode.Next;
				}

				if (!(tcx.Basin.bottomNode != tcx.Basin.leftNode))
				{
					return;
				}

				tcx.Basin.rightNode = tcx.Basin.bottomNode;
				while (tcx.Basin.rightNode.HasNext && tcx.Basin.rightNode.Point.Y < tcx.Basin.rightNode.Next.Point.Y)
				{
					tcx.Basin.rightNode = tcx.Basin.rightNode.Next;
				}

				if (!(tcx.Basin.rightNode != tcx.Basin.bottomNode))
				{
					return;
				}

				tcx.Basin.width = tcx.Basin.rightNode.Point.X - tcx.Basin.leftNode.Point.X;
				tcx.Basin.leftHighest = tcx.Basin.leftNode.Point.Y > tcx.Basin.rightNode.Point.Y;
				FillBasinReq(tcx, tcx.Basin.bottomNode);
			}

			private static void FillBasinReq(DTSweepContext tcx, AdvancingFrontNode node)
			{
				if (IsShallow(tcx, node))
				{
					return;
				}

				Fill(tcx, node);
				if (node.Prev == tcx.Basin.leftNode && node.Next == tcx.Basin.rightNode)
				{
					return;
				}

				if (node.Prev == tcx.Basin.leftNode)
				{
					if (TriangulationUtil.Orient2d(node.Point, node.Next.Point, node.Next.Next.Point) == Orientation.CW)
					{
						return;
					}

					node = node.Next;
				}
				else if (node.Next == tcx.Basin.rightNode)
				{
					Orientation orientation = TriangulationUtil.Orient2d(node.Point, node.Prev.Point, node.Prev.Prev.Point);
					if (orientation == Orientation.CCW)
					{
						return;
					}

					node = node.Prev;
				}
				else
				{
					node = (node.Prev.Point.Y < node.Next.Point.Y ? node.Prev : node.Next);
				}

				FillBasinReq(tcx, node);
			}

			private static bool IsShallow(DTSweepContext tcx, AdvancingFrontNode node)
			{
				double height;

				if (tcx.Basin.leftHighest)
				{
					height = tcx.Basin.leftNode.Point.Y - node.Point.Y;
				}
				else
				{
					height = tcx.Basin.rightNode.Point.Y - node.Point.Y;
				}
				if (tcx.Basin.width > height)
				{
					return true;
				}
				return false;
			}

			private static double HoleAngle(AdvancingFrontNode node)
			{
				double x = node.Point.X;
				double y = node.Point.Y;
				double num = node.Next.Point.X - x;
				double num2 = node.Next.Point.Y - y;
				double num3 = node.Prev.Point.X - x;
				double num4 = node.Prev.Point.Y - y;
				return Math.Atan2(num * num4 - num2 * num3, num * num3 + num2 * num4);
			}

			private static double BasinAngle(AdvancingFrontNode node)
			{
				double x = node.Point.X - node.Next.Next.Point.X;
				double y = node.Point.Y - node.Next.Next.Point.Y;
				return Math.Atan2(y, x);
			}

			private static void Fill(DTSweepContext tcx, AdvancingFrontNode node)
			{
				DelaunayTriangle delaunayTriangle = new DelaunayTriangle(node.Prev.Point, node.Point, node.Next.Point);
				delaunayTriangle.MarkNeighbor(node.Prev.Triangle);
				delaunayTriangle.MarkNeighbor(node.Triangle);
				tcx.Triangles.Add(delaunayTriangle);
				node.Prev.Next = node.Next;
				node.Next.Prev = node.Prev;
				tcx.RemoveNode(node);
				if (!Legalize(tcx, delaunayTriangle))
				{
					tcx.MapTriangleToNodes(delaunayTriangle);
				}
			}

			private static bool Legalize(DTSweepContext tcx, DelaunayTriangle t)
			{
				// To legalize a triangle we start by finding if any of the three edges
				// violate the Delaunay condition
				for (int i = 0; i < 3; i++)
				{
					// TODO: fix so that cEdge is always valid when creating new triangles then we can check it here
					//       instead of below with ot
					if (t.EdgeIsDelaunay[i])
					{
						continue;
					}

					DelaunayTriangle ot = t.Neighbors[i];
					if (ot == null)
					{
						continue;
					}

					TriangulationPoint p = t.Points[i];
					TriangulationPoint op = ot.OppositePoint(t, p);
					int oi = ot.IndexOf(op);
					// If this is a Constrained Edge or a Delaunay Edge(only during recursive legalization)
					// then we should not try to legalize
					if (ot.EdgeIsConstrained[oi] || ot.EdgeIsDelaunay[oi])
					{
						t.SetConstrainedEdgeAcross(p, ot.EdgeIsConstrained[oi]); // XXX: have no good way of setting this property when creating new triangles so lets set it here
						continue;
					}

					if (!TriangulationUtil.SmartIncircle(p, t.PointCCWFrom(p), t.PointCWFrom(p), op))
					{
						continue;
					}

					// Lets mark this shared edge as Delaunay
					t.EdgeIsDelaunay[i] = true;
					ot.EdgeIsDelaunay[oi] = true;

					// Lets rotate shared edge one vertex CW to legalize it
					RotateTrianglePair(t, p, ot, op);

					// We now got one valid Delaunay Edge shared by two triangles
					// This gives us 4 new edges to check for Delaunay

					// Make sure that triangle to node mapping is done only one time for a specific triangle
					if (!Legalize(tcx, t))
					{
						tcx.MapTriangleToNodes(t);
					}
					if (!Legalize(tcx, ot))
					{
						tcx.MapTriangleToNodes(ot);
					}

					// Reset the Delaunay edges, since they only are valid Delaunay edges
					// until we add a new triangle or point.
					// XXX: need to think about this. Can these edges be tried after we
					//      return to previous recursive level?
					t.EdgeIsDelaunay[i] = false;
					ot.EdgeIsDelaunay[oi] = false;

					// If triangle have been legalized no need to check the other edges since
					// the recursive legalization will handles those so we can end here.
					return true;
				}
				return false;
			}


			private static void RotateTrianglePair(DelaunayTriangle t, TriangulationPoint p, DelaunayTriangle ot, TriangulationPoint op)
			{
				DelaunayTriangle delaunayTriangle = t.NeighborCCWFrom(p);
				DelaunayTriangle delaunayTriangle2 = t.NeighborCWFrom(p);
				DelaunayTriangle delaunayTriangle3 = ot.NeighborCCWFrom(op);
				DelaunayTriangle delaunayTriangle4 = ot.NeighborCWFrom(op);
				bool constrainedEdgeCCW = t.GetConstrainedEdgeCCW(p);
				bool constrainedEdgeCW = t.GetConstrainedEdgeCW(p);
				bool constrainedEdgeCCW2 = ot.GetConstrainedEdgeCCW(op);
				bool constrainedEdgeCW2 = ot.GetConstrainedEdgeCW(op);
				bool delaunayEdgeCCW = t.GetDelaunayEdgeCCW(p);
				bool delaunayEdgeCW = t.GetDelaunayEdgeCW(p);
				bool delaunayEdgeCCW2 = ot.GetDelaunayEdgeCCW(op);
				bool delaunayEdgeCW2 = ot.GetDelaunayEdgeCW(op);
				t.Legalize(p, op);
				ot.Legalize(op, p);
				ot.SetDelaunayEdgeCCW(p, delaunayEdgeCCW);
				t.SetDelaunayEdgeCW(p, delaunayEdgeCW);
				t.SetDelaunayEdgeCCW(op, delaunayEdgeCCW2);
				ot.SetDelaunayEdgeCW(op, delaunayEdgeCW2);
				ot.SetConstrainedEdgeCCW(p, constrainedEdgeCCW);
				t.SetConstrainedEdgeCW(p, constrainedEdgeCW);
				t.SetConstrainedEdgeCCW(op, constrainedEdgeCCW2);
				ot.SetConstrainedEdgeCW(op, constrainedEdgeCW2);
				t.Neighbors.Clear();
				ot.Neighbors.Clear();
				if (delaunayTriangle != null)
				{
					ot.MarkNeighbor(delaunayTriangle);
				}
				if (delaunayTriangle2 != null)
				{
					t.MarkNeighbor(delaunayTriangle2);
				}
				if (delaunayTriangle3 != null)
				{
					t.MarkNeighbor(delaunayTriangle3);
				}
				if (delaunayTriangle4 != null)
				{
					ot.MarkNeighbor(delaunayTriangle4);
				}
				t.MarkNeighbor(ot);
			}
		}
}
