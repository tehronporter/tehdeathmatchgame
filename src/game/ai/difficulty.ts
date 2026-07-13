export type AIDifficulty = 'easy' | 'medium' | 'hard' | 'nightmare';

export interface AIProfile {
  reactionMs: number;
  blockChance: number;
  aggressionChance: number;
  specialUsageChance: number;
}

export const AI_PROFILES: Record<AIDifficulty, AIProfile> = {
  easy: { reactionMs: 900, blockChance: 0.05, aggressionChance: 0.3, specialUsageChance: 0.3 },
  medium: { reactionMs: 550, blockChance: 0.15, aggressionChance: 0.5, specialUsageChance: 0.5 },
  hard: { reactionMs: 350, blockChance: 0.3, aggressionChance: 0.7, specialUsageChance: 0.7 },
  nightmare: { reactionMs: 180, blockChance: 0.45, aggressionChance: 0.9, specialUsageChance: 0.9 },
};
