using System.Collections.Generic;
using UnityEngine;

// 0.0.2's CollisionEvent (decompiled from the shipped 0.0.2 build), put on each part in Hard Mode instead of
// 0.0.3's. The class name differs, and 0.0.2's Health is 0.0.3's HealthAndStamina (same TakeDamage; see
// dev/hardmode/code_diff.md C1-C3).

public class CollisionEvent002 : MonoBehaviour
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
	}

	private void OnCollisionStay(Collision collision)
	{
		CollisionSorter(collision, false, true);
	}

	private void OnCollisionExit(Collision collision)
	{
		CollisionSorter(collision, true, false);
	}

	private void CollisionSorter(Collision collision, bool collisionExit, bool collisionStay)
	{
		if (!(player != null) || player.state == Player.State.Dead || thisPartName == null || collision.contacts.Length <= 0 || !(collision.contacts[0].otherCollider.transform.root != transform.root))
		{
			return;
		}
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
			num = 10f;
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
		if (player.state == Player.State.Dead || player.state == Player.State.Stunned)
		{
			return;
		}
		if (player.direction == Vector3.zero && collisionStay)
		{
			player.state = Player.State.Standing;
		}
		else if (collisionStay)
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
