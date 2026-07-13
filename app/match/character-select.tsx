import { router } from 'expo-router';
import { FlatList, Pressable, StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { theme } from '../../src/components/ui/theme';
import { ROSTER } from '../../src/game/characters/roster';
import { useSelectionStore } from '../../src/state/selectionStore';

export default function CharacterSelect() {
  const playerCharacterId = useSelectionStore((s) => s.playerCharacterId);
  const setPlayerCharacter = useSelectionStore((s) => s.setPlayerCharacter);

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>CHOOSE YOUR FIGHTER</Text>
      <FlatList
        data={ROSTER}
        horizontal
        showsHorizontalScrollIndicator={false}
        style={styles.listWrap}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.list}
        renderItem={({ item }) => (
          <Pressable
            onPress={() => setPlayerCharacter(item.id)}
            style={[
              styles.card,
              { borderColor: item.id === playerCharacterId ? item.color : theme.colors.border },
            ]}
          >
            <View style={[styles.swatch, { backgroundColor: item.color }]} />
            <Text style={styles.name}>{item.name}</Text>
            <Text style={styles.stats}>
              H{item.stats.health} S{item.stats.strength} SP{item.stats.speed} SPC{item.stats.special}
            </Text>
          </Pressable>
        )}
      />
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
    fontSize: 20,
    fontWeight: '800',
    letterSpacing: 3,
  },
  listWrap: {
    flexGrow: 0,
  },
  list: {
    gap: 12,
    paddingHorizontal: 16,
    alignItems: 'center',
  },
  card: {
    width: 120,
    height: 180,
    padding: 12,
    borderWidth: 2,
    backgroundColor: theme.colors.panel,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },
  swatch: {
    width: 36,
    height: 36,
    borderRadius: 18,
  },
  name: {
    color: theme.colors.text,
    fontSize: 12,
    fontWeight: '700',
    textAlign: 'center',
  },
  stats: {
    color: theme.colors.textDim,
    fontSize: 10,
  },
});
