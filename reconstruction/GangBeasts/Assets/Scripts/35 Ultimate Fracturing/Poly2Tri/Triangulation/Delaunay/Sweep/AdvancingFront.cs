using System.Text;
using System;

namespace Poly2Tri
{
		public class AdvancingFront
		{
			public AdvancingFrontNode Head;

			public AdvancingFrontNode Tail;

			protected AdvancingFrontNode Search;

			public AdvancingFront(AdvancingFrontNode head, AdvancingFrontNode tail)
			{
				Head = head;
				Tail = tail;
				Search = head;
				AddNode(head);
				AddNode(tail);
			}

			public void AddNode(AdvancingFrontNode node)
			{
			}

			public void RemoveNode(AdvancingFrontNode node)
			{
			}

			public override string ToString()
			{
				StringBuilder stringBuilder = new StringBuilder();
				for (AdvancingFrontNode advancingFrontNode = Head; advancingFrontNode != Tail; advancingFrontNode = advancingFrontNode.Next)
				{
					stringBuilder.Append(advancingFrontNode.Point.X).Append("->");
				}
				stringBuilder.Append(Tail.Point.X);
				return stringBuilder.ToString();
			}

			private AdvancingFrontNode FindSearchNode(double x)
			{
				return Search;
			}

			public AdvancingFrontNode LocateNode(TriangulationPoint point)
			{
				return LocateNode(point.X);
			}

			private AdvancingFrontNode LocateNode(double x)
			{
				AdvancingFrontNode advancingFrontNode = FindSearchNode(x);
				if (x < advancingFrontNode.Value)
				{
					while ((advancingFrontNode = advancingFrontNode.Prev) != null)
					{
						if (x >= advancingFrontNode.Value)
						{
							Search = advancingFrontNode;
							return advancingFrontNode;
						}
					}
				}
				else
				{
					while ((advancingFrontNode = advancingFrontNode.Next) != null)
					{
						if (x < advancingFrontNode.Value)
						{
							Search = advancingFrontNode.Prev;
							return advancingFrontNode.Prev;
						}
					}
				}
				return null;
			}

			public AdvancingFrontNode LocatePoint(TriangulationPoint point)
			{
				double x = point.X;
				AdvancingFrontNode advancingFrontNode = FindSearchNode(x);
				double x2 = advancingFrontNode.Point.X;
				if (x == x2)
				{
					if (point != advancingFrontNode.Point)
					{
						if (point == advancingFrontNode.Prev.Point)
						{
							advancingFrontNode = advancingFrontNode.Prev;
						}
						else
						{
							if (point != advancingFrontNode.Next.Point)
							{
								throw new Exception("Failed to find Node for given afront point");
							}

							advancingFrontNode = advancingFrontNode.Next;
						}
					}
					else
					{
					}
				}
				else if (x < x2)
				{
					while ((advancingFrontNode = advancingFrontNode.Prev) != null && point != advancingFrontNode.Point)
					{
					}
				}
				else
				{
					while ((advancingFrontNode = advancingFrontNode.Next) != null && point != advancingFrontNode.Point)
					{
					}
				}

				Search = advancingFrontNode;
				return advancingFrontNode;
			}
		}
}
