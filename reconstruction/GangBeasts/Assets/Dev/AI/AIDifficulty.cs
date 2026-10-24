public enum AILevel
{
	Easy,
	Normal,
	Hard,
	Brutal
}

// How sharp the Smart AI is: how fast it reacts, how often and how carefully it punches, whether it
// sidesteps punches, leaps at enemies just out of reach, and finishes stunned enemies off a ledge.
public class AIDifficulty
{
	// Seconds before it acts on an enemy it has only just noticed.
	public float reaction;

	// Seconds between its punches (random in this range).
	public float punchMin;

	public float punchMax;

	// Punches only at an enemy at most this many degrees off its chest's facing.
	public float facing;

	// Chance to sidestep an enemy's punch it sees coming.
	public float dodge;

	// Leaps per second at an enemy just out of reach.
	public float lunge;

	// Grabs stunned enemies and throws them off the level.
	public bool finish;

	public static AIDifficulty Of(AILevel level)
	{
		AIDifficulty d = new AIDifficulty();
		switch (level)
		{
		case AILevel.Easy:
			d.reaction = 0.6f;
			d.punchMin = 0.45f;
			d.punchMax = 0.8f;
			d.facing = 35f;
			d.dodge = 0f;
			d.lunge = 0.1f;
			d.finish = false;
			break;
		case AILevel.Normal:
			d.reaction = 0.35f;
			d.punchMin = 0.25f;
			d.punchMax = 0.45f;
			d.facing = 50f;
			d.dodge = 0.15f;
			d.lunge = 0.3f;
			d.finish = true;
			break;
		case AILevel.Hard:
			d.reaction = 0.2f;
			d.punchMin = 0.15f;
			d.punchMax = 0.3f;
			d.facing = 60f;
			d.dodge = 0.35f;
			d.lunge = 0.5f;
			d.finish = true;
			break;
		default:
			d.reaction = 0.1f;
			d.punchMin = 0.12f;
			d.punchMax = 0.2f;
			d.facing = 65f;
			d.dodge = 0.6f;
			d.lunge = 0.7f;
			d.finish = true;
			break;
		}
		return d;
	}
}
