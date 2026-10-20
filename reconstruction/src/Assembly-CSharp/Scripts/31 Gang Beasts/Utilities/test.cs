using UnityEngine;

public class test : MonoBehaviour
{
	private void Start()
	{
	}

	private void OnTriggerEnter(Collider collider)
	{
		Transform parent = collider.transform;
		while (parent.parent != null)
		{
			parent = parent.parent;
		}
		Debug.Log(parent.name);
	}
}
