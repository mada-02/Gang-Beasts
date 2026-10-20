#pragma strict
#pragma implicit
#pragma downcast


var guiSpeed : GUIText;
var pauseText : GUIText;
var resetText : GUIText;
var bulletPrefab : GameObject;
private var speed : float;
private var steer : float;
private var shootTimer : float;
private var pause : boolean;
private var menu : boolean;
function Update () {
	if (Input.GetKeyDown(KeyCode.Escape) && !cInput.scanning) {
		cGUI.ToggleGUI();
		pause = cGUI.showingAnyGUI;
	}
	if (!cGUI.showingAnyGUI) {
		if (cInput.GetKeyDown("Pause")) {
			pause = !pause;
		}
		if (!pause) {
			if (cInput.GetKey("Shoot") && !(Time.time <= shootTimer + 0.25)) {
				var position : Vector3 = Vector3(transform.position.x - 1, transform.position.y, transform.position.z);
				var position2 : Vector3 = Vector3(transform.position.x + 1, transform.position.y, transform.position.z);
				var gameObject : GameObject = (UnityEngine.Object.Instantiate(bulletPrefab, position, Quaternion.identity)) as GameObject;
				gameObject.tag = "Player";
				var gameObject2 : GameObject = (UnityEngine.Object.Instantiate(bulletPrefab, position2, Quaternion.identity)) as GameObject;
				gameObject2.tag = "Player";
				shootTimer = Time.time;
			}
			if (cInput.GetKey("Up")) {
				speed += 0.15;
			}
			if (cInput.GetKey("Down")) {
				speed -= 0.15;
			}
			var axis : float = cInput.GetAxis("Horizontal");
			steer = (-axis) * 45;
			transform.localEulerAngles = Vector3(transform.localEulerAngles.x, transform.localEulerAngles.y, steer);
			transform.Translate(Vector3.right * axis * 30 * Time.deltaTime);
			steer = Mathf.Clamp(steer, -45, 45);
			speed = Mathf.Clamp(speed, 5, 10.0);
			var x : float = Mathf.Clamp(transform.position.x, -24, 24.0);
			transform.position = Vector3(x, 5, transform.position.z);
			transform.Translate(Vector3.forward * speed * Time.deltaTime);
			var num : int = (speed * 10);
			guiSpeed.text = "Speed: " + num;
		}
	}
	if (pause) {
		Time.timeScale = 0.0;
		pauseText.enabled = true;
	} else {
		Time.timeScale = 1;
		pauseText.enabled = false;
	}
}

function OnDisable () {
	if (resetText) {
		resetText.enabled = true;
	}
}

