import type { CharacterStats, Move } from '../characters/types';

export interface MoveResult {
  damage: number;
  staminaCost: number;
  hypeGain: number;
  knockback: number;
  landed: boolean;
}

export function resolveMove(
  attackerStats: CharacterStats,
  move: Move,
  defenderStamina: number,
  isBlocking: boolean,
): MoveResult {
  const canAfford = defenderStamina >= 0;
  if (!canAfford) {
    return { damage: 0, staminaCost: 0, hypeGain: 0, knockback: 0, landed: false };
  }

  const strengthMultiplier = 0.6 + attackerStats.strength * 0.15;
  const rawDamage = move.baseDamage * strengthMultiplier;
  const damage = isBlocking ? rawDamage * 0.25 : rawDamage;
  const knockback = isBlocking ? move.knockback * 0.3 : move.knockback;

  return {
    damage: Math.round(damage),
    staminaCost: move.staminaCost,
    hypeGain: move.hypeGain,
    knockback,
    landed: true,
  };
}
