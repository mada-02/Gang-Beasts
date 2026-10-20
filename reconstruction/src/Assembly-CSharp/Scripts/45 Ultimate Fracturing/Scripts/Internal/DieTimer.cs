using UnityEngine;

namespace UltimateFracturing
{
		public class DieTimer : MonoBehaviour
		{
			public float SecondsToDie = float.PositiveInfinity;

			public float OffscreenLifeTime = float.PositiveInfinity;

			private float m_fTimer;

			private void Start()
			{
				m_fTimer = 0f;
			}

			private void Update()
			{
				m_fTimer += Time.deltaTime;
				if (m_fTimer > SecondsToDie)
				{
					Object.Destroy(gameObject);
				}
			}
		}
}
