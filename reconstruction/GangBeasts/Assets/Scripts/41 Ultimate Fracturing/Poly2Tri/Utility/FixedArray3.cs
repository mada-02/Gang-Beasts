using System.Collections.Generic;
using System.Collections;
using System;

namespace Poly2Tri
{
		public struct FixedArray3<T> : IEnumerable<T>, IEnumerable where T : class
		{
			public T _0;

			public T _1;

			public T _2;

			IEnumerator IEnumerable.GetEnumerator()
			{
				return GetEnumerator();
			}

			public T this[int index]
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

			public bool Contains(T value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] != null)
					{
						T val = this[i];
						if (val.Equals(value))
						{
							return true;
						}
					}
				}
				return false;
			}

			public int IndexOf(T value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] != null)
					{
						T val = this[i];
						if (val.Equals(value))
						{
							return i;
						}
					}
				}
				return -1;
			}

			public void Clear()
			{
				_0 = (_1 = (_2 = (T)null));
			}

			public void Clear(T value)
			{
				for (int i = 0; i < 3; i++)
				{
					if (this[i] != null)
					{
						T val = this[i];
						if (val.Equals(value))
						{
							this[i] = (T)null;
						}
					}
				}
			}

			private IEnumerable<T> Enumerate()
			{
				for (int i = 0; i < 3; i++)
				{
					yield return this[i];
				}
			}

			public IEnumerator<T> GetEnumerator()
			{
				return Enumerate().GetEnumerator();
			}
		}
}
