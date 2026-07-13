export type MoveId = 'punch' | 'kick' | 'grab' | 'special';

export interface Move {
  id: MoveId;
  baseDamage: number;
  staminaCost: number;
  hypeGain: number;
  knockback: number;
  windupMs: number;
}

export interface CharacterStats {
  health: number;
  strength: number;
  speed: number;
  special: number;
}

export interface Character {
  id: string;
  name: string;
  stats: CharacterStats;
  color: string;
  finisherId: string;
}
