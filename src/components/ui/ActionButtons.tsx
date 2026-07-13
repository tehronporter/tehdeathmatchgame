import { Pressable, StyleSheet, Text, View } from 'react-native';
import { theme } from './theme';
import { useInputStore } from '../../state/inputStore';
import type { MoveId } from '../../game/characters/types';

const BUTTONS: { id: MoveId; label: string }[] = [
  { id: 'punch', label: 'P' },
  { id: 'kick', label: 'K' },
  { id: 'grab', label: 'G' },
  { id: 'special', label: 'S' },
];

export function ActionButtons() {
  const queueAction = useInputStore((s) => s.queueAction);

  return (
    <View style={styles.row}>
      {BUTTONS.map((btn) => (
        <Pressable
          key={btn.id}
          onPress={() => queueAction(btn.id)}
          style={({ pressed }) => [styles.button, pressed && styles.pressed]}
        >
          <Text style={styles.label}>{btn.label}</Text>
        </Pressable>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    gap: 10,
  },
  button: {
    width: 54,
    height: 54,
    borderRadius: 27,
    borderWidth: 2,
    borderColor: theme.colors.border,
    backgroundColor: theme.colors.panel,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pressed: {
    borderColor: theme.colors.accent,
    backgroundColor: theme.colors.accent,
  },
  label: {
    color: theme.colors.text,
    fontSize: 18,
    fontWeight: '900',
  },
});
