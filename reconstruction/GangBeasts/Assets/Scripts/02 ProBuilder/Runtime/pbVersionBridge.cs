using UnityEngine;

public class pbVersionBridge
{
	public static int GetMajorVersion()
	{
		return 0;
	}

	public static bool IsPro()
	{
		bool isPro = false;
		return isPro;
	}

	public static bool StaticBatchingEnabled(GameObject go)
	{
		return true;
	}

	public static void SetActive(GameObject go, bool isActive)
	{
		go.SetActive(isActive);
	}
}
