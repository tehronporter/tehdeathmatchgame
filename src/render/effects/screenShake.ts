import { create } from 'zustand';

interface ScreenShakeState {
  trauma: number;
  addTrauma: (amount: number) => void;
  decay: (dt: number) => void;
}

const DECAY_PER_SECOND = 1.5;

export const useScreenShakeStore = create<ScreenShakeState>((set) => ({
  trauma: 0,
  addTrauma: (amount) => set((state) => ({ trauma: Math.min(1, state.trauma + amount) })),
  decay: (dt) => set((state) => ({ trauma: Math.max(0, state.trauma - DECAY_PER_SECOND * dt) })),
}));

export function traumaOffset(trauma: number): { x: number; y: number } {
  const shake = trauma * trauma;
  return {
    x: (Math.random() * 2 - 1) * shake * 0.3,
    y: (Math.random() * 2 - 1) * shake * 0.2,
  };
}
