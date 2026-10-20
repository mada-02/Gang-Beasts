using Destruction.Common;
using System.Collections.Generic;
using UnityEngine;

namespace Destruction.Tools
{
		public interface IDestructionAffectable
		{
			void OnPreDestruction(BaseDestructable objectToDestroy);

			void OnPostDestruction(List<Collider> fragments);
		}
}
