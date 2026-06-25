import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _themeKey = 'votrr_theme_mode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final FlutterSecureStorage _storage;

  ThemeNotifier(this._storage) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await _storage.read(key: _themeKey);
    if (saved == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
  }

  Future<void> setLight() async {
    state = ThemeMode.light;
    await _storage.write(key: _themeKey, value: 'light');
  }

  Future<void> setDark() async {
    state = ThemeMode.dark;
    await _storage.write(key: _themeKey, value: 'dark');
  }

  Future<void> toggle() async {
    state == ThemeMode.dark ? await setLight() : await setDark();
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier(const FlutterSecureStorage());
});