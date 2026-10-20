using UnityEngine;

[RequireComponent(typeof(Camera))]
[AddComponentMenu("")]
public class CC_Base : MonoBehaviour
{
	public Shader shader;

	protected Material _material;

	protected virtual void Start()
	{
		if (!SystemInfo.supportsImageEffects)
		{
			enabled = false;
			return;
		}

		if (!shader || !shader.isSupported)
		{
			enabled = false;
		}
	}

	protected Material material
	{
		get
		{
			if (_material == null)
			{
				_material = new Material(shader);
				_material.hideFlags = HideFlags.HideAndDontSave;
			}
			return _material;
		}
	}

	protected virtual void OnDisable()
	{
		if ((bool)_material)
		{
			Object.DestroyImmediate(_material);
		}
	}
}
