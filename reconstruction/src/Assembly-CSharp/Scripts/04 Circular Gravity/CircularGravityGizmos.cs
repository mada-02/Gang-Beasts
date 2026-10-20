using UnityEngine;

[ExecuteInEditMode]
public class CircularGravityGizmos : MonoBehaviour
{
	private CircularGravity circularGravity;

	private void Update()
	{
		circularGravity = GetComponent<CircularGravity>();
		if (circularGravity != null)
		{
			DrawGravityForceGizmos();
		}
	}

	private void DrawGravityForceGizmos()
	{
		Transform transform = base.transform;
		Color color;
		if (circularGravity.forcePower == 0f)
		{
			color = Color.white;
		}
		else
		{
			color = (circularGravity.forcePower > 0f ? Color.green : Color.red);
		}

		switch (circularGravity.shape)
		{
			case CircularGravity.Shape.Sphere:
				Debug.DrawLine(transform.position + transform.rotation * Vector3.up * circularGravity.sizeProperties.size, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.down * circularGravity.sizeProperties.size, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.left * circularGravity.sizeProperties.size, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.right * circularGravity.sizeProperties.size, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.forward * circularGravity.sizeProperties.size, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.back * circularGravity.sizeProperties.size, transform.position, color);
				break;
			case CircularGravity.Shape.Capsule:
			{
				Debug.DrawLine(transform.position + transform.rotation * Vector3.up * circularGravity.sizeProperties.capsuleRadius, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.down * circularGravity.sizeProperties.capsuleRadius, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.left * circularGravity.sizeProperties.capsuleRadius, transform.position, color);
				Debug.DrawLine(transform.position + transform.rotation * Vector3.right * circularGravity.sizeProperties.capsuleRadius, transform.position, color);
				Vector3 vector = transform.position + transform.rotation * Vector3.forward * circularGravity.sizeProperties.size;
				Debug.DrawLine(transform.position, vector, color);
				Debug.DrawLine(vector + transform.rotation * Vector3.up * circularGravity.sizeProperties.capsuleRadius, vector, color);
				Debug.DrawLine(vector + transform.rotation * Vector3.down * circularGravity.sizeProperties.capsuleRadius, vector, color);
				Debug.DrawLine(vector + transform.rotation * Vector3.left * circularGravity.sizeProperties.capsuleRadius, vector, color);
				Debug.DrawLine(vector + transform.rotation * Vector3.right * circularGravity.sizeProperties.capsuleRadius, vector, color);
				break;
			}

			case CircularGravity.Shape.RayCast:
				Debug.DrawLine(transform.position + transform.rotation * Vector3.forward * circularGravity.sizeProperties.size, transform.position, color);
				break;
		}
	}
}
