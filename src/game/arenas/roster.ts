import type { Arena } from './types';

export const ARENAS: Arena[] = [
  { id: 'wrestling-ring', name: 'Wrestling Ring', color: '#3a1e1e', hazards: [{ id: 'thrown-chair', triggerType: 'timer', intervalMs: 15000, damage: 8 }] },
  { id: 'warehouse', name: 'Warehouse', color: '#26261e', hazards: [{ id: 'explosive-barrel', triggerType: 'timer', intervalMs: 18000, damage: 12 }] },
  { id: 'junkyard', name: 'Junkyard', color: '#1e2a26', hazards: [{ id: 'magnet-drop', triggerType: 'timer', intervalMs: 20000, damage: 10 }] },
  { id: 'tv-studio', name: 'TV Studio', color: '#1e1e2e', hazards: [{ id: 'falling-light', triggerType: 'timer', intervalMs: 16000, damage: 9 }] },
  { id: 'vegas-rooftop', name: 'Vegas Rooftop', color: '#2e1e2a', hazards: [{ id: 'helicopter-wind', triggerType: 'timer', intervalMs: 17000, damage: 6 }] },
  { id: 'construction-site', name: 'Construction Site', color: '#2a2416', hazards: [{ id: 'falling-pipe', triggerType: 'timer', intervalMs: 14000, damage: 11 }] },
];

export function getArena(id: string): Arena {
  const arena = ARENAS.find((a) => a.id === id);
  if (!arena) throw new Error(`Unknown arena id: ${id}`);
  return arena;
}
