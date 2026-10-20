using Destruction.Common;
using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Tools
{
		public class LinkObjectsOnDestroy : MonoBehaviour, IDestructionAffectable
		{
			public GameObject[] objectsToDestroy;

			public MonoBehaviour[] componentsToDisable;

			public MonoBehaviour[] componentsToEnable;

			void IDestructionAffectable.OnPreDestruction(BaseDestructable objectToDestroy)
			{
			}

			public void OnPostDestruction(List<Collider> fragments)
			{
				GameObject[] array = objectsToDestroy;
				foreach (GameObject gameObject in array)
				{
					if (!(gameObject == null))
					{
						Object.Destroy(gameObject);
					}
				}
				MonoBehaviour[] array2 = componentsToDisable;
				foreach (MonoBehaviour monoBehaviour in array2)
				{
					if (!(monoBehaviour == null))
					{
						monoBehaviour.enabled = false;
					}
				}
				MonoBehaviour[] array3 = componentsToEnable;
				foreach (MonoBehaviour monoBehaviour2 in array3)
				{
					if (!(monoBehaviour2 == null))
					{
						monoBehaviour2.enabled = true;
					}
				}
			}
		}
}
