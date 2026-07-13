import { create } from 'zustand';
import { ROSTER } from '../game/characters/roster';
import { ARENAS } from '../game/arenas/roster';

interface SelectionState {
  playerCharacterId: string;
  opponentCharacterId: string;
  arenaId: string;
  setPlayerCharacter: (id: string) => void;
}

export const useSelectionStore = create<SelectionState>((set) => ({
  playerCharacterId: ROSTER[0].id,
  opponentCharacterId: ROSTER[1].id,
  arenaId: ARENAS[0].id,
  setPlayerCharacter: (id) => set({ playerCharacterId: id }),
}));
