import { router } from 'expo-router';
import { FlatList, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { Panel } from '../../src/components/ui/Panel';
import { theme } from '../../src/components/ui/theme';
import { usePlayerStore } from '../../src/state/playerStore';

export default function Leaderboard() {
  const { wins, winStreak, level, achievements, dailyChallenges } = usePlayerStore();

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>LEADERBOARD (LOCAL)</Text>
      <Panel style={styles.summary}>
        <Text style={styles.row}>Level {level} — {wins} wins — {winStreak} streak</Text>
      </Panel>
      <Text style={styles.section}>Daily challenges</Text>
      <FlatList
        data={dailyChallenges}
        keyExtractor={(c) => c.id}
        renderItem={({ item }) => (
          <Text style={styles.row}>
            {item.completed ? '✔' : '—'} {item.label} ({item.progress}/{item.target})
          </Text>
        )}
      />
      <Text style={styles.section}>Achievements</Text>
      <FlatList
        data={achievements}
        keyExtractor={(a) => a.id}
        renderItem={({ item }) => (
          <Text style={styles.row}>{item.earnedAt ? '✔' : '—'} {item.label}</Text>
        )}
      />
      <ArcadeButton label="BACK" onPress={() => router.back()} />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
    alignItems: 'center',
    paddingTop: 60,
    gap: 12,
    paddingHorizontal: 24,
  },
  title: {
    color: theme.colors.text,
    fontSize: 22,
    fontWeight: '800',
    letterSpacing: 3,
  },
  summary: {
    width: '100%',
  },
  section: {
    color: theme.colors.accent,
    fontSize: 14,
    fontWeight: '700',
    alignSelf: 'flex-start',
    marginTop: 8,
  },
  row: {
    color: theme.colors.text,
    fontSize: 13,
    paddingVertical: 2,
  },
});
