using UnityEngine;

public abstract class CreationSingleton<T> : MonoBehaviour where T : CreationSingleton<T>
{
	private static T m_Instance;

	public static T Instance
	{
		get
		{
			if (m_Instance == null)
			{
				m_Instance = Object.FindObjectOfType(typeof(T)) as T;
				if (m_Instance == null)
				{
					m_Instance = new GameObject("Temp Instance of " + typeof(T), typeof(T)).GetComponent<T>();
					if (m_Instance == null)
					{
						Debug.LogError("Problem during the creation of " + typeof(T));
					}
				}
			}
			return m_Instance;
		}
	}

	private void Awake()
	{
		if (m_Instance == null)
		{
			m_Instance = this as T;
		}
	}
}
