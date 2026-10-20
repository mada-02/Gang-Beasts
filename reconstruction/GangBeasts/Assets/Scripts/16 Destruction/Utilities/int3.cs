using System;

namespace Destruction.Utilities
{
		public struct int3 : IFormattable
		{
			private readonly int m_x;

			private readonly int m_y;

			private readonly int m_z;

			public int3(int _x, int _y, int _z)
			{
				m_x = _x;
				m_y = _y;
				m_z = _z;
			}

			public int x
			{
				get
				{
					return m_x;
				}
			}

			public int y
			{
				get
				{
					return m_y;
				}
			}

			public int z
			{
				get
				{
					return m_z;
				}
			}

			public override string ToString()
			{
				return ToString("f2", null);
			}

			public string ToString(string format, IFormatProvider formatProvider)
			{
				return m_x.ToString(format) + ", " + m_y.ToString(format) + ", " + m_z.ToString(format);
			}
		}
}
