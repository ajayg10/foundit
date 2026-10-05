import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controls the app's ThemeMode (System / Light / Dark).
///
/// Implemented as a simple ValueNotifier to avoid adding any new
/// state-management dependency. The chosen value is kept in memory
/// for the lifetime of the app (survives hot restart).
class ThemeModeController extends ValueNotifier<ThemeMode> {
  static const _key = 'theme_mode';
  SharedPreferences? _prefs;

  ThemeModeController._() : super(ThemeMode.system);

  static final ThemeModeController instance = ThemeModeController._();

  ThemeMode get mode => value;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      final saved = _prefs?.getString(_key);
      if (saved != null) {
        value = ThemeMode.values.firstWhere(
          (m) => m.name == saved,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (_) {
      // Fall back to System if loading fails
      value = ThemeMode.system;
    }
  }

  void setMode(ThemeMode mode) {
    if (value == mode) return;
    value = mode;
    _prefs?.setString(_key, mode.name);
  }

  void setLight() => setMode(ThemeMode.light);
  void setDark() => setMode(ThemeMode.dark);
  void setSystem() => setMode(ThemeMode.system);
}
