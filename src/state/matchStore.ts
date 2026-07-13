import { create } from 'zustand';

export interface FighterHudState {
  health: number;
  maxHealth: number;
  stamina: number;
  maxStamina: number;
  hype: number;
  maxHype: number;
}

export interface MatchState {
  status: 'countdown' | 'active' | 'finisher' | 'ended';
  timeElapsed: number;
  fighters: [FighterHudState, FighterHudState];
  winner: 0 | 1 | null;
  setStatus: (status: MatchState['status']) => void;
  tick: (dt: number) => void;
  applyDamage: (fighterIndex: 0 | 1, amount: number) => void;
  spendStamina: (fighterIndex: 0 | 1, amount: number) => void;
  addHype: (fighterIndex: 0 | 1, amount: number) => void;
  endMatch: (winner: 0 | 1) => void;
  reset: () => void;
}

function freshFighter(): FighterHudState {
  return { health: 100, maxHealth: 100, stamina: 100, maxStamina: 100, hype: 0, maxHype: 100 };
}

export const useMatchStore = create<MatchState>((set) => ({
  status: 'countdown',
  timeElapsed: 0,
  fighters: [freshFighter(), freshFighter()],
  winner: null,
  setStatus: (status) => set({ status }),
  tick: (dt) => set((state) => ({ timeElapsed: state.timeElapsed + dt })),
  applyDamage: (fighterIndex, amount) =>
    set((state) => {
      const fighters = [...state.fighters] as [FighterHudState, FighterHudState];
      const fighter = fighters[fighterIndex];
      fighters[fighterIndex] = {
        ...fighter,
        health: Math.max(0, fighter.health - amount),
      };
      return { fighters };
    }),
  spendStamina: (fighterIndex, amount) =>
    set((state) => {
      const fighters = [...state.fighters] as [FighterHudState, FighterHudState];
      const fighter = fighters[fighterIndex];
      fighters[fighterIndex] = {
        ...fighter,
        stamina: Math.max(0, fighter.stamina - amount),
      };
      return { fighters };
    }),
  addHype: (fighterIndex, amount) =>
    set((state) => {
      const fighters = [...state.fighters] as [FighterHudState, FighterHudState];
      const fighter = fighters[fighterIndex];
      fighters[fighterIndex] = {
        ...fighter,
        hype: Math.min(fighter.maxHype, fighter.hype + amount),
      };
      return { fighters };
    }),
  endMatch: (winner) => set({ status: 'ended', winner }),
  reset: () => set({ status: 'countdown', timeElapsed: 0, fighters: [freshFighter(), freshFighter()], winner: null }),
}));
