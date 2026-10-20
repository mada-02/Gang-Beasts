using UnityEngine;

namespace Destruction.Utilities
{
		public class Face
		{
			public static Vector3[] points;

			public int i0;

			public int i1;

			public int i2;

			public float a;

			public float b;

			public float c;

			public float d;

			public Face(int i0, int i1, int i2)
			{
				this.i0 = i0;
				this.i1 = i1;
				this.i2 = i2;
				ComputePlane();
			}

			public Vector3 Centroid
			{
				get
				{
					Vector3 vector = points[i0];
					Vector3 vector2 = points[i1];
					Vector3 vector3 = points[i2];
					return new Vector3(vector.x + vector2.x + vector3.x, vector.y + vector2.y + vector3.y, vector.z + vector2.z + vector3.z) / 3f;
				}
			}

			private void ComputePlane()
			{
				Vector3 vector = points[i0];
				Vector3 vector2 = points[i1];
				Vector3 vector3 = points[i2];
				a = vector.y * (vector2.z - vector3.z) + vector2.y * (vector3.z - vector.z) + vector3.y * (vector.z - vector2.z);
				b = vector.z * (vector2.x - vector3.x) + vector2.z * (vector3.x - vector.x) + vector3.z * (vector.x - vector2.x);
				c = vector.x * (vector2.y - vector3.y) + vector2.x * (vector3.y - vector.y) + vector3.x * (vector.y - vector2.y);
				d = -(vector.x * (vector2.y * vector3.z - vector3.y * vector2.z) + vector2.x * (vector3.y * vector.z - vector.y * vector3.z) + vector3.x * (vector.y * vector2.z - vector2.y * vector.z));
			}

			public bool IsVisible(Vector3 p)
			{
				return a * p.x + b * p.y + c * p.z + d >= 0f;
			}

			public void Flip()
			{
				int num = i0;
				i0 = i1;
				i1 = num;
				ComputePlane();
			}
		}
}
