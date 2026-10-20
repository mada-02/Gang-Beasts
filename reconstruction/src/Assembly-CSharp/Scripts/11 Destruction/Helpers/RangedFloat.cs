using System;
using UnityEngine;

namespace Destruction.Common
{
		[Serializable]
		public class RangedFloat
		{
			[SerializeField]
			private float min = 1f;

			[SerializeField]
			private float max = 10f;

			public RangedFloat(float min, float max)
			{
				this.min = min;
				this.max = max;
			}

			public float Min
			{
				get
				{
					return min;
				}
			}

			public float Max
			{
				get
				{
					return max;
				}
			}

			public float Random()
			{
				return UnityEngine.Random.Range(min, max);
			}

			public float Clamp(float input)
			{
				return Mathf.Clamp(input, min, max);
			}
		}
}
