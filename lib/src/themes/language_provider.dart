import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'ar'; // Default language
  Locale _locale = Locale('ar');

  String get currentLanguage => _currentLanguage;
  Locale get locale => _locale;

  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Method to get text direction based on language
  TextDirection get textDirection =>
      _currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;
}