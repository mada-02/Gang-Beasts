#pragma strict


var testA : int = 1;
var testB : int = 1;
function Start () {
}

function Update () {
	if ((testA == 1 && testB == 0) || (testA == 1 && testB == 2)) {
		MonoBehaviour.print("true");
	}
}

