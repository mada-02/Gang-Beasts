var player : int;
var movementSpeed : float = 200;
var jumpStrength : float = 300;
var maxHealth : float = 100;
var currentHealth : float = 100;
var normalColor : Color = Color.gray;
var unconscious : boolean;
var dead : boolean;
var balanced : boolean;
var debugMode : boolean;
var hurtSound : AudioClip[];
var deathSound : AudioClip[];
var hasTriggered : boolean;

@HideInInspector
var head : Transform;
@HideInInspector
var body : Transform;
@HideInInspector
var bodyUpper : Transform;
@HideInInspector
var bodyLower : Transform;
@HideInInspector
var ball : Transform;
@HideInInspector
var leftHand : Transform;
@HideInInspector
var rightHand : Transform;

private var direction : Vector3;
var onGround : boolean;
var inWater : boolean;
var waterIsCold : boolean;
var canJump : boolean = true;

function Start () {
	head = transform.Find("Head");
	body = transform.Find("Body");
	bodyUpper = transform.Find("Body Upper Collider");
	bodyLower = transform.Find("Body Lower Collider");
	ball = transform.Find("Ball");
	leftHand = transform.Find("Left Hand");
	rightHand = transform.Find("Right Hand");
	head.renderer.material.color = normalColor;
	body.renderer.material.color = normalColor;
	leftHand.renderer.material.color = normalColor;
	rightHand.renderer.material.color = normalColor;
	ball.rigidbody.maxAngularVelocity = 30;
}

function Update () {
	if (Input.GetKeyDown("1")) {
		debugMode = !debugMode;
	}
	if (Input.GetKeyDown("2")) {
		unconscious = !unconscious;
	}
	if (Input.GetKeyDown("3") || Input.GetButtonDown("Start_" + player)) {
	}
	if (player > 0 && Input.GetButtonDown("Back_" + player)) {
		Application.LoadLevel(Application.loadedLevel);
	}
}

function FixedUpdate () {
	if (player > 0 && !dead) {
		Health();
		if (!unconscious) {
			BalanceCheck();
			var healthPercent : float = currentHealth / maxHealth * 100;
			var currentSpeed : float = movementSpeed * healthPercent / 100;
			var currentJumpStrength : float = jumpStrength * healthPercent / 50;
			if (currentJumpStrength > jumpStrength) {
				currentJumpStrength = jumpStrength;
			}
			head.rigidbody.AddForce(Vector3.up * (healthPercent / 4), ForceMode.Impulse);
			bodyLower.rigidbody.AddForce(Vector3.down * (healthPercent / 4), ForceMode.Impulse);
			if (Input.GetAxis("L_XAxis_" + player) != 0 || Input.GetAxis("L_YAxis_" + player) != 0 || Input.GetAxis("Keyboard_XAxis_" + player) != 0 || Input.GetAxis("Keyboard_YAxis_" + player) != 0) {
				var x : float = Input.GetAxis("L_XAxis_" + player) + Input.GetAxis("Keyboard_XAxis_" + player);
				var z : float = Input.GetAxis("L_YAxis_" + player) + Input.GetAxis("Keyboard_YAxis_" + player);
				direction = Vector3(x, 0, z);
				if (direction.magnitude > 1.0) {
					direction = direction.normalized;
				}
				if (onGround) {
					ball.rigidbody.freezeRotation = false;
					ball.rigidbody.AddTorque(Vector3(direction.z, 0, -direction.x) * currentSpeed, ForceMode.Impulse);
				} else {
					ball.rigidbody.freezeRotation = true;
					bodyUpper.rigidbody.AddForce(direction * 2, ForceMode.Impulse);
					bodyLower.rigidbody.AddForce(direction * 2, ForceMode.Impulse);
				}
			} else {
				ball.rigidbody.freezeRotation = true;
			}
			head.rigidbody.AddForceAtPosition(direction, head.forward, ForceMode.Impulse);
			bodyUpper.rigidbody.AddForceAtPosition(direction, bodyUpper.forward, ForceMode.Impulse);
			bodyLower.rigidbody.AddForceAtPosition(direction, bodyLower.forward, ForceMode.Impulse);
			head.rigidbody.AddForceAtPosition(-direction, -head.forward, ForceMode.Impulse);
			bodyUpper.rigidbody.AddForceAtPosition(-direction, -bodyUpper.forward, ForceMode.Impulse);
			bodyLower.rigidbody.AddForceAtPosition(-direction, -bodyLower.forward, ForceMode.Impulse);
			JumpCheck(currentJumpStrength);
		}
	}
}

function JumpCheck (currentJumpStrength : float) {
	if (Input.GetButtonDown("A_" + player) && canJump) {
		if (onGround) {
			bodyUpper.rigidbody.AddForce(Vector3.up * currentJumpStrength, ForceMode.Impulse);
			onGround = false;
		} else if (inWater) {
			bodyUpper.rigidbody.AddForce(Vector3.up * (currentJumpStrength / 4), ForceMode.Impulse);
		}
		canJump = false;
		yield WaitForSeconds(0.1);
		canJump = true;
	}
}

function Impact (velocity : float, mass : float, bodyPart : Transform) {
	if (!dead && mass > 1) {
		var damage : float = velocity / 2 + mass / 2;
		if (velocity >= 20 && bodyPart == head) {
			currentHealth -= damage * 2;
			if (damage > 12) {
				Knockout(Mathf.Round(damage / 6));
			}
			bodyPart.renderer.material.color = normalColor + Color(0.25, 0.25, 0.25);
			yield WaitForSeconds(0.1);
			bodyPart.renderer.material.color = normalColor;
			MakeSound("hurt");
		} else if (velocity >= 30) {
			if (damage > 15) {
				Knockout(Mathf.Round(damage / 8));
			}
			currentHealth -= damage;
			if (bodyPart == ball || bodyPart == bodyUpper) {
				body.renderer.material.color = normalColor + Color(0.25, 0.25, 0.25);
				yield WaitForSeconds(0.1);
				body.renderer.material.color = normalColor;
			} else {
				bodyPart.renderer.material.color = normalColor + Color(0.25, 0.25, 0.25);
				yield WaitForSeconds(0.1);
				bodyPart.renderer.material.color = normalColor;
			}
			MakeSound("hurt");
		}
		if (currentHealth <= 0) {
			currentHealth = 0;
			dead = true;
			head.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
			body.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
			leftHand.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
			rightHand.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
			MakeSound("death");
		}
	}
}

function MakeSound (soundType : String) {
	if (!hasTriggered && !inWater) {
		hasTriggered = true;
		switch (soundType) {
			case "death":
				head.audio.PlayOneShot(deathSound[Random.Range(0, deathSound.Length)], 1);
				break;
			case "hurt":
				head.audio.PlayOneShot(hurtSound[Random.Range(0, hurtSound.Length)], 1);
				break;
		}
		yield WaitForSeconds(0.1);
		hasTriggered = false;
	}
}

function Impact (name : String, bodyPart : Transform) {
	if (!dead && waterIsCold) {
		if (bodyPart == ball || bodyPart == bodyUpper) {
			body.renderer.material.color = normalColor + Color(0.25, 0.25, 0.25);
			yield WaitForSeconds(0.1);
			body.renderer.material.color = normalColor;
		} else {
			bodyPart.renderer.material.color = normalColor + Color(0.25, 0.25, 0.25);
			yield WaitForSeconds(0.1);
			bodyPart.renderer.material.color = normalColor;
		}
		currentHealth -= Time.deltaTime * 10;
		MakeSound("hurt");
	}
	if (currentHealth <= 0) {
		currentHealth = 0;
		dead = true;
		head.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
		body.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
		leftHand.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
		rightHand.renderer.material.color = normalColor - Color(0.5, 0.5, 0.5);
		MakeSound("death");
	}
}

function Health () {
	currentHealth += Time.deltaTime * 40;
	if (currentHealth > maxHealth) {
		currentHealth = maxHealth;
	}
}

function Knockout (time : float) {
	if (time > 3) {
		time = 3;
	}
	unconscious = true;
	yield WaitForSeconds(time);
	unconscious = false;
}

function BalanceCheck () {
	if (balanced) {
		var up : Vector3 = Vector3.up;
		var up2 : Vector3 = Vector3.up;
		if (Vector3.Distance(up, up2) > 0.75) {
			balanced = false;
			var knockoutTime : float = Random.Range(0.5, 2.5);
			Knockout(knockoutTime);
		}
	}
	if (!balanced) {
		if (knockoutTime <= 0) {
			balanced = true;
		} else {
			knockoutTime = -Time.deltaTime;
		}
	}
}

function OnDrawGizmos () {
	if (Application.isPlaying && debugMode) {
		Gizmos.color = Color.gray;
		Gizmos.DrawSphere(head.position + direction, 0.099);
		Gizmos.DrawSphere(bodyUpper.position + direction, 0.099);
		Gizmos.DrawSphere(bodyLower.position + direction, 0.099);
		Gizmos.DrawSphere(head.position + -direction, 0.099);
		Gizmos.DrawSphere(bodyUpper.position + -direction, 0.099);
		Gizmos.DrawSphere(bodyLower.position + -direction, 0.099);
		Gizmos.color = Color.green;
		Gizmos.DrawSphere(head.position + head.forward, 0.1);
		Gizmos.DrawSphere(bodyUpper.position + bodyUpper.forward, 0.1);
		Gizmos.DrawSphere(bodyLower.position + bodyLower.forward, 0.1);
		Gizmos.color = Color.red;
		Gizmos.DrawSphere(head.position + -head.forward, 0.1);
		Gizmos.DrawSphere(bodyUpper.position + -bodyUpper.forward, 0.1);
		Gizmos.DrawSphere(bodyLower.position + -bodyLower.forward, 0.1);
	}
}
