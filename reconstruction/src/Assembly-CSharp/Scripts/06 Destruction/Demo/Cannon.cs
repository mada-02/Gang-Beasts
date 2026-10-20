using Destruction.Common;
using System.Collections;
using UnityEngine;

namespace Destruction
{
		public class Cannon : MonoBehaviour
		{
			public GameObject explosionPrefab;

			public Rigidbody firePrefab;

			public Transform target;

			public float distance = 10f;

			public float impactSize = 2f;

			public float xSpeed = 250f;

			public float ySpeed = 120f;

			public float yMinLimit = -20f;

			public float yMaxLimit = 80f;

			private float x;

			private float y;

			[Range(0f, 50000f)]
			public float force = 10000f;

			private void Start()
			{
				Vector3 eulerAngles = transform.eulerAngles;
				x = eulerAngles.y;
				y = eulerAngles.x;
				UpdatePosition();
			}

			private void Update()
			{
				if (Input.GetKeyDown(KeyCode.Mouse0))
				{
					FireCannon();
				}
				if ((bool)target && Input.GetKey(KeyCode.Mouse1))
				{
					UpdatePosition();
				}
			}

			private void UpdatePosition()
			{
				x += Input.GetAxis("Mouse X") * xSpeed * 0.02f;
				y -= Input.GetAxis("Mouse Y") * ySpeed * 0.02f;
				y = ClampAngle(y, yMinLimit, yMaxLimit);
				Quaternion quaternion = Quaternion.Euler(y, x, 0f);
				Vector3 position = quaternion * new Vector3(0f, 0f, -distance) + target.position;
				transform.rotation = quaternion;
				transform.position = position;
			}

			private static float ClampAngle(float angle, float min, float max)
			{
				if (angle < -360f)
				{
					angle += 360f;
				}
				if (angle > 360f)
				{
					angle -= 360f;
				}
				return Mathf.Clamp(angle, min, max);
			}

			private void FireCannon()
			{
				if (firePrefab == null)
				{
					StartCoroutine(FireRayCannon());
				}
				else
				{
					FireAmmoCannon();
				}
			}

			private IEnumerator FireRayCannon()
			{
				Ray mouseRay = camera.ScreenPointToRay(Input.mousePosition);
				RaycastHit hit;
				if (!Physics.Raycast(mouseRay, out hit, 100f))
				{
					yield break;
				}
				Collider[] collidersNearby = Physics.OverlapSphere(hit.point, 0.4f);
				if (explosionPrefab == null)
				{
					Collider[] array = collidersNearby;
					foreach (Collider c in array)
					{
						if (!(c == null))
						{
							Rigidbody targetBody = c.attachedRigidbody;
							if (targetBody != null)
							{
								targetBody.AddForceAtPosition(force * mouseRay.direction, hit.point);
							}
						}
					}
					yield return new WaitForSeconds(0.01f);
					Collider[] array2 = collidersNearby;
					foreach (Collider c2 in array2)
					{
						if (!(c2 == null))
						{
							Component hitDestructable = c2.GetComponent(typeof(IDestructable));
							if (hitDestructable is IDestructable)
							{
								(hitDestructable as IDestructable).Destroy(hit.point, impactSize);
							}
						}
					}
				}
				else
				{
					Object.Instantiate(explosionPrefab, hit.point, Quaternion.LookRotation(Vector3.Cross(hit.normal, transform.right), hit.normal));
				}
			}

			private void FireAmmoCannon()
			{
				Ray ray = camera.ScreenPointToRay(Input.mousePosition);
				Rigidbody rigidbody = Object.Instantiate(firePrefab, ray.origin, transform.rotation) as Rigidbody;
				rigidbody.AddForce(ray.direction * force);
			}
		}
}
