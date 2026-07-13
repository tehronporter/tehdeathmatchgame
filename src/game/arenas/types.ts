export interface HazardDefinition {
  id: string;
  triggerType: 'timer' | 'hypeThreshold' | 'random';
  intervalMs?: number;
  damage: number;
}

export interface Arena {
  id: string;
  name: string;
  color: string;
  hazards: HazardDefinition[];
}
