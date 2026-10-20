using UnityEngine;

public class ExplosionSource : MonoBehaviour
{
	public float InfluenceRadius = 1f;

	public float Force = 1f;

	public bool CheckStructureIntegrity;

	public bool MoveManually;

	public Vector3 PosStart;

	public Vector3 PosEnd;

	public float MoveDuration = 2f;

	private FracturedObject[] m_aFracturedObjects;

	private float m_fStartTime;

	private void Start()
	{
		m_aFracturedObjects = Object.FindObjectsOfType(typeof(FracturedObject)) as FracturedObject[];
		m_fStartTime = Time.time;
	}

	private void Update()
	{
		if (!MoveManually)
		{
			transform.position = Vector3.Lerp(PosStart, PosEnd, Mathf.Clamp01((Time.time - m_fStartTime) / MoveDuration));
		}
		FracturedObject[] aFracturedObjects = m_aFracturedObjects;
		foreach (FracturedObject fracturedObject in aFracturedObjects)
		{
			fracturedObject.Explode(transform.position, Force, InfluenceRadius, false, true, false, CheckStructureIntegrity);
		}
	}
}
