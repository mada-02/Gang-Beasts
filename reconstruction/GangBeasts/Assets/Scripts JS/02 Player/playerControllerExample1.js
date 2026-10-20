#pragma strict
#pragma implicit
#pragma downcast


private var targetHeightHead : float;
private var targetHeightBodyUpper : float;
private var targetHeightBodyLower : float;
private var head : Transform;
private var bodyUpper : Transform;
private var bodyLower : Transform;
private var leftArmUpper : Transform;
private var leftArmLower : Transform;
private var leftHand : Transform;
private var rightArmUpper : Transform;
private var rightArmLower : Transform;
private var rightHand : Transform;
private var leftLegUpper : Transform;
private var leftLegLower : Transform;
private var leftFoot : Transform;
private var leftToe : Transform;
private var rightLegUpper : Transform;
private var rightLegLower : Transform;
private var rightFoot : Transform;
private var rightToe : Transform;
private var forwardDirection : Vector3;
private var targetDirection : Vector3;
private var walkCycleTimer : float;
private var leftLimbPosition : int;
private var rightLimbPosition : int = 2;
private var onGround : boolean;
@HideInInspector
var detachedHead : boolean;
@HideInInspector
var detachedBodyUpper : boolean;
@HideInInspector
var detachedLeftLeg : boolean;
@HideInInspector
var detachedRightLeg : boolean;
function Start () {
	head = transform.Find("head");
	bodyUpper = transform.Find("body_upper");
	bodyLower = transform.Find("body_lower");
	leftArmUpper = transform.Find("left_arm_upper");
	leftArmLower = transform.Find("left_arm_lower");
	leftHand = transform.Find("left_hand");
	rightArmUpper = transform.Find("right_arm_upper");
	rightArmLower = transform.Find("right_arm_lower");
	rightHand = transform.Find("right_hand");
	leftLegUpper = transform.Find("left_leg_upper");
	leftLegLower = transform.Find("left_leg_lower");
	leftFoot = transform.Find("left_foot");
	leftToe = transform.Find("left_toe");
	rightLegUpper = transform.Find("right_leg_upper");
	rightLegLower = transform.Find("right_leg_lower");
	rightFoot = transform.Find("right_foot");
	rightToe = transform.Find("right_toe");
	targetHeightHead = Vector3.Distance(transform.position, head.position);
	targetHeightBodyUpper = Vector3.Distance(transform.position, bodyUpper.position);
	targetHeightBodyLower = Vector3.Distance(transform.position, bodyLower.position);
}

function FixedUpdate () {
	if (!detachedLeftLeg || !detachedRightLeg) {
		Stand(bodyLower, targetHeightBodyLower);
		if (!detachedBodyUpper) {
			Stand(bodyUpper, targetHeightBodyUpper);
			if (!detachedHead) {
				Stand(head, targetHeightHead);
			}
		}
	}
	if ((Input.GetAxis("Horizontal") != 0.0 && onGround) || (Input.GetAxis("Vertical") != 0.0 && onGround)) {
		targetDirection = Vector3(Input.GetAxis("Horizontal"), 0.0, Input.GetAxis("Vertical"));
		targetDirection *= 1000;
		forwardDirection = head.transform.forward;
		head.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		head.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		forwardDirection = bodyUpper.transform.forward;
		bodyUpper.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		bodyUpper.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		forwardDirection = bodyLower.transform.forward;
		bodyLower.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		bodyLower.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		if (!detachedBodyUpper) {
			bodyUpper.rigidbody.AddRelativeForce(Vector3(0.0, 0.0, 5), ForceMode.Impulse);
			bodyLower.rigidbody.AddRelativeForce(Vector3(0.0, 0.0, -5), ForceMode.Impulse);
		}
		if (!(walkCycleTimer <= 0.0)) {
			walkCycleTimer -= Time.deltaTime;
		} else {
			walkCycleTimer = 0.2;
			leftLimbPosition++;
			rightLimbPosition++;
		}
		if (leftLimbPosition >= 4) {
			leftLimbPosition = 0;
		}
		if (rightLimbPosition >= 4) {
			rightLimbPosition = 0;
		}
		MoveLimbs(leftArmUpper, leftArmLower, leftLegUpper, leftLegLower, leftFoot, leftToe, leftLimbPosition);
		MoveLimbs(rightArmUpper, rightArmLower, rightLegUpper, rightLegLower, rightFoot, rightToe, rightLimbPosition);
	} else {
		forwardDirection = head.transform.forward;
		head.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		head.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		forwardDirection = bodyUpper.transform.forward;
		bodyUpper.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		bodyUpper.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		forwardDirection = bodyLower.transform.forward;
		bodyLower.rigidbody.AddForceAtPosition(targetDirection, forwardDirection, ForceMode.Impulse);
		bodyLower.rigidbody.AddForceAtPosition(-targetDirection, -forwardDirection, ForceMode.Impulse);
		if (!detachedHead && !detachedBodyUpper) {
			head.rigidbody.AddForce(Vector3.up * 2, ForceMode.Impulse);
			bodyLower.rigidbody.AddForce(Vector3.down * 2, ForceMode.Impulse);
		}
		if (!detachedLeftLeg && onGround) {
			leftLegUpper.rigidbody.AddForce(Vector3.up * 2, ForceMode.Impulse);
			leftFoot.rigidbody.AddForce(Vector3.down * 4, ForceMode.Impulse);
		}
		if (!detachedRightLeg && onGround) {
			rightLegUpper.rigidbody.AddForce(Vector3.up * 2, ForceMode.Impulse);
			rightFoot.rigidbody.AddForce(Vector3.down * 4, ForceMode.Impulse);
		}
	}
	if (Input.GetButtonDown("Jump") && (!detachedLeftLeg || !detachedRightLeg)) {
		Jump(bodyLower, targetHeightBodyLower);
		if (!detachedBodyUpper) {
			Jump(bodyUpper, targetHeightBodyUpper);
			if (!detachedHead) {
				Jump(head, targetHeightHead);
			}
		}
	}
	if (!onGround) {
		if (!detachedBodyUpper) {
			if (Input.GetAxis("Horizontal") != 0.0 || Input.GetAxis("Vertical") != 0.0) {
				targetDirection = Vector3(Input.GetAxis("Horizontal"), 0.0, Input.GetAxis("Vertical"));
			}
			bodyUpper.rigidbody.AddForce(targetDirection * 2, ForceMode.Impulse);
		}
		if (!detachedLeftLeg) {
			leftLegLower.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			leftLegUpper.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			leftFoot.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
		}
		if (!detachedRightLeg) {
			rightLegLower.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			rightLegUpper.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			rightFoot.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
		}
	}
}

function Stand (targetPart : Transform, targetHeight : float) {
	var hitInfo : RaycastHit;
	if (Physics.Raycast(targetPart.position, Vector3.down, hitInfo)) {
		if (!(hitInfo.distance >= targetHeight) && !(hitInfo.distance <= 0.0)) {
			targetPart.rigidbody.AddForce(Vector3.up * 10, ForceMode.Impulse);
			onGround = true;
		} else if (!(hitInfo.distance <= targetHeight + 0.1)) {
			onGround = false;
		}
	}
}

function Jump (targetPart : Transform, targetHeight : float) {
	var hitInfo : RaycastHit;
	if (Physics.Raycast(targetPart.position, Vector3.down, hitInfo) && !(hitInfo.distance >= targetHeight + 0.2) && !(hitInfo.distance <= 0.0)) {
		targetPart.rigidbody.AddForce(Vector3.up * 80, ForceMode.Impulse);
	}
}

function MoveLimbs (armUpper : Transform, armLower : Transform, legUpper : Transform, legLower : Transform, foot : Transform, toe : Transform, walkCyclePosition : int) {
	switch (walkCyclePosition) {
		case 0:
			legUpper.rigidbody.AddRelativeTorque(Vector3(-4, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeTorque(Vector3(4, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeForce(Vector3(0.0, 4, 0.0), ForceMode.Impulse);
			foot.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			toe.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			if (armUpper.name == "left_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(1, -1, -1), ForceMode.Impulse);
			}
			if (armUpper.name == "right_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(1, 1, 1), ForceMode.Impulse);
			}
			armLower.rigidbody.AddRelativeTorque(Vector3(4, 0.0, 0.0), ForceMode.Impulse);
			break;
		case 1:
			legUpper.rigidbody.AddRelativeTorque(Vector3(-4, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeTorque(Vector3(-4, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddForce(Vector3(0.0, 1, 0.0), ForceMode.Impulse);
			foot.rigidbody.AddRelativeTorque(-Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			toe.rigidbody.AddRelativeTorque(-Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			if (armUpper.name == "left_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(1, -1, -1), ForceMode.Impulse);
			}
			if (armUpper.name == "right_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(1, 1, 1), ForceMode.Impulse);
			}
			armLower.rigidbody.AddRelativeTorque(Vector3(4, 0.0, 0.0), ForceMode.Impulse);
			break;
		case 2:
			legUpper.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeForce(Vector3(0.0, -1, 0.0), ForceMode.Impulse);
			foot.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			toe.rigidbody.AddRelativeTorque(Vector3(-1, 0.0, 0.0), ForceMode.Impulse);
			if (armUpper.name == "left_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(-1, -1, -1), ForceMode.Impulse);
			}
			if (armUpper.name == "right_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(-1, 1, 1), ForceMode.Impulse);
			}
			armLower.rigidbody.AddRelativeTorque(Vector3(-4, 0.0, 0.0), ForceMode.Impulse);
			break;
		case 3:
			legUpper.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeTorque(Vector3(1, 0.0, 0.0), ForceMode.Impulse);
			legLower.rigidbody.AddRelativeForce(Vector3(0.0, -1, 0.0), ForceMode.Impulse);
			foot.rigidbody.AddRelativeTorque(Vector3(4, 0.0, 0.0), ForceMode.Impulse);
			toe.rigidbody.AddRelativeTorque(Vector3(4, 0.0, 0.0), ForceMode.Impulse);
			if (armUpper.name == "left_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(-1, -1, -1), ForceMode.Impulse);
			}
			if (armUpper.name == "right_arm_upper") {
				armUpper.rigidbody.AddRelativeTorque(Vector3(-1, 1, 1), ForceMode.Impulse);
			}
			armLower.rigidbody.AddRelativeTorque(Vector3(-4, 0.0, 0.0), ForceMode.Impulse);
			break;
	}
}

