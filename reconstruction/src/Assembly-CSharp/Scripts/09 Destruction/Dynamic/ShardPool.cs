using Destruction.Common;
using UnityEngine;

namespace Destruction.Dynamic
{
		public class ShardPool : MonoBehaviour
		{
			private static ShardPool pool;

			[SerializeField]
			[HideInInspector]
			private Shard[] shards;

			[SerializeField]
			private int maxPoolSize = 800;

			private int nextFreeShard;

			public static int ShardsUsed
			{
				get
				{
					CheckPool();
					return pool.nextFreeShard;
				}
			}

			public bool IsPopulated
			{
				get
				{
					return shards != null;
				}
			}

			public static Shard NextShard
			{
				get
				{
					CheckPool();
					if (CanGetNextShard)
					{
						return pool.shards[pool.nextFreeShard++];
					}
					return null;
				}
			}

			private static bool CanGetNextShard
			{
				get
				{
					return pool.nextFreeShard + 1 < pool.shards.Length;
				}
			}

			private void Awake()
			{
				pool = this;
				PopulatePool();
			}

			private void Start()
			{
				WarmUpDestruction();
			}

			private void WarmUpDestruction()
			{
				ConvexFracture convexFracture = GameObject.CreatePrimitive(PrimitiveType.Cube).AddComponent<ConvexFracture>();
				convexFracture.transform.position = new Vector3(100000f, 100000f, 10000000f);
				((IDestructable)convexFracture).Destroy(convexFracture.transform.position, 0.1f);
				foreach (Collider finalizedBrokenPiece in convexFracture.finalizedBrokenPieces)
				{
					Object.Destroy(finalizedBrokenPiece.gameObject);
				}
			}

			public static void CheckPool()
			{
				if (pool == null)
				{
					FindPoolInScene();
				}
				pool.PopulatePool();
			}

			private static void FindPoolInScene()
			{
				pool = Object.FindObjectOfType(typeof(ShardPool)) as ShardPool;
				if (pool == null)
				{
					GameObject gameObject = new GameObject("_Shard Pool");
					pool = gameObject.AddComponent<ShardPool>();
				}
			}

			public void PopulatePool()
			{
				if (IsPopulated && shards.Length == maxPoolSize)
				{
					return;
				}
				if (shards != null)
				{
					Shard[] array = shards;
					foreach (Shard shard in array)
					{
						Object.DestroyImmediate(shard.gameObject);
					}
				}
				shards = new Shard[maxPoolSize];
				for (int j = 0; j < maxPoolSize; j++)
				{
					shards[j] = new GameObject("Shard").AddComponent<Shard>();
					shards[j].transform.parent = transform;
				}
			}
		}
}
