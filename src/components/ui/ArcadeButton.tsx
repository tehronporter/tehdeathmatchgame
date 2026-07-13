import { Pressable, StyleSheet, Text } from 'react-native';
import { theme } from './theme';

interface ArcadeButtonProps {
  label: string;
  onPress: () => void;
  disabled?: boolean;
}

export function ArcadeButton({ label, onPress, disabled }: ArcadeButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      style={({ pressed }) => [
        styles.button,
        disabled && styles.disabled,
        pressed && styles.pressed,
      ]}
    >
      <Text style={[styles.label, disabled && styles.labelDisabled]}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    borderWidth: 2,
    borderColor: theme.colors.border,
    paddingVertical: 14,
    paddingHorizontal: 24,
    alignItems: 'center',
    backgroundColor: theme.colors.panel,
  },
  pressed: {
    borderColor: theme.colors.accent,
  },
  disabled: {
    opacity: 0.35,
  },
  label: {
    color: theme.colors.text,
    fontSize: 18,
    fontWeight: '800',
    letterSpacing: 3,
  },
  labelDisabled: {
    color: theme.colors.textDim,
  },
});
