import { router } from 'expo-router';
import { StyleSheet, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { theme } from '../../src/components/ui/theme';

export default function CharacterSelect() {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>CHARACTER SELECT</Text>
      <Text style={styles.body}>Roster not built yet — Phase 3.</Text>
      <ArcadeButton label="ENTER ARENA" onPress={() => router.push('/match/fight')} />
      <ArcadeButton label="BACK" onPress={() => router.back()} />
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
    fontSize: 22,
    fontWeight: '800',
    letterSpacing: 3,
  },
  body: {
    color: theme.colors.textDim,
    fontSize: 14,
  },
});
