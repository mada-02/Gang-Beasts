#pragma strict
#pragma implicit
#pragma downcast


var sceneGroups : Group[];
function NewGroup (theObjects : GameObject[], newGroupName : String) {
	var obj : Group = Group();
	obj.name = newGroupName;
	obj.objects = theObjects;
	obj.frozen = false;
	obj.hidden = false;
	if (sceneGroups != null) {
		var array : UnityScript.Lang.Array = new Array(sceneGroups);
		array.Add(obj);
		sceneGroups = array.ToBuiltin(Group);
	} else {
		sceneGroups = new Group[1];
		sceneGroups[0] = obj;
	}
}

function ToggleFreeze (theGroup : Group) {
	CleanGroup(theGroup);
	theGroup.frozen = !theGroup.frozen;
	for (var obj2 : GameObject in theGroup.objects) {
		if (theGroup.frozen) {
			obj2.hideFlags = HideFlags.NotEditable;
		} else if (!theGroup.hidden) {
			obj2.hideFlags = HideFlags.None;
		}
	}
}

function ToggleVis (theGroup : Group) {
	if (theGroup.hidden) {
		ShowGroup(theGroup);
	} else {
		HideGroup(theGroup);
	}
}

function HideGroup (theGroup : Group) {
	CleanGroup(theGroup);
	for (var obj3 : GameObject in theGroup.objects) {
		obj3.hideFlags = HideFlags.NotEditable;
		obj3.SetActive(false);
	}
	theGroup.hidden = true;
}

function ShowGroup (theGroup : Group) {
	CleanGroup(theGroup);
	for (var obj4 : GameObject in theGroup.objects) {
		if (!theGroup.frozen) {
			obj4.hideFlags = HideFlags.None;
		}
		obj4.SetActive(true);
	}
	theGroup.hidden = false;
}

function Isolate (i : int) {
	for (var j : int = 0; j < sceneGroups.length; j++) {
		if (j != i) {
			HideGroup(sceneGroups[j]);
		}
	}
	ShowGroup(sceneGroups[i]);
}

function RemoveGroup (i : int) {
	CleanGroup(sceneGroups[i]);
	for (var obj5 : GameObject in sceneGroups[i].objects) {
		obj5.SetActive(true);
		obj5.hideFlags = HideFlags.None;
	}
	var array : UnityScript.Lang.Array = new Array(sceneGroups);
	array.RemoveAt(i);
	sceneGroups = array.ToBuiltin(Group);
}

function UpdateGroup (theGroup : Group, objects : GameObject[]) {
	CleanGroup(theGroup);
	for (var obj6 : GameObject in theGroup.objects) {
		obj6.SetActive(true);
		obj6.hideFlags = HideFlags.None;
	}
	theGroup.objects = objects;
	theGroup.hidden = false;
	theGroup.frozen = false;
}

function MoveGroupUp (shiftIndex : int) {
	var array : UnityScript.Lang.Array = UnityScript.Lang.Array();
	for (var i : int = 0; i < shiftIndex - 1; i++) {
		array.Add(sceneGroups[i]);
	}
	array.Add(sceneGroups[shiftIndex]);
	for (var j : int = shiftIndex - 1; j < sceneGroups.length; j++) {
		if (j != shiftIndex) {
			array.Add(sceneGroups[j]);
		}
	}
	sceneGroups = array.ToBuiltin(Group);
}

function CleanGroup (theGroup : Group) {
	var array : UnityScript.Lang.Array = UnityScript.Lang.Array();
	for (var obj7 : GameObject in theGroup.objects) {
		if (obj7 != null) {
			array.Add(obj7);
		}
	}
	theGroup.objects = array.ToBuiltin(GameObject);
}

