using System.Collections.Generic;

namespace Poly2Tri
{
		public abstract class TriangulationContext
		{
			public readonly List<DelaunayTriangle> Triangles = new List<DelaunayTriangle>();

			public readonly List<TriangulationPoint> Points = new List<TriangulationPoint>(200);

			public TriangulationDebugContext DebugContext { get; protected set; }

			public TriangulationMode TriangulationMode { get; protected set; }

			public ITriangulatable Triangulatable { get; private set; }

			public int StepCount { get; private set; }

			public void Done()
			{
				StepCount++;
			}

			public abstract TriangulationAlgorithm Algorithm { get; }

			public virtual void PrepareTriangulation(ITriangulatable t)
			{
				Triangulatable = t;
				TriangulationMode = t.TriangulationMode;
				t.Prepare(this);
			}

			public abstract TriangulationConstraint NewConstraint(TriangulationPoint a, TriangulationPoint b);

			public void Update(string message)
			{
			}

			public virtual void Clear()
			{
				Points.Clear();
				if (DebugContext != null)
				{
					DebugContext.Clear();
				}
				StepCount = 0;
			}

			public virtual bool IsDebugEnabled { get; protected set; }

			public DTSweepDebugContext DTDebugContext
			{
				get
				{
					return DebugContext as DTSweepDebugContext;
				}
			}
		}
}
