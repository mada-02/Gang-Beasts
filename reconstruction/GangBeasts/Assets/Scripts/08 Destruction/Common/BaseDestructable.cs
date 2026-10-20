using Destruction.Tools;
using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Common
{
		public abstract class BaseDestructable : MonoBehaviour, IDestructable, IDestructionAffectable, ISchedulable
		{
			public StickyZone[] stickyZones;

			public bool destroyWhenOffscreen = true;

			public RangedFloat offscreenTimer = new RangedFloat(10f, 20f);

			public bool useDestroyTimer = true;

			public RangedFloat destroyTime = new RangedFloat(10f, 20f);

			public bool useMyTag = true;

			public bool useMyLayer = true;

			public bool useScheduler;

			public List<Collider> finalizedBrokenPieces = new List<Collider>();

			private bool isDestructionScheduled;

			private Vector4 storedInfo;

			void IDestructable.Destroy(Vector3 point, float force)
			{
				if (!(!isDestructionScheduled || !useScheduler))
				{
					return;
				}

				if (useScheduler)
				{
					isDestructionScheduled = true;
					storedInfo = new Vector4(point.x, point.y, point.z, force);
					Scheduler.ScheduleObject(this);
				}
				else
				{
					BeginFracture(point, force);
				}
			}

			public Vector3 LastImpactPoint { get; protected set; }

			protected bool Complete { get; set; }

			protected abstract void BeginFracture(Vector3 point, float size);

			public void BeginScheduledOperation()
			{
				if (!isDestructionScheduled)
				{
					return;
				}

				BeginFracture(storedInfo, storedInfo.w);
			}

			public void OnPreDestruction(BaseDestructable objectToDestroy)
			{
			}

			public void OnPostDestruction(List<Collider> fragments)
			{
				if (stickyZones != null)
				{
					StickyZone[] array = stickyZones;
					foreach (StickyZone stickyZone in array)
					{
						stickyZone.PerformStick(finalizedBrokenPieces);
					}
				}
				foreach (Collider fragment in fragments)
				{
					GameObject gameObject = fragment.gameObject;
					if (useMyLayer)
					{
						gameObject.layer = base.gameObject.layer;
					}
					if (useMyTag)
					{
						gameObject.tag = base.gameObject.tag;
					}
					if (destroyWhenOffscreen)
					{
						gameObject.AddComponent<DestroyMeOffscreen>().TimeBeforeDestroy = offscreenTimer;
					}
					if (useDestroyTimer)
					{
						Object.Destroy(gameObject, destroyTime.Random());
					}
				}
			}

			private void OnDrawGizmosSelected()
			{
				if (stickyZones == null)
				{
					return;
				}
				StickyZone[] array = stickyZones;
				foreach (StickyZone stickyZone in array)
				{
					if (!(stickyZone == null))
					{
						stickyZone.DrawGizmos();
					}
				}
			}
		}
}
