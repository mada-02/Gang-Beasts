using Destruction.Common;
using System;
using UnityEngine;

namespace Destruction.Tools
{
		[AddComponentMenu("Destruction/Collision Trigger")]
		public class Trigger : MonoBehaviour, IDamagable
		{
			[Flags]
			public enum TriggerType
			{
				Collision = 1,
				Bullet = 2,
				Explosion = 4
			}

			public TriggerType triggerType;

			[SerializeField]
			private float impactForceThreshold = 10f;

			[SerializeField]
			private bool onlyTriggerWithTag;

			[SerializeField]
			private string triggerTag;

			[SerializeField]
			private float startingHealth = 1f;

			[SerializeField]
			private float toughness = 0.5f;

			[SerializeField]
			private float currentHealth;

			private Vector4 lastImpactPoint;

			private bool hasBeenTriggered;

			private float CurrentHealth
			{
				get
				{
					return currentHealth;
				}
				set
				{
					currentHealth = Mathf.Clamp01(value);
					CheckHealth();
				}
			}

			private float InverseToughness
			{
				get
				{
					return 1f - toughness;
				}
			}

			private float ImpactForceThresholdSqr
			{
				get
				{
					return impactForceThreshold * impactForceThreshold;
				}
			}

			private void Awake()
			{
				CurrentHealth = startingHealth;
			}

			private void CheckHealth()
			{
				if (CurrentHealth <= 0f)
				{
					TriggerDestruction(lastImpactPoint, lastImpactPoint.w);
				}
			}

			private bool ShouldCollisionTrigger(string tag)
			{
				return !onlyTriggerWithTag || (onlyTriggerWithTag && tag.Equals(triggerTag));
			}

			public void TriggerDestruction(Vector3 triggerPosition, float magnitude)
			{
				if (hasBeenTriggered)
				{
					return;
				}

				hasBeenTriggered = true;
				IDestructable[] interfaces = gameObject.GetInterfaces<IDestructable>();
				foreach (IDestructable destructable in interfaces)
				{
					destructable.Destroy(triggerPosition, magnitude);
				}
			}

			private void OnCollisionEnter(Collision c)
			{
				if ((triggerType & TriggerType.Collision) == 0)
				{
					return;
				}
				if (!ShouldCollisionTrigger(c.transform.tag))
				{
					return;
				}

				float sqrMagnitude = c.impactForceSum.sqrMagnitude;
				if (sqrMagnitude < ImpactForceThresholdSqr)
				{
					return;
				}

				lastImpactPoint = c.contacts[0].point;
				lastImpactPoint.w = Mathf.Clamp(Mathf.Sqrt(sqrMagnitude - ImpactForceThresholdSqr), 0.1f, 1.5f);
				CurrentHealth = 0f;
			}

			private void OnTriggerEnter(Collider c)
			{
				if (!collider.isTrigger)
				{
					return;
				}
				if ((triggerType & TriggerType.Collision) == 0)
				{
					return;
				}
				if (!ShouldCollisionTrigger(c.tag))
				{
					return;
				}

				lastImpactPoint = transform.position;
				lastImpactPoint.w = 1f;
				CurrentHealth = 0f;
			}

			public void OnBulletHit(Vector4 bulletInfo)
			{
				if (!((triggerType & TriggerType.Bullet) != 0))
				{
					return;
				}

				lastImpactPoint = bulletInfo;
				lastImpactPoint.w = 0.33f;
				CurrentHealth -= bulletInfo.w * InverseToughness;
			}

			public void OnExplosionHit(Vector4 explosionInfo)
			{
				if (!((triggerType & TriggerType.Explosion) != 0))
				{
					return;
				}

				lastImpactPoint = explosionInfo;
				lastImpactPoint.w = 0.5f;
				CurrentHealth -= explosionInfo.w * InverseToughness;
			}

			public void OnCriticalExplosionHit(Vector3 explosionInfo)
			{
				if (!((triggerType & TriggerType.Explosion) != 0))
				{
					return;
				}

				lastImpactPoint = explosionInfo;
				lastImpactPoint.w = 0.1f;
				CurrentHealth = 0f;
			}
		}
}
