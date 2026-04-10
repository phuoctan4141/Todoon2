// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoon/features/app/presentation/app.dart';
import 'package:todoon/core/resources/theme_manager.dart';
import 'package:todoon/generated/locale_keys.g.dart';

extension AppThemeExtension on BuildContext {
  // == Key SharedPreferences ==
  static const _themeKey = 'app_theme_mode';

  MyAppState? get _myAppState => findAncestorStateOfType<MyAppState>();

  // == Get ThemeData ==
  static final _maTheme = MaterialTheme(TextTheme());
  ThemeData get lightTheme => _maTheme.light();
  ThemeData get darkTheme => _maTheme.dark();
  ThemeData get lightHighContrast => _maTheme.lightHighContrast();
  ThemeData get darkHighContrast => _maTheme.darkHighContrast();

  // == Shortcut ==
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;

  // == Get save ThemeMode ==
  Future<ThemeMode> get savedTheme async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_themeKey);
    return saved == 'light'
        ? ThemeMode.light
        : saved == 'dark'
        ? ThemeMode.dark
        : ThemeMode.system;
  }

  // == Save ThemeMode ==
  Future<void> saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _themeKey,
      mode == ThemeMode.light
          ? 'light'
          : mode == ThemeMode.dark
          ? 'dark'
          : 'system',
    );
  }

  // == Get ThemeMode ==
  ThemeMode get currentTheme =>
      theme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;

  // == Set theme  ==
  Future<void> setTheme(ThemeMode themeMode) async {
    await saveTheme(themeMode);
    final currentState = _myAppState;
    currentState?.setState(() => _myAppState?.themeMode = themeMode);
  }

  // == Shortcut methods ==
  Future<void> toLight() => setTheme(ThemeMode.light);
  Future<void> toDark() => setTheme(ThemeMode.dark);
  Future<void> toSystem() => setTheme(ThemeMode.system);

  // == Helper ==
  Color get bgColor =>
      theme.brightness == Brightness.light ? Colors.white : Colors.black;

  Color dueDateColor(DateTime? dueDate) {
    if (dueDate == null) {
      return colors.secondary;
    }
    if (dueDate.isBefore(DateTime.now())) {
      return colors.error;
    }
    return colors.secondary;
  }

  Color bgColorContainer(Color onContainer) {
    if (theme.brightness == Brightness.light) {
      return Color.alphaBlend(
        onContainer.withValues(alpha: 0.15),
        colors.surface,
      );
    } else {
      return Color.alphaBlend(
        onContainer.withValues(alpha: 0.30),
        colors.surface,
      );
    }
  }
}

extension SystemBarExtension on BuildContext {
  void setSystemBarsFromTheme() {
    final brightness = Theme.of(this).brightness;
    SystemChrome.setSystemUIOverlayStyle(
      brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }
}

extension ThemeOptionExtension on ThemeMode {
  String get title {
    switch (this) {
      case ThemeMode.light:
        return LocaleKeys.theme_light;
      case ThemeMode.dark:
        return LocaleKeys.theme_dark;
      case ThemeMode.system:
        return LocaleKeys.theme_system;
    }
  }

  String get subtitle {
    switch (this) {
      case ThemeMode.light:
        return LocaleKeys.theme_lightSub;
      case ThemeMode.dark:
        return LocaleKeys.theme_darkSub;
      case ThemeMode.system:
        return LocaleKeys.theme_systemSub;
    }
  }

  IconData get icon {
    switch (this) {
      case ThemeMode.light:
        return Icons.light_mode_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.brightness_medium_rounded;
    }
  }
}
