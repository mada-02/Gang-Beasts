using System;

namespace Poly2Tri
{
		public class Rect2D
		{
			private double mMinX;

			private double mMaxX;

			private double mMinY;

			private double mMaxY;

			public Rect2D()
			{
				Clear();
			}

			public double MinX
			{
				get
				{
					return mMinX;
				}
				set
				{
					mMinX = value;
				}
			}

			public double MaxX
			{
				get
				{
					return mMaxX;
				}
				set
				{
					mMaxX = value;
				}
			}

			public double MinY
			{
				get
				{
					return mMinY;
				}
				set
				{
					mMinY = value;
				}
			}

			public double MaxY
			{
				get
				{
					return mMaxY;
				}
				set
				{
					mMaxY = value;
				}
			}

			public double Left
			{
				get
				{
					return mMinX;
				}
				set
				{
					mMinX = value;
				}
			}

			public double Right
			{
				get
				{
					return mMaxX;
				}
				set
				{
					mMaxX = value;
				}
			}

			public double Top
			{
				get
				{
					return mMaxY;
				}
				set
				{
					mMaxY = value;
				}
			}

			public double Bottom
			{
				get
				{
					return mMinY;
				}
				set
				{
					mMinY = value;
				}
			}

			public double Width
			{
				get
				{
					return Right - Left;
				}
			}

			public double Height
			{
				get
				{
					return Top - Bottom;
				}
			}

			public bool Empty
			{
				get
				{
					return Left == Right || Top == Bottom;
				}
			}

			public override int GetHashCode()
			{
				return base.GetHashCode();
			}

			public override bool Equals(object obj)
			{
				Rect2D rect2D = obj as Rect2D;
				if (rect2D != null)
				{
					return Equals(rect2D);
				}
				return base.Equals(obj);
			}

			public bool Equals(Rect2D r)
			{
				return Equals(r, MathUtil.EPSILON);
			}

			public bool Equals(Rect2D r, double epsilon)
			{
				if (!MathUtil.AreValuesEqual(MinX, r.MinX, epsilon))
				{
					return false;
				}
				if (!MathUtil.AreValuesEqual(MaxX, r.MaxX))
				{
					return false;
				}
				if (!MathUtil.AreValuesEqual(MinY, r.MinY, epsilon))
				{
					return false;
				}
				if (!MathUtil.AreValuesEqual(MaxY, r.MaxY, epsilon))
				{
					return false;
				}
				return true;
			}

			public void Clear()
			{
				MinX = double.MaxValue;
				MaxX = double.MinValue;
				MinY = double.MaxValue;
				MaxY = double.MinValue;
			}

			public void Set(double xmin, double xmax, double ymin, double ymax)
			{
				MinX = xmin;
				MaxX = xmax;
				MinY = ymin;
				MaxY = ymax;
				Normalize();
			}

			public void Set(Rect2D b)
			{
				MinX = b.MinX;
				MaxX = b.MaxX;
				MinY = b.MinY;
				MaxY = b.MaxY;
			}

			public void SetSize(double w, double h)
			{
				Right = Left + w;
				Top = Bottom + h;
			}

			public bool Contains(double x, double y)
			{
				return x > Left && y > Bottom && x < Right && y < Top;
			}

			public bool Contains(Point2D p)
			{
				return Contains(p.X, p.Y);
			}

			public bool Contains(Rect2D r)
			{
				return Left < r.Left && Right > r.Right && Top < r.Top && Bottom > r.Bottom;
			}

			public bool ContainsInclusive(double x, double y)
			{
				return x >= Left && y >= Top && x <= Right && y <= Bottom;
			}

			public bool ContainsInclusive(double x, double y, double epsilon)
			{
				return x + epsilon >= Left && y + epsilon >= Top && x - epsilon <= Right && y - epsilon <= Bottom;
			}

			public bool ContainsInclusive(Point2D p)
			{
				return ContainsInclusive(p.X, p.Y);
			}

			public bool ContainsInclusive(Point2D p, double epsilon)
			{
				return ContainsInclusive(p.X, p.Y, epsilon);
			}

			public bool ContainsInclusive(Rect2D r)
			{
				return Left <= r.Left && Right >= r.Right && Top <= r.Top && Bottom >= r.Bottom;
			}

			public bool ContainsInclusive(Rect2D r, double epsilon)
			{
				return Left - epsilon <= r.Left && Right + epsilon >= r.Right && Top - epsilon <= r.Top && Bottom + epsilon >= r.Bottom;
			}

			public bool Intersects(Rect2D r)
			{
				return Right > r.Left && Left < r.Right && Bottom < r.Top && Top > r.Bottom;
			}

			public Point2D GetCenter()
			{
				Point2D result9 = new Point2D((Left + Right) / 2.0, (Bottom + Top) / 2.0);
				return result9;
			}

			public bool IsNormalized()
			{
				return Right >= Left && Bottom <= Top;
			}

			public void Normalize()
			{
				if (Left > Right)
				{
					MathUtil.Swap(ref mMinX, ref mMaxX);
				}
				if (Bottom < Top)
				{
					MathUtil.Swap(ref mMinY, ref mMaxY);
				}
			}

			public void AddPoint(Point2D p)
			{
				MinX = Math.Min(MinX, p.X);
				MaxX = Math.Max(MaxX, p.X);
				MinY = Math.Min(MinY, p.Y);
				MaxY = Math.Max(MaxY, p.Y);
			}

			public void Inflate(double w, double h)
			{
				Left -= w;
				Top += h;
				Right += w;
				Bottom -= h;
			}

			public void Inflate(double left, double top, double right, double bottom)
			{
				Left -= left;
				Top += top;
				Right += right;
				Bottom -= bottom;
			}

			public void Offset(double w, double h)
			{
				Left += w;
				Top += h;
				Right += w;
				Bottom += h;
			}

			public void SetPosition(double x, double y)
			{
				double num = Right - Left;
				double num2 = Bottom - Top;
				Left = x;
				Bottom = y;
				Right = x + num;
				Top = y + num2;
			}

			public bool Intersection(Rect2D r1, Rect2D r2)
			{
				if (!TriangulationUtil.RectsIntersect(r1, r2))
				{
					double num = (Bottom = 0.0);
					num = (Top = num);
					num = (Right = num);
					Left = num;
					return false;
				}

				Left = (r1.Left > r2.Left ? r1.Left : r2.Left);
				Top = (r1.Top < r2.Top ? r1.Top : r2.Top);
				Right = (r1.Right < r2.Right ? r1.Right : r2.Right);
				Bottom = (r1.Bottom > r2.Bottom ? r1.Bottom : r2.Bottom);
				return true;
			}

			public void Union(Rect2D r1, Rect2D r2)
			{
				if (r2.Right == r2.Left || r2.Bottom == r2.Top)
				{
					Set(r1);
				}
				else
				{
					if (r1.Right == r1.Left || r1.Bottom == r1.Top)
					{
						Set(r2);
					}
					else
					{
						Left = (r1.Left < r2.Left ? r1.Left : r2.Left);
						Top = (r1.Top > r2.Top ? r1.Top : r2.Top);
						Right = (r1.Right > r2.Right ? r1.Right : r2.Right);
						Bottom = (r1.Bottom < r2.Bottom ? r1.Bottom : r2.Bottom);
					}
				}
			}
		}
}
