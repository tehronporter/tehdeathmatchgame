import AsyncStorage from '@react-native-async-storage/async-storage';
import { create } from 'zustand';
import { createJSONStorage, persist } from 'zustand/middleware';

export interface Achievement {
  id: string;
  label: string;
  earnedAt: number | null;
}

export interface DailyChallenge {
  id: string;
  label: string;
  target: number;
  progress: number;
  completed: boolean;
}

interface PlayerState {
  xp: number;
  level: number;
  coins: number;
  wins: number;
  totalPunchesLanded: number;
  finishersPerformed: number;
  winStreak: number;
  achievements: Achievement[];
  dailyChallenges: DailyChallenge[];
  recordWin: (finisherUsed: boolean) => void;
  recordLoss: () => void;
  recordPunchLanded: () => void;
}

const XP_PER_LEVEL = 500;

const DEFAULT_ACHIEVEMENTS: Achievement[] = [
  { id: 'first-win', label: 'First Win', earnedAt: null },
  { id: 'hundred-wins', label: '100 Wins', earnedAt: null },
  { id: 'first-finisher', label: 'First Finisher', earnedAt: null },
  { id: 'five-hundred-punches', label: '500 Punches', earnedAt: null },
];

function freshDailyChallenges(): DailyChallenge[] {
  return [
    { id: 'win-3', label: 'Win 3 matches', target: 3, progress: 0, completed: false },
    { id: 'land-100-punches', label: 'Land 100 punches', target: 100, progress: 0, completed: false },
    { id: 'perform-5-finishers', label: 'Perform 5 finishers', target: 5, progress: 0, completed: false },
  ];
}

function earnAchievement(achievements: Achievement[], id: string): Achievement[] {
  return achievements.map((a) => (a.id === id && !a.earnedAt ? { ...a, earnedAt: Date.now() } : a));
}

function bumpChallenge(challenges: DailyChallenge[], id: string, amount: number): DailyChallenge[] {
  return challenges.map((c) => {
    if (c.id !== id) return c;
    const progress = Math.min(c.target, c.progress + amount);
    return { ...c, progress, completed: progress >= c.target };
  });
}

export const usePlayerStore = create<PlayerState>()(
  persist(
    (set, get) => ({
      xp: 0,
      level: 1,
      coins: 0,
      wins: 0,
      totalPunchesLanded: 0,
      finishersPerformed: 0,
      winStreak: 0,
      achievements: DEFAULT_ACHIEVEMENTS,
      dailyChallenges: freshDailyChallenges(),
      recordWin: (finisherUsed) =>
        set((state) => {
          const xp = state.xp + 100;
          const level = Math.floor(xp / XP_PER_LEVEL) + 1;
          const wins = state.wins + 1;
          const winStreak = state.winStreak + 1;
          const finishersPerformed = state.finishersPerformed + (finisherUsed ? 1 : 0);
          let achievements = state.achievements;
          if (wins === 1) achievements = earnAchievement(achievements, 'first-win');
          if (wins >= 100) achievements = earnAchievement(achievements, 'hundred-wins');
          if (finishersPerformed >= 1) achievements = earnAchievement(achievements, 'first-finisher');
          let dailyChallenges = bumpChallenge(state.dailyChallenges, 'win-3', 1);
          if (finisherUsed) dailyChallenges = bumpChallenge(dailyChallenges, 'perform-5-finishers', 1);
          return {
            xp,
            level,
            coins: state.coins + 25,
            wins,
            winStreak,
            finishersPerformed,
            achievements,
            dailyChallenges,
          };
        }),
      recordLoss: () => set({ winStreak: 0 }),
      recordPunchLanded: () =>
        set((state) => {
          const totalPunchesLanded = state.totalPunchesLanded + 1;
          let achievements = state.achievements;
          if (totalPunchesLanded >= 500) achievements = earnAchievement(achievements, 'five-hundred-punches');
          const dailyChallenges = bumpChallenge(state.dailyChallenges, 'land-100-punches', 1);
          return { totalPunchesLanded, achievements, dailyChallenges };
        }),
    }),
    { name: 'deathmatch-player', storage: createJSONStorage(() => AsyncStorage) },
  ),
);
