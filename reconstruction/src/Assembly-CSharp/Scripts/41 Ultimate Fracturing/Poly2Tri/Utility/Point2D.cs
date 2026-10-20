using System;

namespace Poly2Tri
{
		public class Point2D : IComparable<Point2D>
		{
			protected double mX;

			protected double mY;

			public Point2D()
			{
				mX = 0.0;
				mY = 0.0;
			}

			public Point2D(double x, double y)
			{
				mX = x;
				mY = y;
			}

			public Point2D(Point2D p)
			{
				mX = p.X;
				mY = p.Y;
			}

			public virtual double X
			{
				get
				{
					return mX;
				}
				set
				{
					mX = value;
				}
			}

			public virtual double Y
			{
				get
				{
					return mY;
				}
				set
				{
					mY = value;
				}
			}

			public float Xf
			{
				get
				{
					return (float)X;
				}
			}

			public float Yf
			{
				get
				{
					return (float)Y;
				}
			}

			public override string ToString()
			{
				return "[" + X.ToString() + "," + Y.ToString() + "]";
			}

			public override int GetHashCode()
			{
				return base.GetHashCode();
			}

			public override bool Equals(object obj)
			{
				Point2D point2D = obj as Point2D;
				if (point2D != null)
				{
					return Equals(point2D);
				}
				return base.Equals(obj);
			}

			public bool Equals(Point2D p)
			{
				return Equals(p, 0.0);
			}

			public bool Equals(Point2D p, double epsilon)
			{
				if (p == null || !MathUtil.AreValuesEqual(X, p.X, epsilon) || !MathUtil.AreValuesEqual(Y, p.Y, epsilon))
				{
					return false;
				}
				return true;
			}

			public int CompareTo(Point2D other)
			{
				if (Y < other.Y)
				{
					return -1;
				}
				if (Y > other.Y)
				{
					return 1;
				}
				if (X < other.X)
				{
					return -1;
				}
				if (X > other.X)
				{
					return 1;
				}
				return 0;
			}

			public virtual void Set(double x, double y)
			{
				X = x;
				Y = y;
			}

			public virtual void Set(Point2D p)
			{
				X = p.X;
				Y = p.Y;
			}

			public void Add(Point2D p)
			{
				X += p.X;
				Y += p.Y;
			}

			public void Add(double scalar)
			{
				X += scalar;
				Y += scalar;
			}

			public void Subtract(Point2D p)
			{
				X -= p.X;
				Y -= p.Y;
			}

			public void Subtract(double scalar)
			{
				X -= scalar;
				Y -= scalar;
			}

			public void Multiply(Point2D p)
			{
				X *= p.X;
				Y *= p.Y;
			}

			public void Multiply(double scalar)
			{
				X *= scalar;
				Y *= scalar;
			}

			public void Divide(Point2D p)
			{
				X /= p.X;
				Y /= p.Y;
			}

			public void Divide(double scalar)
			{
				X /= scalar;
				Y /= scalar;
			}

			public void Negate()
			{
				X = -X;
				Y = -Y;
			}

			public double Magnitude()
			{
				return Math.Sqrt(X * X + Y * Y);
			}

			public double MagnitudeSquared()
			{
				return X * X + Y * Y;
			}

			public double MagnitudeReciprocal()
			{
				return 1.0 / Magnitude();
			}

			public void Normalize()
			{
				Multiply(MagnitudeReciprocal());
			}

			public double Dot(Point2D p)
			{
				return X * p.X + Y * p.Y;
			}

			public double Cross(Point2D p)
			{
				return X * p.Y - Y * p.X;
			}

			public void Clamp(Point2D low, Point2D high)
			{
				X = Math.Max(low.X, Math.Min(X, high.X));
				Y = Math.Max(low.Y, Math.Min(Y, high.Y));
			}

			public void Abs()
			{
				X = Math.Abs(X);
				Y = Math.Abs(Y);
			}

			public void Reciprocal()
			{
				if (X != 0.0 && Y != 0.0)
				{
					X = 1.0 / X;
					Y = 1.0 / Y;
				}
			}

			public void Translate(Point2D vector)
			{
				Add(vector);
			}

			public void Translate(double x, double y)
			{
				X += x;
				Y += y;
			}

			public void Scale(Point2D vector)
			{
				Multiply(vector);
			}

			public void Scale(double scalar)
			{
				Multiply(scalar);
			}

			public void Scale(double x, double y)
			{
				X *= x;
				Y *= y;
			}

			public void Rotate(double radians)
			{
				double num = Math.Cos(radians);
				double num2 = Math.Sin(radians);
				double x = X;
				double y = Y;
				X = x * num - y * num2;
				Y = x * num2 + y * num;
			}

			public void RotateDegrees(double degrees)
			{
				double radians = degrees * Math.PI / 180.0;
				Rotate(radians);
			}

			public static double Dot(Point2D lhs, Point2D rhs)
			{
				return lhs.X * rhs.X + lhs.Y * rhs.Y;
			}

			public static double Cross(Point2D lhs, Point2D rhs)
			{
				return lhs.X * rhs.Y - lhs.Y * rhs.X;
			}

			public static Point2D Clamp(Point2D a, Point2D low, Point2D high)
			{
				Point2D point2D = new Point2D(a);
				point2D.Clamp(low, high);
				return point2D;
			}

			public static Point2D Min(Point2D a, Point2D b)
			{
				Point2D point2D = new Point2D();
				point2D.X = Math.Min(a.X, b.X);
				point2D.Y = Math.Min(a.Y, b.Y);
				return point2D;
			}

			public static Point2D Max(Point2D a, Point2D b)
			{
				Point2D point2D = new Point2D();
				point2D.X = Math.Max(a.X, b.X);
				point2D.Y = Math.Max(a.Y, b.Y);
				return point2D;
			}

			public static Point2D Abs(Point2D a)
			{
				Point2D result777 = new Point2D(Math.Abs(a.X), Math.Abs(a.Y));
				return result777;
			}

			public static Point2D Reciprocal(Point2D a)
			{
				Point2D result889 = new Point2D(1.0 / a.X, 1.0 / a.Y);
				return result889;
			}

			public static Point2D Perpendicular(Point2D lhs, double scalar)
			{
				Point2D result16 = new Point2D(lhs.Y * scalar, lhs.X * (-scalar));
				return result16;
			}

			public static Point2D Perpendicular(double scalar, Point2D rhs)
			{
				Point2D result153 = new Point2D((-scalar) * rhs.Y, scalar * rhs.X);
				return result153;
			}

			public static Point2D operator +(Point2D lhs, Point2D rhs)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Add(rhs);
				return point2D;
			}

			public static Point2D operator +(Point2D lhs, double scalar)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Add(scalar);
				return point2D;
			}

			public static Point2D operator -(Point2D lhs, Point2D rhs)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Subtract(rhs);
				return point2D;
			}

			public static Point2D operator -(Point2D lhs, double scalar)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Subtract(scalar);
				return point2D;
			}

			public static Point2D operator *(Point2D lhs, Point2D rhs)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Multiply(rhs);
				return point2D;
			}

			public static Point2D operator *(Point2D lhs, double scalar)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Multiply(scalar);
				return point2D;
			}

			public static Point2D operator *(double scalar, Point2D lhs)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Multiply(scalar);
				return point2D;
			}

			public static Point2D operator /(Point2D lhs, Point2D rhs)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Divide(rhs);
				return point2D;
			}

			public static Point2D operator /(Point2D lhs, double scalar)
			{
				Point2D point2D = new Point2D(lhs);
				point2D.Divide(scalar);
				return point2D;
			}

			public static Point2D operator -(Point2D p)
			{
				Point2D point2D = new Point2D(p);
				point2D.Negate();
				return point2D;
			}

			public static bool operator <(Point2D lhs, Point2D rhs)
			{
				return (lhs.CompareTo(rhs) == -1) ? true : false;
			}

			public static bool operator >(Point2D lhs, Point2D rhs)
			{
				return (lhs.CompareTo(rhs) == 1) ? true : false;
			}

			public static bool operator <=(Point2D lhs, Point2D rhs)
			{
				return (lhs.CompareTo(rhs) <= 0) ? true : false;
			}

			public static bool operator >=(Point2D lhs, Point2D rhs)
			{
				return (lhs.CompareTo(rhs) >= 0) ? true : false;
			}
		}
}
