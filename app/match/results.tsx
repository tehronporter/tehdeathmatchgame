import { router } from 'expo-router';
import { StyleSheet, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { theme } from '../../src/components/ui/theme';
import { getCharacter } from '../../src/game/characters/roster';
import { useMatchStore } from '../../src/state/matchStore';
import { useSelectionStore } from '../../src/state/selectionStore';

export default function Results() {
  const winner = useMatchStore((s) => s.winner);
  const { playerCharacterId, opponentCharacterId } = useSelectionStore();
  const winnerName =
    winner === 0
      ? getCharacter(playerCharacterId).name
      : winner === 1
        ? getCharacter(opponentCharacterId).name
        : '—';

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>{winnerName} WINS</Text>
      <ArcadeButton label="PLAY AGAIN" onPress={() => router.replace('/match/character-select')} />
      <ArcadeButton label="MAIN MENU" onPress={() => router.replace('/(menu)')} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 20,
  },
  title: {
    color: theme.colors.text,
    fontSize: 26,
    fontWeight: '900',
    letterSpacing: 3,
    textAlign: 'center',
  },
});
