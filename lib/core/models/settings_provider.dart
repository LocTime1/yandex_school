import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsProvider extends ChangeNotifier {
  bool _useSystemTheme = true;
  bool _hapticsEnabled = true;
  Color _mainColor = Colors.green;

  bool get useSystemTheme => _useSystemTheme;
  bool get hapticsEnabled => _hapticsEnabled;
  Color get mainColor => _mainColor;

  static const _pinKey = 'pin_code';
  static const _biometricsKey = 'biometrics_enabled';
  final _storage = const FlutterSecureStorage();

  bool _biometricsEnabled = false;
  bool get biometricsEnabled => _biometricsEnabled;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme = prefs.getBool('useSystemTheme') ?? true;
    _hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
    int? colorValue = prefs.getInt('mainColor');
    _mainColor = colorValue != null ? Color(colorValue) : Colors.green;

    _biometricsEnabled = (await _storage.read(key: _biometricsKey)) == '1';
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

  Future<void> setPin(String pin) async {
    if (pin.length != 4) throw Exception("PIN-код должен быть 4 цифры");
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<void> removePin() async {
    await _storage.delete(key: _pinKey);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null && pin.length == 4;
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    _biometricsEnabled = enabled;
    await _storage.write(key: _biometricsKey, value: enabled ? '1' : '0');
    notifyListeners();
  }
}
