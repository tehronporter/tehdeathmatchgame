import { Canvas, useFrame, useThree } from '@react-three/fiber';
import * as CANNON from 'cannon-es';
import { useMemo, useRef } from 'react';
import type { Mesh } from 'three';
import { createMatchWorld, stepWorld } from '../../game/physics/world';
import { createFighterRig, knockHead, moveTorso, type FighterRig } from '../../game/physics/fighterRig';
import { resolveMove } from '../../game/combat/resolveMove';
import { MOVES } from '../../game/combat/moves';
import { BasicAI } from '../../game/ai/basicAI';
import { FINISHERS } from '../../game/finishers/finishers';
import { useMatchStore } from '../../state/matchStore';
import { useInputStore } from '../../state/inputStore';
import { usePlayerStore } from '../../state/playerStore';
import { useScreenShakeStore, traumaOffset } from '../effects/screenShake';
import type { Character } from '../../game/characters/types';
import type { Arena } from '../../game/arenas/types';

const MOVE_SPEED = 3;
const HAZARD_HALF_RANGE = 1.5;

interface FightSceneProps {
  playerCharacter: Character;
  opponentCharacter: Character;
  arena: Arena;
  onMatchEnd: (winner: 0 | 1, finisherUsed: boolean) => void;
}

function FighterMesh({ rig, color }: { rig: FighterRig; color: string }) {
  const torsoRef = useRef<Mesh>(null);
  const headRef = useRef<Mesh>(null);

  useFrame(() => {
    if (torsoRef.current) {
      torsoRef.current.position.set(rig.torso.position.x, rig.torso.position.y, rig.torso.position.z);
    }
    if (headRef.current) {
      headRef.current.position.set(rig.head.position.x, rig.head.position.y, rig.head.position.z);
    }
  });

  return (
    <group>
      <mesh ref={torsoRef}>
        <boxGeometry args={[0.8, 1.2, 0.6]} />
        <meshStandardMaterial color={color} />
      </mesh>
      <mesh ref={headRef}>
        <sphereGeometry args={[0.28, 16, 16]} />
        <meshStandardMaterial color={color} />
      </mesh>
    </group>
  );
}

function CameraShake({ basePosition }: { basePosition: [number, number, number] }) {
  const { camera } = useThree();

  useFrame((_, delta) => {
    useScreenShakeStore.getState().decay(delta);
    const trauma = useScreenShakeStore.getState().trauma;
    const offset = traumaOffset(trauma);
    camera.position.set(basePosition[0] + offset.x, basePosition[1] + offset.y, basePosition[2]);
  });

  return null;
}

function MatchController({
  playerRig,
  opponentRig,
  world,
  playerCharacter,
  opponentCharacter,
  arena,
  onMatchEnd,
}: {
  playerRig: FighterRig;
  opponentRig: FighterRig;
  world: CANNON.World;
  playerCharacter: Character;
  opponentCharacter: Character;
  arena: Arena;
  onMatchEnd: (winner: 0 | 1, finisherUsed: boolean) => void;
}) {
  const ai = useMemo(() => new BasicAI(), []);
  const hazardElapsedMs = useRef(0);
  const ended = useRef(false);

  useFrame((_, delta) => {
    if (ended.current) return;
    stepWorld(world, delta);

    const store = useMatchStore.getState();
    if (store.status === 'ended' || store.status === 'finisher') return;

    const distance = Math.abs(playerRig.torso.position.x - opponentRig.torso.position.x);

    const inputState = useInputStore.getState();
    moveTorso(playerRig, inputState.moveX > 0.2 ? 1 : inputState.moveX < -0.2 ? -1 : 0, MOVE_SPEED);
    const playerAction = useInputStore.getState().consumeAction();
    if (playerAction && store.fighters[0].stamina >= MOVES[playerAction].staminaCost) {
      const result = resolveMove(playerCharacter.stats, MOVES[playerAction], store.fighters[0].stamina, false);
      store.spendStamina(0, result.staminaCost);
      store.applyDamage(1, result.damage);
      store.addHype(0, result.hypeGain);
      knockHead(opponentRig, playerRig.torso.position.x < opponentRig.torso.position.x ? 1 : -1, result.knockback);
      if (playerAction === 'punch') usePlayerStore.getState().recordPunchLanded();
      useScreenShakeStore.getState().addTrauma(result.damage / 60);
    }

    const aiDecision = ai.decide(
      { distance, ownStamina: store.fighters[1].stamina, ownHype: store.fighters[1].hype, maxHype: store.fighters[1].maxHype },
      delta,
    );
    moveTorso(opponentRig, aiDecision.moveTowards === 1 ? (opponentRig.torso.position.x > playerRig.torso.position.x ? -1 : 1) : 0, MOVE_SPEED * 0.8);
    if (aiDecision.action && distance <= 2.4 && store.fighters[1].stamina >= MOVES[aiDecision.action].staminaCost) {
      const result = resolveMove(opponentCharacter.stats, MOVES[aiDecision.action], store.fighters[1].stamina, false);
      store.spendStamina(1, result.staminaCost);
      store.applyDamage(0, result.damage);
      store.addHype(1, result.hypeGain);
      knockHead(playerRig, opponentRig.torso.position.x < playerRig.torso.position.x ? 1 : -1, result.knockback);
      useScreenShakeStore.getState().addTrauma(result.damage / 60);
    }

    const hazard = arena.hazards[0];
    if (hazard?.triggerType === 'timer' && hazard.intervalMs) {
      hazardElapsedMs.current += delta * 1000;
      if (hazardElapsedMs.current >= hazard.intervalMs) {
        hazardElapsedMs.current = 0;
        if (Math.abs(playerRig.torso.position.x) < HAZARD_HALF_RANGE) store.applyDamage(0, hazard.damage);
        if (Math.abs(opponentRig.torso.position.x) < HAZARD_HALF_RANGE) store.applyDamage(1, hazard.damage);
      }
    }

    const latest = useMatchStore.getState();
    if (latest.fighters[0].hype >= latest.fighters[0].maxHype) {
      ended.current = true;
      store.setStatus('finisher');
      setTimeout(() => {
        useMatchStore.getState().endMatch(0);
        onMatchEnd(0, true);
      }, FINISHERS[playerCharacter.finisherId]?.durationMs ?? 1800);
      return;
    }
    if (latest.fighters[1].hype >= latest.fighters[1].maxHype) {
      ended.current = true;
      store.setStatus('finisher');
      setTimeout(() => {
        useMatchStore.getState().endMatch(1);
        onMatchEnd(1, true);
      }, FINISHERS[opponentCharacter.finisherId]?.durationMs ?? 1800);
      return;
    }
    if (latest.fighters[0].health <= 0) {
      ended.current = true;
      store.endMatch(1);
      onMatchEnd(1, false);
      return;
    }
    if (latest.fighters[1].health <= 0) {
      ended.current = true;
      store.endMatch(0);
      onMatchEnd(0, false);
      return;
    }

    store.tick(delta);
  });

  return null;
}

export function FightScene({ playerCharacter, opponentCharacter, arena, onMatchEnd }: FightSceneProps) {
  const world = useMemo(() => createMatchWorld(), []);
  const playerRig = useMemo(() => createFighterRig(world, -1.5), [world]);
  const opponentRig = useMemo(() => createFighterRig(world, 1.5), [world]);

  return (
    <Canvas style={{ flex: 1 }} camera={{ position: [0, 2.2, 7], fov: 50 }}>
      <color attach="background" args={[arena.color]} />
      <ambientLight intensity={0.7} />
      <directionalLight position={[3, 6, 3]} intensity={1.3} />
      <mesh rotation={[-Math.PI / 2, 0, 0]}>
        <planeGeometry args={[14, 14]} />
        <meshStandardMaterial color="#0a0a0a" />
      </mesh>
      <FighterMesh rig={playerRig} color={playerCharacter.color} />
      <FighterMesh rig={opponentRig} color={opponentCharacter.color} />
      <CameraShake basePosition={[0, 2.2, 7]} />
      <MatchController
        playerRig={playerRig}
        opponentRig={opponentRig}
        world={world}
        playerCharacter={playerCharacter}
        opponentCharacter={opponentCharacter}
        arena={arena}
        onMatchEnd={onMatchEnd}
      />
    </Canvas>
  );
}
