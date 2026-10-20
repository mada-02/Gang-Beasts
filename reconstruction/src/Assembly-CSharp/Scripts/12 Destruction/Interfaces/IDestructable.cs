using UnityEngine;

namespace Destruction.Common
{
		internal interface IDestructable
		{
			void Destroy(Vector3 point, float force);
		}
}
