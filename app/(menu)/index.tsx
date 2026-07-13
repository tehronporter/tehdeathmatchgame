import { router } from 'expo-router';
import { StyleSheet, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { theme } from '../../src/components/ui/theme';

export default function MainMenu() {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>DEATHMATCH{'\n'}ARENA</Text>
      <View style={styles.menu}>
        <ArcadeButton label="PLAY" onPress={() => router.push('/match/character-select')} />
        <ArcadeButton label="MULTIPLAYER" onPress={() => {}} disabled />
        <ArcadeButton label="CUSTOMIZE" onPress={() => router.push('/(menu)/customize')} />
        <ArcadeButton label="SHOP" onPress={() => router.push('/(menu)/shop')} />
        <ArcadeButton label="LEADERBOARD" onPress={() => router.push('/(menu)/leaderboard')} />
        <ArcadeButton label="SETTINGS" onPress={() => router.push('/(menu)/settings')} />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: theme.colors.background,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 48,
  },
  title: {
    color: theme.colors.text,
    fontSize: 36,
    fontWeight: '900',
    letterSpacing: 4,
    textAlign: 'center',
    textShadowColor: theme.colors.accent,
    textShadowRadius: 12,
    textShadowOffset: { width: 0, height: 0 },
  },
  menu: {
    gap: 12,
    width: '70%',
  },
});
