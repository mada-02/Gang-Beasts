#pragma strict


private var player : playerControllerExample;
function Start () {
	player = collider.transform.root.GetComponent(playerControllerExample);
}

function OnJointBreak () {
	switch (transform.name) {
	case "head":
		player.detachedHead = true;
		break;
	case "body_middle":
		player.detachedBodyUpper = true;
		break;
	case "body_lower":
		player.detachedBodyUpper = true;
		break;
	case "left_leg_upper":
		player.detachedLeftLeg = true;
		break;
	case "left_leg_lower":
		player.detachedLeftLeg = true;
		break;
	case "left_foot":
		player.detachedLeftLeg = true;
		break;
	case "right_leg_upper":
		player.detachedRightLeg = true;
		break;
	case "right_leg_lower":
		player.detachedRightLeg = true;
		break;
	case "right_foot":
		player.detachedRightLeg = true;
		break;
	}
}

