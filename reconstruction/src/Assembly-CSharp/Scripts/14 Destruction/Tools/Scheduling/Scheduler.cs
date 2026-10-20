using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Tools
{
		public class Scheduler : CreationSingleton<Scheduler>
		{
			[SerializeField]
			private int amountToDeschedulePerFrame = 1;

			private readonly Queue<ISchedulable> scheduledObjects = new Queue<ISchedulable>();

			public static void ScheduleObject(ISchedulable objectToSchedule)
			{
				if (objectToSchedule == null)
				{
					Debug.LogWarning("Trying to schedule null object.");
					return;
				}

				CreationSingleton<Scheduler>.Instance.scheduledObjects.Enqueue(objectToSchedule);
			}

			private void Update()
			{
				for (int i = 0; i < Mathf.Min(scheduledObjects.Count, amountToDeschedulePerFrame); i++)
				{
					scheduledObjects.Dequeue().BeginScheduledOperation();
				}
			}
		}
}
