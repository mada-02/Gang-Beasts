using System.Collections.Generic;
using System.Linq;
using System;
using UnityEngine;

namespace Destruction
{
		internal static class DestructionHelper
		{
			public static void Resize<T>(this List<T> list, int size)
			{
				int count = list.Count;
				if (size < count)
				{
					list.RemoveRange(size, count - size);
				}
			}

			public static void Toggle(ref bool value, string name)
			{
				GUILayout.BeginHorizontal("box");
				GUILayout.Label(name + " : ");
				value = GUILayout.Toggle(value, string.Empty);
				GUILayout.EndHorizontal();
			}

			public static T[] FindObjectsOfType<T>()
			{
				T[] result611 = UnityEngine.Object.FindObjectsOfType(typeof(T)) as T[];
				return result611;
			}

			public static T[] GetInterfaces<T>(this GameObject gameObject)
			{
				if (!typeof(T).IsInterface)
				{
					throw new SystemException("Specified type is not an interface!");
				}
				MonoBehaviour[] components = gameObject.GetComponents<MonoBehaviour>();
				return (from a in components
					where a.GetType().GetInterfaces().Any((Type k) => k == typeof(T))
					select (T)(object)a).ToArray();
			}

			public static List<Vector3> DedupCollectionWithRandom(List<Vector3> input)
			{
				HashSet<Vector3> hashSet = new HashSet<Vector3>();
				foreach (Vector3 item in input)
				{
					if (!hashSet.Contains(item))
					{
						hashSet.Add(item + UnityEngine.Random.insideUnitSphere * 0.0001f);
					}
				}
				return new List<Vector3>(hashSet);
			}

			public static List<Vector3> DedupCollectionWithRandom(List<Vector3> input, IEqualityComparer<Vector3> comparer)
			{
				HashSet<Vector3> hashSet = new HashSet<Vector3>(comparer);
				foreach (Vector3 item in input)
				{
					if (!hashSet.Contains(item))
					{
						hashSet.Add(item + UnityEngine.Random.insideUnitSphere * 0.0001f);
					}
				}
				return new List<Vector3>(hashSet);
			}

			public static List<T> DedupCollection<T>(IEnumerable<T> input)
			{
				HashSet<T> hashSet = new HashSet<T>();
				foreach (T item in input)
				{
					if (!hashSet.Contains(item))
					{
						hashSet.Add(item);
					}
				}
				return new List<T>(hashSet);
			}

			public static void SortClockwiseOnPlane(this Vector3[] input, Vector3 planeNormal)
			{
				Vector3 centroid = Vector3.zero;
				for (int i = 0; i < input.Length; i++)
				{
					centroid += input[i];
				}
				centroid /= (float)input.Length;
				Vector3 referenceVector = input[0] - centroid;
				Array.Sort(input, (Vector3 p1, Vector3 p2) => Comparer<float>.Default.Compare(SignedAngle(planeNormal, p1 - centroid, referenceVector), SignedAngle(planeNormal, p2 - centroid, referenceVector)));
			}

			public static void SortClockwiseOnPlane(this List<Vector3> input, Vector3 planeNormal)
			{
				Vector3 centroid = Vector3.zero;
				for (int i = 0; i < input.Count; i++)
				{
					centroid += input[i];
				}
				centroid /= (float)input.Count;
				Vector3 referenceVector = input[0] - centroid;
				input.Sort((Vector3 p1, Vector3 p2) => Comparer<float>.Default.Compare(SignedAngle(planeNormal, p1 - centroid, referenceVector), SignedAngle(planeNormal, p2 - centroid, referenceVector)));
			}

			public static void SortAntiClockwiseOnPlane(this List<Vector3> input, Vector3 planeNormal)
			{
				Vector3 centroid = Vector3.zero;
				for (int i = 0; i < input.Count; i++)
				{
					centroid += input[i];
				}
				centroid /= (float)input.Count;
				Vector3 referenceVector = input[0] - centroid;
				input.Sort((Vector3 p1, Vector3 p2) => -SignedAngle(planeNormal, p1 - centroid, referenceVector).CompareTo(SignedAngle(planeNormal, p2 - centroid, referenceVector)));
			}

			public static void SortAntiClockwiseOnPlane(this Vector3[] input, Vector3 planeNormal)
			{
				Vector3 centroid = Vector3.zero;
				for (int i = 0; i < input.Length; i++)
				{
					centroid += input[i];
				}
				centroid /= (float)input.Length;
				Vector3 referenceVector = input[0] - centroid;
				Array.Sort(input, (Vector3 p1, Vector3 p2) => -SignedAngle(planeNormal, p1 - centroid, referenceVector).CompareTo(SignedAngle(planeNormal, p2 - centroid, referenceVector)));
			}

			public static float SignedAngle(Vector3 referencePlane, Vector3 a, Vector3 b)
			{
				Vector3 lhs = Vector3.Cross(a, b);
				float num = Mathf.Atan2(lhs.sqrMagnitude, Vector3.Dot(a, b)) * 57.29578f;
				return Vector3.Dot(lhs, referencePlane) < 0f ? (-num) : num;
			}
		}
}
