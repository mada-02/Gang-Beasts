using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System;

namespace Poly2Tri
{
		public class Polygon : Point2DList, ICollection<TriangulationPoint>, IList<TriangulationPoint>, IEnumerable, IEnumerable<TriangulationPoint>, ITriangulatable
		{
			protected Dictionary<uint, TriangulationPoint> mPointMap = new Dictionary<uint, TriangulationPoint>();

			protected List<DelaunayTriangle> mTriangles;

			private double mPrecision = TriangulationPoint.kVertexCodeDefaultPrecision;

			protected List<Polygon> mHoles;

			protected List<TriangulationPoint> mSteinerPoints;

			protected PolygonPoint _last;

			public Polygon(IList<PolygonPoint> points)
			{
				if (points.Count < 3)
				{
					throw new ArgumentException("List has fewer than 3 points", "points");
				}
				AddRange(points, WindingOrderType.Unknown);
			}

			public Polygon(IEnumerable<PolygonPoint> points)
				: this((points as IList<PolygonPoint>) ?? points.ToArray())
			{
			}

			public Polygon(params PolygonPoint[] points)
				: this((IList<PolygonPoint>)points)
			{
			}

			IEnumerator<TriangulationPoint> IEnumerable<TriangulationPoint>.GetEnumerator()
			{
				return new TriangulationPointEnumerator(mPoints);
			}

			public IList<TriangulationPoint> Points
			{
				get
				{
					return this;
				}
			}

			public IList<DelaunayTriangle> Triangles
			{
				get
				{
					return mTriangles;
				}
			}

			public TriangulationMode TriangulationMode
			{
				get
				{
					return TriangulationMode.Polygon;
				}
			}

			public string FileName { get; set; }

			public bool DisplayFlipX { get; set; }

			public bool DisplayFlipY { get; set; }

			public float DisplayRotate { get; set; }

			public double Precision
			{
				get
				{
					return mPrecision;
				}
				set
				{
					mPrecision = value;
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

			public IList<Polygon> Holes
			{
				get
				{
					return mHoles;
				}
			}

			public int IndexOf(TriangulationPoint p)
			{
				return mPoints.IndexOf(p);
			}

			public override void Add(Point2D p)
			{
				Add(p, -1, true);
			}

			public void Add(TriangulationPoint p)
			{
				Add(p, -1, true);
			}

			public void Add(PolygonPoint p)
			{
				Add(p, -1, true);
			}

			protected override void Add(Point2D p, int idx, bool bCalcWindingOrderAndEpsilon)
			{
				TriangulationPoint triangulationPoint = p as TriangulationPoint;
				if (triangulationPoint == null)
				{
					return;
				}

				if (mPointMap.ContainsKey(triangulationPoint.VertexCode))
				{
					return;
				}

				mPointMap.Add(triangulationPoint.VertexCode, triangulationPoint);
				base.Add(p, idx, bCalcWindingOrderAndEpsilon);
				PolygonPoint polygonPoint = p as PolygonPoint;
				if (polygonPoint != null)
				{
					polygonPoint.Previous = _last;
					if (_last != null)
					{
						polygonPoint.Next = _last.Next;
						_last.Next = polygonPoint;
					}

					_last = polygonPoint;
				}
			}

			public void AddRange(IList<PolygonPoint> points, WindingOrderType windingOrder)
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
				return base.Remove(p);
			}

			public void RemovePoint(PolygonPoint p)
			{
				PolygonPoint next = p.Next;
				PolygonPoint previous = p.Previous;
				previous.Next = next;
				next.Previous = previous;
				mPoints.Remove(p);
				mBoundingBox.Clear();
				foreach (PolygonPoint mPoint in mPoints)
				{
					mBoundingBox.AddPoint(mPoint);
				}
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

			public void AddSteinerPoint(TriangulationPoint point)
			{
				if (mSteinerPoints == null)
				{
					mSteinerPoints = new List<TriangulationPoint>();
				}
				mSteinerPoints.Add(point);
			}

			public void AddSteinerPoints(List<TriangulationPoint> points)
			{
				if (mSteinerPoints == null)
				{
					mSteinerPoints = new List<TriangulationPoint>();
				}
				mSteinerPoints.AddRange(points);
			}

			public void ClearSteinerPoints()
			{
				if (mSteinerPoints != null)
				{
					mSteinerPoints.Clear();
				}
			}

			public void AddHole(Polygon poly)
			{
				if (mHoles == null)
				{
					mHoles = new List<Polygon>();
				}
				mHoles.Add(poly);
			}

			public void AddTriangle(DelaunayTriangle t)
			{
				mTriangles.Add(t);
			}

			public void AddTriangles(IEnumerable<DelaunayTriangle> list)
			{
				mTriangles.AddRange(list);
			}

			public void ClearTriangles()
			{
				if (mTriangles != null)
				{
					mTriangles.Clear();
				}
			}

			public bool IsPointInside(TriangulationPoint p)
			{
				return PolygonUtil.PointInPolygon2D(this, p);
			}

			public void Prepare(TriangulationContext tcx)
			{
				if (mTriangles == null)
				{
					mTriangles = new List<DelaunayTriangle>(mPoints.Count);
				}
				else
				{
					mTriangles.Clear();
				}
				for (int i = 0; i < mPoints.Count - 1; i++)
				{
					tcx.NewConstraint(this[i], this[i + 1]);
				}
				tcx.NewConstraint(this[0], this[Count - 1]);
				tcx.Points.AddRange(this);
				if (mHoles != null)
				{
					foreach (Polygon mHole in mHoles)
					{
						for (int j = 0; j < mHole.mPoints.Count - 1; j++)
						{
							tcx.NewConstraint(mHole[j], mHole[j + 1]);
						}
						tcx.NewConstraint(mHole[0], mHole[mHole.Count - 1]);
						tcx.Points.AddRange(mHole);
					}
				}
				if (mSteinerPoints != null)
				{
					tcx.Points.AddRange(mSteinerPoints);
				}
			}
		}
}
