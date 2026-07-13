export interface Finisher {
  id: string;
  label: string;
  cameraZoom: number;
  durationMs: number;
}

export const FINISHERS: Record<string, Finisher> = {
  'meteor-strike': { id: 'meteor-strike', label: 'METEOR STRIKE', cameraZoom: 1.8, durationMs: 2200 },
  'giant-boot': { id: 'giant-boot', label: 'GIANT BOOT', cameraZoom: 1.6, durationMs: 1800 },
  'mic-drop': { id: 'mic-drop', label: 'MIC DROP', cameraZoom: 1.5, durationMs: 1600 },
  'rocket-launch': { id: 'rocket-launch', label: 'ROCKET LAUNCH', cameraZoom: 2, durationMs: 2400 },
  'tnt-pile': { id: 'tnt-pile', label: 'TNT PILE', cameraZoom: 1.7, durationMs: 2000 },
  'knife-throw': { id: 'knife-throw', label: 'KNIFE THROW', cameraZoom: 1.4, durationMs: 1400 },
  'money-cannon': { id: 'money-cannon', label: 'MONEY CANNON', cameraZoom: 1.6, durationMs: 1800 },
};
