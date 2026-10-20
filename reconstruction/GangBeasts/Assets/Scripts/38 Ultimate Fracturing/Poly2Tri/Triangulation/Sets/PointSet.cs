using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public class PointSet : Point2DList, ICollection<TriangulationPoint>, IList<TriangulationPoint>, IEnumerable, IEnumerable<TriangulationPoint>, ITriangulatable
		{
			protected Dictionary<uint, TriangulationPoint> mPointMap = new Dictionary<uint, TriangulationPoint>();

			protected double mPrecision = TriangulationPoint.kVertexCodeDefaultPrecision;

			public PointSet(List<TriangulationPoint> bounds)
			{
				foreach (TriangulationPoint bound in bounds)
				{
					Add(bound, -1, false);
					mBoundingBox.AddPoint(bound);
				}
				mEpsilon = CalculateEpsilon();
				mWindingOrder = WindingOrderType.Unknown;
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
				private set
				{
				}
			}

			public IList<DelaunayTriangle> Triangles { get; private set; }

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

			public virtual TriangulationMode TriangulationMode
			{
				get
				{
					return TriangulationMode.Unconstrained;
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

			public int IndexOf(TriangulationPoint p)
			{
				return mPoints.IndexOf(p);
			}

			public override void Add(Point2D p)
			{
				Add(p as TriangulationPoint, -1, false);
			}

			public virtual void Add(TriangulationPoint p)
			{
				Add(p, -1, false);
			}

			protected override void Add(Point2D p, int idx, bool constrainToBounds)
			{
				Add(p as TriangulationPoint, idx, constrainToBounds);
			}

			protected bool Add(TriangulationPoint p, int idx, bool constrainToBounds)
			{
				if (p == null)
				{
					return false;
				}
				if (constrainToBounds)
				{
					ConstrainPointToBounds(p);
				}
				if (mPointMap.ContainsKey(p.VertexCode))
				{
					return true;
				}
				mPointMap.Add(p.VertexCode, p);
				if (idx < 0)
				{
					mPoints.Add(p);
				}
				else
				{
					mPoints.Insert(idx, p);
				}
				return true;
			}

			public override void AddRange(IEnumerator<Point2D> iter, WindingOrderType windingOrder)
			{
				if (!(iter != null))
				{
					return;
				}

				iter.Reset();
				while (iter.MoveNext())
				{
					Add(iter.Current);
				}
			}

			public virtual bool AddRange(List<TriangulationPoint> points)
			{
				bool flag = true;
				foreach (TriangulationPoint point in points)
				{
					flag = Add(point, -1, false) && flag;
				}
				return flag;
			}

			public bool TryGetPoint(double x, double y, out TriangulationPoint p)
			{
				uint key = TriangulationPoint.CreateVertexCode(x, y, Precision);
				if (mPointMap.TryGetValue(key, out p))
				{
					return true;
				}
				return false;
			}

			public void Insert(int idx, TriangulationPoint item)
			{
				mPoints.Insert(idx, item);
			}

			public override bool Remove(Point2D p)
			{
				return mPoints.Remove(p);
			}

			public bool Remove(TriangulationPoint p)
			{
				return mPoints.Remove(p);
			}

			public override void RemoveAt(int idx)
			{
				if (!(idx >= 0 && idx < Count))
				{
					return;
				}

				mPoints.RemoveAt(idx);
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

			protected bool ConstrainPointToBounds(Point2D p)
			{
				double x = p.X;
				double y = p.Y;
				p.X = Math.Max(MinX, p.X);
				p.X = Math.Min(MaxX, p.X);
				p.Y = Math.Max(MinY, p.Y);
				p.Y = Math.Min(MaxY, p.Y);
				return p.X != x || p.Y != y;
			}

			protected bool ConstrainPointToBounds(TriangulationPoint p)
			{
				double x = p.X;
				double y = p.Y;
				p.X = Math.Max(MinX, p.X);
				p.X = Math.Min(MaxX, p.X);
				p.Y = Math.Max(MinY, p.Y);
				p.Y = Math.Min(MaxY, p.Y);
				return p.X != x || p.Y != y;
			}

			public virtual void AddTriangle(DelaunayTriangle t)
			{
				Triangles.Add(t);
			}

			public void AddTriangles(IEnumerable<DelaunayTriangle> list)
			{
				foreach (DelaunayTriangle item in list)
				{
					AddTriangle(item);
				}
			}

			public void ClearTriangles()
			{
				Triangles.Clear();
			}

			public virtual bool Initialize()
			{
				return true;
			}

			public virtual void Prepare(TriangulationContext tcx)
			{
				if (Triangles == null)
				{
					Triangles = new List<DelaunayTriangle>(Points.Count);
				}
				else
				{
					Triangles.Clear();
				}
				tcx.Points.AddRange(Points);
			}
		}
}
