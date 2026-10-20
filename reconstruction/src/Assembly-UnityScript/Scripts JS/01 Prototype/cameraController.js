#pragma strict
#pragma implicit
#pragma downcast


private var head : GameObject;
private var bodyUpper : GameObject;
private var bodyLower : GameObject;
private var smooth : float = 10.0;
private var targetLocation : Vector3;
function Start () {
	head = GameObject.Find("head");
	bodyUpper = GameObject.Find("body_upper");
	bodyLower = GameObject.Find("body_lower");
}

function LateUpdate () {
	targetLocation = (head.transform.position + bodyUpper.transform.position + bodyLower.transform.position) / 3;
	var num : float = Vector3.Distance(head.transform.position, bodyUpper.transform.position);
	if (!(Vector3.Distance(head.transform.position, bodyLower.transform.position) <= num)) {
		num = Vector3.Distance(head.transform.position, bodyLower.transform.position);
	}
	if (!(Vector3.Distance(bodyUpper.transform.position, bodyLower.transform.position) <= num)) {
		num = Vector3.Distance(bodyUpper.transform.position, bodyLower.transform.position);
	}
	var position : Vector3 = Vector3.Lerp(transform.position, targetLocation + Vector3(0.0, num / 50 + 2.5, (-num) / 50 - 5), Time.deltaTime * smooth);
	transform.LookAt(targetLocation);
	transform.position = position;
	if (Input.GetKeyDown("r")) {
		Application.LoadLevel(Application.loadedLevel);
	}
}

