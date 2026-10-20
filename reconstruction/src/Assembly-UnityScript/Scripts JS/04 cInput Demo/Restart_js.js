#pragma strict
#pragma implicit
#pragma downcast


var resetText : GUIText;
function Start () {
	resetText.enabled = false;
}

function OnMouseDown () {
	Application.LoadLevel("Main (JS)");
}

