using UnityEngine;

public static class GameObjectExtensions
{
	public static void SetActive(this GameObject go, bool isActive)
	{
		go.SetActive(isActive);
	}
}
