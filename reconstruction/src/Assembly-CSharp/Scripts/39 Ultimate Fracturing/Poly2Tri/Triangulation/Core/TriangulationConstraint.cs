using System;

namespace Poly2Tri
{
		public class TriangulationConstraint : Edge
		{
			private uint mContraintCode;

			public TriangulationConstraint(TriangulationPoint p1, TriangulationPoint p2)
			{
				mP = p1;
				mQ = p2;
				if (p1.Y > p2.Y)
				{
					mQ = p1;
					mP = p2;
				}
				else if (p1.Y == p2.Y)
				{
					if (p1.X > p2.X)
					{
						mQ = p1;
						mP = p2;
					}
					else if (p1.X == p2.X)
					{
						//                logger.info( "Failed to create constraint {}={}", p1, p2 );
						//                throw new DuplicatePointException( p1 + "=" + p2 );
						//                return;
					}
				}
				CalculateContraintCode();
			}

			public TriangulationPoint P
			{
				get
				{
					return mP as TriangulationPoint;
				}
				set
				{
					if (value != null && mP != value)
					{
						mP = value;
						CalculateContraintCode();
					}
				}
			}

			public TriangulationPoint Q
			{
				get
				{
					return mQ as TriangulationPoint;
				}
				set
				{
					if (value != null && mQ != value)
					{
						mQ = value;
						CalculateContraintCode();
					}
				}
			}

			public uint ConstraintCode
			{
				get
				{
					return mContraintCode;
				}
			}

			public override string ToString()
			{
				return "[P=" + P.ToString() + ", Q=" + Q.ToString() + " : {" + mContraintCode.ToString() + "}]";
			}

			public void CalculateContraintCode()
			{
				mContraintCode = CalculateContraintCode(P, Q);
			}

			public static uint CalculateContraintCode(TriangulationPoint p, TriangulationPoint q)
			{
				if (p == null || p == null)
				{
					throw new ArgumentNullException();
				}
				uint constraintCode = MathUtil.Jenkins32Hash(BitConverter.GetBytes(p.VertexCode), 0u);
				constraintCode = MathUtil.Jenkins32Hash(BitConverter.GetBytes(q.VertexCode), constraintCode);
				return constraintCode;
			}
		}
}
