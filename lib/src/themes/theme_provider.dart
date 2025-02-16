// lib/src/themes/theme_provider.dart
import 'package:flutter/material.dart';
import 'light_mode.dart'; // Import the lightMode theme

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode; // Use the custom lightMode theme

  ThemeData get themeData => _themeData;

  bool get isDarkData => _themeData.brightness == Brightness.dark;

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? ThemeData.dark() : lightMode;
    notifyListeners();
  }
}