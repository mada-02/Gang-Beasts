#pragma strict


var bulletPrefab : GameObject;
var playerTransform : Transform;
private var bulletTimer : float;
private var _mesh : Transform;
private var _turret : Transform;
function Start () {
	_mesh = transform.FindChild("Mesh");
	_turret = transform.FindChild("Turret");
}

function Update () {
	if (!_mesh.renderer.isVisible) {
		bulletTimer = Time.time - 1;
	}
	transform.Translate(Vector3.forward * 5.0 * Time.deltaTime);
	if (playerTransform && _mesh.renderer.isVisible && !(Time.time <= bulletTimer + 1.5)) {
		var gameObject : GameObject = (UnityEngine.Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity)) as GameObject;
		gameObject.transform.LookAt(playerTransform);
		gameObject.tag = "Enemy";
		bulletTimer = Time.time;
	}
}

