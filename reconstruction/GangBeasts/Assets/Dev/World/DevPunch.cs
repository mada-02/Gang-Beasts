using UnityEngine;

// On each beast's hands. Punches only use fixed impulses (PunchAndGrab), so extra punch power is added
// here when a hand lands while it is "Body Part (Harmful)": knockback, and damage by the formula
// CollisionEvent.DamageCheck uses for a harmful hand, scaled by the extra power.
public class DevPunch : MonoBehaviour
{
	public static float power = 1f;

	private float cooldown;

	private void Update()
	{
		if (cooldown > 0f)
		{
			cooldown -= Time.deltaTime;
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		if (power <= 1f || cooldown > 0f || tag != "Body Part (Harmful)" || collision.rigidbody == null || collision.contacts.Length == 0)
		{
			return;
		}
		Transform victim = collision.rigidbody.transform.root;
		if (victim == transform.root)
		{
			return;
		}
		cooldown = 0.15f;
		Vector3 direction = rigidbody.velocity.sqrMagnitude > 0.01f ? rigidbody.velocity.normalized : -collision.contacts[0].normal;
		float impulse = 20f * (power - 1f);
		collision.rigidbody.AddForce(direction * impulse, ForceMode.Impulse);
		Player player = victim.GetComponent<Player>();
		HealthAndStamina health = victim.GetComponent<HealthAndStamina>();
		if (player == null || health == null)
		{
			return;
		}
		if (player.part.ContainsKey("chest") && player.part["chest"] != collision.transform)
		{
			player.part["chest"].rigidbody.AddForce((direction + Vector3.up * 0.3f) * impulse, ForceMode.Impulse);
		}
		// The game's own check on this contact plays the punch sound and applies the normal damage.
		float damage = Mathf.Abs(Vector3.Dot(collision.contacts[0].normal, collision.relativeVelocity)) * rigidbody.mass / 100f * 10f;
		if (collision.relativeVelocity.magnitude * 10f > 15f)
		{
			health.TakeDamage(collision, Mathf.RoundToInt(damage * (power - 1f)), collision.collider.tag == "Body Part (Weak Point)");
		}
	}
}
