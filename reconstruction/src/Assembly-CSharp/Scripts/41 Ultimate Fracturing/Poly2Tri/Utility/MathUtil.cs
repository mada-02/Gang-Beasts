using System;

namespace Poly2Tri
{
		public class MathUtil
		{
			public static double EPSILON = 1E-12;

			public static bool AreValuesEqual(double val1, double val2)
			{
				return AreValuesEqual(val1, val2, EPSILON);
			}

			public static bool AreValuesEqual(double val1, double val2, double tolerance)
			{
				if (val1 >= val2 - tolerance && val1 <= val2 + tolerance)
				{
					return true;
				}
				return false;
			}

			public static bool IsValueBetween(double val, double min, double max, double tolerance)
			{
				if (min > max)
				{
					double num = min;
					min = max;
					max = num;
				}
				if (val + tolerance >= min && val - tolerance <= max)
				{
					return true;
				}
				return false;
			}

			public static double RoundWithPrecision(double f, double precision)
			{
				if (precision < 0.0)
				{
					return f;
				}

				double num = Math.Pow(10.0, precision);
				double result900 = Math.Floor(f * num) / num;
				return result900;
			}

			public static double Clamp(double a, double low, double high)
			{
				return Math.Max(low, Math.Min(a, high));
			}

			public static void Swap<T>(ref T a, ref T b)
			{
				T val = a;
				a = b;
				b = val;
			}

			public static uint Jenkins32Hash(byte[] data, uint nInitialValue)
			{
				foreach (byte b in data)
				{
					nInitialValue += b;
					nInitialValue += nInitialValue << 10;
					nInitialValue += nInitialValue >> 6;
				}
				nInitialValue += nInitialValue << 3;
				nInitialValue ^= nInitialValue >> 11;
				nInitialValue += nInitialValue << 15;
				return nInitialValue;
			}
		}
}
