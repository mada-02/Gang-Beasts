// Switches read by the developer-branch hooks in the game's own scripts (Player.cs, HealthAndStamina.cs;
// see CLAUDE.md and tools/dev/hooks/). Each fix can be turned off (Debug tab) to get 0.0.3's behaviour back.
public static class DevHooks
{
	// Player.TauntInput: a mob whose target died kept taunting after it found a new, living target
	// (the reset sat in an else branch it could not reach while it had a target).
	public static bool fixMobTaunt = true;

	// HealthAndStamina.TakeDamage: a dying mob takes a life from score[player], and mobs' index 4 is
	// past the P1-P4 scores, so every such death threw IndexOutOfRangeException (after the mob was
	// already marked dead). The fix skips the out-of-range decrement.
	public static bool fixScoreIndex = true;
}
