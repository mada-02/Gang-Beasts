namespace Poly2Tri
{
		public class DTSweepDebugContext : TriangulationDebugContext
		{
			private DelaunayTriangle _primaryTriangle;

			private DelaunayTriangle _secondaryTriangle;

			private TriangulationPoint _activePoint;

			private AdvancingFrontNode _activeNode;

			private DTSweepConstraint _activeConstraint;

			public DTSweepDebugContext(DTSweepContext tcx)
				: base(tcx)
			{
			}

			public DelaunayTriangle PrimaryTriangle
			{
				get
				{
					return _primaryTriangle;
				}
				set
				{
					_primaryTriangle = value;
					_tcx.Update("set PrimaryTriangle");
				}
			}

			public DelaunayTriangle SecondaryTriangle
			{
				get
				{
					return _secondaryTriangle;
				}
				set
				{
					_secondaryTriangle = value;
					_tcx.Update("set SecondaryTriangle");
				}
			}

			public TriangulationPoint ActivePoint
			{
				get
				{
					return _activePoint;
				}
				set
				{
					_activePoint = value;
					_tcx.Update("set ActivePoint");
				}
			}

			public AdvancingFrontNode ActiveNode
			{
				get
				{
					return _activeNode;
				}
				set
				{
					_activeNode = value;
					_tcx.Update("set ActiveNode");
				}
			}

			public DTSweepConstraint ActiveConstraint
			{
				get
				{
					return _activeConstraint;
				}
				set
				{
					_activeConstraint = value;
					_tcx.Update("set ActiveConstraint");
				}
			}

			public bool IsDebugContext
			{
				get
				{
					return true;
				}
			}

			public override void Clear()
			{
				PrimaryTriangle = null;
				SecondaryTriangle = null;
				ActivePoint = null;
				ActiveNode = null;
				ActiveConstraint = null;
			}
		}
}
