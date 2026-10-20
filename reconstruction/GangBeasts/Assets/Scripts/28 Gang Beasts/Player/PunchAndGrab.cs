using UnityEngine;

public class PunchAndGrab : MonoBehaviour
{
	public bool useStamina;

	private Player player;

	private HealthAndStamina stats;

	private Targeting targeting;

	private float leftTimer;

	private float rightTimer;

	private float punchCost;

	private float grabCost = 1.1f;

	private float liftCost = 5f;

	public float liftForce = 20f;

	private void Start()
	{
		player = gameObject.GetComponent<Player>();
		stats = gameObject.GetComponent<HealthAndStamina>();
		targeting = player.part["targetFinder"].GetComponent<Targeting>();
	}

	private void FixedUpdate()
	{
		if (player.leftGrab && stats.stamina > grabCost)
		{
			Grab(player.part["leftHand"]);
		}
		if (player.rightGrab && stats.stamina > grabCost)
		{
			Grab(player.part["rightHand"]);
		}
		if ((player.leftGrab || player.rightGrab) && (player.part["leftHand"].GetComponent<HingeJoint>() != null || player.part["rightHand"].GetComponent<HingeJoint>() != null))
		{
			stats.stamina -= grabCost;
		}
		if (!player.leftGrab || stats.stamina <= grabCost)
		{
			LetGo(player.part["leftHand"]);
		}
		if (!player.rightGrab || stats.stamina <= grabCost)
		{
			LetGo(player.part["rightHand"]);
		}
		if (player.taunt)
		{
			Taunt();
		}
		if (player.leftPunch)
		{
			leftTimer += Time.deltaTime;
			Punch(player.part["leftArm"], player.part["leftForarm"], player.part["leftHand"], leftTimer);
		}
		if (player.rightPunch)
		{
			rightTimer += Time.deltaTime;
			Punch(player.part["rightArm"], player.part["rightForarm"], player.part["rightHand"], rightTimer);
		}
	}

	private void Punch(Transform arm, Transform forarm, Transform hand, float timer)
	{
		if (timer <= 0.2f)
		{
			if (useStamina)
			{
				forarm.rigidbody.AddForce(-player.part["chest"].forward * (30f * stats.stamina / 100f), ForceMode.Impulse);
				hand.rigidbody.AddForce(player.part["chest"].up + player.part["chest"].forward * (20f * stats.stamina / 100f), ForceMode.Impulse);
			}
			else
			{
				forarm.rigidbody.AddForce(-player.part["chest"].forward * 30f, ForceMode.Impulse);
				hand.rigidbody.AddForce(player.part["chest"].up + player.part["chest"].forward * 20f, ForceMode.Impulse);
			}
		}
		else
		{
		}

		if (timer > 0.2f && timer < 0.4f)
		{
			hand.rigidbody.tag = "Body Part (Harmful)";
			Vector3 zero = Vector3.zero;
			float num = 0f;
			if (targeting.punchTarget != null)
			{
				zero = (targeting.punchTarget.renderer.bounds.center - hand.position).normalized;
				num = (useStamina ? (80f * stats.stamina / 100f) : 80f);
			}
			else
			{
				zero = (player.part["chest"].position + player.part["chest"].forward + player.part["chest"].up / 1.5f - hand.position).normalized;
				num = (useStamina ? (60f * stats.stamina / 100f) : 60f);
			}

			forarm.rigidbody.AddForce(-zero * (num / 4f), ForceMode.Impulse);
			arm.rigidbody.AddForce(-zero * (num / 4f), ForceMode.Impulse);
			player.part["chest"].rigidbody.AddForce(-zero * (num / 4f), ForceMode.Impulse);
			hand.rigidbody.AddForce(zero * num, ForceMode.Impulse);
		}

		if (timer >= 0.6f)
		{
			hand.rigidbody.tag = "Body Part";
			stats.stamina -= punchCost;
			if (hand.name == "leftHand")
			{
				player.leftPunch = false;
				leftTimer = 0f;
			}

			if (hand.name == "rightHand")
			{
				player.rightPunch = false;
				rightTimer = 0f;
			}
		}
	}

	private void Grab(Transform hand)
	{
		if (hand.GetComponent<HingeJoint>() == null)
		{
			if (targeting.grabTarget != null)
			{
				hand.rigidbody.AddForce((targeting.grabTarget.collider.bounds.center - hand.position).normalized * 4f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-((targeting.grabTarget.collider.bounds.center - hand.position).normalized * 4f), ForceMode.Impulse);
			}
			else
			{
				hand.rigidbody.AddForce(player.part["chest"].forward * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-(player.part["chest"].forward * 2f), ForceMode.Impulse);
			}
		}

		if (hand.GetComponent<HingeJoint>() != null)
		{
			if (hand.name == "leftHand")
			{
				if (player.leftLift && !player.rightLift)
				{
					hand.rigidbody.AddForce(Vector3.up * liftForce, ForceMode.Impulse);
					player.part["chest"].rigidbody.AddForce(-Vector3.up * liftForce, ForceMode.Impulse);
				}

				if (player.leftLift && player.rightLift)
				{
					hand.rigidbody.AddForce(Vector3.up * (liftForce * 2f), ForceMode.Impulse);
					player.part["chest"].rigidbody.AddForce(-Vector3.up * (liftForce * 2f), ForceMode.Impulse);
				}
			}

			if (hand.name == "rightHand")
			{
				if (!player.leftLift && player.rightLift)
				{
					hand.rigidbody.AddForce(Vector3.up * liftForce, ForceMode.Impulse);
					player.part["chest"].rigidbody.AddForce(-Vector3.up * liftForce, ForceMode.Impulse);
				}

				if (player.leftLift && player.rightLift)
				{
					hand.rigidbody.AddForce(Vector3.up * (liftForce * 2f), ForceMode.Impulse);
					player.part["chest"].rigidbody.AddForce(-Vector3.up * (liftForce * 2f), ForceMode.Impulse);
				}
			}
		}
	}

	private void Taunt()
	{
		if (player.taunt)
		{
			if (!player.leftPunch)
			{
				player.part["leftHand"].rigidbody.AddForce(player.part["chest"].up * 4f, ForceMode.Impulse);
				player.part["leftForarm"].rigidbody.AddForce(-player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-Vector3.up * 4f, ForceMode.Impulse);
			}
			if (!player.rightPunch)
			{
				player.part["rightHand"].rigidbody.AddForce(player.part["chest"].up * 4f, ForceMode.Impulse);
				player.part["rightForarm"].rigidbody.AddForce(player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-Vector3.up * 4f, ForceMode.Impulse);
			}
		}
	}

	private void LetGo(Transform hand)
	{
		HingeJoint[] components = hand.GetComponents<HingeJoint>();
		HingeJoint[] array = components;
		foreach (HingeJoint obj in array)
		{
			Object.Destroy(obj);
		}
	}
}
