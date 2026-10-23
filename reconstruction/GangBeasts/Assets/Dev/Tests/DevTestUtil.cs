using System.Collections.Generic;
using System.Reflection;
using System.Text;
using UnityEngine;

// Helpers shared by test suites.
public static class DevTestUtil
{
	// The physics of a beast as text, one line per part: rigidbody, colliders, joint and scale relative
	// to the root. Pose and placement are left out, so two beasts built the same way compare equal.
	public static List<string> Signature(Beast beast)
	{
		List<string> lines = new List<string>();
		Player p = beast.player;
		lines.Add("root scale " + R(p.transform.localScale));
		List<string> names = new List<string>(p.part.Keys);
		names.Sort(string.CompareOrdinal);
		foreach (string name in names)
		{
			Transform t = p.part[name];
			StringBuilder b = new StringBuilder(name);
			b.Append(" layer ").Append(t.gameObject.layer).Append(" tag ").Append(t.tag).Append(" scale ").Append(R(t.localScale));
			Rigidbody rb = t.rigidbody;
			if (rb != null)
			{
				// Constraints are left out: Movement freezes and frees the ball's rotation every step.
				b.Append(" | rb ").Append(F(rb.mass)).Append(' ').Append(F(rb.drag)).Append(' ').Append(F(rb.angularDrag)).Append(' ').Append(rb.useGravity)
					.Append(' ').Append(rb.collisionDetectionMode);
			}
			foreach (Collider c in t.GetComponents<Collider>())
			{
				b.Append(" | ").Append(c.GetType().Name).Append(c.isTrigger ? " trigger" : "").Append(c.enabled ? "" : " off");
				CapsuleCollider cap = c as CapsuleCollider;
				SphereCollider sph = c as SphereCollider;
				BoxCollider box = c as BoxCollider;
				MeshCollider mesh = c as MeshCollider;
				if (cap != null)
				{
					b.Append(' ').Append(F(cap.radius)).Append(' ').Append(F(cap.height)).Append(' ').Append(cap.direction).Append(' ').Append(V(cap.center));
				}
				if (sph != null)
				{
					b.Append(' ').Append(F(sph.radius)).Append(' ').Append(V(sph.center));
				}
				if (box != null)
				{
					b.Append(' ').Append(V(box.size)).Append(' ').Append(V(box.center));
				}
				if (mesh != null)
				{
					b.Append(' ').Append(mesh.sharedMesh != null ? mesh.sharedMesh.name : "none").Append(mesh.convex ? " convex" : "");
				}
				b.Append(" mat ").Append(c.sharedMaterial != null ? c.sharedMaterial.name : "none");
			}
			ConfigurableJoint j = t.GetComponent<ConfigurableJoint>();
			if (j != null)
			{
				b.Append(" | joint to ").Append(j.connectedBody != null ? j.connectedBody.name : "world")
					.Append(' ').Append(j.xMotion).Append(j.yMotion).Append(j.zMotion).Append(' ').Append(j.angularXMotion).Append(j.angularYMotion).Append(j.angularZMotion)
					.Append(" lim ").Append(F(j.lowAngularXLimit.limit)).Append(' ').Append(F(j.highAngularXLimit.limit)).Append(' ').Append(F(j.angularYLimit.limit))
					.Append(' ').Append(F(j.angularZLimit.limit)).Append(' ').Append(F(j.linearLimit.limit))
					.Append(" anchor ").Append(V(j.anchor)).Append(" axes ").Append(V(j.axis)).Append(V(j.secondaryAxis))
					.Append(" proj ").Append(j.projectionMode).Append(' ').Append(F(j.projectionDistance)).Append(' ').Append(F(j.projectionAngle))
					.Append(" drives ").Append(D(j.angularXDrive)).Append(D(j.angularYZDrive)).Append(D(j.slerpDrive)).Append(' ').Append(j.rotationDriveMode)
					.Append(" break ").Append(F(j.breakForce)).Append(' ').Append(F(j.breakTorque));
			}
			lines.Add(b.ToString());
		}
		return lines;
	}

	// The settings fields (DevFields.settings) of every beast component, as text.
	public static List<string> Settings(Beast beast, bool includeIdentity)
	{
		List<string> lines = new List<string>();
		Component[] components = { beast.player, beast.stats, beast.movement, beast.jump, beast.punch, beast.targeting };
		foreach (Component c in components)
		{
			if (c == null)
			{
				continue;
			}
			foreach (string name in DevFields.settings[c.GetType()])
			{
				if (!includeIdentity && c is Player && (name == "player" || name == "gangName" || name == "actorColor" || name == "mob"))
				{
					continue;
				}
				if (c is HealthAndStamina && name == "health")
				{
					continue;
				}
				object v = c.GetType().GetField(name, BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic).GetValue(c);
				lines.Add(c.GetType().Name + "." + name + " = " + Show(v));
			}
		}
		return lines;
	}

	private static string Show(object v)
	{
		if (v == null)
		{
			return "null";
		}
		if (v is float)
		{
			return F((float)v);
		}
		System.Array array = v as System.Array;
		if (array != null)
		{
			StringBuilder b = new StringBuilder("[");
			foreach (object x in array)
			{
				b.Append(x != null ? x.ToString() : "null").Append(',');
			}
			return b.Append(']').ToString();
		}
		return v.ToString();
	}

	public static string F(float f)
	{
		return f.ToString("R");
	}

	public static string V(Vector3 v)
	{
		return "(" + F(v.x) + "," + F(v.y) + "," + F(v.z) + ")";
	}

	// Rounded to 1e-4: a part's scale under the root after Player.Awake re-parents it carries float
	// noise (0.350000024 for 0.35) that differs between otherwise identical beasts.
	public static string R(Vector3 v)
	{
		return "(" + v.x.ToString("0.0000") + "," + v.y.ToString("0.0000") + "," + v.z.ToString("0.0000") + ")";
	}

	private static string D(JointDrive d)
	{
		return "[" + d.mode + " " + F(d.positionSpring) + " " + F(d.positionDamper) + " " + F(d.maximumForce) + "]";
	}

	// Lines in a but not in b, prefixed "-", and in b but not in a, "+" (at most max of them).
	public static List<string> Diff(List<string> a, List<string> b, int max)
	{
		List<string> diff = new List<string>();
		foreach (string line in a)
		{
			if (!b.Contains(line) && diff.Count < max)
			{
				diff.Add("- " + line);
			}
		}
		foreach (string line in b)
		{
			if (!a.Contains(line) && diff.Count < max)
			{
				diff.Add("+ " + line);
			}
		}
		return diff;
	}

	public static float MaxPartSpeed(Beast beast)
	{
		float max = 0f;
		foreach (Rigidbody rb in beast.gameObject.GetComponentsInChildren<Rigidbody>())
		{
			max = Mathf.Max(max, rb.velocity.magnitude);
		}
		return max;
	}

	// Sets SceneManager.totalPlayers before a level loads (the Menu's SceneManager persists and decides
	// how many human slots each level keeps).
	public static void SetPlayers(int count)
	{
		GameObject go = GameObject.FindWithTag("Scene Manager");
		if (go != null)
		{
			SceneManager sm = go.GetComponent<SceneManager>();
			sm.totalPlayers = count;
			sm.score = new int[count];
			for (int i = 0; i < count; i++)
			{
				sm.score[i] = sm.startingLives;
			}
		}
	}
}
