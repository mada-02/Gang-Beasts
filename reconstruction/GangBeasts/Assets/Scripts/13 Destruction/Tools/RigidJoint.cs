using System.Collections.Generic;
using UnityEngine;

public class RigidJoint : MonoBehaviour
{
	public bool isFixedToWorld;

	[SerializeField]
	private List<RigidJoint> attachedJoints = new List<RigidJoint>();

	private bool isDead;

	private static HashSet<RigidJoint> walkedJoints;

	public bool IsFixedToWorld
	{
		get
		{
			return isFixedToWorld;
		}
	}

	private bool IsCurrentlyFixed
	{
		get
		{
			return IsFixedToWorld || CheckAllAttachedJoints();
		}
	}

	private bool ShouldUseGravity
	{
		get
		{
			if (isFixedToWorld)
			{
				return false;
			}
			return !IsCurrentlyFixed;
		}
	}

	private bool CheckAllAttachedJoints()
	{
		if (walkedJoints == null)
		{
			walkedJoints = new HashSet<RigidJoint>();
		}
		else
		{
			walkedJoints.Clear();
		}
		walkedJoints.Add(this);
		return AnyAttachedFixed(this);
	}

	private static bool AnyAttachedFixed(RigidJoint joint)
	{
		if (joint.isFixedToWorld)
		{
			return true;
		}
		if (!walkedJoints.Contains(joint))
		{
			walkedJoints.Add(joint);
		}
		if (joint.attachedJoints == null)
		{
			return false;
		}
		for (int i = 0; i < joint.attachedJoints.Count; i++)
		{
			if (joint.attachedJoints[i] == null || joint.attachedJoints[i].isDead)
			{
				continue;
			}
			if (walkedJoints.Contains(joint.attachedJoints[i]))
			{
				continue;
			}
			if (AnyAttachedFixed(joint.attachedJoints[i]))
			{
				return true;
			}
		}
		return false;
	}

	public bool IsConnectedToJoint(Rigidbody joint)
	{
		if (attachedJoints == null)
		{
			return false;
		}
		for (int i = 0; i < attachedJoints.Count; i++)
		{
			if (attachedJoints[i] != null && attachedJoints[i].rigidbody == joint)
			{
				return true;
			}
		}
		return false;
	}

	public void AttachToObject(Rigidbody rBody)
	{
		if (rBody == null)
		{
			isFixedToWorld = true;
			return;
		}

		RigidJoint rigidJoint = rBody.GetComponent<RigidJoint>() ?? rBody.gameObject.AddComponent<RigidJoint>();
		if (IsConnectedToJoint(rigidJoint.rigidbody))
		{
			return;
		}

		attachedJoints.Add(rigidJoint);
	}

	private void OnDrawGizmosSelected()
	{
		if (attachedJoints == null)
		{
			return;
		}

		foreach (RigidJoint attachedJoint in attachedJoints)
		{
			if (attachedJoint == null)
			{
				continue;
			}

			Gizmos.color = (IsCurrentlyFixed ? Color.green : Color.white);
			Gizmos.color = (isFixedToWorld || attachedJoint.IsFixedToWorld ? Color.red : Gizmos.color);
			Gizmos.DrawSphere(attachedJoint.transform.position, 0.1f);
			Gizmos.DrawLine(transform.position, attachedJoint.transform.position);
		}
	}

	private void Awake()
	{
		rigidbody.isKinematic = true;
	}

	private void OnConnectedJointDead()
	{
		if (ShouldUseGravity)
		{
			rigidbody.isKinematic = false;
			rigidbody.WakeUp();
			Object.Destroy(this);
		}
	}

	private void OnDestroy()
	{
		isDead = true;
		foreach (RigidJoint attachedJoint in attachedJoints)
		{
			if (attachedJoint == null)
			{
				continue;
			}

			attachedJoint.OnConnectedJointDead();
		}
	}
}
