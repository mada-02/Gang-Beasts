using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public struct FixedBitArray3 : IEnumerable<bool>, IEnumerable
		{
			public bool _0;

			public bool _1;

			public bool _2;

			IEnumerator IEnumerable.GetEnumerator()
			{
				return GetEnumerator();
			}

			public bool this[int index]
			{
				get
				{
					switch (index)
					{
					case 0:
						return _0;
					case 1:
						return _1;
					case 2:
						return _2;
					default:
						throw new IndexOutOfRangeException();
					}
				}
				set
				{
					switch (index)
					{
					case 0:
						_0 = value;
						break;
					case 1:
						_1 = value;
						break;
					case 2:
						_2 = value;
						break;
					default:
						throw new IndexOutOfRangeException();
					}
				}
			}

			public bool Contains(bool value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] == value)
					{
						return true;
					}
				}
				return false;
			}

			public int IndexOf(bool value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] == value)
					{
						return i;
					}
				}
				return -1;
			}

			public void Clear()
			{
				_0 = (_1 = (_2 = false));
			}

			public void Clear(bool value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] == value)
					{
						this[i] = false;
					}
				}
			}

			private IEnumerable<bool> Enumerate()
			{
				for (int i = 0; i < 3; i++)
				{
					yield return this[i];
				}
			}

			public IEnumerator<bool> GetEnumerator()
			{
				return Enumerate().GetEnumerator();
			}
		}
}
