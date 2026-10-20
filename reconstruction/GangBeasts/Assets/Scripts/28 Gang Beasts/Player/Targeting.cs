using System.Collections.Generic;
using UnityEngine;

public class Targeting : MonoBehaviour
{
	public List<GameObject> targetsInSphere;

	public GameObject punchTarget;

	public GameObject grabTarget;

	public float fov = 120f;

	private Player player;

	private void Start()
	{
		player = transform.root.GetComponent<Player>();
	}

	private void Update()
	{
		FindTargets();
	}

	private void OnTriggerEnter(Collider collider)
	{
		if (collider.transform.root != transform.root && (collider.tag.Contains("Body Part") || collider.tag.Contains("Prop")))
		{
			targetsInSphere.Add(collider.gameObject);
		}
	}

	private void OnTriggerExit(Collider collider)
	{
		targetsInSphere.Remove(collider.gameObject);
	}

	public void FindTargets()
	{
		punchTarget = null;
		grabTarget = null;
		if (targetsInSphere.Count > 0)
		{
			float num = float.PositiveInfinity;
			for (int i = 0; i < targetsInSphere.Count; i++)
			{
				if (!(!(targetsInSphere[i] != null) || !(targetsInSphere[i].transform.root != transform.root)))
				{
					float num2 = Vector3.Distance(targetsInSphere[i].transform.position, player.part["head"].position);
					Vector3 vector = targetsInSphere[i].transform.position - player.part["head"].renderer.bounds.center;
					float num3 = Vector3.Angle(vector, player.part["chest"].forward);
					switch (targetsInSphere[i].transform.tag)
					{
						case "Body Part (Weak Point)":
							if (num2 - 0.25f < num && num3 < fov)
							{
								num = num2 - 0.25f;
								punchTarget = targetsInSphere[i];
								grabTarget = targetsInSphere[i];
							}

							break;
						case "Body Part":
						case "Body Part (Harmful)":
							if (num2 - 0.15f < num && num3 < fov)
							{
								num = num2 - 0.15f;
								grabTarget = targetsInSphere[i];
							}

							break;
						case "Prop (Button)":
						case "Prop (Lever)":
							if ((double)num2 - 0.05 < (double)num && num3 < fov)
							{
								num = num2 - 0.05f;
								grabTarget = targetsInSphere[i];
							}

							break;
						default:
							if (num2 < num && num3 < fov)
							{
								num = num2;
								grabTarget = targetsInSphere[i];
							}

							break;
					}
				}
			}
		}
	}
}
