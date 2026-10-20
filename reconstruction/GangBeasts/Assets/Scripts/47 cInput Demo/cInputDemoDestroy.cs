using System.Collections;
using UnityEngine;

public class cInputDemoDestroy : MonoBehaviour
{
	private IEnumerator Start()
	{
		yield return new WaitForSeconds(1.5f);
		Object.Destroy(gameObject);
	}
}
