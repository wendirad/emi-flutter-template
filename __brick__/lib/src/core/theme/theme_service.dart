import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  /// Reads the saved mode. Call once before `runApp` so the first frame
  /// already uses the right theme.
  Future<void> load() async {
    final pref = await SharedPreferences.getInstance();
    final v = pref.getString('theme_mode');
    _mode = switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  /// Switches to the opposite of [current], the brightness the user is looking
  /// at. Starting from [ThemeMode.system] this flips the effective theme
  /// instead of assuming the system is light.
  Future<void> toggle(Brightness current) async {
    _mode = current == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
      'theme_mode',
      _mode == ThemeMode.light ? 'light' : 'dark',
    );
    notifyListeners();
  }
}
