using UnityEngine;

public class Jump : MonoBehaviour
{
	public float jumpStrength;

	public float currentJumpStrength;

	public float jumpTimer;

	public float fallTime;

	public float airSpeed = 5f;

	private bool jumped;

	private Vector3 inputDirection;

	private Player player;

	private Targeting targeting;

	private void Start()
	{
		player = gameObject.GetComponent<Player>();
		targeting = player.part["targetFinder"].GetComponent<Targeting>();
	}

	private void FixedUpdate()
	{
		inputDirection = player.direction;
		if (player.state == Player.State.Jumping || player.state == Player.State.Falling)
		{
			if (jumpTimer < fallTime)
			{
				if (player.applyedForce > player.force / 4f)
				{
					Jumping();
				}
				else
				{
					Falling();
				}
			}
			else
			{
				Falling();
			}
			jumpTimer += Time.deltaTime;
		}
		else
		{
			jumped = false;
			jumpTimer = 0f;
		}
		currentJumpStrength += jumpStrength * 5f * Time.deltaTime;
		if (currentJumpStrength > jumpStrength)
		{
			currentJumpStrength = jumpStrength;
		}
	}

	private void Jumping()
	{
		if (!jumped && player.onGround)
		{
			player.part["chest"].rigidbody.AddForce(Vector3.up * currentJumpStrength, ForceMode.Impulse);
			currentJumpStrength -= jumpStrength * 40f * Time.deltaTime;
			if (currentJumpStrength < 0f)
			{
				currentJumpStrength = 0f;
			}
			jumped = true;
		}
		player.part["ball"].rigidbody.freezeRotation = true;
		Vector3 vector = inputDirection + Vector3.down;
		Vector3 direction = inputDirection;
		if (targeting.grabTarget != null)
		{
			direction = targeting.grabTarget.transform.position - player.part["head"].position;
		}
		if (player.duck)
		{
			player.part["chest"].rigidbody.AddRelativeTorque(-Vector3.left * 1000f, ForceMode.Impulse);
		}
		else
		{
			Straighten(player.part["chest"], player.part["ball"], Vector3.up, player.applyedForce);
		}
		AlignToVector(player.part["head"], player.part["head"].forward, direction, player.applyedForce);
		AlignToVector(player.part["chest"], player.part["chest"].forward, vector, player.applyedForce * 10f);
		AlignToVector(player.part["hips"], player.part["hips"].forward, vector, player.applyedForce * 10f);
		player.part["leftThigh"].rigidbody.AddTorque(-player.part["chest"].right * 20f, ForceMode.Impulse);
		player.part["leftLeg"].rigidbody.AddTorque(player.part["chest"].right, ForceMode.Impulse);
		player.part["rightThigh"].rigidbody.AddTorque(-player.part["chest"].right * 20f, ForceMode.Impulse);
		player.part["rightLeg"].rigidbody.AddTorque(player.part["chest"].right, ForceMode.Impulse);
		float num = float.PositiveInfinity;
		if (targeting.grabTarget != null)
		{
			Vector3 vector2 = targeting.grabTarget.collider.bounds.center - player.part["hips"].collider.bounds.center;
			num = Vector3.Angle(vector2, player.part["hips"].up);
		}
		if (targeting.grabTarget != null && num <= 90f)
		{
			Debug.DrawLine(player.part["head"].collider.bounds.center, targeting.grabTarget.collider.bounds.center);
			player.part["leftHand"].rigidbody.AddForce((targeting.grabTarget.collider.bounds.center - player.part["leftHand"].position).normalized * 2f, ForceMode.Impulse);
			player.part["rightHand"].rigidbody.AddForce((targeting.grabTarget.collider.bounds.center - player.part["rightHand"].position).normalized * 2f, ForceMode.Impulse);
			player.part["chest"].rigidbody.AddForce(-(targeting.grabTarget.collider.bounds.center - player.part["chest"].position).normalized * 4f, ForceMode.Impulse);
		}
		if (targeting.grabTarget == null || num > 90f)
		{
			Debug.DrawRay(player.part["head"].collider.bounds.center, Vector3.up);
			player.part["leftHand"].rigidbody.AddForce(player.part["chest"].forward * 2f, ForceMode.Impulse);
			player.part["rightHand"].rigidbody.AddForce(player.part["chest"].forward * 2f, ForceMode.Impulse);
			player.part["leftForarm"].rigidbody.AddForce(-player.part["chest"].right * 2f, ForceMode.Impulse);
			player.part["rightForarm"].rigidbody.AddForce(player.part["chest"].right * 2f, ForceMode.Impulse);
			player.part["hips"].rigidbody.AddForce(-player.part["chest"].forward * 4f, ForceMode.Impulse);
		}
		if (player.direction != Vector3.zero)
		{
			player.part["chest"].rigidbody.AddForce(vector * airSpeed, ForceMode.Impulse);
		}
	}

	private void Falling()
	{
		Vector3 vector = inputDirection + Vector3.down;
		Vector3 direction = inputDirection;
		if (targeting.grabTarget != null)
		{
			direction = targeting.grabTarget.transform.position - player.part["head"].position;
		}
		AlignToVector(player.part["head"], player.part["head"].forward, direction, player.applyedForce);
		if (player.direction != Vector3.zero)
		{
			player.part["hips"].rigidbody.AddForce(inputDirection * airSpeed, ForceMode.Impulse);
		}
	}

	private void AlignToVector(Transform part, Vector3 axis, Vector3 direction, float applyedForce)
	{
		part.rigidbody.AddForceAtPosition(-axis, direction.normalized * player.applyedForce, ForceMode.Impulse);
		part.rigidbody.AddForceAtPosition(axis, -direction.normalized * player.applyedForce, ForceMode.Impulse);
	}

	private void Straighten(Transform partA, Transform partB, Vector3 direction, float applyedForce)
	{
		partA.rigidbody.AddForce(direction * player.applyedForce, ForceMode.Impulse);
		partB.rigidbody.AddForce(-direction * player.applyedForce, ForceMode.Impulse);
	}
}
