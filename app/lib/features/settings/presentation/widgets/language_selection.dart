import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/locales_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  late LocaleOption _selectedOption;
  Locale? _previousLocale;

  @override
  void initState() {
    super.initState();
    _selectedOption = AppLocales.localeOptions.first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale;
    if (_previousLocale != currentLocale) {
      _previousLocale = currentLocale;
      _loadCurrentLanguage(currentLocale);
    }
  }

  void _loadCurrentLanguage(Locale currentLocale) {
    final matched = AppLocales.localeOptions.firstWhere(
      (option) =>
          option.locale.languageCode == currentLocale.languageCode &&
          option.locale.countryCode == currentLocale.countryCode,
      orElse: () => AppLocales.enLocaleOption,
    );
    if (mounted && _selectedOption != matched) {
      setState(() {
        _selectedOption = matched;
      });
    }
  }

  void _onLanguageChanged(LocaleOption? value) {
    if (value != null && value != _selectedOption) {
      setState(() {
        _selectedOption = value;
      });
      context.setLocale(value.locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevation.e3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHeader(), _buildRadioGroup(), const Gap(AppSize.s8)],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1.0,
      color: context.colors.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r16),
          topRight: Radius.circular(AppRadius.r16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p16),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: Durations.medium3,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Icon(
                key: ValueKey(_selectedOption.locale.languageCode),
                _selectedOption.icon,
              ),
            ),
            const Gap(AppSize.s12),
            Text(
              LocaleKeys.title_Language.tr(),
              style: AppStyles.medium(
                color: context.colors.onSurface,
                fontSize: AppFontSize.s18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioGroup() {
    return RadioGroup<LocaleOption>(
      groupValue: _selectedOption,
      onChanged: _onLanguageChanged,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          children: [
            _buildRadioTile(AppLocales.enLocaleOption),
            const Gap(AppSize.s4),
            _buildRadioTile(AppLocales.viLocaleOption),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(LocaleOption option) {
    return RadioListTile<LocaleOption>(
      title: Text(option.title),
      subtitle: Text(option.subtitle),
      value: option,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
    );
  }
}
