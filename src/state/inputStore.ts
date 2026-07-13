import { create } from 'zustand';
import type { MoveId } from '../game/characters/types';

interface InputState {
  moveX: number;
  pendingAction: MoveId | null;
  setMoveX: (x: number) => void;
  queueAction: (action: MoveId) => void;
  consumeAction: () => MoveId | null;
}

export const useInputStore = create<InputState>((set, get) => ({
  moveX: 0,
  pendingAction: null,
  setMoveX: (x) => set({ moveX: x }),
  queueAction: (action) => set({ pendingAction: action }),
  consumeAction: () => {
    const action = get().pendingAction;
    if (action) set({ pendingAction: null });
    return action;
  },
}));
