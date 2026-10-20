using System.Collections.Generic;

namespace Poly2Tri
{
		public class ConstrainedPointSet : PointSet
		{
			protected Dictionary<uint, TriangulationConstraint> mConstraintMap = new Dictionary<uint, TriangulationConstraint>();

			protected List<Contour> mHoles = new List<Contour>();

			public ConstrainedPointSet(List<TriangulationPoint> bounds)
				: base(bounds)
			{
				AddBoundaryConstraints();
			}

			public ConstrainedPointSet(List<TriangulationPoint> bounds, List<TriangulationConstraint> constraints)
				: base(bounds)
			{
				AddBoundaryConstraints();
				AddConstraints(constraints);
			}

			public ConstrainedPointSet(List<TriangulationPoint> bounds, int[] indices)
				: base(bounds)
			{
				AddBoundaryConstraints();
				List<TriangulationConstraint> list = new List<TriangulationConstraint>();
				for (int i = 0; i < indices.Length; i += 2)
				{
					TriangulationConstraint item = new TriangulationConstraint(bounds[indices[i]], bounds[indices[i + 1]]);
					list.Add(item);
				}
				AddConstraints(list);
			}

			public override TriangulationMode TriangulationMode
			{
				get
				{
					return TriangulationMode.Constrained;
				}
			}

			protected void AddBoundaryConstraints()
			{
				TriangulationPoint p = null;
				TriangulationPoint p2 = null;
				TriangulationPoint p3 = null;
				TriangulationPoint p4 = null;
				if (!TryGetPoint(MinX, MinY, out p))
				{
					p = new TriangulationPoint(MinX, MinY);
					Add(p);
				}
				if (!TryGetPoint(MaxX, MinY, out p2))
				{
					p2 = new TriangulationPoint(MaxX, MinY);
					Add(p2);
				}
				if (!TryGetPoint(MaxX, MaxY, out p3))
				{
					p3 = new TriangulationPoint(MaxX, MaxY);
					Add(p3);
				}
				if (!TryGetPoint(MinX, MaxY, out p4))
				{
					p4 = new TriangulationPoint(MinX, MaxY);
					Add(p4);
				}
				TriangulationConstraint tc = new TriangulationConstraint(p, p2);
				AddConstraint(tc);
				TriangulationConstraint tc2 = new TriangulationConstraint(p2, p3);
				AddConstraint(tc2);
				TriangulationConstraint tc3 = new TriangulationConstraint(p3, p4);
				AddConstraint(tc3);
				TriangulationConstraint tc4 = new TriangulationConstraint(p4, p);
				AddConstraint(tc4);
			}

			public override void Add(Point2D p)
			{
				Add(p as TriangulationPoint, -1, true);
			}

			public override void Add(TriangulationPoint p)
			{
				Add(p, -1, true);
			}

			public override bool AddRange(List<TriangulationPoint> points)
			{
				bool flag = true;
				foreach (TriangulationPoint point in points)
				{
					flag = Add(point, -1, true) && flag;
				}
				return flag;
			}

			public bool AddHole(List<TriangulationPoint> points, string name)
			{
				if (points == null)
				{
					return false;
				}

				List<Contour> list = new List<Contour>();
				int num = 0;
				Contour item = new Contour(this, points, WindingOrderType.Unknown);
				list.Add(item);
				if (mPoints.Count > 1)
				{
					int count = list[num].Count;
					for (int i = 0; i < count; i++)
					{
						ConstrainPointToBounds(list[num][i]);
					}
				}

				while (num < list.Count)
				{
					list[num].RemoveDuplicateNeighborPoints();
					list[num].WindingOrder = WindingOrderType.CCW;
					bool flag = true;
					PolygonError polygonError = list[num].CheckPolygon();
					while (flag && polygonError != PolygonError.None)
					{
						if ((polygonError & PolygonError.NotEnoughVertices) == PolygonError.NotEnoughVertices)
						{
							flag = false;
						}
						else if ((polygonError & PolygonError.NotSimple) == PolygonError.NotSimple)
						{
							List<Point2DList> list2 = PolygonUtil.SplitComplexPolygon(list[num], list[num].Epsilon);
							list.RemoveAt(num);
							foreach (Point2DList item2 in list2)
							{
								Contour contour = new Contour(this);
								contour.AddRange(item2);
								list.Add(contour);
							}

							polygonError = list[num].CheckPolygon();
						}
						else if ((polygonError & PolygonError.Degenerate) == PolygonError.Degenerate)
						{
							list[num].Simplify(Epsilon);
							polygonError = list[num].CheckPolygon();
						}
						else if ((polygonError & PolygonError.AreaTooSmall) == PolygonError.AreaTooSmall || (polygonError & PolygonError.SidesTooCloseToParallel) == PolygonError.SidesTooCloseToParallel || (polygonError & PolygonError.TooThin) == PolygonError.TooThin || (polygonError & PolygonError.Unknown) == PolygonError.Unknown)
						{
							flag = false;
						}
						else
						{
						}
					}

					if (!flag && list[num].Count != 2)
					{
						list.RemoveAt(num);
					}
					else
					{
						num++;
					}
				}

				bool result = true;
				num = 0;
				while (num < list.Count)
				{
					int count2 = list[num].Count;
					if (count2 < 2)
					{
						num++;
						result = false;
						continue;
					}

					if (count2 == 2)
					{
						uint key = TriangulationConstraint.CalculateContraintCode(list[num][0], list[num][1]);
						TriangulationConstraint value = null;
						if (!mConstraintMap.TryGetValue(key, out value))
						{
							value = new TriangulationConstraint(list[num][0], list[num][1]);
							AddConstraint(value);
						}
					}
					else
					{
						Contour contour2 = new Contour(this, list[num], WindingOrderType.Unknown);
						contour2.WindingOrder = WindingOrderType.CCW;
						contour2.Name = name + ":" + num.ToString();
						mHoles.Add(contour2);
					}

					num++;
				}

				return result;
			}

			public bool AddConstraints(List<TriangulationConstraint> constraints)
			{
				if (constraints == null || constraints.Count < 1)
				{
					return false;
				}
				bool flag = true;
				foreach (TriangulationConstraint constraint in constraints)
				{
					if (ConstrainPointToBounds(constraint.P) || ConstrainPointToBounds(constraint.Q))
					{
						constraint.CalculateContraintCode();
					}
					TriangulationConstraint value = null;
					if (!mConstraintMap.TryGetValue(constraint.ConstraintCode, out value))
					{
						value = constraint;
						flag = AddConstraint(value) && flag;
					}
				}
				return flag;
			}

			public bool AddConstraint(TriangulationConstraint tc)
			{
				if (tc == null || tc.P == null || tc.Q == null)
				{
					return false;
				}
				if (mConstraintMap.ContainsKey(tc.ConstraintCode))
				{
					return true;
				}
				TriangulationPoint p;
				if (TryGetPoint(tc.P.X, tc.P.Y, out p))
				{
					tc.P = p;
				}
				else
				{
					Add(tc.P);
				}
				if (TryGetPoint(tc.Q.X, tc.Q.Y, out p))
				{
					tc.Q = p;
				}
				else
				{
					Add(tc.Q);
				}
				mConstraintMap.Add(tc.ConstraintCode, tc);
				return true;
			}

			public bool TryGetConstraint(uint constraintCode, out TriangulationConstraint tc)
			{
				return mConstraintMap.TryGetValue(constraintCode, out tc);
			}

			public int GetNumConstraints()
			{
				return mConstraintMap.Count;
			}

			public Dictionary<uint, TriangulationConstraint>.Enumerator GetConstraintEnumerator()
			{
				return mConstraintMap.GetEnumerator();
			}

			public int GetNumHoles()
			{
				int num = 0;
				foreach (Contour mHole in mHoles)
				{
					num += mHole.GetNumHoles(false);
				}
				return num;
			}

			public Contour GetHole(int idx)
			{
				if (idx < 0 || idx >= mHoles.Count)
				{
					return null;
				}
				return mHoles[idx];
			}

			public int GetActualHoles(out List<Contour> holes)
			{
				holes = new List<Contour>();
				foreach (Contour mHole in mHoles)
				{
					mHole.GetActualHoles(false, ref holes);
				}
				return holes.Count;
			}

			protected void InitializeHoles()
			{
				Contour.InitializeHoles(mHoles, this, this);
				foreach (Contour mHole in mHoles)
				{
					mHole.InitializeHoles(this);
				}
			}

			public override bool Initialize()
			{
				InitializeHoles();
				return base.Initialize();
			}

			public override void Prepare(TriangulationContext tcx)
			{
				if (!Initialize())
				{
					return;
				}

				base.Prepare(tcx);
				Dictionary<uint, TriangulationConstraint>.Enumerator enumerator = mConstraintMap.GetEnumerator();
				while (enumerator.MoveNext())
				{
					TriangulationConstraint value = enumerator.Current.Value;
					tcx.NewConstraint(value.P, value.Q);
				}
			}

			public override void AddTriangle(DelaunayTriangle t)
			{
				Triangles.Add(t);
			}
		}
}
