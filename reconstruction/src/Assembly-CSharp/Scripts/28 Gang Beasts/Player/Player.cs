using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{
	public enum State
	{
		Standing,
		Ducking,
		Running,
		Jumping,
		Falling,
		Stunned,
		Dead
	}

	public int player;

	public string gangName = "None";

	public Color actorColor = Color.gray;

	public Vector3 direction;

	public float jumpReset;

	public bool canJump;

	public bool onGround;

	public float fallTimer;

	public float groundTimer;

	public float leftHandTimer;

	public bool leftGrab;

	public bool leftPunch;

	public bool leftLift;

	public bool leftInputDown;

	public float rightHandTimer;

	public bool rightGrab;

	public bool rightPunch;

	public bool rightLift;

	public bool rightInputDown;

	public bool taunt;

	public bool duck;

	public float force = 80f;

	public float applyedForce;

	public float punchRetriggerDelay;

	public bool mob;

	public NavMeshAgent agent;

	public Player target;

	public bool targetInRange;

	private bool handToggle;

	public bool leftLegOnGround;

	public bool rightLegOnGround;

	public bool ballOnGround;

	public bool grabNotMoveableLeft;

	public bool grabNotMoveableRight;

	public bool climb;

	public Dictionary<string, Transform> part = new Dictionary<string, Transform>();

	public State state;

	private void Awake()
	{
		applyedForce = force;
		renderer.material.color = actorColor;
		tag = "Player";
		transform.name = "Player " + player;
		part["head"] = transform.Find("hips/chest/head");
		part["chest"] = transform.Find("hips/chest");
		part["hips"] = transform.Find("hips");
		part["stomach"] = transform.Find("hips/stomach");
		part["groin"] = transform.Find("hips/groin");
		part["leftArm"] = transform.Find("hips/chest/leftArm");
		part["leftForarm"] = transform.Find("hips/chest/leftArm/leftForarm");
		part["leftHand"] = transform.Find("hips/chest/leftArm/leftForarm/leftHand");
		part["leftThigh"] = transform.Find("hips/leftThigh");
		part["leftLeg"] = transform.Find("hips/leftThigh/leftLeg");
		part["rightArm"] = transform.Find("hips/chest/rightArm");
		part["rightForarm"] = transform.Find("hips/chest/rightArm/rightForarm");
		part["rightHand"] = transform.Find("hips/chest/rightArm/rightForarm/rightHand");
		part["rightThigh"] = transform.Find("hips/rightThigh");
		part["rightLeg"] = transform.Find("hips/rightThigh/rightLeg");
		part["ball"] = transform.Find("hips/ball");
		part["targetFinder"] = transform.Find("hips/chest/targetFinder");
		foreach (KeyValuePair<string, Transform> item in part)
		{
			if ((bool)item.Value.rigidbody)
			{
				item.Value.parent = transform;
				item.Value.rigidbody.isKinematic = false;
			}
		}
		CapsuleCollider[] components = part["chest"].GetComponents<CapsuleCollider>();
		CapsuleCollider[] components2 = part["stomach"].GetComponents<CapsuleCollider>();
		CapsuleCollider[] array = components;
		foreach (CapsuleCollider collider in array)
		{
			CapsuleCollider[] array2 = components2;
			foreach (CapsuleCollider capsuleCollider in array2)
			{
				Physics.IgnoreCollision(collider, capsuleCollider);
				Physics.IgnoreCollision(capsuleCollider, part["hips"].collider);
				Physics.IgnoreCollision(capsuleCollider, part["groin"].collider);
				Physics.IgnoreCollision(capsuleCollider, part["leftThigh"].collider);
				Physics.IgnoreCollision(capsuleCollider, part["rightThigh"].collider);
			}
			Physics.IgnoreCollision(collider, part["leftArm"].collider);
			Physics.IgnoreCollision(collider, part["rightArm"].collider);
			Physics.IgnoreCollision(collider, part["hips"].collider);
			Physics.IgnoreCollision(collider, part["groin"].collider);
		}
		agent = transform.Find("agent").GetComponent<NavMeshAgent>();
	}

	private void Start()
	{
		GameObject gameObject = GameObject.FindWithTag("Scene Manager");
		SceneManager component = gameObject.GetComponent<SceneManager>();
		if (!mob)
		{
			if (player < component.totalPlayers)
			{
				if (component.score[player] <= 0)
				{
					Object.Destroy(base.gameObject);
				}

				component.guiTextColor[player] = new Color(actorColor.r, actorColor.g, actorColor.b, 0.8f);
			}
			else
			{
				Object.Destroy(base.gameObject);
			}
		}
	}

	private void Update()
	{
		if (state != State.Stunned && state != State.Dead)
		{
			if (mob)
			{
				FindClosestTarget();
				if (target != null)
				{
					if (Vector3.Distance(target.part["chest"].position, part["chest"].position) > 1f)
					{
						targetInRange = false;
					}
					if (Vector3.Angle(target.part["chest"].position - part["chest"].position, part["chest"].forward) > 90f)
					{
						targetInRange = false;
					}
					if (Vector3.Distance(target.part["chest"].position, part["chest"].position) < 0.5f)
					{
						targetInRange = false;
					}
				}
			}
			MovementInput();
			DuckInput();
			JumpInput();
			LeftHandInput();
			RightHandInput();
			TauntInput();
			ClimbInput();
			if (!leftLegOnGround && !rightLegOnGround && !ballOnGround)
			{
				if (groundTimer < 0.5f)
				{
					groundTimer += Time.deltaTime;
				}
				if (groundTimer > 0.5f)
				{
					onGround = false;
					if (state != State.Jumping)
					{
						state = State.Falling;
					}
				}
			}
			if (leftLegOnGround || rightLegOnGround || ballOnGround)
			{
				onGround = true;
				groundTimer = 0f;
				if (state == State.Falling)
				{
					state = State.Standing;
				}
			}
		}
		else
		{
			leftGrab = false;
			rightGrab = false;
			leftLift = false;
			rightLift = false;
			leftPunch = false;
			rightPunch = false;
			taunt = false;
			leftHandTimer = 0f;
			part["leftHand"].tag = "Body Part";
			rightHandTimer = 0f;
			part["rightHand"].tag = "Body Part";
			canJump = true;
			jumpReset = 0f;
		}
		if (state == State.Dead)
		{
			tag = "Untagged";
		}
		if (state == State.Dead || state == State.Stunned || state == State.Falling)
		{
			if (applyedForce > 0f)
			{
				applyedForce -= Time.deltaTime * (force / 2f);
			}
			if (applyedForce < 0f)
			{
				applyedForce = 0f;
			}
		}
		else
		{
			if (applyedForce < force)
			{
				applyedForce += Time.deltaTime * (force / 6f);
			}
			if (applyedForce > force)
			{
				applyedForce = force;
			}
		}
		if (punchRetriggerDelay > 0f)
		{
			punchRetriggerDelay -= Time.deltaTime;
		}
	}

	private void LeftHandInput()
	{
		if (!mob)
		{
			if (cInput.GetButton("P" + (player + 1) + " Left Punch & Grab"))
			{
				leftInputDown = true;
				if (leftHandTimer > 0.2f)
				{
					leftGrab = true;
				}
				leftHandTimer += Time.deltaTime;
				if (cInput.GetButton("P" + (player + 1) + " Action"))
				{
					leftLift = true;
				}
				else
				{
					leftLift = false;
				}
			}
			if (cInput.GetButtonUp("P" + (player + 1) + " Left Punch & Grab"))
			{
				leftInputDown = false;
				if (leftHandTimer <= 0.2f && punchRetriggerDelay <= 0f)
				{
					punchRetriggerDelay = 0.05f;
					leftPunch = true;
				}
				leftGrab = false;
				leftLift = false;
				leftHandTimer = 0f;
			}
		}
		else if (targetInRange && punchRetriggerDelay <= 0f)
		{
			handToggle = !handToggle;
			punchRetriggerDelay = 0.05f + Random.Range(0f, 0.5f);
			if (handToggle)
			{
				rightPunch = true;
			}
			if (!handToggle)
			{
				leftPunch = true;
			}
		}
	}

	private void RightHandInput()
	{
		if (!mob)
		{
			if (cInput.GetButton("P" + (player + 1) + " Right Punch & Grab"))
			{
				rightInputDown = true;
				if (rightHandTimer > 0.2f)
				{
					rightGrab = true;
				}
				rightHandTimer += Time.deltaTime;
				if (cInput.GetButton("P" + (player + 1) + " Action"))
				{
					rightLift = true;
				}
				else
				{
					rightLift = false;
				}
			}
			if (cInput.GetButtonUp("P" + (player + 1) + " Right Punch & Grab"))
			{
				rightInputDown = false;
				if (rightHandTimer <= 0.2f && punchRetriggerDelay <= 0f)
				{
					punchRetriggerDelay = 0.05f;
					rightPunch = true;
				}
				rightGrab = false;
				rightLift = false;
				rightHandTimer = 0f;
			}
		}
		else if (targetInRange && punchRetriggerDelay <= 0f)
		{
			handToggle = !handToggle;
			punchRetriggerDelay = 0.05f + Random.Range(0f, 0.5f);
			if (handToggle)
			{
				rightPunch = true;
			}
			if (!handToggle)
			{
				leftPunch = true;
			}
		}
	}

	private void MovementInput()
	{
		direction = Vector3.zero;
		if (!mob)
		{
			if (cInput.GetAxis("P" + (player + 1) + " Vertical") != 0f || cInput.GetAxis("P" + (player + 1) + " Horizontal") != 0f)
			{
				Vector3 vector = Camera.main.transform.TransformDirection(Vector3.forward);
				vector.y = 0f;
				vector = vector.normalized;
				Vector3 vector2 = new Vector3(vector.z, 0f, -vector.x);
				float num = 0f;
				float num2 = 0f;
				num = cInput.GetAxis("P" + (player + 1) + " Vertical");
				num2 = cInput.GetAxis("P" + (player + 1) + " Horizontal");
				direction = num2 * vector2 + num * vector;
				if (direction.sqrMagnitude > 1f)
				{
					direction = direction.normalized;
				}
			}
		}
		else
		{
			float num3 = Vector3.Distance(part["chest"].position, agent.transform.position);
			if (num3 > 0.5f)
			{
				direction = agent.transform.position - part["chest"].position;
				if (direction.sqrMagnitude > 1f)
				{
					direction = direction.normalized;
				}
			}
		}
	}

	private void DuckInput()
	{
		if (!mob && cInput.GetButton("P" + (player + 1) + " Duck"))
		{
			duck = true;
		}
		else
		{
			duck = false;
		}
	}

	private void TauntInput()
	{
		if (!mob && cInput.GetButton("P" + (player + 1) + " Gesture"))
		{
			taunt = true;
		}
		else if (mob && target != null)
		{
			if (target.state == State.Dead)
			{
				taunt = true;
			}
		}
		else
		{
			taunt = false;
		}
	}

	private void JumpInput()
	{
		if (jumpReset <= 0f && !mob)
		{
			if (cInput.GetButton("P" + (player + 1) + " Jump") && canJump && (state == State.Standing || state == State.Running))
			{
				jumpReset = 0.2f;
				canJump = false;
				state = State.Jumping;
			}
			if (!cInput.GetButton("P" + (player + 1) + " Jump"))
			{
				canJump = true;
			}
		}
		if (jumpReset > 0f)
		{
			jumpReset -= Time.deltaTime;
		}
	}

	private void ClimbInput()
	{
		if (!mob)
		{
			if (cInput.GetButton("P" + (player + 1) + " Jump"))
			{
				climb = true;
			}
			else
			{
				climb = false;
			}
		}
	}

	private void FindClosestTarget()
	{
		GameObject[] array = GameObject.FindGameObjectsWithTag("Player");
		float num = float.PositiveInfinity;
		for (int i = 0; i < array.Length; i++)
		{
			Player component = array[i].GetComponent<Player>();
			if (!(!(component.gangName != gangName) || component.state == State.Dead || component.state == State.Stunned))
			{
				float num2 = Vector3.Distance(component.part["chest"].position, part["chest"].position);
				float num3 = Vector3.Angle(component.part["chest"].position - part["chest"].position, part["chest"].forward);
				if (num2 < num && num2 < 10f && num3 < 90f && array[i].transform.root != transform.root)
				{
					num = num2;
					target = component;
					if (num2 < 1.5f)
					{
						targetInRange = true;
					}
					else
					{
						targetInRange = false;
					}

					if (Vector3.Distance(agent.transform.position, part["chest"].position) < 2f)
					{
						agent.SetDestination(target.part["chest"].position);
					}
					else
					{
						agent.SetDestination(part["chest"].position);
					}
				}
			}
		}
	}
}
