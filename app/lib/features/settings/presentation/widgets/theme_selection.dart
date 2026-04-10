import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/generated/locale_keys.g.dart';

class ThemeSelection extends StatefulWidget {
  const ThemeSelection({super.key});

  @override
  State<ThemeSelection> createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  ThemeMode _selectedTheme = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  Future<void> _loadCurrentTheme() async {
    final currentTheme = await context.savedTheme;
    if (mounted) {
      setState(() {
        _selectedTheme = currentTheme;
      });
    }
  }

  void _onThemeChanged(ThemeMode? value) {
    if (value != null && value != _selectedTheme) {
      setState(() {
        _selectedTheme = value;
      });
      context.setTheme(value);
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
              child: Icon(key: ValueKey(_selectedTheme), _selectedTheme.icon),
            ),
            const Gap(AppSize.s12),
            Text(
              LocaleKeys.title_Theme.tr(),
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
    return RadioGroup<ThemeMode>(
      groupValue: _selectedTheme,
      onChanged: _onThemeChanged,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          children: [
            _buildRadioTile(ThemeMode.system),
            const Gap(AppSize.s4),
            _buildRadioTile(ThemeMode.light),
            const Gap(AppSize.s4),
            _buildRadioTile(ThemeMode.dark),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile(ThemeMode mode) {
    return RadioListTile<ThemeMode>(
      title: Text(mode.title.tr()),
      subtitle: Text(mode.subtitle.tr()),
      value: mode,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r8),
      ),
    );
  }
}
