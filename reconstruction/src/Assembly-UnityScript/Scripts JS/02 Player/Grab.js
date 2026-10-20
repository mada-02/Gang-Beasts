#pragma strict


private var actor : Actor;
var player : int;
private var unconscious : boolean;
var grabbing : boolean;
var holdingSomething : boolean;
var debugMode : boolean;
function Start () {
	actor = collider.transform.root.GetComponent(Actor);
	player = actor.player;
}

function Update () {
	if (Input.GetKeyDown("1")) {
		debugMode = !debugMode;
	}
}

function FixedUpdate () {
	if (transform.name == "Left Hand") {
		if (Input.GetButton("X_" + player) || Input.GetButton("LB_" + player)) {
			if (!actor.unconscious || !actor.dead) {
				grabbing = true;
			}
			transform.rigidbody.AddForce(actor.bodyUpper.forward * 2, ForceMode.Impulse);
			actor.bodyUpper.rigidbody.AddForce(-actor.bodyUpper.forward * 2, ForceMode.Impulse);
		} else {
			grabbing = false;
			holdingSomething = false;
			UnityEngine.Object.Destroy(GetComponent(HingeJoint));
		}
		if (actor.unconscious || actor.dead) {
			grabbing = false;
			holdingSomething = false;
			UnityEngine.Object.Destroy(GetComponent(HingeJoint));
		}
	}
	if (transform.name == "Right Hand") {
		if (Input.GetButton("B_" + player) || Input.GetButton("RB_" + player)) {
			if (!actor.unconscious || !actor.dead) {
				grabbing = true;
			}
			transform.rigidbody.AddForce(actor.bodyUpper.forward * 2, ForceMode.Impulse);
			actor.bodyUpper.rigidbody.AddForce(-actor.bodyUpper.forward * 2, ForceMode.Impulse);
		} else {
			grabbing = false;
			holdingSomething = false;
			UnityEngine.Object.Destroy(GetComponent(HingeJoint));
		}
		if (actor.unconscious || actor.dead) {
			grabbing = false;
			holdingSomething = false;
			UnityEngine.Object.Destroy(GetComponent(HingeJoint));
		}
	}
}

function OnCollisionEnter (collision : Collision) {
	for (var item : ContactPoint in collision.contacts) {
		if (item.otherCollider.transform.root != item.otherCollider.transform) {
			if (item.otherCollider.transform.parent.gameObject != transform.parent.gameObject && grabbing && !holdingSomething) {
				holdingSomething = true;
				var hingeJoint : HingeJoint = gameObject.AddComponent(HingeJoint);
				hingeJoint.connectedBody = collision.rigidbody;
			}
		} else if (item.otherCollider.transform != transform.parent.gameObject && grabbing && !holdingSomething) {
			holdingSomething = true;
			hingeJoint = gameObject.AddComponent(HingeJoint);
			hingeJoint.connectedBody = collision.rigidbody;
		}
	}
}

function OnDrawGizmos () {
	if (Application.isPlaying && debugMode) {
		if (holdingSomething) {
			Gizmos.color = Color.green;
		} else if (grabbing) {
			Gizmos.color = Color.red;
		} else {
			Gizmos.color = Color.gray;
		}
		Gizmos.DrawSphere(transform.position, 0.2);
	}
}

