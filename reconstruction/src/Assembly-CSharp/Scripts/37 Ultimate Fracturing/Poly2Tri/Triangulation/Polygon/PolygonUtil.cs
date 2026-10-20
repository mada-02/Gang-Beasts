using System.Collections.Generic;
using System.Text;
using System;

namespace Poly2Tri
{
		public class PolygonUtil
		{
			public enum PolyUnionError
			{
				None,
				NoIntersections,
				Poly1InsidePoly2,
				InfiniteLoop
			}

			[Flags]
			public enum PolyOperation : uint
			{
				None = 0u,
				Union = 1u,
				Intersect = 2u,
				Subtract = 4u
			}

			public static Point2DList.WindingOrderType CalculateWindingOrder(IList<Point2D> l)
			{
				double num = 0.0;
				for (int i = 0; i < l.Count; i++)
				{
					int index = (i + 1) % l.Count;
					num += l[i].X * l[index].Y;
					num -= l[i].Y * l[index].X;
				}
				num /= 2.0;
				if (num < 0.0)
				{
					return Point2DList.WindingOrderType.CW;
				}
				if (num > 0.0)
				{
					return Point2DList.WindingOrderType.CCW;
				}
				return Point2DList.WindingOrderType.Unknown;
			}

			public static bool PolygonsAreSame2D(IList<Point2D> poly1, IList<Point2D> poly2)
			{
				int count = poly1.Count;
				int count2 = poly2.Count;
				if (count != count2)
				{
					return false;
				}

				Point2D point2D = new Point2D(0.0, 0.0);
				for (int i = 0; i < count2; i++)
				{
					point2D.Set(poly1[0]);
					point2D.Subtract(poly2[i]);
					if (point2D.MagnitudeSquared() < 0.0001)
					{
						int num = i;
						bool flag = false;
						bool flag2;
						do
						{
							flag2 = true;
							for (int j = 1; j < count; j++)
							{
								if (!flag)
								{
									i++;
								}
								else
								{
									i--;
									if (i < 0)
									{
										i = count2 - 1;
									}
								}

								point2D.Set(poly1[j]);
								point2D.Subtract(poly2[i % count2]);
								if (point2D.MagnitudeSquared() >= 0.0001)
								{
									if (flag)
									{
										return false;
									}

									i = num;
									flag = true;
									flag2 = false;
									break;
								}
							}
						}
						while (!flag2);
						return true;
					}
				}

				return false;
			}

			public static bool PointInPolygon2D(IList<Point2D> polygon, Point2D p)
			{
				if (polygon == null || polygon.Count < 3)
				{
					return false;
				}
				int count = polygon.Count;
				Point2D point2D = polygon[count - 1];
				bool flag = ((point2D.Y >= p.Y) ? true : false);
				Point2D point2D2 = null;
				bool flag2 = false;
				for (int i = 0; i < count; i++)
				{
					point2D2 = polygon[i];
					bool flag3 = ((point2D2.Y >= p.Y) ? true : false);
					if (flag != flag3 && (point2D2.Y - p.Y) * (point2D.X - point2D2.X) >= (point2D2.X - p.X) * (point2D.Y - point2D2.Y) == flag3)
					{
						flag2 = !flag2;
					}
					flag = flag3;
					point2D = point2D2;
				}
				return flag2;
			}

			public static bool PolygonsIntersect2D(IList<Point2D> poly1, Rect2D boundRect1, IList<Point2D> poly2, Rect2D boundRect2)
			{
				if (poly1 == null || poly1.Count < 3 || boundRect1 == null || poly2 == null || poly2.Count < 3 || boundRect2 == null)
				{
					return false;
				}
				if (!boundRect1.Intersects(boundRect2))
				{
					return false;
				}
				double epsilon = Math.Max(Math.Min(boundRect1.Width, boundRect2.Width) * 0.001, MathUtil.EPSILON);
				int count = poly1.Count;
				int count2 = poly2.Count;
				for (int i = 0; i < count; i++)
				{
					int num = i + 1;
					if (num == count)
					{
						num = 0;
					}
					for (int j = 0; j < count2; j++)
					{
						int num2 = j + 1;
						if (num2 == count2)
						{
							num2 = 0;
						}
						Point2D pIntersectionPt = null;
						if (TriangulationUtil.LinesIntersect2D(poly1[i], poly1[num], poly2[j], poly2[num2], ref pIntersectionPt, epsilon))
						{
							return true;
						}
					}
				}
				return false;
			}

			public bool PolygonContainsPolygon(IList<Point2D> poly1, Rect2D boundRect1, IList<Point2D> poly2, Rect2D boundRect2)
			{
				return PolygonContainsPolygon(poly1, boundRect1, poly2, boundRect2, true);
			}

			public static bool PolygonContainsPolygon(IList<Point2D> poly1, Rect2D boundRect1, IList<Point2D> poly2, Rect2D boundRect2, bool runIntersectionTest)
			{
				if (poly1 == null || poly1.Count < 3 || poly2 == null || poly2.Count < 3)
				{
					return false;
				}
				if (runIntersectionTest)
				{
					if (poly1.Count == poly2.Count && PolygonsAreSame2D(poly1, poly2))
					{
						return false;
					}
					bool bIntersect = PolygonsIntersect2D(poly1, boundRect1, poly2, boundRect2);
					if (bIntersect)
					{
						return false;
					}
				}
				if (PointInPolygon2D(poly1, poly2[0]))
				{
					return true;
				}
				return false;
			}

			public static void ClipPolygonToEdge2D(Point2D edgeBegin, Point2D edgeEnd, IList<Point2D> poly, out List<Point2D> outPoly)
			{
				outPoly = null;
				if (edgeBegin == null || edgeEnd == null || poly == null || poly.Count < 3)
				{
					return;
				}
				outPoly = new List<Point2D>();
				int index = poly.Count - 1;
				Point2D ptRayVector = new Point2D(edgeEnd.X - edgeBegin.X, edgeEnd.Y - edgeBegin.Y);
				bool flag = TriangulationUtil.Orient2d(edgeBegin, edgeEnd, poly[index]) == Orientation.CW;
				Point2D point2D = new Point2D(0.0, 0.0);
				for (int i = 0; i < poly.Count; i++)
				{
					bool flag2 = TriangulationUtil.Orient2d(edgeBegin, edgeEnd, poly[i]) == Orientation.CW;
					if (flag2)
					{
						if (flag)
						{
							outPoly.Add(poly[i]);
						}
						else
						{
							point2D.Set(poly[i].X - poly[index].X, poly[i].Y - poly[index].Y);
							Point2D ptIntersection = new Point2D(0.0, 0.0);
							if (TriangulationUtil.RaysIntersect2D(poly[index], point2D, edgeBegin, ptRayVector, ref ptIntersection))
							{
								outPoly.Add(ptIntersection);
								outPoly.Add(poly[i]);
							}
						}
					}
					else if (flag)
					{
						point2D.Set(poly[i].X - poly[index].X, poly[i].Y - poly[index].Y);
						Point2D ptIntersection2 = new Point2D(0.0, 0.0);
						if (TriangulationUtil.RaysIntersect2D(poly[index], point2D, edgeBegin, ptRayVector, ref ptIntersection2))
						{
							outPoly.Add(ptIntersection2);
						}
					}
					index = i;
					flag = flag2;
				}
			}

			public static void ClipPolygonToPolygon(IList<Point2D> poly, IList<Point2D> clipPoly, out List<Point2D> outPoly)
			{
				outPoly = null;
				if (!(poly != null && poly.Count >= 3 && clipPoly != null && clipPoly.Count >= 3))
				{
					return;
				}

				outPoly = new List<Point2D>(poly);
				int count = clipPoly.Count;
				int index = count - 1;
				for (int i = 0; i < count; i++)
				{
					List<Point2D> outPoly2 = null;
					Point2D edgeBegin = clipPoly[index];
					Point2D edgeEnd = clipPoly[i];
					ClipPolygonToEdge2D(edgeBegin, edgeEnd, outPoly, out outPoly2);
					outPoly.Clear();
					outPoly.AddRange(outPoly2);
					index = i;
				}
			}

			public static PolyUnionError PolygonUnion(Point2DList polygon1, Point2DList polygon2, out Point2DList union)
			{
				PolygonOperationContext polygonOperationContext = new PolygonOperationContext();
				polygonOperationContext.Init(PolyOperation.Union, polygon1, polygon2);
				PolygonUnionInternal(polygonOperationContext);
				union = polygonOperationContext.Union;
				return polygonOperationContext.mError;
			}

			protected static void PolygonUnionInternal(PolygonOperationContext ctx)
			{
				Point2DList union = ctx.Union;
				if (ctx.mStartingIndex == -1)
				{
					switch (ctx.mError)
					{
						case PolyUnionError.NoIntersections:
						case PolyUnionError.InfiniteLoop:
							return;
						case PolyUnionError.Poly1InsidePoly2:
							union.AddRange(ctx.mOriginalPolygon2);
							return;
					}
				}

				Point2DList point2DList = ctx.mPoly1;
				Point2DList point2DList2 = ctx.mPoly2;
				List<int> list = ctx.mPoly1VectorAngles;
				Point2D point2D = ctx.mPoly1[ctx.mStartingIndex];
				int num = ctx.mStartingIndex;
				int num2 = -1;
				union.Clear();
				do
				{
					union.Add(point2DList[num]);
					foreach (EdgeIntersectInfo mIntersection in ctx.mIntersections)
					{
						if (point2DList[num].Equals(mIntersection.IntersectionPoint, point2DList.Epsilon))
						{
							int num3 = point2DList2.IndexOf(mIntersection.IntersectionPoint);
							int index = point2DList2.NextIndex(num3);
							Point2D point = point2DList2[index];
							bool flag = false;
							if (list[index] == -1)
							{
								flag = ctx.PointInPolygonAngle(point, point2DList);
								list[index] = (flag ? 1 : 0);
							}
							else
							{
								flag = (list[index] == 1) ? true : false;
							}

							if (!flag)
							{
								if (point2DList == ctx.mPoly1)
								{
									point2DList = ctx.mPoly2;
									list = ctx.mPoly2VectorAngles;
									point2DList2 = ctx.mPoly1;
									if (num2 < 0)
									{
										num2 = num3;
									}
								}
								else
								{
									point2DList = ctx.mPoly1;
									list = ctx.mPoly1VectorAngles;
									point2DList2 = ctx.mPoly2;
								}

								num = num3;
								break;
							}
						}
					}

					num = point2DList.NextIndex(num);
					if (point2DList == ctx.mPoly1)
					{
						if (num == 0)
						{
							break;
						}
					}
					else if (num2 >= 0 && num == num2)
					{
						break;
					}
				}
				while (point2DList[num] != point2D && union.Count <= ctx.mPoly1.Count + ctx.mPoly2.Count);
				if (union.Count > ctx.mPoly1.Count + ctx.mPoly2.Count)
				{
					ctx.mError = PolyUnionError.InfiniteLoop;
				}
			}

			public static PolyUnionError PolygonIntersect(Point2DList polygon1, Point2DList polygon2, out Point2DList intersectOut)
			{
				PolygonOperationContext polygonOperationContext = new PolygonOperationContext();
				polygonOperationContext.Init(PolyOperation.Intersect, polygon1, polygon2);
				PolygonIntersectInternal(polygonOperationContext);
				intersectOut = polygonOperationContext.Intersect;
				return polygonOperationContext.mError;
			}

			protected static void PolygonIntersectInternal(PolygonOperationContext ctx)
			{
				Point2DList intersect = ctx.Intersect;
				if (ctx.mStartingIndex == -1)
				{
					switch (ctx.mError)
					{
					case PolyUnionError.NoIntersections:
					case PolyUnionError.InfiniteLoop:
						return;
					case PolyUnionError.Poly1InsidePoly2:
						intersect.AddRange(ctx.mOriginalPolygon2);
						return;
					}
				}
				Point2DList point2DList = ctx.mPoly1;
				Point2DList point2DList2 = ctx.mPoly2;
				List<int> list = ctx.mPoly1VectorAngles;
				int num = ctx.mPoly1.IndexOf(ctx.mIntersections[0].IntersectionPoint);
				Point2D point2D = ctx.mPoly1[num];
				int num2 = num;
				int num3 = -1;
				intersect.Clear();
				while (!intersect.Contains(point2DList[num]))
				{
					intersect.Add(point2DList[num]);
					foreach (EdgeIntersectInfo mIntersection in ctx.mIntersections)
					{
						if (!point2DList[num].Equals(mIntersection.IntersectionPoint, point2DList.Epsilon))
						{
							continue;
						}
						int num4 = point2DList2.IndexOf(mIntersection.IntersectionPoint);
						int index = point2DList2.NextIndex(num4);
						Point2D point = point2DList2[index];
						bool flag = false;
						if (list[index] == -1)
						{
							flag = ctx.PointInPolygonAngle(point, point2DList);
							list[index] = (flag ? 1 : 0);
						}
						else
						{
							flag = list[index] == 1;
						}
						if (!flag)
						{
							continue;
						}
						if (point2DList == ctx.mPoly1)
						{
							point2DList = ctx.mPoly2;
							list = ctx.mPoly2VectorAngles;
							point2DList2 = ctx.mPoly1;
							if (num3 < 0)
							{
								num3 = num4;
							}
						}
						else
						{
							point2DList = ctx.mPoly1;
							list = ctx.mPoly1VectorAngles;
							point2DList2 = ctx.mPoly2;
						}
						num = num4;
						break;
					}
					num = point2DList.NextIndex(num);
					if (point2DList == ctx.mPoly1)
					{
						if (num == num2)
						{
							break;
						}
					}
					else if (num3 >= 0 && num == num3)
					{
						break;
					}
					if (point2DList[num] == point2D || intersect.Count > ctx.mPoly1.Count + ctx.mPoly2.Count)
					{
						break;
					}
				}
				if (intersect.Count > ctx.mPoly1.Count + ctx.mPoly2.Count)
				{
					ctx.mError = PolyUnionError.InfiniteLoop;
				}
			}

			public static PolyUnionError PolygonSubtract(Point2DList polygon1, Point2DList polygon2, out Point2DList subtract)
			{
				PolygonOperationContext polygonOperationContext = new PolygonOperationContext();
				polygonOperationContext.Init(PolyOperation.Subtract, polygon1, polygon2);
				PolygonSubtractInternal(polygonOperationContext);
				subtract = polygonOperationContext.Subtract;
				return polygonOperationContext.mError;
			}

			public static void PolygonSubtractInternal(PolygonOperationContext ctx)
			{
				Point2DList subtract = ctx.Subtract;
				if (ctx.mStartingIndex == -1)
				{
					switch (ctx.mError)
					{
						case PolyUnionError.NoIntersections:
						case PolyUnionError.Poly1InsidePoly2:
						case PolyUnionError.InfiniteLoop:
							return;
					}
				}

				Point2DList point2DList = ctx.mPoly1;
				Point2DList point2DList2 = ctx.mPoly2;
				List<int> list = ctx.mPoly1VectorAngles;
				Point2D point2D = ctx.mPoly1[ctx.mStartingIndex];
				int index = ctx.mStartingIndex;
				subtract.Clear();
				bool flag = true;
				do
				{
					subtract.Add(point2DList[index]);
					foreach (EdgeIntersectInfo mIntersection in ctx.mIntersections)
					{
						if (point2DList[index].Equals(mIntersection.IntersectionPoint, point2DList.Epsilon))
						{
							int num = point2DList2.IndexOf(mIntersection.IntersectionPoint);
							if (flag)
							{
								int index2 = point2DList2.PreviousIndex(num);
								Point2D point = point2DList2[index2];
								bool flag2 = false;
								if (list[index2] == -1)
								{
									flag2 = ctx.PointInPolygonAngle(point, point2DList);
									list[index2] = (flag2 ? 1 : 0);
								}
								else
								{
									flag2 = (list[index2] == 1) ? true : false;
								}

								if (flag2)
								{
									if (point2DList == ctx.mPoly1)
									{
										point2DList = ctx.mPoly2;
										list = ctx.mPoly2VectorAngles;
										point2DList2 = ctx.mPoly1;
									}
									else
									{
										point2DList = ctx.mPoly1;
										list = ctx.mPoly1VectorAngles;
										point2DList2 = ctx.mPoly2;
									}

									index = num;
									flag = !flag;
									break;
								}

								continue;
							}

							int index3 = point2DList2.NextIndex(num);
							Point2D point2 = point2DList2[index3];
							bool flag3 = false;
							if (list[index3] == -1)
							{
								flag3 = ctx.PointInPolygonAngle(point2, point2DList);
								list[index3] = (flag3 ? 1 : 0);
							}
							else
							{
								flag3 = (list[index3] == 1) ? true : false;
							}

							if (!flag3)
							{
								if (point2DList == ctx.mPoly1)
								{
									point2DList = ctx.mPoly2;
									list = ctx.mPoly2VectorAngles;
									point2DList2 = ctx.mPoly1;
								}
								else
								{
									point2DList = ctx.mPoly1;
									list = ctx.mPoly1VectorAngles;
									point2DList2 = ctx.mPoly2;
								}

								index = num;
								flag = !flag;
								break;
							}
						}
					}

					if (flag)
					{
						index = point2DList.NextIndex(index);
					}
					else
					{
						index = point2DList.PreviousIndex(index);
					}
				}
				while (point2DList[index] != point2D && subtract.Count <= ctx.mPoly1.Count + ctx.mPoly2.Count);
				if (subtract.Count > ctx.mPoly1.Count + ctx.mPoly2.Count)
				{
					ctx.mError = PolyUnionError.InfiniteLoop;
				}
			}

			public static PolyUnionError PolygonOperation(PolyOperation operations, Point2DList polygon1, Point2DList polygon2, out Dictionary<uint, Point2DList> results)
			{
				PolygonOperationContext polygonOperationContext = new PolygonOperationContext();
				polygonOperationContext.Init(operations, polygon1, polygon2);
				results = polygonOperationContext.mOutput;
				return PolygonOperation(polygonOperationContext);
			}

			public static PolyUnionError PolygonOperation(PolygonOperationContext ctx)
			{
				if ((ctx.mOperations & PolyOperation.Union) == PolyOperation.Union)
				{
					PolygonUnionInternal(ctx);
				}
				if ((ctx.mOperations & PolyOperation.Intersect) == PolyOperation.Intersect)
				{
					PolygonIntersectInternal(ctx);
				}
				if ((ctx.mOperations & PolyOperation.Subtract) == PolyOperation.Subtract)
				{
					PolygonSubtractInternal(ctx);
				}
				return ctx.mError;
			}

			public static List<Point2DList> SplitComplexPolygon(Point2DList verts, double epsilon)
			{
				int count = verts.Count;
				int num = 0;
				List<SplitComplexPolygonNode> list = new List<SplitComplexPolygonNode>();
				for (int i = 0; i < verts.Count; i++)
				{
					SplitComplexPolygonNode item = new SplitComplexPolygonNode(new Point2D(verts[i].X, verts[i].Y));
					list.Add(item);
				}

				for (int j = 0; j < verts.Count; j++)
				{
					int index = (j == count - 1 ? 0 : (j + 1));
					int index2 = (!(j != 0) ? (count - 1) : (j - 1));
					list[j].AddConnection(list[index]);
					list[j].AddConnection(list[index2]);
				}

				num = list.Count;
				bool flag = true;
				int num2 = 0;
				while (flag)
				{
					flag = false;
					int num3 = 0;
					while (!flag && num3 < num)
					{
						int num4 = 0;
						while (!flag && num4 < list[num3].NumConnected)
						{
							int num5 = 0;
							while (!flag && num5 < num)
							{
								if (num5 != num3 && !(list[num5] == list[num3][num4]))
								{
									int num6 = 0;
									while (!flag && num6 < list[num5].NumConnected)
									{
										if (!(list[num5][num6] == list[num3][num4]) && !(list[num5][num6] == list[num3]))
										{
											Point2D pIntersectionPt = new Point2D();
											if (TriangulationUtil.LinesIntersect2D(list[num3].Position, list[num3][num4].Position, list[num5].Position, list[num5][num6].Position, true, true, true, ref pIntersectionPt, epsilon))
											{
												flag = true;
												SplitComplexPolygonNode splitComplexPolygonNode = new SplitComplexPolygonNode(pIntersectionPt);
												int num7 = list.IndexOf(splitComplexPolygonNode);
												if (num7 >= 0 && num7 < list.Count)
												{
													splitComplexPolygonNode = list[num7];
												}
												else
												{
													list.Add(splitComplexPolygonNode);
													num = list.Count;
												}

												SplitComplexPolygonNode splitComplexPolygonNode2 = list[num3];
												SplitComplexPolygonNode splitComplexPolygonNode3 = list[num3][num4];
												SplitComplexPolygonNode splitComplexPolygonNode4 = list[num5];
												SplitComplexPolygonNode splitComplexPolygonNode5 = list[num5][num6];
												splitComplexPolygonNode3.RemoveConnection(splitComplexPolygonNode2);
												splitComplexPolygonNode2.RemoveConnection(splitComplexPolygonNode3);
												splitComplexPolygonNode5.RemoveConnection(splitComplexPolygonNode4);
												splitComplexPolygonNode4.RemoveConnection(splitComplexPolygonNode5);
												if (!splitComplexPolygonNode.Position.Equals(splitComplexPolygonNode2.Position, epsilon))
												{
													splitComplexPolygonNode.AddConnection(splitComplexPolygonNode2);
													splitComplexPolygonNode2.AddConnection(splitComplexPolygonNode);
												}

												if (!splitComplexPolygonNode.Position.Equals(splitComplexPolygonNode4.Position, epsilon))
												{
													splitComplexPolygonNode.AddConnection(splitComplexPolygonNode4);
													splitComplexPolygonNode4.AddConnection(splitComplexPolygonNode);
												}

												if (!splitComplexPolygonNode.Position.Equals(splitComplexPolygonNode3.Position, epsilon))
												{
													splitComplexPolygonNode.AddConnection(splitComplexPolygonNode3);
													splitComplexPolygonNode3.AddConnection(splitComplexPolygonNode);
												}

												if (!splitComplexPolygonNode.Position.Equals(splitComplexPolygonNode5.Position, epsilon))
												{
													splitComplexPolygonNode.AddConnection(splitComplexPolygonNode5);
													splitComplexPolygonNode5.AddConnection(splitComplexPolygonNode);
												}
											}
										}

										num6++;
									}
								}

								num5++;
							}

							num4++;
						}

						num3++;
					}

					num2++;
				}

				bool flag2 = true;
				int num8 = num;
				double num9 = epsilon * epsilon;
				while (flag2)
				{
					flag2 = false;
					for (int k = 0; k < num; k++)
					{
						if (list[k].NumConnected != 0)
						{
							for (int l = k + 1; l < num; l++)
							{
								if (!(list[l].NumConnected == 0))
								{
									Point2D point2D = list[k].Position - list[l].Position;
									if (point2D.MagnitudeSquared() <= num9)
									{
										if (num8 <= 3)
										{
											throw new Exception("Eliminated so many duplicate points that resulting polygon has < 3 vertices!");
										}

										num8--;
										flag2 = true;
										SplitComplexPolygonNode splitComplexPolygonNode6 = list[k];
										SplitComplexPolygonNode splitComplexPolygonNode7 = list[l];
										int numConnected = splitComplexPolygonNode7.NumConnected;
										for (int m = 0; m < numConnected; m++)
										{
											SplitComplexPolygonNode splitComplexPolygonNode8 = splitComplexPolygonNode7[m];
											if (splitComplexPolygonNode8 != splitComplexPolygonNode6)
											{
												splitComplexPolygonNode6.AddConnection(splitComplexPolygonNode8);
												splitComplexPolygonNode8.AddConnection(splitComplexPolygonNode6);
											}

											splitComplexPolygonNode8.RemoveConnection(splitComplexPolygonNode7);
										}

										splitComplexPolygonNode7.ClearConnections();
										list.RemoveAt(l);
										num--;
									}
								}
							}
						}
					}
				}

				double num10 = double.MaxValue;
				double num11 = double.MinValue;
				int index3 = -1;
				for (int n = 0; n < num; n++)
				{
					if (list[n].Position.Y < num10 && list[n].NumConnected > 1)
					{
						num10 = list[n].Position.Y;
						index3 = n;
						num11 = list[n].Position.X;
					}
					else if (list[n].Position.Y == num10 && list[n].Position.X > num11 && list[n].NumConnected > 1)
					{
						index3 = n;
						num11 = list[n].Position.X;
					}
				}

				Point2D incomingDir = new Point2D(1.0, 0.0);
				List<Point2D> list2 = new List<Point2D>();
				SplitComplexPolygonNode splitComplexPolygonNode9 = list[index3];
				SplitComplexPolygonNode splitComplexPolygonNode10 = splitComplexPolygonNode9;
				SplitComplexPolygonNode rightestConnection = splitComplexPolygonNode9.GetRightestConnection(incomingDir);
				if (rightestConnection == null)
				{
					return SplitComplexPolygonCleanup(verts);
				}

				list2.Add(splitComplexPolygonNode10.Position);
				while (rightestConnection != splitComplexPolygonNode10)
				{
					if (list2.Count > 4 * num)
					{
						throw new Exception("nodes should never be visited four times apiece (proof?), so we've probably hit a loop...crap");
					}

					list2.Add(rightestConnection.Position);
					SplitComplexPolygonNode incoming = splitComplexPolygonNode9;
					splitComplexPolygonNode9 = rightestConnection;
					rightestConnection = splitComplexPolygonNode9.GetRightestConnection(incoming);
					if (rightestConnection == null)
					{
						return SplitComplexPolygonCleanup(list2);
					}
				}

				if (list2.Count < 1)
				{
					return SplitComplexPolygonCleanup(verts);
				}

				return SplitComplexPolygonCleanup(list2);
			}

			private static List<Point2DList> SplitComplexPolygonCleanup(IList<Point2D> orig)
			{
				List<Point2DList> list = new List<Point2DList>();
				Point2DList point2DList = new Point2DList(orig);
				list.Add(point2DList);
				int i = 0;
				for (int num = list.Count; i < num; i++)
				{
					int num2 = list[i].Count;
					for (int j = 0; j < num2; j++)
					{
						for (int k = j + 1; k < num2; k++)
						{
							if (list[i][j].Equals(list[i][k], point2DList.Epsilon))
							{
								int num3 = k - j;
								Point2DList point2DList2 = new Point2DList();
								for (int l = j + 1; l <= k; l++)
								{
									point2DList2.Add(list[i][l]);
								}
								list[i].RemoveRange(j + 1, num3);
								list.Add(point2DList2);
								num++;
								num2 -= num3;
								k = j + 1;
							}
						}
					}
					list[i].Simplify();
				}
				return list;
			}
		}

		public class EdgeIntersectInfo
		{
			public EdgeIntersectInfo(Edge edgeOne, Edge edgeTwo, Point2D intersectionPoint)
			{
				EdgeOne = edgeOne;
				EdgeTwo = edgeTwo;
				IntersectionPoint = intersectionPoint;
			}
			public Edge EdgeOne { get; private set; }

			public Edge EdgeTwo { get; private set; }

			public Point2D IntersectionPoint { get; private set; }
		}

		public class SplitComplexPolygonNode
		{
			private List<SplitComplexPolygonNode> mConnected = new List<SplitComplexPolygonNode>();

			private Point2D mPosition;

			public SplitComplexPolygonNode()
			{
			}

			public SplitComplexPolygonNode(Point2D pos)
			{
				mPosition = pos;
			}

			public int NumConnected
			{
				get
				{
					return mConnected.Count;
				}
			}

			public Point2D Position
			{
				get
				{
					return mPosition;
				}
				set
				{
					mPosition = value;
				}
			}

			public SplitComplexPolygonNode this[int index]
			{
				get
				{
					return mConnected[index];
				}
			}

			public override bool Equals(object obj)
			{
				SplitComplexPolygonNode splitComplexPolygonNode = obj as SplitComplexPolygonNode;
				if (splitComplexPolygonNode == null)
				{
					return base.Equals(obj);
				}
				return Equals(splitComplexPolygonNode);
			}

			public bool Equals(SplitComplexPolygonNode pn)
			{
				if ((object)pn == null)
				{
					return false;
				}
				if (mPosition == null || pn.Position == null)
				{
					return false;
				}
				return mPosition.Equals(pn.Position);
			}

			public override int GetHashCode()
			{
				return base.GetHashCode();
			}

			public override string ToString()
			{
				StringBuilder stringBuilder = new StringBuilder(256);
				stringBuilder.Append(mPosition.ToString());
				stringBuilder.Append(" -> ");
				for (int i = 0; i < NumConnected; i++)
				{
					if (i != 0)
					{
						stringBuilder.Append(", ");
					}
					stringBuilder.Append(mConnected[i].Position.ToString());
				}
				return stringBuilder.ToString();
			}

			private bool IsRighter(double sinA, double cosA, double sinB, double cosB)
			{
				if (sinA < 0.0)
				{
					if (sinB > 0.0 || cosA <= cosB)
					{
						return true;
					}
					return false;
				}
				if (sinB < 0.0 || cosA <= cosB)
				{
					return false;
				}
				return true;
			}

			private int remainder(int x, int modulus)
			{
				int i;
				for (i = x % modulus; i < 0; i += modulus)
				{
				}
				return i;
			}

			public void AddConnection(SplitComplexPolygonNode toMe)
			{
				if (!mConnected.Contains(toMe) && toMe != this)
				{
					mConnected.Add(toMe);
				}
			}

			public void RemoveConnection(SplitComplexPolygonNode fromMe)
			{
				mConnected.Remove(fromMe);
			}

			private void RemoveConnectionByIndex(int index)
			{
				if (!(index >= 0 && index < mConnected.Count))
				{
					return;
				}

				mConnected.RemoveAt(index);
			}

			public void ClearConnections()
			{
				mConnected.Clear();
			}

			private bool IsConnectedTo(SplitComplexPolygonNode me)
			{
				return mConnected.Contains(me);
			}

			public SplitComplexPolygonNode GetRightestConnection(SplitComplexPolygonNode incoming)
			{
				if (NumConnected == 0)
				{
					throw new Exception("the connection graph is inconsistent");
				}
				if (NumConnected == 1)
				{
					return incoming;
				}
				Point2D point2D = mPosition - incoming.mPosition;
				double num = point2D.Magnitude();
				point2D.Normalize();
				if (num <= MathUtil.EPSILON)
				{
					throw new Exception("Length too small");
				}
				SplitComplexPolygonNode splitComplexPolygonNode = null;
				for (int i = 0; i < NumConnected; i++)
				{
					if (mConnected[i] == incoming)
					{
						continue;
					}
					Point2D point2D2 = mConnected[i].mPosition - mPosition;
					double num2 = point2D2.MagnitudeSquared();
					point2D2.Normalize();
					if (num2 <= MathUtil.EPSILON * MathUtil.EPSILON)
					{
						throw new Exception("Length too small");
					}
					double cosA = Point2D.Dot(point2D, point2D2);
					double sinA = Point2D.Cross(point2D, point2D2);
					if (splitComplexPolygonNode != null)
					{
						Point2D point2D3 = splitComplexPolygonNode.mPosition - mPosition;
						point2D3.Normalize();
						double cosB = Point2D.Dot(point2D, point2D3);
						double sinB = Point2D.Cross(point2D, point2D3);
						if (IsRighter(sinA, cosA, sinB, cosB))
						{
							splitComplexPolygonNode = mConnected[i];
						}
					}
					else
					{
						splitComplexPolygonNode = mConnected[i];
					}
				}
				return splitComplexPolygonNode;
			}

			public SplitComplexPolygonNode GetRightestConnection(Point2D incomingDir)
			{
				Point2D pos = mPosition - incomingDir;
				SplitComplexPolygonNode incoming = new SplitComplexPolygonNode(pos);
				SplitComplexPolygonNode result44 = GetRightestConnection(incoming);
				return result44;
			}

			public static bool operator ==(SplitComplexPolygonNode lhs, SplitComplexPolygonNode rhs)
			{
				if ((object)lhs != null)
				{
					return lhs.Equals(rhs);
				}
				if ((object)rhs == null)
				{
					return true;
				}
				return false;
			}

			public static bool operator !=(SplitComplexPolygonNode lhs, SplitComplexPolygonNode rhs)
			{
				if ((object)lhs != null)
				{
					return !lhs.Equals(rhs);
				}
				if ((object)rhs == null)
				{
					return false;
				}
				return true;
			}
		}

		public class PolygonOperationContext
		{
			public PolygonUtil.PolyOperation mOperations;

			public Point2DList mOriginalPolygon1;

			public Point2DList mOriginalPolygon2;

			public Point2DList mPoly1;

			public Point2DList mPoly2;

			public List<EdgeIntersectInfo> mIntersections;

			public int mStartingIndex;

			public PolygonUtil.PolyUnionError mError;

			public List<int> mPoly1VectorAngles;

			public List<int> mPoly2VectorAngles;

			public Dictionary<uint, Point2DList> mOutput = new Dictionary<uint, Point2DList>();

			public Point2DList Union
			{
				get
				{
					Point2DList value = null;
					if (!mOutput.TryGetValue(1u, out value))
					{
						value = new Point2DList();
						mOutput.Add(1u, value);
					}
					return value;
				}
			}

			public Point2DList Intersect
			{
				get
				{
					Point2DList value = null;
					if (!mOutput.TryGetValue(2u, out value))
					{
						value = new Point2DList();
						mOutput.Add(2u, value);
					}
					return value;
				}
			}

			public Point2DList Subtract
			{
				get
				{
					Point2DList value = null;
					if (!mOutput.TryGetValue(4u, out value))
					{
						value = new Point2DList();
						mOutput.Add(4u, value);
					}
					return value;
				}
			}

			public void Clear()
			{
				mOperations = PolygonUtil.PolyOperation.None;
				mOriginalPolygon1 = null;
				mOriginalPolygon2 = null;
				mPoly1 = null;
				mPoly2 = null;
				mIntersections = null;
				mStartingIndex = -1;
				mError = PolygonUtil.PolyUnionError.None;
				mPoly1VectorAngles = null;
				mPoly2VectorAngles = null;
				mOutput = new Dictionary<uint, Point2DList>();
			}

			public bool Init(PolygonUtil.PolyOperation operations, Point2DList polygon1, Point2DList polygon2)
			{
				Clear();
				mOperations = operations;
				mOriginalPolygon1 = polygon1;
				mOriginalPolygon2 = polygon2;
				mPoly1 = new Point2DList(polygon1);
				mPoly1.WindingOrder = Point2DList.WindingOrderType.CCW;
				mPoly2 = new Point2DList(polygon2);
				mPoly2.WindingOrder = Point2DList.WindingOrderType.CCW;
				if (!VerticesIntersect(mPoly1, mPoly2, out mIntersections))
				{
					mError = PolygonUtil.PolyUnionError.NoIntersections;
					return false;
				}
				int count = mIntersections.Count;
				for (int i = 0; i < count; i++)
				{
					for (int j = i + 1; j < count; j++)
					{
						if (mIntersections[i].EdgeOne.EdgeStart.Equals(mIntersections[j].EdgeOne.EdgeStart) && mIntersections[i].EdgeOne.EdgeEnd.Equals(mIntersections[j].EdgeOne.EdgeEnd))
						{
							mIntersections[j].EdgeOne.EdgeStart = mIntersections[i].IntersectionPoint;
						}
						if (mIntersections[i].EdgeTwo.EdgeStart.Equals(mIntersections[j].EdgeTwo.EdgeStart) && mIntersections[i].EdgeTwo.EdgeEnd.Equals(mIntersections[j].EdgeTwo.EdgeEnd))
						{
							mIntersections[j].EdgeTwo.EdgeStart = mIntersections[i].IntersectionPoint;
						}
					}
				}
				foreach (EdgeIntersectInfo mIntersection in mIntersections)
				{
					if (!mPoly1.Contains(mIntersection.IntersectionPoint))
					{
						mPoly1.Insert(mPoly1.IndexOf(mIntersection.EdgeOne.EdgeStart) + 1, mIntersection.IntersectionPoint);
					}
					if (!mPoly2.Contains(mIntersection.IntersectionPoint))
					{
						mPoly2.Insert(mPoly2.IndexOf(mIntersection.EdgeTwo.EdgeStart) + 1, mIntersection.IntersectionPoint);
					}
				}
				mPoly1VectorAngles = new List<int>();
				for (int k = 0; k < mPoly2.Count; k++)
				{
					mPoly1VectorAngles.Add(-1);
				}
				mPoly2VectorAngles = new List<int>();
				for (int l = 0; l < mPoly1.Count; l++)
				{
					mPoly2VectorAngles.Add(-1);
				}
				int num = 0;
				do
				{
					bool flag = PointInPolygonAngle(mPoly1[num], mPoly2);
					mPoly2VectorAngles[num] = (flag ? 1 : 0);
					if (flag)
					{
						mStartingIndex = num;
						break;
					}
					num = mPoly1.NextIndex(num);
				}
				while (num != 0);
				if (mStartingIndex == -1)
				{
					mError = PolygonUtil.PolyUnionError.Poly1InsidePoly2;
					return false;
				}
				return true;
			}

			private bool VerticesIntersect(Point2DList polygon1, Point2DList polygon2, out List<EdgeIntersectInfo> intersections)
			{
				intersections = new List<EdgeIntersectInfo>();
				double epsilon = Math.Min(polygon1.Epsilon, polygon2.Epsilon);
				for (int i = 0; i < polygon1.Count; i++)
				{
					Point2D point2D = polygon1[i];
					Point2D point2D2 = polygon1[polygon1.NextIndex(i)];
					for (int j = 0; j < polygon2.Count; j++)
					{
						Point2D pIntersectionPt = new Point2D();
						Point2D point2D3 = polygon2[j];
						Point2D point2D4 = polygon2[polygon2.NextIndex(j)];
						if (TriangulationUtil.LinesIntersect2D(point2D, point2D2, point2D3, point2D4, ref pIntersectionPt, epsilon))
						{
							intersections.Add(new EdgeIntersectInfo(new Edge(point2D, point2D2), new Edge(point2D3, point2D4), pIntersectionPt));
						}
					}
				}
				return intersections.Count > 0;
			}

			public bool PointInPolygonAngle(Point2D point, Point2DList polygon)
			{
				double num = 0.0;
				for (int i = 0; i < polygon.Count; i++)
				{
					Point2D p = polygon[i] - point;
					Point2D p2 = polygon[polygon.NextIndex(i)] - point;
					num += VectorAngle(p, p2);
				}
				if (Math.Abs(num) < Math.PI)
				{
					return false;
				}
				return true;
			}

			public double VectorAngle(Point2D p1, Point2D p2)
			{
				double num = Math.Atan2(p1.Y, p1.X);
				double num2 = Math.Atan2(p2.Y, p2.X);
				double num3;
				for (num3 = num2 - num; num3 > Math.PI; num3 -= Math.PI * 2.0)
				{
				}
				for (; num3 < -Math.PI; num3 += Math.PI * 2.0)
				{
				}
				return num3;
			}
		}
}
