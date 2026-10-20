using UnityEngine;

public class HealthAndStamina : MonoBehaviour
{
	public float health = 100f;

	private float maxHealth;

	public float stamina;

	private float maxStamina;

	public float healthRegenerationSpeed = 5f;

	private float staminaRegenerationSpeed = 100f;

	public float maxStunTime;

	public float stunThreshold;

	private float stunTimer;

	public bool canDie;

	public bool dead;

	public bool runOnce;

	public AudioClip[] hurtSound;

	private float hurtRetriggerDelay;

	public AudioClip[] stunSound;

	public float stunRetriggerDelay;

	public AudioClip[] deathSound;

	public AudioClip[] punchSound;

	private float leftPunchRetriggerDelay;

	private float rightPunchRetriggerDelay;

	public Blink blink;

	private Player player;

	private void Start()
	{
		maxHealth = health;
		maxStamina = health;
		stamina = health;
		player = gameObject.GetComponent<Player>();
		blink = player.part["head"].FindChild("eyes").GetComponent<Blink>();
	}

	private void Update()
	{
		if (player.state != Player.State.Dead)
		{
			if (stamina < 0f)
			{
				stamina = 0f;
			}
			ReplenishStats();
			StunCheck();
		}
		if (hurtRetriggerDelay > 0f)
		{
			hurtRetriggerDelay -= Time.deltaTime;
		}
		if (stunRetriggerDelay > 0f)
		{
			stunRetriggerDelay -= Time.deltaTime;
		}
		if (leftPunchRetriggerDelay > 0f)
		{
			leftPunchRetriggerDelay -= Time.deltaTime;
		}
		if (rightPunchRetriggerDelay > 0f)
		{
			rightPunchRetriggerDelay -= Time.deltaTime;
		}
	}

	private void ReplenishStats()
	{
		health += Time.deltaTime * healthRegenerationSpeed;
		if (health >= maxHealth)
		{
			health = maxHealth;
			stunTimer = 0f;
		}
		if (stamina < health)
		{
			stamina += Time.deltaTime * staminaRegenerationSpeed;
		}
		if (stamina >= health)
		{
			stamina = health;
		}
	}

	private void StunCheck()
	{
		if (stunTimer > 0f)
		{
			stunTimer -= Time.deltaTime;
			player.state = Player.State.Stunned;
		}
		if (stunTimer <= 0f)
		{
			stunTimer = 0f;
			if (player.state == Player.State.Stunned)
			{
				player.state = Player.State.Standing;
			}
		}
	}

	public void TakeDamage(Collision collision, float damage, bool weakSpot)
	{
		if (weakSpot)
		{
			damage *= 2f;
		}

		health -= damage;
		if (health <= 0f)
		{
			health = 0f;
			bool flag = canDie;
			if (flag)
			{
				if (flag)
				{
					if (deathSound.Length > 0 && player.state != Player.State.Dead)
					{
						int num = Random.Range(0, deathSound.Length - 1);
						SoundAtPoint(deathSound[num], player.part["head"].position, 1f, 1f);
					}

					player.state = Player.State.Dead;
					if (!runOnce)
					{
						runOnce = true;
						GameObject gameObject = GameObject.FindWithTag("Scene Manager");
						SceneManager component = gameObject.GetComponent<SceneManager>();
						component.score[player.player]--;
					}
				}
			}
			else
			{
				stunTimer = maxStunTime;
				if (player.state != Player.State.Stunned && stunSound.Length > 0 && stunRetriggerDelay <= 0f)
				{
					float pitch = Random.Range(0.9f, 1.1f);
					int num2 = Random.Range(0, stunSound.Length - 1);
					SoundAtPoint(stunSound[num2], player.part["head"].position, 1f, pitch);
					stunRetriggerDelay = Random.Range(1f, 2f);
				}
			}
		}

		if (!(player.state == Player.State.Dead))
		{
			if (damage > stunThreshold)
			{
				float num3 = stunTimer;
				num3 += damage / 10f;
				stunTimer = Mathf.Clamp(num3, 0f, maxStunTime);
				if (player.state != Player.State.Stunned && stunSound.Length > 0 && stunRetriggerDelay <= 0f)
				{
					float pitch2 = Random.Range(0.9f, 1.1f);
					int num4 = Random.Range(0, stunSound.Length - 1);
					SoundAtPoint(stunSound[num4], player.part["head"].position, 1f, pitch2);
					stunRetriggerDelay = Random.Range(1f, 2f);
				}
			}
			else if (player.state != Player.State.Stunned)
			{
				blink.eye = 0.1f;
				if (hurtSound.Length > 0 && hurtRetriggerDelay <= 0f)
				{
					float pitch3 = Random.Range(0.9f, 1.1f);
					int num5 = Random.Range(0, hurtSound.Length - 1);
					SoundAtPoint(hurtSound[num5], player.part["head"].position, 1f, pitch3);
					hurtRetriggerDelay = Random.Range(1f, 2f);
				}
			}

			if (punchSound.Length > 0)
			{
				if (collision.collider.name == "leftHand" && leftPunchRetriggerDelay <= 0f)
				{
					float magnitude = collision.relativeVelocity.magnitude;
					float pitch4 = Random.Range(0.5f, 0.75f);
					int num6 = Random.Range(0, punchSound.Length - 1);
					SoundAtPoint(punchSound[num6], collision.contacts[0].point, magnitude, pitch4);
					leftPunchRetriggerDelay = 0.3f;
				}

				if (collision.collider.name == "rightHand" && rightPunchRetriggerDelay <= 0f)
				{
					float magnitude2 = collision.relativeVelocity.magnitude;
					float pitch5 = Random.Range(0.5f, 0.75f);
					int num7 = Random.Range(0, punchSound.Length - 1);
					SoundAtPoint(punchSound[num7], collision.contacts[0].point, magnitude2, pitch5);
					rightPunchRetriggerDelay = 0.3f;
				}
			}
		}
	}

	private void SoundAtPoint(AudioClip clip, Vector3 position, float volume, float pitch)
	{
		GameObject gameObject = new GameObject();
		gameObject.transform.position = position;
		gameObject.name = clip.name;
		gameObject.AddComponent<AudioSource>();
		gameObject.audio.pitch = pitch;
		gameObject.audio.PlayOneShot(clip, volume);
		Object.Destroy(gameObject, clip.length / pitch);
	}
}
