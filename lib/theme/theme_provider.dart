import 'package:flutter/material.dart';
import 'package:minimal_notes/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  bool get _isDarkMode => _themeData == darkMode;

  set themeData(ThemeData _themeData) {
    themeData = _themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) _themeData = darkMode;
    else _themeData = lightMode;
  }
}