#pragma strict


var timeOut : float = 1.0;
var detachChildren : boolean;
function Awake () {
	Invoke("DestroyNow", timeOut);
}

function DestroyNow () {
	if (detachChildren) {
		transform.DetachChildren();
	}
	UnityEngine.Object.DestroyObject(gameObject);
}

