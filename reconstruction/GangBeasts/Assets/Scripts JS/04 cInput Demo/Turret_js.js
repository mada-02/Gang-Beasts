#pragma strict
#pragma implicit
#pragma downcast


var rocketPrefab : GameObject;
var shootPoint : Transform;
var target : Transform;
private var damping : float = 20;
private var shootDelay : float = 3;
private var shootTime : float;
function Start () {
	shootDelay = UnityEngine.Random.Range(3, 7);
	shootTime = shootDelay;
}

function Update () {
	if (target && transform.FindChild("Box10").renderer.isVisible) {
		var to : Quaternion = Quaternion.LookRotation(target.position - transform.position);
		transform.rotation = Quaternion.Slerp(transform.rotation, to, Time.deltaTime * damping);
		transform.eulerAngles = Vector3(0.0, transform.eulerAngles.y, 0.0);
		if (!(Time.time <= shootTime)) {
			Shoot();
			shootTime = Time.time + shootDelay;
		}
	}
}

function Shoot () {
	var gameObject : GameObject = UnityEngine.Object.Instantiate(rocketPrefab, shootPoint.position, Quaternion.identity);
	gameObject.transform.LookAt(target);
	gameObject.tag = "Enemy";
}

