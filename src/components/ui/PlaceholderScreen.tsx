import { router } from 'expo-router';
import { StyleSheet, Text } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from './ArcadeButton';
import { theme } from './theme';

export function PlaceholderScreen({ title }: { title: string }) {
  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.body}>Coming post-prototype.</Text>
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
    gap: 24,
  },
  title: {
    color: theme.colors.text,
    fontSize: 24,
    fontWeight: '800',
    letterSpacing: 3,
  },
  body: {
    color: theme.colors.textDim,
    fontSize: 14,
  },
});
