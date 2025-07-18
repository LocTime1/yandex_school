import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _useSystemTheme = true;
  bool _hapticsEnabled = true;
  Color _mainColor = Colors.green;

  bool get useSystemTheme => _useSystemTheme;
  bool get hapticsEnabled => _hapticsEnabled;
  Color get mainColor => _mainColor;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
    int? colorValue = prefs.getInt('mainColor');
    _mainColor = colorValue != null ? Color(colorValue) : Colors.green;
    notifyListeners();
  }

  Future<void> setUseSystemTheme(bool value) async {
    _useSystemTheme = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('useSystemTheme', value);
    notifyListeners();
  }

  Future<void> setHapticsEnabled(bool value) async {
    _hapticsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hapticsEnabled', value);
    notifyListeners();
  }

  Future<void> setMainColor(Color color) async {
    _mainColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mainColor', color.value);
    notifyListeners();
  }
}
