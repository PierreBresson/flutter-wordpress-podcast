import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final updateThemeModeProvider =
    Provider.autoDispose.family<ThemeMode, ThemeMode>((ref, themeMode) {
  return ref.read(themeModeProvider.notifier).update((state) => themeMode);
});
