import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  static bool isDark = false;

  ThemeController() {
    loadTheme();
  }

  void updateSystemBrightness(Brightness brightness) {
    bool dark = false;
    if (_themeMode == ThemeMode.system) {
      dark = brightness == Brightness.dark;
    } else {
      dark = _themeMode == ThemeMode.dark;
    }
    if (isDark != dark) {
      isDark = dark;
    }
  }

  void _updateIsDarkStatic() {
    if (_themeMode == ThemeMode.light) {
      isDark = false;
    } else if (_themeMode == ThemeMode.dark) {
      isDark = true;
    }
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = prefs.getString('theme_mode') ?? 'system';
      if (modeStr == 'light') {
        _themeMode = ThemeMode.light;
      } else if (modeStr == 'dark') {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
      _updateIsDarkStatic();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _updateIsDarkStatic();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', mode.name);
    } catch (_) {}
  }
}
