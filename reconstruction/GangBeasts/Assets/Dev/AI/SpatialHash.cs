using System.Collections.Generic;
using UnityEngine;

// Points bucketed on a horizontal grid, for "who is near here" without scanning every beast. Rebuilt
// each AI world tick; reuses its lists so a steady state allocates nothing.
public class SpatialHash
{
	private readonly float cell;

	private readonly Dictionary<long, List<int>> cells = new Dictionary<long, List<int>>();

	private readonly Stack<List<int>> spare = new Stack<List<int>>();

	private Vector3[] points = new Vector3[0];

	private int count;

	public SpatialHash(float cell)
	{
		this.cell = cell;
	}

	private long Key(int x, int z)
	{
		return ((long)x << 32) ^ (uint)z;
	}

	public void Build(Vector3[] positions, int n)
	{
		foreach (List<int> list in cells.Values)
		{
			list.Clear();
			spare.Push(list);
		}
		cells.Clear();
		points = positions;
		count = n;
		for (int i = 0; i < n; i++)
		{
			long key = Key(Mathf.FloorToInt(positions[i].x / cell), Mathf.FloorToInt(positions[i].z / cell));
			List<int> list;
			if (!cells.TryGetValue(key, out list))
			{
				list = spare.Count > 0 ? spare.Pop() : new List<int>();
				cells[key] = list;
			}
			list.Add(i);
		}
	}

	// Indices of the points within radius of centre (3D distance), appended to results.
	public void Query(Vector3 centre, float radius, List<int> results)
	{
		int x0 = Mathf.FloorToInt((centre.x - radius) / cell);
		int x1 = Mathf.FloorToInt((centre.x + radius) / cell);
		int z0 = Mathf.FloorToInt((centre.z - radius) / cell);
		int z1 = Mathf.FloorToInt((centre.z + radius) / cell);
		float r2 = radius * radius;
		for (int x = x0; x <= x1; x++)
		{
			for (int z = z0; z <= z1; z++)
			{
				List<int> list;
				if (!cells.TryGetValue(Key(x, z), out list))
				{
					continue;
				}
				foreach (int i in list)
				{
					if ((points[i] - centre).sqrMagnitude <= r2)
					{
						results.Add(i);
					}
				}
			}
		}
	}

	public int Count
	{
		get { return count; }
	}
}
