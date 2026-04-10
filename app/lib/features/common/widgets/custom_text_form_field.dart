import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todoon/core/extensions/app_theme_extension.dart';
import 'package:todoon/core/resources/icons_manager.dart';
import 'package:todoon/core/resources/styles_manager.dart';
import 'package:todoon/core/resources/values_manager.dart';
import 'package:todoon/core/utils/validators.dart';
import 'package:todoon/generated/locale_keys.g.dart';

/// === CustomTextFormField ===
class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    this.onFieldSubmitted,
    required this.label,
    this.validator,
    this.obscureText = false,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: obscureText,
      validator: validator,
      style: AppStyles.regular(fontSize: AppFontSize.s18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.semiBold(
          color: colors.onPrimaryContainer,
          fontSize: AppFontSize.s16,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: Padding(
          padding: const EdgeInsetsGeometry.all(AppPadding.p4),
          child: suffixIcon,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppPadding.p36,
          vertical: AppPadding.p16,
        ),
      ),
    );
  }
}

class ObscureController extends ValueNotifier<bool> {
  ObscureController({bool initialValue = true}) : super(initialValue);

  void toggle() => value = !value;
}

/// === EmailTextFormField ===
class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const EmailTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return CustomTextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      label: LocaleKeys.auth_email.tr(),
      validator: (value) => Validators.email(value)?.tr(),
      prefixIcon: Icon(AppIcons.email, color: colors.onTertiaryContainer),
    );
  }
}

/// === PasswordTextFormField ===
class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  final ObscureController obscureController;

  const PasswordTextFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.obscureController,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ValueListenableBuilder<bool>(
      valueListenable: obscureController,
      builder: (_, obscure, _) {
        return CustomTextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          label: LocaleKeys.auth_pass.tr(),
          validator: (value) => Validators.password(value)?.tr(),
          obscureText: obscure,
          prefixIcon: Icon(
            AppIcons.password,
            color: colors.onTertiaryContainer,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? AppIcons.hide_password : AppIcons.show_password,
              color: obscure
                  ? colors.onTertiaryContainer
                  : colors.onSurfaceVariant,
            ),
            onPressed: obscureController.toggle,
          ),
        );
      },
    );
  }
}

/// === ConfirmPasswordTextFormField ===
class ConfirmPasswordTextFormField extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  final ObscureController obscureController;

  const ConfirmPasswordTextFormField({
    super.key,
    required this.passwordController,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.obscureController,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ValueListenableBuilder<bool>(
      valueListenable: obscureController,
      builder: (_, obscure, _) {
        return CustomTextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          label: LocaleKeys.auth_conPass.tr(),
          obscureText: obscure,
          validator: (value) =>
              Validators.confirmPassword(value, passwordController.text)?.tr(),
          prefixIcon: Icon(
            AppIcons.password,
            color: colors.onTertiaryContainer,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? AppIcons.hide_password : AppIcons.show_password,
              color: obscure
                  ? colors.onTertiaryContainer
                  : colors.onSurfaceVariant,
            ),
            onPressed: obscureController.toggle,
          ),
        );
      },
    );
  }
}
