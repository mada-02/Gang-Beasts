using System;
using UnityEngine;

namespace Destruction
{
		[Serializable]
		public class RangedInt
		{
			[SerializeField]
			private int min = 1;

			[SerializeField]
			private int max = 10;

			public RangedInt(int min, int max)
			{
				this.min = min;
				this.max = max;
			}

			public int Min
			{
				get
				{
					return min;
				}
			}

			public int Max
			{
				get
				{
					return max;
				}
			}

			public int Size
			{
				get
				{
					return max - min;
				}
			}

			public int Random()
			{
				return UnityEngine.Random.Range(min, max);
			}

			public int Clamp(int input)
			{
				return Mathf.Clamp(input, min, max);
			}
		}
}
