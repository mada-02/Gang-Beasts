using UnityEngine;

namespace mset
{
		public class Logo : MonoBehaviour
		{
			public Texture2D logoTexture;

			public Color color = Color.white;

			public Vector2 logoPixelOffset = new Vector2(0f, 0f);

			public Vector2 logoPercentOffset = new Vector2(0f, 0f);

			public Corner placement = Corner.BottomLeft;

			private Rect texRect = new Rect(0f, 0f, 0f, 0f);

			private void Reset()
			{
				logoTexture = Resources.Load("renderedLogo") as Texture2D;
			}

			private void Start()
			{
			}

			private void updateTexRect()
			{
				if ((bool)logoTexture)
				{
					float num = logoTexture.width;
					float num2 = logoTexture.height;
					float num3 = 0f;
					float num4 = 0f;
					if ((bool)camera)
					{
						num3 = camera.pixelWidth;
						num4 = camera.pixelHeight;
					}
					else if ((bool)Camera.main)
					{
						num3 = Camera.main.pixelWidth;
						num4 = Camera.main.pixelHeight;
					}
					else if ((bool)Camera.current)
					{
					}
					float num5 = logoPixelOffset.x + logoPercentOffset.x * num3 * 0.01f;
					float num6 = logoPixelOffset.y + logoPercentOffset.y * num4 * 0.01f;
					switch (placement)
					{
					case Corner.TopLeft:
						texRect.x = num5;
						texRect.y = num6;
						break;
					case Corner.TopRight:
						texRect.x = num3 - num5 - num;
						texRect.y = num6;
						break;
					case Corner.BottomLeft:
						texRect.x = num5;
						texRect.y = num4 - num6 - num2;
						break;
					case Corner.BottomRight:
						texRect.x = num3 - num5 - num;
						texRect.y = num4 - num6 - num2;
						break;
					}
					texRect.width = num;
					texRect.height = num2;
				}
			}

			private void OnGUI()
			{
				updateTexRect();
				if ((bool)logoTexture)
				{
					GUI.color = color;
					GUI.DrawTexture(texRect, logoTexture);
				}
			}
		}
}
