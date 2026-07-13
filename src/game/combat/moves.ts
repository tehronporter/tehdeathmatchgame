import type { Move, MoveId } from '../characters/types';

export const MOVES: Record<MoveId, Move> = {
  punch: { id: 'punch', baseDamage: 6, staminaCost: 8, hypeGain: 4, knockback: 1.5, windupMs: 150 },
  kick: { id: 'kick', baseDamage: 10, staminaCost: 14, hypeGain: 6, knockback: 3, windupMs: 300 },
  grab: { id: 'grab', baseDamage: 4, staminaCost: 18, hypeGain: 8, knockback: 5, windupMs: 400 },
  special: { id: 'special', baseDamage: 20, staminaCost: 40, hypeGain: 15, knockback: 8, windupMs: 600 },
};
