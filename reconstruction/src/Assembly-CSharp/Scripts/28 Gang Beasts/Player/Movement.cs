using UnityEngine;

public class Movement : MonoBehaviour
{
	public float movementSpeed;

	private Vector3 inputDirection;

	private float runTimer;

	public float animationSpeed = 0.1f;

	public int leftLimbPosition;

	public int rightLimbPosition;

	private Player player;

	private Targeting targeting;

	private void Start()
	{
		player = gameObject.GetComponent<Player>();
		targeting = player.part["targetFinder"].GetComponent<Targeting>();
		player.part["ball"].rigidbody.useConeFriction = true;
		player.part["ball"].rigidbody.maxAngularVelocity = movementSpeed;
	}

	private void FixedUpdate()
	{
		inputDirection = player.direction;
		if (player.state != Player.State.Stunned && player.state != Player.State.Dead && (player.state == Player.State.Standing || player.state == Player.State.Running))
		{
			if (inputDirection == Vector3.zero)
			{
				Standing();
				player.state = Player.State.Standing;
				runTimer = -1f;
			}
			else if (player.applyedForce > player.force / 4f)
			{
				Running();
				player.state = Player.State.Running;
				runTimer += Time.deltaTime;
			}
			else
			{
				Standing();
				player.state = Player.State.Standing;
				runTimer = -1f;
			}
		}
	}

	private void Standing()
	{
		player.part["ball"].rigidbody.freezeRotation = true;
		if (player.duck)
		{
			Vector3 vector = player.part["chest"].TransformDirection(Vector3.forward);
			vector.y = 0f;
			player.part["chest"].rigidbody.AddRelativeTorque(-Vector3.left * 200f, ForceMode.Impulse);
			player.part["hips"].rigidbody.AddRelativeTorque(Vector3.left * 200f, ForceMode.Impulse);
		}
		else
		{
			Straighten(player.part["chest"], player.part["ball"], Vector3.up, player.applyedForce);
			Straighten(player.part["leftThigh"], player.part["leftLeg"], Vector3.up, player.applyedForce / 4f);
			Straighten(player.part["rightThigh"], player.part["rightLeg"], Vector3.up, player.applyedForce / 4f);
		}
		Vector3 direction = player.direction + Vector3.down;
		Vector3 direction2 = player.direction;
		if (targeting.grabTarget != null)
		{
			direction2 = targeting.grabTarget.transform.position - player.part["head"].position;
		}
		AlignToVector(player.part["head"], player.part["head"].forward, direction2, player.applyedForce);
		AlignToVector(player.part["chest"], player.part["chest"].forward, direction, player.applyedForce * 10f);
		AlignToVector(player.part["hips"], player.part["hips"].forward, direction, player.applyedForce * 10f);
	}

	private void Running()
	{
		if (player.applyedForce < player.force || player.duck)
		{
			player.part["ball"].rigidbody.freezeRotation = true;
		}
		else
		{
			player.part["ball"].rigidbody.freezeRotation = false;
		}
		Vector3 direction = inputDirection + Vector3.down;
		Vector3 direction2 = inputDirection;
		if (targeting.grabTarget != null)
		{
			direction2 = targeting.grabTarget.transform.position - player.part["head"].position;
		}
		if (player.duck)
		{
			Vector3 vector = player.part["chest"].TransformDirection(Vector3.forward);
			vector.y = 0f;
			player.part["chest"].rigidbody.AddRelativeTorque(-Vector3.left * 200f, ForceMode.Impulse);
			player.part["hips"].rigidbody.AddRelativeTorque(Vector3.left * 200f, ForceMode.Impulse);
			Straighten(player.part["hips"], player.part["ball"], Vector3.up, player.applyedForce);
		}
		else
		{
			Straighten(player.part["chest"], player.part["ball"], Vector3.up, player.applyedForce);
		}
		AlignToVector(player.part["head"], player.part["head"].forward, direction2, player.applyedForce);
		AlignToVector(player.part["chest"], player.part["chest"].forward, direction, player.applyedForce);
		AlignToVector(player.part["hips"], player.part["hips"].forward, direction, player.applyedForce);
		float num = Vector3.Angle(inputDirection, -player.part["chest"].right);
		float num2 = Vector3.Angle(inputDirection, player.part["chest"].right);
		if (num < num2)
		{
			player.part["chest"].rigidbody.AddTorque(-Vector3.up * 100000f, ForceMode.Impulse);
			player.part["hips"].rigidbody.AddTorque(-Vector3.up * 100000f, ForceMode.Impulse);
		}
		if (num2 < num)
		{
			player.part["chest"].rigidbody.AddTorque(Vector3.up * 100000f, ForceMode.Impulse);
			player.part["hips"].rigidbody.AddTorque(Vector3.up * 100000f, ForceMode.Impulse);
		}
		if (runTimer < 0f)
		{
			int num3 = Random.Range(0, 2);
			if (num3 == 1)
			{
				leftLimbPosition = 0;
				rightLimbPosition = 3;
				runTimer = 0f;
			}
			else
			{
				leftLimbPosition = 3;
				rightLimbPosition = 0;
				runTimer = 0f;
			}
		}
		if (runTimer < animationSpeed)
		{
			runTimer += Time.deltaTime;
		}
		else
		{
			runTimer = 0f;
			leftLimbPosition++;
			rightLimbPosition++;
		}
		if (leftLimbPosition >= 6)
		{
			leftLimbPosition = 0;
		}
		if (rightLimbPosition >= 6)
		{
			rightLimbPosition = 0;
		}
		MoveLeg(player.part["chest"], player.part["leftThigh"], player.part["leftLeg"], leftLimbPosition);
		MoveLeg(player.part["chest"], player.part["rightThigh"], player.part["rightLeg"], rightLimbPosition);
		MoveArm(player.part["chest"], player.part["leftArm"], player.part["leftForarm"], player.part["leftHand"], leftLimbPosition);
		MoveArm(player.part["chest"], player.part["rightArm"], player.part["rightForarm"], player.part["rightHand"], rightLimbPosition);
		player.part["ball"].rigidbody.maxAngularVelocity = movementSpeed;
		Vector3 vector2 = new Vector3(inputDirection.z, 0f, -inputDirection.x);
		float num4 = Vector3.Angle(inputDirection, player.part["chest"].forward);
		if (num4 < 30f)
		{
			player.part["ball"].rigidbody.AddTorque(vector2 * movementSpeed, ForceMode.Impulse);
		}
		else
		{
			player.part["ball"].rigidbody.AddTorque(vector2 * (movementSpeed / 10f), ForceMode.Impulse);
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

	private void MoveLeg(Transform chest, Transform thigh, Transform leg, int position)
	{
		switch (position)
		{
		case 0:
		case 1:
			AlignToVector(thigh, -thigh.up, inputDirection, player.applyedForce);
			AlignToVector(leg, leg.up, inputDirection, player.applyedForce);
			thigh.rigidbody.AddTorque(-player.part["chest"].right * 20f, ForceMode.Impulse);
			leg.rigidbody.AddTorque(player.part["chest"].right * 20f, ForceMode.Impulse);
			break;
		case 2:
		case 3:
			AlignToVector(thigh, -thigh.up, inputDirection, player.applyedForce);
			AlignToVector(leg, -leg.up, inputDirection, player.applyedForce);
			break;
		case 4:
			AlignToVector(thigh, thigh.up, chest.up, player.applyedForce);
			AlignToVector(leg, leg.up, chest.up, player.applyedForce);
			leg.rigidbody.AddForceAtPosition(Vector3.down * player.applyedForce / 10f, -leg.up, ForceMode.Impulse);
			chest.rigidbody.AddForce(-Vector3.up * player.applyedForce / 5f, ForceMode.Impulse);
			break;
		case 5:
			AlignToVector(thigh, thigh.up, inputDirection, player.applyedForce);
			AlignToVector(leg, leg.up, inputDirection, player.applyedForce);
			chest.rigidbody.AddForce(Vector3.up * player.applyedForce / 5f, ForceMode.Impulse);
			break;
		}
	}

	public void MoveArm(Transform chest, Transform arm, Transform forarm, Transform hand, int position)
	{
		AlignToVector(chest, chest.up, chest.forward, player.applyedForce);
		switch (position)
		{
		case 2:
		case 3:
			AlignToVector(arm, arm.up, -inputDirection, player.applyedForce * 10f);
			AlignToVector(forarm, forarm.up, inputDirection, player.applyedForce * 10f);
			forarm.rigidbody.AddForce(-inputDirection * 2f, ForceMode.Impulse);
			break;
		case 4:
		case 5:
			AlignToVector(arm, arm.up, -chest.forward, player.applyedForce * 10f);
			AlignToVector(forarm, forarm.up, -chest.forward, player.applyedForce * 10f);
			forarm.rigidbody.AddForce(inputDirection, ForceMode.Impulse);
			break;
		case 0:
		case 1:
			AlignToVector(arm, arm.up, inputDirection, player.applyedForce * 10f);
			AlignToVector(forarm, forarm.up, -inputDirection, player.applyedForce * 10f);
			forarm.rigidbody.AddForce(chest.up, ForceMode.Impulse);
			break;
		}
	}
}
