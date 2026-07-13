import { router } from 'expo-router';
import { StyleSheet, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { theme } from '../../src/components/ui/theme';

export default function Results() {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>WINNER</Text>
      <Text style={styles.body}>Match resolution not built yet — Phase 3.</Text>
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
    fontSize: 28,
    fontWeight: '900',
    letterSpacing: 4,
  },
  body: {
    color: theme.colors.textDim,
    fontSize: 14,
  },
});
