using UnityEngine;

public class StatusBar : MonoBehaviour
{
	private GameObject healthBar;

	private GameObject staminaBar;

	private float statusBarDisplayTime = 1.5f;

	private float statusBarDisplayTimer;

	private float lastHealth;

	private float lastStamina;

	private Player player;

	private HealthAndStamina stats;

	private void Start()
	{
		player = GetComponent<Player>();
		stats = GetComponent<HealthAndStamina>();
		CreateHealthBar();
		CreateStaminaBar();
	}

	private void Update()
	{
		if (player.state != Player.State.Dead)
		{
			if (stats.health < lastHealth || stats.stamina < lastStamina)
			{
				statusBarDisplayTimer = statusBarDisplayTime;
			}
			CheckStatusBars();
			lastHealth = stats.health;
			lastStamina = stats.stamina;
		}
		else
		{
			healthBar.renderer.enabled = false;
			staminaBar.renderer.enabled = false;
		}
	}

	private void CreateHealthBar()
	{
		healthBar = GameObject.CreatePrimitive(PrimitiveType.Quad);
		Object.Destroy(healthBar.collider);
		healthBar.name = "healthBar";
		healthBar.transform.parent = transform.root;
		healthBar.transform.localEulerAngles = new Vector3(0f, 0f, 0f);
		healthBar.transform.localScale = new Vector3(stats.health / 200f, 0.04f, 1f);
		healthBar.renderer.material.shader = Shader.Find("GUI/Text Shader");
		healthBar.renderer.enabled = false;
	}

	private void CreateStaminaBar()
	{
		staminaBar = GameObject.CreatePrimitive(PrimitiveType.Quad);
		Object.Destroy(staminaBar.collider);
		staminaBar.name = "staminaBar";
		staminaBar.transform.parent = transform.root;
		staminaBar.transform.localEulerAngles = new Vector3(0f, 0f, 0f);
		staminaBar.transform.localScale = new Vector3(stats.stamina / 200f, 0.04f, 1f);
		staminaBar.renderer.material.shader = Shader.Find("GUI/Text Shader");
		staminaBar.renderer.enabled = false;
	}

	private void CheckStatusBars()
	{
		if (statusBarDisplayTimer > 0f)
		{
			statusBarDisplayTimer -= Time.deltaTime;
			UpdateHealthBar(false);
			UpdateStaminaBar(false);
		}
		else
		{
			UpdateHealthBar(true);
			UpdateStaminaBar(true);
		}
	}

	private void UpdateHealthBar(bool fadeOut)
	{
		healthBar.transform.position = player.part["head"].renderer.bounds.center + new Vector3(0f, 0.5f, 0f);
		healthBar.transform.rotation = Camera.main.transform.rotation;
		Vector3 localScale = new Vector3(stats.health / 200f, 0.05f, 1f);
		if (localScale.x < 0f)
		{
			localScale.x = 0f;
		}
		float a = healthBar.renderer.material.color.a;
		if (fadeOut)
		{
			a -= Time.deltaTime / 2f;
			if (a <= 0f)
			{
				a = 0f;
				healthBar.renderer.enabled = false;
			}
		}
		else
		{
			a = 0.5f;
			healthBar.renderer.enabled = true;
		}
		healthBar.transform.localScale = localScale;
		healthBar.renderer.material.color = new Color(1f - stats.health / 100f, stats.health / 100f, 0f, a);
	}

	private void UpdateStaminaBar(bool fadeOut)
	{
		staminaBar.transform.position = player.part["head"].renderer.bounds.center + new Vector3(0f, 0.44f, 0f);
		staminaBar.transform.rotation = Camera.main.transform.rotation;
		Vector3 localScale = new Vector3(stats.stamina / 200f, 0.05f, 1f);
		if (localScale.x < 0f)
		{
			localScale.x = 0f;
		}
		float a = staminaBar.renderer.material.color.a;
		if (fadeOut)
		{
			a -= Time.deltaTime / 2f;
			if (a <= 0f)
			{
				a = 0f;
				staminaBar.renderer.enabled = false;
			}
		}
		else
		{
			a = 0.5f;
			staminaBar.renderer.enabled = true;
		}
		staminaBar.transform.localScale = localScale;
		staminaBar.renderer.material.color = new Color(0f, 0f, stats.health / 100f, a);
	}
}
