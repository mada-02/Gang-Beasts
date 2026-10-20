using System.Collections.Generic;
using System;

namespace Poly2Tri
{
		public class TriangulationPoint : Point2D
		{
			public static readonly double kVertexCodeDefaultPrecision = 5.0;

			protected uint mVertexCode;

			public TriangulationPoint(double x, double y)
				: this(x, y, kVertexCodeDefaultPrecision)
			{
			}

			public TriangulationPoint(double x, double y, double precision)
				: base(x, y)
			{
				mVertexCode = CreateVertexCode(x, y, precision);
			}

			public override double X
			{
				get
				{
					return mX;
				}
				set
				{
					if (value != mX)
					{
						mX = value;
						mVertexCode = CreateVertexCode(mX, mY, kVertexCodeDefaultPrecision);
					}
				}
			}

			public override double Y
			{
				get
				{
					return mY;
				}
				set
				{
					if (value != mY)
					{
						mY = value;
						mVertexCode = CreateVertexCode(mX, mY, kVertexCodeDefaultPrecision);
					}
				}
			}

			public uint VertexCode
			{
				get
				{
					return mVertexCode;
				}
			}

			public List<DTSweepConstraint> Edges { get; private set; }

			public bool HasEdges
			{
				get
				{
					return Edges != null;
				}
			}

			public override string ToString()
			{
				return base.ToString() + ":{" + mVertexCode.ToString() + "}";
			}

			public override int GetHashCode()
			{
				return (int)mVertexCode;
			}

			public override bool Equals(object obj)
			{
				TriangulationPoint triangulationPoint = obj as TriangulationPoint;
				if (triangulationPoint != null)
				{
					return mVertexCode == triangulationPoint.VertexCode;
				}
				return base.Equals(obj);
			}

			public override void Set(double x, double y)
			{
				if (x != mX || y != mY)
				{
					mX = x;
					mY = y;
					mVertexCode = CreateVertexCode(mX, mY, kVertexCodeDefaultPrecision);
				}
			}

			public static uint CreateVertexCode(double x, double y, double precision)
			{
				float value = (float)MathUtil.RoundWithPrecision(x, precision);
				float value2 = (float)MathUtil.RoundWithPrecision(y, precision);
				uint vCode = MathUtil.Jenkins32Hash(BitConverter.GetBytes(value), 0u);
				vCode = MathUtil.Jenkins32Hash(BitConverter.GetBytes(value2), vCode);
				return vCode;
			}

			public void AddEdge(DTSweepConstraint e)
			{
				if (Edges == null)
				{
					Edges = new List<DTSweepConstraint>();
				}
				Edges.Add(e);
			}

			public bool HasEdge(TriangulationPoint p)
			{
				DTSweepConstraint edge = null;
				return GetEdge(p, out edge);
			}

			public bool GetEdge(TriangulationPoint p, out DTSweepConstraint edge)
			{
				edge = null;
				if (Edges == null || Edges.Count < 1 || p == null || p.Equals(this))
				{
					return false;
				}
				foreach (DTSweepConstraint edge2 in Edges)
				{
					if ((edge2.P.Equals(this) && edge2.Q.Equals(p)) || (edge2.P.Equals(p) && edge2.Q.Equals(this)))
					{
						edge = edge2;
						return true;
					}
				}
				return false;
			}

			public static Point2D ToPoint2D(TriangulationPoint p)
			{
				return p;
			}
		}
}
