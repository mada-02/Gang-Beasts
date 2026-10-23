using UnityEngine;

// 0.0.2's PunchAndGrab (decompiled from the shipped 0.0.2 build), run in Hard Mode instead of 0.0.3's. Only
// the class name differs from the original (see dev/hardmode/code_diff.md G1-G5).

public class PunchAndGrab002 : MonoBehaviour
{
	private Player player;

	private Targeting targeting;

	private float leftTimer;

	private float rightTimer;

	public float liftForce = 20f;

	private void Start()
	{
		player = gameObject.GetComponent<Player>();
		targeting = player.part["targetFinder"].GetComponent<Targeting>();
	}

	private void FixedUpdate()
	{
		if (player.leftGrab)
		{
			Grab(player.part["leftHand"]);
		}
		if (player.rightGrab)
		{
			Grab(player.part["rightHand"]);
		}
		if (!player.leftGrab)
		{
			LetGo(player.part["leftHand"]);
		}
		if (!player.rightGrab)
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
			forarm.rigidbody.AddForce(-player.part["chest"].forward * 30f, ForceMode.Impulse);
			hand.rigidbody.AddForce(player.part["chest"].up + player.part["chest"].forward * 20f, ForceMode.Impulse);
		}
		if (timer > 0.2f && timer < 0.4f)
		{
			hand.rigidbody.tag = "Body Part (Harmful)";
			Vector3 zero = Vector3.zero;
			zero = ((!(targeting.punchTarget != null)) ? (player.part["chest"].position + player.part["chest"].forward + player.part["chest"].up / 2f - hand.position).normalized : (targeting.punchTarget.renderer.bounds.center - hand.position).normalized);
			forarm.rigidbody.AddForce(-zero * 30f, ForceMode.Impulse);
			arm.rigidbody.AddForce(-zero * 30f, ForceMode.Impulse);
			hand.rigidbody.AddForce(zero * 80f, ForceMode.Impulse);
		}
		if (timer >= 0.6f)
		{
			hand.rigidbody.tag = "Body Part";
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
				hand.rigidbody.AddForce((targeting.grabTarget.renderer.bounds.center - hand.position).normalized * 4f, ForceMode.Impulse);
			}
			else
			{
				hand.rigidbody.AddForce(player.part["chest"].forward * 2f, ForceMode.Impulse);
			}
		}
		if (!(hand.GetComponent<HingeJoint>() != null))
		{
			return;
		}
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

	private void Taunt()
	{
		if (player.taunt)
		{
			if (!player.leftPunch && !player.leftGrab)
			{
				player.part["leftHand"].rigidbody.AddForce(player.part["chest"].up * 4f, ForceMode.Impulse);
				player.part["leftForarm"].rigidbody.AddForce(-player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-Vector3.up * 2f, ForceMode.Impulse);
			}
			if (!player.rightPunch && !player.rightGrab)
			{
				player.part["rightHand"].rigidbody.AddForce(player.part["chest"].up * 4f, ForceMode.Impulse);
				player.part["rightForarm"].rigidbody.AddForce(player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-player.part["chest"].right * 2f, ForceMode.Impulse);
				player.part["chest"].rigidbody.AddForce(-Vector3.up * 2f, ForceMode.Impulse);
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
