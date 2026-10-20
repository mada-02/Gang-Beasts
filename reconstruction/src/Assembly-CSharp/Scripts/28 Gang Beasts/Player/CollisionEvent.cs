using System.Collections.Generic;
using UnityEngine;

public class CollisionEvent : MonoBehaviour
{
	private string thisPartName;

	private Player player;

	private HealthAndStamina health;

	public AudioClip[] stepSound;

	private float stepRetriggerDelay;

	public AudioClip[] punchSound;

	private float punchRetriggerDelay;

	private void Start()
	{
		Transform root = transform.root;
		player = root.GetComponent<Player>();
		health = root.GetComponent<HealthAndStamina>();
		foreach (KeyValuePair<string, Transform> item in player.part)
		{
			if (item.Value == transform)
			{
				thisPartName = item.Key;
			}
		}
	}

	private void Update()
	{
		if (stepRetriggerDelay > 0f)
		{
			stepRetriggerDelay -= Time.deltaTime;
		}
		if (punchRetriggerDelay > 0f)
		{
			punchRetriggerDelay -= Time.deltaTime;
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		CollisionSorter(collision, false, false);
		if (thisPartName != null && collision.contacts.Length > 0 && collision.contacts[0].otherCollider.transform.root != transform.root && collision.transform.root.tag != "Player" && collision.transform.root.tag != "Player (Dont Track)" && collision.transform.root.tag != "Mob")
		{
			if (thisPartName == "leftLeg")
			{
				player.leftLegOnGround = true;
			}
			if (thisPartName == "rightLeg")
			{
				player.rightLegOnGround = true;
			}
			if (thisPartName == "ball")
			{
				player.rightLegOnGround = true;
			}
		}
	}

	private void OnCollisionStay(Collision collision)
	{
		if (thisPartName != null && collision.contacts.Length > 0 && collision.contacts[0].otherCollider.transform.root != transform.root && collision.transform.root.tag != "Player" && collision.transform.root.tag != "Player (Dont Track)" && collision.transform.root.tag != "Mob")
		{
			if (thisPartName == "leftLeg")
			{
				player.leftLegOnGround = true;
			}
			if (thisPartName == "rightLeg")
			{
				player.rightLegOnGround = true;
			}
			if (thisPartName == "ball")
			{
				player.rightLegOnGround = true;
			}
		}
	}

	private void OnCollisionExit(Collision collision)
	{
		CollisionSorter(collision, true, false);
		if (thisPartName != null && collision.contacts.Length > 0 && collision.contacts[0].otherCollider.transform.root != transform.root && collision.transform.root.tag != "Player" && collision.transform.root.tag != "Player (Dont Track)" && collision.transform.root.tag != "Mob")
		{
			if (thisPartName == "leftLeg")
			{
				player.leftLegOnGround = false;
			}
			if (thisPartName == "rightLeg")
			{
				player.rightLegOnGround = false;
			}
			if (thisPartName == "ball")
			{
				player.rightLegOnGround = false;
			}
		}
	}

	private void CollisionSorter(Collision collision, bool collisionExit, bool collisionStay)
	{
		if (!(!(player != null) || player.state == Player.State.Dead || thisPartName == null || collision.contacts.Length <= 0 || !(collision.contacts[0].otherCollider.transform.root != transform.root)))
		{
			float num = Vector3.Angle(collision.contacts[0].normal, Vector3.up);
			if (num <= 45f && player.state != Player.State.Falling && player.jumpReset <= 0f)
			{
				GroundCheck(collision, collisionStay);
			}
			else
			{
				DamageCheck(collision);
			}

			if (player.state != Player.State.Stunned)
			{
				if (thisPartName == "leftHand" && player.leftGrab)
				{
					GrabCheck(collision);
				}

				if (thisPartName == "rightHand" && player.rightGrab)
				{
					GrabCheck(collision);
				}
			}
		}
	}

	private void SoundAtPoint(AudioClip clip, Vector3 position, float volume, float pitch)
	{
		GameObject gameObject = new GameObject();
		gameObject.transform.position = position;
		gameObject.name = clip.name;
		gameObject.AddComponent<AudioSource>();
		gameObject.audio.pitch = pitch;
		gameObject.audio.PlayOneShot(clip, volume);
		Object.Destroy(gameObject, clip.length / pitch);
	}

	private void DamageCheck(Collision collision)
	{
		float num = 0f;
		float num2 = 0f;
		float num3 = collision.relativeVelocity.magnitude;
		if ((bool)collision.rigidbody)
		{
			num = collision.rigidbody.mass;
			num2 = Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity) * collision.rigidbody.mass / 100f;
			if (collision.rigidbody.tag == "Body Part (Harmful)" || collision.rigidbody.tag == "Prop (Harmful)")
			{
				num2 *= 10f;
				num3 *= 10f;
			}
		}
		else
		{
			num = 1000f;
			num2 = Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity) * num / 100f;
		}
		if (num3 > 15f)
		{
			if (transform.tag == "Body Part (Weak Point)")
			{
				health.TakeDamage(collision, Mathf.RoundToInt(num2), true);
			}
			else
			{
				health.TakeDamage(collision, Mathf.RoundToInt(num2), false);
			}
		}
	}

	private void GroundCheck(Collision collision, bool collisionStay)
	{
		if (!(player.state == Player.State.Dead || player.state == Player.State.Stunned))
		{
			if (player.direction == Vector3.zero)
			{
				player.state = Player.State.Standing;
			}
			else
			{
				player.state = Player.State.Running;
			}

			if (thisPartName != "leftLeg" && thisPartName != "rightLeg" && thisPartName != "ball")
			{
				player.canJump = false;
			}

			if (!collisionStay && stepSound.Length > 0 && (thisPartName == "leftLeg" || thisPartName == "rightLeg") && stepRetriggerDelay <= 0f)
			{
				float magnitude = collision.relativeVelocity.magnitude;
				if (magnitude > 1f)
				{
					float num = Random.Range(0.5f, 1f);
					int num2 = Random.Range(0, stepSound.Length - 1);
					SoundAtPoint(stepSound[num2], collision.contacts[0].point, magnitude / 10f, num / Time.timeScale);
					stepRetriggerDelay = 0.1f;
				}
			}
		}
	}

	private void GrabCheck(Collision collision)
	{
		if (transform.root != collision.transform.root && gameObject.GetComponent<HingeJoint>() == null)
		{
			HingeJoint hingeJoint = gameObject.AddComponent<HingeJoint>();
			hingeJoint.useLimits = true;
			if ((bool)collision.rigidbody)
			{
				hingeJoint.connectedBody = collision.rigidbody;
				hingeJoint.breakForce = 150f;
			}
			else
			{
				hingeJoint.connectedBody = null;
				hingeJoint.breakForce = 150f;
			}
		}
	}
}
