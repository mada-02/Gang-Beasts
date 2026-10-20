using UnityEngine;

public class LogicCollidingSphere : MonoBehaviour
{
	public Rigidbody ObjectToDrop;

	private bool bDropped;

	private int nChunksDetached;

	private int nChunkCollisions;

	private void Start()
	{
		nChunksDetached = 0;
		nChunkCollisions = 0;
	}

	private void Update()
	{
		if (bDropped && ObjectToDrop.isKinematic)
		{
			ObjectToDrop.isKinematic = false;
			ObjectToDrop.WakeUp();
		}
	}

	private void OnGUI()
	{
		if (!LogicGlobalFracturing.HelpVisible)
		{
			return;
		}

		LogicGlobalFracturing.GlobalGUI();
		GUILayout.Label("This scene shows:");
		GUILayout.Label("-Voronoi fracturing");
		GUILayout.Label("-Fracturing on physical contact");
		GUILayout.Label("-Collision custom notifications");
		GUILayout.Label("-Collision particles");
		GUILayout.Label("-Collision sounds");
		GUILayout.Label(string.Empty);
		GUILayout.Label("Press the button below to drop the object.");
		if (GUILayout.Button("Drop"))
		{
			bDropped = true;
		}

		GUILayout.Label("Collision notifications:");
		GUILayout.Label(nChunksDetached + " chunks detached");
		GUILayout.Label(nChunkCollisions + " chunk collisions");
	}

	private void OnChunkDetach(FracturedChunk.CollisionInfo info)
	{
		info.bCancelCollisionEvent = false;
		nChunksDetached++;
	}

	private void OnFreeChunkCollision(FracturedChunk.CollisionInfo info)
	{
		info.bCancelCollisionEvent = false;
		nChunkCollisions++;
	}
}
