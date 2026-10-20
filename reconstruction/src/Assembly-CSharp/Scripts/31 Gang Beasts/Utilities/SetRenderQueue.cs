using UnityEngine;

[AddComponentMenu("Effects/SetRenderQueue")]
[RequireComponent(typeof(Renderer))]
public class SetRenderQueue : MonoBehaviour
{
	public int queue = 1;

	public int[] queues;

	protected void Start()
	{
		if (!((bool)renderer && (bool)renderer.sharedMaterial && queues != null))
		{
			return;
		}

		renderer.sharedMaterial.renderQueue = queue;
		for (int i = 0; i < queues.Length && i < renderer.sharedMaterials.Length; i++)
		{
			renderer.sharedMaterials[i].renderQueue = queues[i];
		}
	}
}
