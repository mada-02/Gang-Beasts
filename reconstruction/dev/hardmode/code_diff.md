# 0.0.2 vs 0.0.3: behaviour-code differences that affect physics and combat

Source of truth: `decompiled_002/Assembly-CSharp/*.cs` (regenerate with `bash tools/dev/decompile_002.sh`;
ilspycmd 11.1.0.9782, `-lv CSharp3 -ds SparseIntegerSwitch=false`, from the shipped 0.0.2 build) against
`src/Assembly-CSharp/Scripts/28 Gang Beasts/Player/*.cs` (0.0.3, proven 1:1). Compared with `diff -w`.

`AlignToVector` and `Straighten` ignore their force argument in **both** versions (they always use
`player.applyedForce`), so differences only in that argument (`*1000f`, `/4f`, `*10f`) change nothing and
are not listed.

## Player

| # | 0.0.2 | 0.0.3 |
|---|---|---|
| P1 | Stunned, Dead (or Falling): `applyedForce = 0` at once | drains by `force/2` per second |
| P2 | Recovers `force/8` per second | `force/6` per second |
| P3 | Never enters `Falling` (nothing sets it); no leg/ball ground flags, no `groundTimer` | off the ground for 0.5 s: `Falling` (limp via P1) |
| P4 | Stunned/Dead: hand tags are not reset | resets both hands to `Body Part` |
| P5 | Awake ignores: forearms-chest, stomach-chest/hips/groin, groin-chest/hips/thighs (single colliders) | chest capsules vs stomach capsules, stomach vs hips/groin/thighs, chest vs arms/hips/groin |
| P6 | No duck, no climb input | duck (Button1), climb |

Mob AI (`FindClosestTarget`, punch trigger, taunt) is the same in both.

## Movement

| # | 0.0.2 | 0.0.3 |
|---|---|---|
| M1 | Runs whenever there is input | runs only when `applyedForce > force/4`, otherwise stands |
| M2 | Standing: chest/ball straighten, legs straighten; head turns only towards a grab target | also always turns head towards input (or grab target) and chest + hips towards `direction + down`; duck branch |
| M3 | Running: no yaw torque | `±100000` yaw impulse on chest and hips towards the input side |
| M4 | Leg and arm cycle aim along `chest.forward` | aim along the input direction; thighs/legs also get `∓20` torque about `chest.right` in phases 0-1 |
| M5 | Chest bob `applyedForce/4` | `applyedForce/5` |
| M6 | Ball torque always `movementSpeed` | `movementSpeed`, or `/10` when the chest is more than 30° off the input |
| M7 | Ball rotation unfrozen when `applyedForce >= force` | also requires not ducking |

## Jump

| # | 0.0.2 | 0.0.3 |
|---|---|---|
| J1 | Impulse along `chest.up` every step while `jumpTimer <= 0.1 s`, strength decaying by `40 * jumpStrength * dt` per step | one impulse along world up on the first step with `onGround` |
| J2 | Jumping/Falling: `Jumping()` while `jumpTimer < fallTime`, else empty `Falling()` | `Jumping()` only while `applyedForce > force/4`; `Falling()` turns head and pushes hips `input * airSpeed` |
| J3 | Air push on chest `(input + down) * 3` (`airSpeed` private, 3) | `* airSpeed` (public, default 5; scene value in fingerprint) |
| J4 | Grab-target reach uses `renderer.bounds` | `collider.bounds` |

## PunchAndGrab

| # | 0.0.2 | 0.0.3 |
|---|---|---|
| G1 | Strike (0.2-0.4 s): hand `+80`, forearm and upper arm `-30` each, no chest recoil | targeted `80` / untargeted `60`; forearm, arm **and chest** `-num/4` |
| G2 | Untargeted aim `chest.pos + forward + up/2` | `up/1.5` |
| G3 | Grab pull on hand only | also pulls the chest back by the same impulse; reaching for nothing pulls chest `-forward*2` |
| G4 | No stamina (grabs never run out) | grabs cost 1.1 stamina per step (110/s; about 10 s of hold) |
| G5 | Resting arm only when neither punching nor grabbing; chest pushed down `2` | when not punching; chest down `4` |

## CollisionEvent

| # | 0.0.2 | 0.0.3 |
|---|---|---|
| C1 | Hitting static world: `damage = dot * 10 / 100` | `dot * 1000 / 100`: **100x** more fall/wall damage in 0.0.3 |
| C2 | GroundCheck sets Standing/Running only on collision *stay* | on enter and stay |
| C3 | No leg/ball ground flags | sets `left/rightLegOnGround` (ball sets the right leg's flag, a 0.0.3 bug) |

## Health (0.0.2) vs HealthAndStamina (0.0.3)

Same regeneration, stun and damage formulas; 0.0.2 has no stamina. Only the per-level values differ
(`regenerationSpeed` = `healthRegenerationSpeed`): see the data fingerprint.

## Same in both

`Targeting` (only control flow restructured), `KillZone`, `AlignToVector`/`Straighten`, `GrabCheck`, the
damage formula for body hits (`dot * mass / 100`, x10 harmful, 15 m/s gate).

## Consequences for Hard Mode

The old `additional` Hard Mode reproduced only G1/G2 (by impulse cancellation), P5, the wrist lock and some
data. Reproducing 0.0.2 needs its behaviour code: Hard Mode swaps in faithful ports of 0.0.2's
`Movement`, `Jump`, `PunchAndGrab` (disable the 0.0.3 ones: FixedUpdate only) and `CollisionEvent`
(collision messages still reach disabled behaviours, so the 0.0.3 one is removed and re-added on restore),
plus a pre/post pair around `Player.Update` (execution order -50/+50) for P1-P4. Data (masses, drag,
joints, colliders, stats) comes from the level-file fingerprint.
