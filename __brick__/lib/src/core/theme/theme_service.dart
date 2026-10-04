import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

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

  Future<void> toggleTheme() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
      'theme_mode',
      _mode == ThemeMode.light ? 'light' : 'dark',
    );
    notifyListeners();
  }
}
