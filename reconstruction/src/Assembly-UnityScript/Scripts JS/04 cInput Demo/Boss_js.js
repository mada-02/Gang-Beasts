#pragma strict


var bulletPrefab : GameObject;
var renderedMesh : Renderer;
var playerTransform : Transform;
private var bulletTimer : float;
function Start () {
	if (renderer) {
		renderedMesh = renderer;
	}
}

function Update () {
	if (!renderedMesh) {
		UnityEngine.Object.Destroy(this.gameObject);
		return;
	}
	transform.Translate(Vector3.forward * 5.0 * Time.deltaTime);
	if (playerTransform && renderedMesh.isVisible && !(Time.time <= bulletTimer + 1.5)) {
		var gameObject : GameObject = (UnityEngine.Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity)) as GameObject;
		gameObject.transform.LookAt(playerTransform);
		gameObject.tag = "Enemy";
		gameObject = (UnityEngine.Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity)) as GameObject;
		var worldPosition : Vector3 = Vector3(playerTransform.position.x - 10, playerTransform.position.y, playerTransform.position.z);
		gameObject.transform.LookAt(worldPosition);
		gameObject.tag = "Enemy";
		gameObject = (UnityEngine.Object.Instantiate(bulletPrefab, transform.position, Quaternion.identity)) as GameObject;
		worldPosition = Vector3(playerTransform.position.x + 10, playerTransform.position.y, playerTransform.position.z);
		gameObject.transform.LookAt(worldPosition);
		gameObject.tag = "Enemy";
		bulletTimer = Time.time;
	}
}

