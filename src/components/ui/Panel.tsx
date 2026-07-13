import { StyleSheet, View, ViewProps } from 'react-native';
import { theme } from './theme';

export function Panel({ style, ...props }: ViewProps) {
  return <View style={[styles.panel, style]} {...props} />;
}

const styles = StyleSheet.create({
  panel: {
    borderWidth: 2,
    borderColor: theme.colors.border,
    backgroundColor: theme.colors.panel,
    padding: 16,
  },
});
