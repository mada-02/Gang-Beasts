#pragma strict


var resetText : GUIText;
function Start () {
	resetText.enabled = false;
}

function OnMouseDown () {
	Application.LoadLevel("Main (JS)");
}

