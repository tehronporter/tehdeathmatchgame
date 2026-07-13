import { router } from 'expo-router';
import { useEffect } from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ActionButtons } from '../../src/components/ui/ActionButtons';
import { Joystick } from '../../src/components/ui/Joystick';
import { MatchHud } from '../../src/components/hud/MatchHud';
import { theme } from '../../src/components/ui/theme';
import { FightScene } from '../../src/render/scenes/FightScene';
import { getArena } from '../../src/game/arenas/roster';
import { getCharacter } from '../../src/game/characters/roster';
import { useMatchStore } from '../../src/state/matchStore';
import { useSelectionStore } from '../../src/state/selectionStore';
import { usePlayerStore } from '../../src/state/playerStore';

export default function Fight() {
  const { playerCharacterId, opponentCharacterId, arenaId } = useSelectionStore();
  const status = useMatchStore((s) => s.status);
  const fighters = useMatchStore((s) => s.fighters);
  const setStatus = useMatchStore((s) => s.setStatus);
  const reset = useMatchStore((s) => s.reset);

  const playerCharacter = getCharacter(playerCharacterId);
  const opponentCharacter = getCharacter(opponentCharacterId);
  const arena = getArena(arenaId);

  useEffect(() => {
    reset();
    setStatus('active');
  }, []);

  return (
    <View style={styles.container}>
      <FightScene
        playerCharacter={playerCharacter}
        opponentCharacter={opponentCharacter}
        arena={arena}
        onMatchEnd={(winner, finisherUsed) => {
          if (winner === 0) {
            usePlayerStore.getState().recordWin(finisherUsed);
          } else {
            usePlayerStore.getState().recordLoss();
          }
          setTimeout(() => router.replace('/match/results'), 400);
        }}
      />
      <SafeAreaView style={styles.overlay} pointerEvents="box-none">
        <MatchHud left={fighters[0]} right={fighters[1]} leftName={playerCharacter.name} rightName={opponentCharacter.name} />
        {status === 'finisher' && (
          <View style={styles.finisherBanner} pointerEvents="none">
            <Text style={styles.finisherText}>FINISHER!</Text>
          </View>
        )}
        <View style={styles.controls}>
          <Joystick />
          <ActionButtons />
        </View>
      </SafeAreaView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  overlay: {
    ...StyleSheet.absoluteFill,
    justifyContent: 'space-between',
  },
  controls: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
    paddingHorizontal: 20,
    paddingBottom: 24,
  },
  finisherBanner: {
    position: 'absolute',
    top: '40%',
    alignSelf: 'center',
  },
  finisherText: {
    color: theme.colors.accent,
    fontSize: 40,
    fontWeight: '900',
    letterSpacing: 4,
    textShadowColor: theme.colors.accent,
    textShadowRadius: 20,
  },
});
