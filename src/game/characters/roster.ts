import type { Character } from './types';

export const ROSTER: Character[] = [
  { id: 'action-hero', name: 'The Action Hero', stats: { health: 4, strength: 4, speed: 3, special: 3 }, color: '#1e6bff', finisherId: 'meteor-strike' },
  { id: 'wrestler', name: 'The Wrestler', stats: { health: 5, strength: 5, speed: 2, special: 3 }, color: '#ff2b4d', finisherId: 'giant-boot' },
  { id: 'pop-diva', name: 'The Pop Diva', stats: { health: 3, strength: 2, speed: 5, special: 4 }, color: '#ff4de0', finisherId: 'mic-drop' },
  { id: 'tech-billionaire', name: 'The Tech Billionaire', stats: { health: 3, strength: 2, speed: 3, special: 5 }, color: '#9b59ff', finisherId: 'rocket-launch' },
  { id: 'influencer', name: 'The Influencer', stats: { health: 2, strength: 2, speed: 5, special: 3 }, color: '#ff9d1e', finisherId: 'meteor-strike' },
  { id: 'rockstar', name: 'The Rockstar', stats: { health: 4, strength: 4, speed: 3, special: 3 }, color: '#2eff9d', finisherId: 'giant-boot' },
  { id: 'conspiracy-host', name: 'The Conspiracy Host', stats: { health: 3, strength: 3, speed: 3, special: 4 }, color: '#e0e01e', finisherId: 'tnt-pile' },
  { id: 'chef', name: 'The Chef', stats: { health: 4, strength: 3, speed: 3, special: 3 }, color: '#ff7a1e', finisherId: 'knife-throw' },
  { id: 'billionaire', name: 'The Billionaire', stats: { health: 3, strength: 3, speed: 2, special: 5 }, color: '#c7c7c7', finisherId: 'money-cannon' },
  { id: 'super-fan', name: 'The Super Fan', stats: { health: 3, strength: 3, speed: 4, special: 4 }, color: '#1ee0ff', finisherId: 'meteor-strike' },
];

export function getCharacter(id: string): Character {
  const character = ROSTER.find((c) => c.id === id);
  if (!character) throw new Error(`Unknown character id: ${id}`);
  return character;
}
