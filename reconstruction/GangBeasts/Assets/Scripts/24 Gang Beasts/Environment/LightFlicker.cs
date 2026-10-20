using UnityEngine;

public class LightFlicker : MonoBehaviour
{
	public GameObject[] lightObject;

	public Light[] lightEmitter;

	private void Start()
	{
	}

	private void Update()
	{
		if (lightObject != null)
		{
			for (int i = 0; i < lightObject.Length; i++)
			{
				float num = Random.Range(0f, 1f);
				Color color = new Color(lightObject[i].renderer.material.color.r, lightObject[i].renderer.material.color.g, lightObject[i].renderer.material.color.b, num);
				lightObject[i].renderer.material.color = color;
				lightEmitter[i].intensity = num * 8f;
			}
		}
	}
}
