using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public class Contour : Point2DList, ICollection<TriangulationPoint>, IList<TriangulationPoint>, IEnumerable, IEnumerable<TriangulationPoint>, ITriangulatable
		{
			private List<Contour> mHoles = new List<Contour>();

			private ITriangulatable mParent;

			private string mName = string.Empty;

			public Contour(ITriangulatable parent)
			{
				mParent = parent;
			}

			public Contour(ITriangulatable parent, IList<TriangulationPoint> points, WindingOrderType windingOrder)
			{
				mParent = parent;
				AddRange(points, windingOrder);
			}

			IEnumerator<TriangulationPoint> IEnumerable<TriangulationPoint>.GetEnumerator()
			{
				return new TriangulationPointEnumerator(mPoints);
			}

			public new TriangulationPoint this[int index]
			{
				get
				{
					return mPoints[index] as TriangulationPoint;
				}
				set
				{
					mPoints[index] = value;
				}
			}

			public string Name
			{
				get
				{
					return mName;
				}
				set
				{
					mName = value;
				}
			}

			public IList<DelaunayTriangle> Triangles
			{
				get
				{
					throw new NotImplementedException("PolyHole.Triangles should never get called");
				}
				private set
				{
				}
			}

			public TriangulationMode TriangulationMode
			{
				get
				{
					return mParent.TriangulationMode;
				}
			}

			public string FileName
			{
				get
				{
					return mParent.FileName;
				}
				set
				{
				}
			}

			public bool DisplayFlipX
			{
				get
				{
					return mParent.DisplayFlipX;
				}
				set
				{
				}
			}

			public bool DisplayFlipY
			{
				get
				{
					return mParent.DisplayFlipY;
				}
				set
				{
				}
			}

			public float DisplayRotate
			{
				get
				{
					return mParent.DisplayRotate;
				}
				set
				{
				}
			}

			public double Precision
			{
				get
				{
					return mParent.Precision;
				}
				set
				{
				}
			}

			public double MinX
			{
				get
				{
					return mBoundingBox.MinX;
				}
			}

			public double MaxX
			{
				get
				{
					return mBoundingBox.MaxX;
				}
			}

			public double MinY
			{
				get
				{
					return mBoundingBox.MinY;
				}
			}

			public double MaxY
			{
				get
				{
					return mBoundingBox.MaxY;
				}
			}

			public Rect2D Bounds
			{
				get
				{
					return mBoundingBox;
				}
			}

			public override string ToString()
			{
				return mName + " : " + base.ToString();
			}

			public int IndexOf(TriangulationPoint p)
			{
				return mPoints.IndexOf(p);
			}

			public void Add(TriangulationPoint p)
			{
				Add(p, -1, true);
			}

			protected override void Add(Point2D p, int idx, bool bCalcWindingOrderAndEpsilon)
			{
				TriangulationPoint triangulationPoint = null;
				if (p is TriangulationPoint)
				{
					triangulationPoint = p as TriangulationPoint;
				}
				else
				{
					triangulationPoint = new TriangulationPoint(p.X, p.Y);
				}
				if (idx < 0)
				{
					mPoints.Add(triangulationPoint);
				}
				else
				{
					mPoints.Insert(idx, triangulationPoint);
				}

				mBoundingBox.AddPoint(triangulationPoint);
				if (bCalcWindingOrderAndEpsilon)
				{
					if (mWindingOrder == WindingOrderType.Unknown)
					{
						mWindingOrder = CalculateWindingOrder();
					}

					mEpsilon = CalculateEpsilon();
				}
			}

			public override void AddRange(IEnumerator<Point2D> iter, WindingOrderType windingOrder)
			{
				if (iter == null)
				{
					return;
				}

				if (mWindingOrder == WindingOrderType.Unknown && Count == 0)
				{
					mWindingOrder = windingOrder;
				}

				bool flag = WindingOrder != WindingOrderType.Unknown && windingOrder != WindingOrderType.Unknown && WindingOrder != windingOrder;
				bool flag2 = true;
				int count = mPoints.Count;
				iter.Reset();
				while (iter.MoveNext())
				{
					TriangulationPoint triangulationPoint = null;
					if (iter.Current is TriangulationPoint)
					{
						triangulationPoint = iter.Current as TriangulationPoint;
					}
					else
					{
						triangulationPoint = new TriangulationPoint(iter.Current.X, iter.Current.Y);
					}
					if (!flag2)
					{
						flag2 = true;
						mPoints.Add(triangulationPoint);
					}
					else if (flag)
					{
						mPoints.Insert(count, triangulationPoint);
					}
					else
					{
						mPoints.Add(triangulationPoint);
					}

					mBoundingBox.AddPoint(iter.Current);
				}

				if (mWindingOrder == WindingOrderType.Unknown && windingOrder == WindingOrderType.Unknown)
				{
					mWindingOrder = CalculateWindingOrder();
				}

				mEpsilon = CalculateEpsilon();
			}

			public void AddRange(IList<TriangulationPoint> points, WindingOrderType windingOrder)
			{
				if (points == null || points.Count < 1)
				{
					return;
				}
				if (mWindingOrder == WindingOrderType.Unknown && Count == 0)
				{
					mWindingOrder = windingOrder;
				}
				int count = points.Count;
				bool flag = WindingOrder != WindingOrderType.Unknown && windingOrder != WindingOrderType.Unknown && WindingOrder != windingOrder;
				for (int i = 0; i < count; i++)
				{
					int index = i;
					if (flag)
					{
						index = points.Count - i - 1;
					}
					Add(points[index], -1, false);
				}
				if (mWindingOrder == WindingOrderType.Unknown)
				{
					mWindingOrder = CalculateWindingOrder();
				}
				mEpsilon = CalculateEpsilon();
			}

			public void Insert(int idx, TriangulationPoint p)
			{
				Add(p, idx, true);
			}

			public bool Remove(TriangulationPoint p)
			{
				return Remove((Point2D)p);
			}

			public bool Contains(TriangulationPoint p)
			{
				return mPoints.Contains(p);
			}

			public void CopyTo(TriangulationPoint[] array, int arrayIndex)
			{
				int num = Math.Min(Count, array.Length - arrayIndex);
				for (int i = 0; i < num; i++)
				{
					array[arrayIndex + i] = mPoints[i] as TriangulationPoint;
				}
			}

			protected void AddHole(Contour c)
			{
				c.mParent = this;
				mHoles.Add(c);
			}

			public int GetNumHoles(bool parentIsHole)
			{
				int num = (parentIsHole ? 0 : 1);
				foreach (Contour mHole in mHoles)
				{
					num += mHole.GetNumHoles(!parentIsHole);
				}

				return num;
			}

			public int GetNumHoles()
			{
				return mHoles.Count;
			}

			public Contour GetHole(int idx)
			{
				if (idx < 0 || idx >= mHoles.Count)
				{
					return null;
				}
				return mHoles[idx];
			}

			public void GetActualHoles(bool parentIsHole, ref List<Contour> holes)
			{
				if (parentIsHole)
				{
					holes.Add(this);
				}
				foreach (Contour mHole in mHoles)
				{
					mHole.GetActualHoles(!parentIsHole, ref holes);
				}
			}

			public List<Contour>.Enumerator GetHoleEnumerator()
			{
				return mHoles.GetEnumerator();
			}

			public void InitializeHoles(ConstrainedPointSet cps)
			{
				InitializeHoles(mHoles, this, cps);
				foreach (Contour mHole in mHoles)
				{
					mHole.InitializeHoles(cps);
				}
			}

			public static void InitializeHoles(List<Contour> holes, ITriangulatable parent, ConstrainedPointSet cps)
			{
				int num = holes.Count;
				int i;
				for (i = 0; i < num; i++)
				{
					int num2 = i + 1;
					while (num2 < num)
					{
						if (PolygonUtil.PolygonsAreSame2D(holes[i], holes[num2]))
						{
							holes.RemoveAt(num2);
							num--;
						}
						else
						{
							num2++;
						}
					}
				}
				i = 0;
				while (i < num)
				{
					bool flag = true;
					int num3 = i + 1;
					while (num3 < num)
					{
						if (PolygonUtil.PolygonContainsPolygon(holes[i], holes[i].Bounds, holes[num3], holes[num3].Bounds, false))
						{
							holes[i].AddHole(holes[num3]);
							holes.RemoveAt(num3);
							num--;
							continue;
						}
						if (PolygonUtil.PolygonContainsPolygon(holes[num3], holes[num3].Bounds, holes[i], holes[i].Bounds, false))
						{
							holes[num3].AddHole(holes[i]);
							holes.RemoveAt(i);
							num--;
							flag = false;
							break;
						}
						if (PolygonUtil.PolygonsIntersect2D(holes[i], holes[i].Bounds, holes[num3], holes[num3].Bounds))
						{
							PolygonOperationContext polygonOperationContext = new PolygonOperationContext();
							if (!polygonOperationContext.Init(PolygonUtil.PolyOperation.Union | PolygonUtil.PolyOperation.Intersect, holes[i], holes[num3]))
							{
								if (polygonOperationContext.mError == PolygonUtil.PolyUnionError.Poly1InsidePoly2)
								{
									holes[num3].AddHole(holes[i]);
									holes.RemoveAt(i);
									num--;
									flag = false;
									break;
								}
								throw new Exception("PolygonOperationContext.Init had an error during initialization");
							}
							if (PolygonUtil.PolygonOperation(polygonOperationContext) != PolygonUtil.PolyUnionError.None)
							{
								throw new Exception("PolygonOperation had an error!");
							}
							Point2DList union = polygonOperationContext.Union;
							Point2DList intersect = polygonOperationContext.Intersect;
							Contour contour = new Contour(parent);
							contour.AddRange(union);
							contour.Name = "(" + holes[i].Name + " UNION " + holes[num3].Name + ")";
							contour.WindingOrder = WindingOrderType.CCW;
							int numHoles = holes[i].GetNumHoles();
							for (int j = 0; j < numHoles; j++)
							{
								contour.AddHole(holes[i].GetHole(j));
							}
							numHoles = holes[num3].GetNumHoles();
							for (int k = 0; k < numHoles; k++)
							{
								contour.AddHole(holes[num3].GetHole(k));
							}
							Contour contour2 = new Contour(contour);
							contour2.AddRange(intersect);
							contour2.Name = "(" + holes[i].Name + " INTERSECT " + holes[num3].Name + ")";
							contour2.WindingOrder = WindingOrderType.CCW;
							contour.AddHole(contour2);
							holes[i] = contour;
							holes.RemoveAt(num3);
							num--;
							num3 = i + 1;
						}
						else
						{
							num3++;
						}
					}
					if (flag)
					{
						i++;
					}
				}
				num = holes.Count;
				for (i = 0; i < num; i++)
				{
					int count = holes[i].Count;
					for (int l = 0; l < count; l++)
					{
						int index = holes[i].NextIndex(l);
						uint constraintCode = TriangulationConstraint.CalculateContraintCode(holes[i][l], holes[i][index]);
						TriangulationConstraint tc = null;
						if (!cps.TryGetConstraint(constraintCode, out tc))
						{
							tc = new TriangulationConstraint(holes[i][l], holes[i][index]);
							cps.AddConstraint(tc);
						}
						if (holes[i][l].VertexCode == tc.P.VertexCode)
						{
							holes[i][l] = tc.P;
						}
						else if (holes[i][index].VertexCode == tc.P.VertexCode)
						{
							holes[i][index] = tc.P;
						}
						if (holes[i][l].VertexCode == tc.Q.VertexCode)
						{
							holes[i][l] = tc.Q;
						}
						else if (holes[i][index].VertexCode == tc.Q.VertexCode)
						{
							holes[i][index] = tc.Q;
						}
					}
				}
			}

			public void Prepare(TriangulationContext tcx)
			{
				throw new NotImplementedException("PolyHole.Prepare should never get called");
			}

			public void AddTriangle(DelaunayTriangle t)
			{
				throw new NotImplementedException("PolyHole.AddTriangle should never get called");
			}

			public void AddTriangles(IEnumerable<DelaunayTriangle> list)
			{
				throw new NotImplementedException("PolyHole.AddTriangles should never get called");
			}

			public void ClearTriangles()
			{
				throw new NotImplementedException("PolyHole.ClearTriangles should never get called");
			}

			public Point2D FindPointInContour()
			{
				if (Count < 3)
				{
					return null;
				}
				Point2D centroid = GetCentroid();
				if (IsPointInsideContour(centroid))
				{
					return centroid;
				}
				Random random = new Random();
				while (true)
				{
					centroid.X = random.NextDouble() * (MaxX - MinX) + MinX;
					centroid.Y = random.NextDouble() * (MaxY - MinY) + MinY;
					if (IsPointInsideContour(centroid))
					{
						return centroid;
					}
				}
			}

			public bool IsPointInsideContour(Point2D p)
			{
				if (PolygonUtil.PointInPolygon2D(this, p))
				{
					foreach (Contour mHole in mHoles)
					{
						if (mHole.IsPointInsideContour(p))
						{
							return false;
						}
					}
					return true;
				}
				return false;
			}
		}
}
