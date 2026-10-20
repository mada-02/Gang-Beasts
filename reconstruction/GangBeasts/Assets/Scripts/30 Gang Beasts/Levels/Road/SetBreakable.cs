using UnityEngine;

public class SetBreakable : MonoBehaviour
{
	public float linkStrength = 200f;

	public int variation = 50;

	public float delay = 1f;

	public int weakLinks = 1;

	private ConfigurableJoint[] configurableJoints;

	private void Start()
	{
		configurableJoints = gameObject.GetComponentsInChildren<ConfigurableJoint>();
		for (int i = 0; i < weakLinks; i++)
		{
			Invoke("SetJointsToBreakable", delay);
		}
	}

	private void SetJointsToBreakable()
	{
		int num = Random.Range(1, configurableJoints.Length);
		for (int i = 0; i < configurableJoints.Length; i++)
		{
			if (i == num)
			{
				float num2 = linkStrength + (float)Random.Range(-variation, variation);
				configurableJoints[i].breakForce = num2;
				configurableJoints[i].breakTorque = num2;
			}
		}
	}
}
