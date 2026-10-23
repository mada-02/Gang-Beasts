using UnityEngine;

// The developer layer's root, added to the persistent SceneManager object by the hook in
// SceneManager.Awake (developer branch only; see CLAUDE.md). Every dev module hangs off this object,
// so it lives as long as the game and survives level loads.
public class DevRoot : MonoBehaviour
{
	public static DevRoot instance;

	private void Awake()
	{
		instance = this;
		if (DevTestRunner.Requested())
		{
			gameObject.AddComponent<DevTestRunner>();
		}
	}

	private void OnDestroy()
	{
		if (instance == this)
		{
			instance = null;
		}
	}
}
