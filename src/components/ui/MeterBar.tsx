import { StyleSheet, View } from 'react-native';
import { theme } from './theme';

interface MeterBarProps {
  value: number;
  max: number;
  color: string;
}

export function MeterBar({ value, max, color }: MeterBarProps) {
  const pct = Math.max(0, Math.min(1, max > 0 ? value / max : 0));
  return (
    <View style={styles.track}>
      <View style={[styles.fill, { width: `${pct * 100}%`, backgroundColor: color }]} />
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    height: 10,
    borderWidth: 1,
    borderColor: theme.colors.border,
    backgroundColor: theme.colors.panel,
    overflow: 'hidden',
  },
  fill: {
    height: '100%',
  },
});
