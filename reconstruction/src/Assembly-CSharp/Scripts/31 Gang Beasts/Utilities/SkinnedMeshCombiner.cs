using System.Collections.Generic;
using UnityEngine;

public class SkinnedMeshCombiner : MonoBehaviour
{
	private void Start()
	{
		SkinnedMeshRenderer[] componentsInChildren = GetComponentsInChildren<SkinnedMeshRenderer>();
		List<Transform> list = new List<Transform>();
		List<BoneWeight> list2 = new List<BoneWeight>();
		List<CombineInstance> list3 = new List<CombineInstance>();
		List<Texture2D> list4 = new List<Texture2D>();
		int num = 0;
		SkinnedMeshRenderer[] array = componentsInChildren;
		foreach (SkinnedMeshRenderer skinnedMeshRenderer in array)
		{
			num += skinnedMeshRenderer.sharedMesh.subMeshCount;
		}
		int[] array2 = new int[num];
		int num2 = 0;
		for (int j = 0; j < componentsInChildren.Length; j++)
		{
			SkinnedMeshRenderer skinnedMeshRenderer2 = componentsInChildren[j];
			BoneWeight[] boneWeights = skinnedMeshRenderer2.sharedMesh.boneWeights;
			BoneWeight[] array3 = boneWeights;
			foreach (BoneWeight boneWeight in array3)
			{
				BoneWeight item = boneWeight;
				item.boneIndex0 += num2;
				item.boneIndex1 += num2;
				item.boneIndex2 += num2;
				item.boneIndex3 += num2;
				list2.Add(item);
			}
			num2 += skinnedMeshRenderer2.bones.Length;
			Transform[] bones = skinnedMeshRenderer2.bones;
			Transform[] array4 = bones;
			foreach (Transform item2 in array4)
			{
				list.Add(item2);
			}
			if (skinnedMeshRenderer2.material.mainTexture != null)
			{
				list4.Add(skinnedMeshRenderer2.renderer.material.mainTexture as Texture2D);
			}
			CombineInstance item3 = new CombineInstance
			{
				mesh = skinnedMeshRenderer2.sharedMesh
			};
			array2[j] = item3.mesh.vertexCount;
			item3.transform = skinnedMeshRenderer2.transform.localToWorldMatrix;
			list3.Add(item3);
			Object.Destroy(skinnedMeshRenderer2.gameObject);
		}
		List<Matrix4x4> list5 = new List<Matrix4x4>();
		for (int m = 0; m < list.Count; m++)
		{
			list5.Add(list[m].worldToLocalMatrix * transform.worldToLocalMatrix);
		}
		SkinnedMeshRenderer skinnedMeshRenderer3 = gameObject.AddComponent<SkinnedMeshRenderer>();
		skinnedMeshRenderer3.sharedMesh = new Mesh();
		skinnedMeshRenderer3.sharedMesh.CombineMeshes(list3.ToArray(), true, true);
		Texture2D texture2D = new Texture2D(128, 128);
		Rect[] array5 = texture2D.PackTextures(list4.ToArray(), 0);
		Vector2[] uv = skinnedMeshRenderer3.sharedMesh.uv;
		Vector2[] array6 = new Vector2[uv.Length];
		int num3 = 0;
		int num4 = 0;
		for (int n = 0; n < array6.Length; n++)
		{
			array6[n].x = Mathf.Lerp(array5[num3].xMin, array5[num3].xMax, uv[n].x);
			array6[n].y = Mathf.Lerp(array5[num3].yMin, array5[num3].yMax, uv[n].y);
			if (n >= array2[num3] + num4)
			{
				num4 += array2[num3];
				num3++;
			}
		}
		Material material = new Material(Shader.Find("Marmoset/Transparent/Cutout/Diffuse IBL"));
		material.mainTexture = texture2D;
		skinnedMeshRenderer3.sharedMesh.uv = array6;
		skinnedMeshRenderer3.sharedMaterial = material;
		skinnedMeshRenderer3.bones = list.ToArray();
		skinnedMeshRenderer3.sharedMesh.boneWeights = list2.ToArray();
		skinnedMeshRenderer3.sharedMesh.bindposes = list5.ToArray();
		skinnedMeshRenderer3.sharedMesh.RecalculateBounds();
		skinnedMeshRenderer3.updateWhenOffscreen = true;
	}
}
