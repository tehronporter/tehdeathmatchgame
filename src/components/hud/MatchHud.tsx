import { StyleSheet, Text, View } from 'react-native';
import { MeterBar } from '../ui/MeterBar';
import { theme } from '../ui/theme';
import type { FighterHudState } from '../../state/matchStore';

interface MatchHudProps {
  left: FighterHudState;
  right: FighterHudState;
  leftName: string;
  rightName: string;
}

function FighterMeters({ fighter, name, align }: { fighter: FighterHudState; name: string; align: 'flex-start' | 'flex-end' }) {
  return (
    <View style={[styles.fighterColumn, { alignItems: align }]}>
      <Text style={styles.name}>{name}</Text>
      <MeterBar value={fighter.health} max={fighter.maxHealth} color={theme.colors.health} />
      <MeterBar value={fighter.stamina} max={fighter.maxStamina} color={theme.colors.stamina} />
      <MeterBar value={fighter.hype} max={fighter.maxHype} color={theme.colors.hype} />
    </View>
  );
}

export function MatchHud({ left, right, leftName, rightName }: MatchHudProps) {
  return (
    <View style={styles.row}>
      <FighterMeters fighter={left} name={leftName} align="flex-start" />
      <FighterMeters fighter={right} name={rightName} align="flex-end" />
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    paddingTop: 8,
    gap: 12,
  },
  fighterColumn: {
    flex: 1,
    gap: 4,
  },
  name: {
    color: theme.colors.text,
    fontSize: 12,
    fontWeight: '700',
    letterSpacing: 1,
  },
});
