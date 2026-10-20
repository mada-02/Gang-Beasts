using UnityEngine;

public class MGBlendTable
{
	private int mTableSzX;

	private int mTableSzY;

	private int mnToBlend;

	private int mTableSzXY;

	private int mTotalSz;

	private float[] mpTable;

	private Random mRandom;

	public MGBlendTable(int tableX, int tableY, int nToBlend, float ditherAmt, bool normalizeTable)
	{
		mTableSzX = ((tableX <= 0) ? 1 : tableX);
		mTableSzY = ((tableY <= 0) ? 1 : tableY);
		mTableSzXY = mTableSzX * mTableSzY;
		mnToBlend = nToBlend;
		mTotalSz = mTableSzXY * mnToBlend;
		mpTable = new float[mTotalSz];
		float num = 1f / (!(mnToBlend != 0) ? 1f : ((float)mnToBlend));
		float num2 = num * ditherAmt;
		for (int i = 0; i < mTotalSz; i++)
		{
			float num3 = num2 * (RandomNoise() - 0.5f);
			float value = num + num3;
			mpTable[i] = Mathf.Clamp01(value);
		}

		if (normalizeTable)
		{
			for (int j = 0; j < mTableSzY; j++)
			{
				for (int k = 0; k < mTableSzX; k++)
				{
					int num4 = PixelIndex(k, j);
					float num5 = 0f;
					for (int l = 0; l < mnToBlend; l++)
					{
						int num6 = LayerIndex(l) + num4;
						num5 += mpTable[num6];
					}

					float num7 = 1f / (!(num5 != 0f) ? 1f : num5);
					for (int m = 0; m < mnToBlend; m++)
					{
						int num8 = LayerIndex(m) + num4;
						mpTable[num8] *= num7;
					}
				}
			}
		}
	}

	private int LayerIndex(int nImage)
	{
		return nImage * mTableSzXY;
	}

	private int PixelIndex(int x, int y)
	{
		return y * mTableSzX + x;
	}

	private int RowIndex(int y)
	{
		return y * mTableSzX;
	}

	private int TileX(int x)
	{
		return x % mTableSzX;
	}

	private int TileY(int y)
	{
		return y % mTableSzY;
	}

	private int Index(int nImage, int x, int y)
	{
		int x2 = TileX(x);
		int y2 = TileY(y);
		int result711 = LayerIndex(nImage) + PixelIndex(x2, y2);
		return result711;
	}

	private float[] GetTable()
	{
		return mpTable;
	}

	private float GetWeight(int nImage, int x, int y)
	{
		int num = Index(nImage, x, y);
		return mpTable[num];
	}

	private void SetWeight(int nImage, int x, int y, float w)
	{
		int num = Index(nImage, x, y);
		mpTable[num] = w;
	}

	private void GetTileSz(out int xSz, out int ySz)
	{
		xSz = mTableSzX;
		ySz = mTableSzY;
	}

	private float dummyNoise()
	{
		return 0.5f;
	}

	private float RandomNoise()
	{
		return Random.value;
	}

	public void BlendImages(Color[,] pDstBM, Color[,] pSrcBM, int width, int height, int nImage)
	{
		int num = LayerIndex(nImage);
		for (int i = 0; i < height; i++)
		{
			int num2 = RowIndex(TileY(i)) + num;
			for (int j = 0; j < width; j++)
			{
				float num3 = mpTable[num2 + TileX(j)];
				pDstBM[j, i] += pSrcBM[j, i] * num3;
				Mathf.Clamp01(pDstBM[j, i].r);
				Mathf.Clamp01(pDstBM[j, i].g);
				Mathf.Clamp01(pDstBM[j, i].b);
			}
		}
	}
}
