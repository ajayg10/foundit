import 'package:flutter/material.dart';

/// Controls the app's ThemeMode (System / Light / Dark).
///
/// Implemented as a simple ValueNotifier to avoid adding any new
/// state-management dependency. The chosen value is kept in memory
/// for the lifetime of the app (survives hot restart).
///
/// NOTE: Cold-start persistence requires `shared_preferences`.
/// This is not currently installed. Persistence will be added once
/// the user approves the dependency. Until then, the mode resets to
/// ThemeMode.system on each cold start — the UI setting still works.
class ThemeModeController extends ValueNotifier<ThemeMode> {
  ThemeModeController._() : super(ThemeMode.system);

  static final ThemeModeController instance = ThemeModeController._();

  ThemeMode get mode => value;

  void setMode(ThemeMode mode) {
    if (value == mode) return;
    value = mode;
    // TODO(persistence): save to shared_preferences once approved.
  }

  void setLight() => setMode(ThemeMode.light);
  void setDark() => setMode(ThemeMode.dark);
  void setSystem() => setMode(ThemeMode.system);
}
