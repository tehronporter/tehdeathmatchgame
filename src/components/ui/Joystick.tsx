import { Gesture, GestureDetector } from 'react-native-gesture-handler';
import { StyleSheet, View } from 'react-native';
import Animated, { useAnimatedStyle, useSharedValue, withSpring } from 'react-native-reanimated';
import { runOnJS } from 'react-native-reanimated';
import { theme } from './theme';
import { useInputStore } from '../../state/inputStore';

const RADIUS = 50;

export function Joystick() {
  const knobX = useSharedValue(0);
  const setMoveX = useInputStore((s) => s.setMoveX);

  const pan = Gesture.Pan()
    .onChange((event) => {
      const clamped = Math.max(-RADIUS, Math.min(RADIUS, knobX.value + event.changeX));
      knobX.value = clamped;
      runOnJS(setMoveX)(clamped / RADIUS);
    })
    .onFinalize(() => {
      knobX.value = withSpring(0);
      runOnJS(setMoveX)(0);
    });

  const knobStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: knobX.value }],
  }));

  return (
    <GestureDetector gesture={pan}>
      <View style={styles.base}>
        <Animated.View style={[styles.knob, knobStyle]} />
      </View>
    </GestureDetector>
  );
}

const styles = StyleSheet.create({
  base: {
    width: RADIUS * 2 + 20,
    height: RADIUS + 40,
    borderWidth: 2,
    borderColor: theme.colors.border,
    borderRadius: 12,
    backgroundColor: theme.colors.panel,
    alignItems: 'center',
    justifyContent: 'center',
  },
  knob: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: theme.colors.accent,
  },
});
