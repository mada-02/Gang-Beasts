#pragma strict
#pragma implicit
#pragma downcast


private var actor : Actor;
function Start () {
	actor = collider.transform.root.GetComponent(Actor);
}

function OnCollisionEnter (collision : Collision) {
	if (!actor.dead) {
		for (var contact : ContactPoint in collision.contacts) {
			if (contact.otherCollider.transform.root.gameObject != transform.root.gameObject) {
				var velocity : float = collision.relativeVelocity.magnitude;
				var mass : float = contact.otherCollider.rigidbody.mass;
				actor.Impact(velocity, mass, transform);
				break;
			}
		}
	}
}

function OnTriggerStay (collider : Collider) {
	if (collider.transform.root.gameObject.name == "Water") {
		actor.Impact("Water", transform);
	}
}

