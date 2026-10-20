using UnityEngine;

[ExecuteInEditMode]
public class WaterTile : MonoBehaviour
{
	public PlanarReflection reflection;

	public WaterBase waterBase;

	public void Start()
	{
		AcquireComponents();
	}

	private void AcquireComponents()
	{
		if (!reflection)
		{
			if ((bool)transform.parent)
			{
				reflection = transform.parent.GetComponent<PlanarReflection>();
			}
			else
			{
				reflection = transform.GetComponent<PlanarReflection>();
			}
		}
		if (!waterBase)
		{
			if ((bool)transform.parent)
			{
				waterBase = transform.parent.GetComponent<WaterBase>();
			}
			else
			{
				waterBase = transform.GetComponent<WaterBase>();
			}
		}
	}

	public void OnWillRenderObject()
	{
		if ((bool)reflection)
		{
			reflection.WaterTileBeingRendered(transform, Camera.current);
		}
		if ((bool)waterBase)
		{
			waterBase.WaterTileBeingRendered(transform, Camera.current);
		}
	}
}
