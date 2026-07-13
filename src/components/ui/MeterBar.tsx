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
      <View style={{ flex: pct, backgroundColor: color }} />
      <View style={{ flex: 1 - pct }} />
    </View>
  );
}

const styles = StyleSheet.create({
  track: {
    flexDirection: 'row',
    height: 12,
    borderWidth: 1,
    borderColor: theme.colors.border,
    backgroundColor: theme.colors.panel,
    overflow: 'hidden',
  },
});
