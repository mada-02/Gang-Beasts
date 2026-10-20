using UnityEngine;

namespace Destruction.Tools
{
		public interface IDamagable
		{
			void OnBulletHit(Vector4 bulletInfo);

			void OnExplosionHit(Vector4 explosionInfo);

			void OnCriticalExplosionHit(Vector3 explosionInfo);
		}
}
