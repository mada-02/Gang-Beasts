using UnityEngine;

public class SceneTimeScale : MonoBehaviour
{
	[Range(0f, 1f)]
	public float time = 1f;

	private void Start()
	{
	}

	private void Update()
	{
		Time.timeScale = time;
	}
}
