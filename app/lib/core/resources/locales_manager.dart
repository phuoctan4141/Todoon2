import 'package:flutter/material.dart';

class AppLocales {
  AppLocales._();

  static const String assetsPath = 'assets/translations';

  static const List<Locale> locales = [Locale('en', 'US'), Locale('vi', 'VN')];

  static Locale get fallbackLocale => const Locale('en', 'US');

  static LocaleOption get enLocaleOption => const LocaleOption(
    locale: Locale('en', 'US'),
    title: 'English',
    subtitle: 'English (US)',
    icon: Icons.language_rounded,
  );

  static LocaleOption get viLocaleOption => const LocaleOption(
    locale: Locale('vi', 'VN'),
    title: 'Tiếng Việt',
    subtitle: 'Vietnamese',
    icon: Icons.star_rounded,
  );

  static List<LocaleOption> get localeOptions => [
    enLocaleOption,
    viLocaleOption,
  ];
}

/// === LocaleOption ===
class LocaleOption {
  final Locale locale;
  final String title;
  final String subtitle;
  final IconData icon;

  const LocaleOption({
    required this.locale,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
