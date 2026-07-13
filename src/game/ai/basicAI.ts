import type { MoveId } from '../characters/types';
import { AI_PROFILES, type AIDifficulty } from './difficulty';

export interface AIDecisionInput {
  distance: number;
  ownStamina: number;
  ownHype: number;
  maxHype: number;
}

export interface AIDecision {
  moveTowards: -1 | 0 | 1;
  action: MoveId | null;
  blocking: boolean;
}

const ATTACK_RANGE = 2.2;

export class BasicAI {
  private cooldownMs = 0;
  private readonly profile;

  constructor(difficulty: AIDifficulty = 'medium') {
    this.profile = AI_PROFILES[difficulty];
  }

  decide(input: AIDecisionInput, dt: number): AIDecision {
    this.cooldownMs -= dt * 1000;
    if (this.cooldownMs > 0) {
      return { moveTowards: input.distance > ATTACK_RANGE ? 1 : 0, action: null, blocking: false };
    }
    this.cooldownMs = this.profile.reactionMs;

    if (input.distance > ATTACK_RANGE) {
      return { moveTowards: 1, action: null, blocking: false };
    }

    if (input.ownHype >= input.maxHype && input.ownStamina >= 40 && Math.random() < this.profile.specialUsageChance) {
      return { moveTowards: 0, action: 'special', blocking: false };
    }

    if (input.ownStamina < 10) {
      return { moveTowards: -1, action: null, blocking: false };
    }

    if (Math.random() < this.profile.blockChance) {
      return { moveTowards: 0, action: null, blocking: true };
    }

    if (Math.random() > this.profile.aggressionChance) {
      return { moveTowards: 0, action: null, blocking: false };
    }

    const roll = Math.random();
    const action: MoveId = roll < 0.5 ? 'punch' : roll < 0.8 ? 'kick' : 'grab';
    return { moveTowards: 0, action, blocking: false };
  }
}
