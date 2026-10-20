using UnityEngine;

public class LogicExplodingGoblin : MonoBehaviour
{
	public float ExplosionForce = 4f;

	public FracturedObject TargetFracturedObject;

	private void OnGUI()
	{
		if (!LogicGlobalFracturing.HelpVisible)
		{
			return;
		}

		LogicGlobalFracturing.GlobalGUI();
		GUILayout.Label("This scene shows:");
		GUILayout.Label("-Voronoi fracturing");
		GUILayout.Label("-Triggered explosion");
		GUILayout.Label("-Collision particles");
		GUILayout.Label("-Collision sounds");
		GUILayout.Label(string.Empty);
		GUILayout.Label("Press the button below to explode the object.");
		if (GUILayout.Button("Explode"))
		{
			TargetFracturedObject.Explode(TargetFracturedObject.transform.position, ExplosionForce);
		}
	}
}
