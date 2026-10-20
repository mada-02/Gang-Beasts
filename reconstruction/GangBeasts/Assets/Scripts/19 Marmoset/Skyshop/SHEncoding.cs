using System;
using UnityEngine;

namespace mset
{
		[Serializable]
		public class SHEncoding
		{
			public float[] c = new float[27];

			public Vector4[] cBuffer = new Vector4[9];

			public static float[] sEquationConstants = new float[9] { 0.28209478f, 0.4886025f, 0.4886025f, 0.4886025f, 1.0925485f, 1.0925485f, 0.31539157f, 1.0925485f, 0.54627424f };

			public SHEncoding()
			{
				clearToBlack();
			}

			public void clearToBlack()
			{
				for (int i = 0; i < 27; i++)
				{
					c[i] = 0f;
				}
				for (int j = 0; j < 9; j++)
				{
					cBuffer[j] = Vector4.zero;
				}
			}

			public void copyFrom(SHEncoding src)
			{
				for (int i = 0; i < 27; i++)
				{
					c[i] = src.c[i];
				}
				copyToBuffer();
			}

			public void copyToBuffer()
			{
				for (int i = 0; i < 9; i++)
				{
					float num = sEquationConstants[i];
					cBuffer[i].x = c[i * 3] * num;
					cBuffer[i].y = c[i * 3 + 1] * num;
					cBuffer[i].z = c[i * 3 + 2] * num;
				}
			}
		}
}
