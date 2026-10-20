#pragma strict
#pragma implicit
#pragma downcast

static var meshes : Mesh[];
static var currentTris : int = 0;

static function HasMeshes () : boolean {
	if (!meshes)
		return false;
	for (var m : Mesh in meshes)
		if (null == m)
			return false;
	return true;
}

static function Cleanup () {
	if (!meshes)
		return;

	for (var m : Mesh in meshes) {
		if (null != m) {
			DestroyImmediate (m);
			m = null;
		}
	}
	meshes = null;
}

static function GetMeshes (totalWidth : int, totalHeight : int) : Mesh[] {
	if (HasMeshes() && currentTris == totalWidth * totalHeight) {
		return meshes;
	}
	var num : int = 21666;
	var num2 : int = totalWidth * totalHeight;
	currentTris = num2;
	var num3 : int = Mathf.CeilToInt(1.0 * num2 / (1.0 * num));
	meshes = new Mesh[num3];
	var num4 : int = 0;
	var num5 : int = 0;
	for (num4 = 0; num4 < num2; num4 += num) {
		var triCount : int = Mathf.FloorToInt(Mathf.Clamp(num2 - num4, 0, num));
		meshes[num5] = GetMesh(triCount, num4, totalWidth, totalHeight);
		num5++;
	}
	return meshes;
}

static function GetMesh (triCount : int, triOffset : int, totalWidth : int, totalHeight : int) : Mesh {
	var mesh : Mesh = Mesh();
	mesh.hideFlags = HideFlags.DontSave;
	var array : Vector3[] = new Vector3[triCount * 3];
	var array2 : Vector2[] = new Vector2[triCount * 3];
	var array3 : Vector2[] = new Vector2[triCount * 3];
	var array4 : int[] = new int[triCount * 3];
	var num : float = 0.0075;
	for (var i : int = 0; i < triCount; i++) {
		var num2 : int = i * 3;
		var num3 : int = triOffset + i;
		var num4 : float = Mathf.Floor(num3 % totalWidth) / totalWidth;
		var num5 : float = Mathf.Floor(num3 / totalWidth) / totalHeight;
		var vector : Vector3 = Vector3(num4 * 2 - 1, num5 * 2 - 1, 1.0);
		array[num2 + 0] = vector;
		array[num2 + 1] = vector;
		array[num2 + 2] = vector;
		array2[num2 + 0] = Vector2(0.0, 0.0);
		array2[num2 + 1] = Vector2(1.0, 0.0);
		array2[num2 + 2] = Vector2(0.0, 1.0);
		array3[num2 + 0] = Vector2(num4, num5);
		array3[num2 + 1] = Vector2(num4, num5);
		array3[num2 + 2] = Vector2(num4, num5);
		array4[num2 + 0] = num2 + 0;
		array4[num2 + 1] = num2 + 1;
		array4[num2 + 2] = num2 + 2;
	}
	mesh.vertices = array;
	mesh.triangles = array4;
	mesh.uv = array2;
	mesh.uv2 = array3;
	return mesh;
}

