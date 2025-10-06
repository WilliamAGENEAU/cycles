import 'package:cycles/models/themes/app_theme_mode_enum.dart';
import 'package:cycles/services/settings_service.dart';
import 'package:cycles/utils/constants.dart';
import 'package:flutter/material.dart';

class ThemeNotifier with ChangeNotifier {
  late Color _themeColor;
  late bool _isDynamicEnabled;
  final SettingsService _settingsService = SettingsService();
  AppThemeMode _themeMode = AppThemeMode.system;
  AppThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _themeColor = seedColor;
    _isDynamicEnabled = false;
    loadAllThemeSettings();
  }

  Color get themeColor => _themeColor;
  bool get isDynamicEnabled => _isDynamicEnabled;

  Future<void> setColor(Color color) async {
    _themeColor = color;
    await _settingsService.setThemeColor(color);
    notifyListeners();
  }

  Future<void> setDynamicThemeEnabled(bool isEnabled) async {
    _isDynamicEnabled = isEnabled;
    await _settingsService.setDynamicColorEnabled(isEnabled);
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _settingsService.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> loadAllThemeSettings() async {
    _themeColor = await _settingsService.getThemeColor();
    _isDynamicEnabled = await _settingsService.isDynamicThemeEnabled();
    _themeMode = await _settingsService.getThemeMode();
    notifyListeners();
  }
}
