namespace Destruction.Utilities
{
		public struct int2
		{
			private readonly int m_x;

			private readonly int m_y;

			public int2(int _x, int _y)
			{
				m_x = _x;
				m_y = _y;
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
		}
}
