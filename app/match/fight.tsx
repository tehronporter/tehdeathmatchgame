import { router } from 'expo-router';
import { StyleSheet, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { ArcadeButton } from '../../src/components/ui/ArcadeButton';
import { BlankScene } from '../../src/render/scenes/BlankScene';

export default function Fight() {
  return (
    <View style={styles.container}>
      <BlankScene />
      <SafeAreaView style={styles.overlay} pointerEvents="box-none">
        <ArcadeButton label="END (DEBUG)" onPress={() => router.replace('/match/results')} />
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
    position: 'absolute',
    bottom: 24,
    alignSelf: 'center',
  },
});
